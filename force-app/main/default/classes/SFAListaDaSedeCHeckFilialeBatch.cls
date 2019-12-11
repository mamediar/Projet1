global class SFAListaDaSedeCHeckFilialeBatch implements Database.Batchable<sObject>, Database.Stateful{
    
    global List<SFAListaDaSedeReadHelper> listInExam;
    global List<SFAListaDaSedeReadHelper> listInOut;
    global List<SFAListaDaSedeReadHelper> listInError;
    global String tipo_attivita;
    global String tipo_lista;
    global Date data_visibilita;
    private SFA_ListaCheckWrapper listaCheck;
    global Map<String, List<Account>> mapBranch;
	global SFAListaDaSedeCHeckFilialeBatch(String tipo_attivita, String tipo_lista, Date data_visibilita, List<SFAListaDaSedeReadHelper> listInExam, List<SFAListaDaSedeReadHelper> listInError) {
    	this.listInExam = listInExam;
    	this.listInOut = new List<SFAListaDaSedeReadHelper>();
        this.listInError = listInError;
        this.tipo_attivita = tipo_attivita;
        this.tipo_lista = tipo_lista;
        this.data_visibilita = data_visibilita;
        this.listaCheck = new SFA_ListaCheckWrapper();
        mapBranch = new Map<String, List<Account>>();
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query='SELECT Id, OCS_External_Id__c, OCSAreaId__c, Region_Name__c FROM Account WHERE RecordType.Name = \'Branch\' AND OCS_External_Id__c<>null AND OCSAreaId__c<>null AND Region_Name__c<>null';
        
        System.debug(query);
        return Database.getQueryLocator(query);
        
    }
    global void execute(Database.BatchableContext bc, List<Account> scope) {
        
        for(Account c: scope) {
            if(!mapBranch.containsKey(c.OCS_External_Id__c))
                mapBranch.put(c.OCS_External_Id__c, new List<Account>{c});
            else 
            	mapBranch.get(c.OCS_External_Id__c).add(c);
         }
    }
    global void finish(Database.BatchableContext bc){ 
         for(Integer g=0; g< listInExam.size(); g++) {
            SFAListaDaSedeReadHelper f = listInExam.get(g);
            System.debug('Controllo nella mappa f.codice_filiale: '+f.codice_filiale);
            if(mapBranch.containsKey(AccountUtils.getBranchExternalId(f.codice_filiale))) {
                for(Account c : mapBranch.get(AccountUtils.getBranchExternalId(f.codice_filiale))) {
                    System.debug('Controllo c.OCS_External_Id__c: '+c.OCS_External_Id__c+' con f.codice_filiale: '+f.codice_filiale);
                    if(c.OCS_External_Id__c == AccountUtils.getBranchExternalId(f.codice_filiale) && c.OCSAreaId__c == Decimal.valueOf(f.area_filiale) && c.Region_Name__c == f.regione_filiale) {
                    	listInOut.add(listInExam.remove(g--));
                    	break;
                    }
                }
            }
        }
        for(SFAListaDaSedeReadHelper a : listInExam) {
            listaCheck.addElem(this.tipo_lista, a.accountObj.Name, a.accountObj.OCS_External_Id__c, a.accountObj.Partita_IVA__c, a.accountObj.Codice_Fiscale__c, 'Check fallito: Filiale, Area, Regione non valida');
            listInError.add(a);
        }
        listaCheck.insertList();
        System.debug('listInError: '+listInError.size());
        System.debug('listInOut: '+listInOut.size());
        if(listInOut.size()==0) {
            SFA_ListeCaricate__c listaCaricate = [SELECT Id, Nome_Lista__c, Data_Caricamento__c, Data_Visibilita__c FROM SFA_ListeCaricate__c WHERE Id = :tipo_lista];
            listaCaricate.Numero_righe__c=this.listInOut.size();
            upsert listaCaricate;
        }
        else {
            Database.executeBatch(new SFAListaDaSedeGetDealerForUpsertBatch(this.tipo_attivita, this.tipo_lista, this.data_visibilita, this.listInOut, this.listInError, this.mapBranch));
        }
    }
    public class SFA_ListaCheckWrapper {
        public List<SFA_ListaCheck__c> listaCheck {get; set;}
        
        public SFA_ListaCheckWrapper() {
            this.listaCheck= new List<SFA_ListaCheck__C>();
        }
        public void insertList() {
            if(this.listaCheck.size()<=200)
                insert listaCheck;
            else {
                List<SFA_ListaCheck__c> t = new List<SFA_ListaCheck__c>();
                for(Integer i=0; i<listaCheck.size();i++) {
                    if(i>0 && math.mod(i,200)==0) {
                        insert t;
                        t = new List<SFA_ListaCheck__c>();
                    }
                    else {
                        t.add(listaCheck.get(i));
                    }
                }
                if(t.size()>0) 
                    insert t;
            }
        }
        public void addElem(String idLista, String name,String ocs_code, String piva, String codicefiscale, String errormessaggio) {
            SFA_ListaCheck__c c =  new SFA_ListaCheck__c();
            if(ocs_code.length()>80)
                c.Name = name.substring(0, 77)+'...';
            else c.Name = name;
            if(ocs_code.length()>20)
                c.OCS_Code__c = ocs_code.substring(0, 17)+'...';
            else c.OCS_Code__c = ocs_code;
            if(piva.length()>20)
            	c.P_IVA__c = piva.substring(0, 17)+'...';
            else c.P_IVA__c = piva;
            if(codicefiscale.length()>16)
            	c.CodiceFiscale__c = codicefiscale.substring(0, 13)+'...';
            else c.CodiceFiscale__c = codicefiscale;
            if(errormessaggio.length()>255)
            	c.ErrorMessage__c = errormessaggio.substring(0, 252)+'...';
            else c.ErrorMessage__c = errormessaggio;
            c.SFA_ListeCaricate__c = idLista;
            this.listaCheck.add(c);
        }
    }
}