global class SFAListaDaSedeGetFilialeBatch implements Database.Batchable<sObject>, Database.Stateful{
    
    global List<SFAListaDaSedeReadHelper> listInOut;
    global List<SFAListaDaSedeReadHelper> listInError;
    global String tipo_attivita;
    global String tipo_lista;
    global Date data_visibilita;
    private SFA_ListaCheckWrapper listaCheck;
    global List<Account> accounts;
    global Map<String, List<Account>> mapBranch;
    global Map<String, Group> mapGroup;
	global SFAListaDaSedeGetFilialeBatch(String tipo_attivita, String tipo_lista, Date data_visibilita, List<SFAListaDaSedeReadHelper> listInOut, List<SFAListaDaSedeReadHelper> listInError, List<Account> accounts, Map<String, List<Account>> mapBranch) {
    	this.listInOut = listInOut;
        this.listInError = listInError;
        this.tipo_attivita = tipo_attivita;
        this.tipo_lista = tipo_lista;
        this.data_visibilita = data_visibilita;
        this.listaCheck = new SFA_ListaCheckWrapper();
        this.accounts = accounts; 
        this.mapBranch = mapBranch;
        this.mapGroup = new Map<String, Group>();
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query='SELECT Id, DeveloperName FROM Group WHERE type=\'queue\' AND DeveloperName<>null';
        System.debug(query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Group> scope) {
        for(Group c: scope) {
            for(Integer g=0; g< listInOut.size(); g++) {
                SFAListaDaSedeReadHelper f = listInOut.get(g);
                if(c.DeveloperName==AccountUtils.getBranchExternalId(f.codice_filiale)) {
                	mapGroup.put(c.DeveloperName, c);
                    System.debug('c.DeveloperName '+c.DeveloperName);
                }
            }
        }
    }
    global void finish(Database.BatchableContext bc){ 
        System.debug('listInError: '+listInError.size());
        System.debug('listInOut: '+listInOut.size());
        if(!Test.isRunningTest()) {
            Database.executeBatch(new SFAListaDaSedeGetCaseBatch(this.tipo_attivita, this.tipo_lista, this.data_visibilita, this.listInOut, this.listInError, this.accounts, this.mapBranch, this.mapGroup));
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