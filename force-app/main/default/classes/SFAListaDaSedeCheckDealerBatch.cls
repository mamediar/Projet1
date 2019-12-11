global class SFAListaDaSedeCheckDealerBatch implements Database.Batchable<sObject>, Database.Stateful{
    
    global List<SFAListaDaSedeReadHelper> listInExam;
    global List<SFAListaDaSedeReadHelper> listInError;
    global String tipo_attivita;
    global String tipo_lista;
    global Date data_visibilita;
    private SFA_ListaCheckWrapper listaCheck;
    global String nome_tipo_lista;
    
	global SFAListaDaSedeCheckDealerBatch(String tipo_attivita, String tipo_lista, Date data_visibilita, List<SFAListaDaSedeReadHelper> listInExam, List<SFAListaDaSedeReadHelper> listInError) {
    	this.listInExam = listInExam;
        this.listInError = listInError;
        this.tipo_attivita = tipo_attivita;
        this.tipo_lista = tipo_lista;
        this.nome_tipo_lista=[SELECT Nome_Lista__c FROM SFA_ListeCaricate__c WHERE Id =: this.tipo_lista].Nome_Lista__c;
        this.data_visibilita = data_visibilita;
        this.listaCheck = new SFA_ListaCheckWrapper();
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query='SELECT Account.Name, Account.Codice_Fiscale__c, Account.Partita_IVA__c, Account.OCS_External_Id__c FROM Case where Account.RecordType.Developername=\'Dealer\' AND SFA_ListeCaricate__c = \''+tipo_lista+'\'';
        System.debug(query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Case> scope) {

        System.debug('Controllo CF scope: '+scope);
        for(Case c: scope) {
            for(Integer g=0; g< listInExam.size(); g++) {
                SFAListaDaSedeReadHelper f = listInExam.get(g);
                System.debug('Controllo CF: '+c.Account.Codice_Fiscale__c+' = '+f.accountObj.Codice_Fiscale__c);
                if(c.Account.OCS_External_Id__c!=null && c.Account.OCS_External_Id__c.length()>0 && f.accountObj.OCS_External_Id__c!=null && f.accountObj.OCS_External_Id__c.length()>0 && c.Account.OCS_External_Id__c.equals(f.accountObj.OCS_External_Id__c)) {
                    listaCheck.addElem(this.tipo_lista, c.Account.Name, c.Account.OCS_External_Id__c, c.Account.Partita_IVA__c, c.Account.Codice_Fiscale__c, 'Check fallito: Dealer con OCS_External_Id__c già assegnato alla lista: '+this.nome_tipo_lista);
                    listInError.add(listInExam.remove(g));
                    System.debug('Controllo CF: 1');
                    break;
                }
                if(c.Account.Codice_Fiscale__c!=null && c.Account.Codice_Fiscale__c.length()>0 && f.accountObj.Codice_Fiscale__c!=null && f.accountObj.Codice_Fiscale__c.length()>0 && c.Account.Codice_Fiscale__c.equals(f.accountObj.Codice_Fiscale__c)) {
                    listaCheck.addElem(this.tipo_lista, c.Account.Name, c.Account.OCS_External_Id__c, c.Account.Partita_IVA__c, c.Account.Codice_Fiscale__c, 'Check fallito: Dealer con Codice_Fiscale__c già assegnato alla lista: '+this.nome_tipo_lista);
                    listInError.add(listInExam.remove(g));
                    System.debug('Controllo CF: 2');
                    break;
                }
                if(c.Account.Partita_IVA__c!=null && c.Account.Partita_IVA__c.length()>0 && f.accountObj.Partita_IVA__c!=null && f.accountObj.Partita_IVA__c.length()>0 && c.Account.Partita_IVA__c.equals(f.accountObj.Partita_IVA__c)) {
                    listaCheck.addElem(this.tipo_lista, c.Account.Name, c.Account.OCS_External_Id__c, c.Account.Partita_IVA__c, c.Account.Codice_Fiscale__c, 'Check fallito: Dealer con Partita_IVA__c già assegnato alla lista: '+this.nome_tipo_lista);
                    listInError.add(listInExam.remove(g));
                    System.debug('Controllo CF: 3');
                    break;
                }
            }
        }
        listaCheck.insertList();
    }
    global void finish(Database.BatchableContext bc){ 
        
        System.debug('listInExam: '+listInExam.size());
        System.debug('listInError: '+listInError.size());
        if(listInExam.size()==0) {
            SFA_ListeCaricate__c listaCaricate = [SELECT Id, Nome_Lista__c, Data_Caricamento__c, Data_Visibilita__c FROM SFA_ListeCaricate__c WHERE Id = :tipo_lista];
            listaCaricate.Numero_righe__c=this.listInExam.size();
            upsert listaCaricate;
        }
        else {
            Database.executeBatch(new SFAListaDaSedeCHeckFilialeBatch(this.tipo_attivita, this.tipo_lista, this.data_visibilita, this.listInExam, this.listInError));
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
            if(ocs_code!= null && ocs_code.length()>80)
                c.Name = name.substring(0, 77)+'...';
            else c.Name = name;
            if(ocs_code != null && ocs_code.length()>20)
                c.OCS_Code__c = ocs_code.substring(0, 17)+'...';
            else c.OCS_Code__c = ocs_code;
            if(piva != null && piva.length()>20)
            	c.P_IVA__c = piva.substring(0, 17)+'...';
            else c.P_IVA__c = piva;
            if(codicefiscale!=null && codicefiscale.length()>16)
            	c.CodiceFiscale__c = codicefiscale.substring(0, 13)+'...';
            else c.CodiceFiscale__c = codicefiscale;
            if(errormessaggio!=null && errormessaggio.length()>255)
            	c.ErrorMessage__c = errormessaggio.substring(0, 252)+'...';
            else c.ErrorMessage__c = errormessaggio;
            c.SFA_ListeCaricate__c = idLista;
            this.listaCheck.add(c);
        }
    }
}