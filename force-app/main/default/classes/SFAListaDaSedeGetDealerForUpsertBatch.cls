global class SFAListaDaSedeGetDealerForUpsertBatch implements Database.Batchable<sObject>, Database.Stateful{
    
    global List<SFAListaDaSedeReadHelper> listInOut;
    global List<SFAListaDaSedeReadHelper> listInError;
    global String tipo_attivita;
    global String tipo_lista;
    global Date data_visibilita;
    private SFA_ListaCheckWrapper listaCheck;
    global Map<String, List<Account>> mapBranch;
    global SFAListaDaSedeGetDealerForUpsertBatch(String tipo_attivita, String tipo_lista, Date data_visibilita, List<SFAListaDaSedeReadHelper> listInOut, List<SFAListaDaSedeReadHelper> listInError, Map<String, List<Account>> mapBranch) {
        this.listInOut = listInOut;
        this.listInError = listInError;
        this.tipo_attivita = tipo_attivita;
        this.tipo_lista = tipo_lista;
        this.data_visibilita = data_visibilita;
        this.listaCheck = new SFA_ListaCheckWrapper();
        this.mapBranch = mapBranch;
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query='SELECT Id, Codice_Fiscale__c, Partita_IVA__c, OCS_External_Id__c FROM Account where RecordType.Developername=\'Dealer\'';
        System.debug(query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Account> scope) {
        for(Account c: scope) {
            for(SFAListaDaSedeReadHelper f : listInOut) {
                String cId=null;
                if(c.OCS_External_Id__c!=null && c.OCS_External_Id__c.length()>0 && f.accountObj.OCS_External_Id__c!=null && f.accountObj.OCS_External_Id__c.length()>0 && c.OCS_External_Id__c.equals(f.accountObj.OCS_External_Id__c)) {
                    cId = c.Id;
                    System.debug('Trovato Account tramite OCS_External_Id__c: '+c.Id);
                }
                else if(c.Codice_Fiscale__c!=null && c.Codice_Fiscale__c.length()>0 && f.accountObj.Codice_Fiscale__c!=null && f.accountObj.Codice_Fiscale__c.length()>0 && c.Codice_Fiscale__c.equals(f.accountObj.Codice_Fiscale__c)) {
                    cId = c.Id;
                    System.debug('Trovato Account tramite Codice_Fiscale__c: '+c.Id);
                }
                else if(c.Partita_IVA__c!=null && c.Partita_IVA__c.length()>0 && f.accountObj.Partita_IVA__c!=null && f.accountObj.Partita_IVA__c.length()>0 && c.Partita_IVA__c.equals(f.accountObj.Partita_IVA__c)) {
                    cId = c.Id;
                    System.debug('Trovato Account tramite Partita_IVA__c: '+c.Id);
                }
                if(cId!=null) {
                    f.accountObj.Id=cId;
                    break;
                }
            }
            
        }
        
    }
    global void finish(Database.BatchableContext bc){ 
        String recordTypeId= [SELECT Id FROM RecordType WHERE Developername='Dealer'].Id;
        List<Account> accounts = new List<Account>();
        List<Account> accountsNew = new List<Account>();

        for(SFAListaDaSedeReadHelper f : listInOut) {
            f.accountObj.RecordTypeId=recordTypeId;
            if(f.accountObj.Id==null) 
                accountsNew.add(f.accountObj);
            else {
                accounts.add(f.accountObj);
            }
        }
        /*if(accountsNew.size()<=200 && accountsNew.size()>0)*/
        
        //#### modifica reggressione 19/09 caricamento account ###
        if(accountsNew.size()<=200 && accountsNew.size()>0)
            insert accountsNew;
        else {
            List<Account> t = new List<Account>();
            for(Integer j=0; j<accountsNew.size();j++) {
                if(j>0 && math.mod(j,199)==0) {
                    insert t;
                    t = new List<Account>();
                }
                else {
                    t.add(accountsNew.get(j));
                }
            }
            if(t.size()>0) 
                insert t;
        }
        //#### modifica reggressione 19/09 caricamento account ###
        /*Map<Account, DealerAccount> accountMap = new Map<Account, DealerAccount>();
        for(SFAListaDaSedeReadHelper f : listInOut) {
            if(f.accountObj.Id==null) {
                DealerAccount da = new DealerAccount();
                da.account=f.accountObj;
                accountMap.put(f.accountObj, da);
                System.debug(da.account.Partita_Iva__c);
            }
            else {
                accounts.add(f.accountObj);
            }
        }
        XCSCreazioneAnagraficaDealer.crea(accountMap, false);
        Set<Account> mapValueSet = accountMap.keySet();
        System.debug('Dopo la Insert');
        for(Account da : mapValueSet) {
            System.debug('Id: '+da.Id+' Partita iva: '+da.Partita_Iva__c);
            accounts.add(accountMap.get(da).account);
        } */
        System.debug('Accounts Existed: '+accounts.size());
        System.debug('Account New: '+accountsNew.size());
        for(Account g: accountsNew)
            accounts.add(g);
        System.debug('Accounts Total: '+accounts.size());
        System.debug('listInError: '+listInError.size());
        System.debug('listInOut: '+listInOut.size());
        if(!Test.isRunningTest()) {
            Database.executeBatch(new SFAListaDaSedeGetFilialeBatch(this.tipo_attivita, this.tipo_lista, this.data_visibilita, this.listInOut, this.listInError, accounts, this.mapBranch));
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