global class SFAListaDaSedeGetCaseBatch implements Database.Batchable<sObject>, Database.Stateful{
    
    global List<SFAListaDaSedeReadHelper> listInOut;
    global List<SFAListaDaSedeReadHelper> listInError;
    global String tipo_attivita;
    global String tipo_lista;
    global Date data_visibilita;
    private SFA_ListaCheckWrapper listaCheck;
    global List<Account> accounts;
    global List<Case> caseParent;
    global Map<String, List<Account>> mapBranch;
    global Map<String, Group> mapGroup;
    global Map<String, Case> mapCaseStd;
    global SFAListaDaSedeGetCaseBatch(String tipo_attivita, String tipo_lista, Date data_visibilita, List<SFAListaDaSedeReadHelper> listInOut, List<SFAListaDaSedeReadHelper> listInError, List<Account> accounts, Map<String, List<Account>> mapBranch, Map<String, Group> mapGroup) {
        this.listInOut = listInOut;
        this.listInError = listInError;
        this.tipo_attivita = tipo_attivita;
        this.tipo_lista = tipo_lista;
        this.data_visibilita = data_visibilita;
        this.listaCheck = new SFA_ListaCheckWrapper();
        this.accounts = accounts; 
        this.caseParent = new List<Case>();
        this.mapBranch = mapBranch;
        this.mapGroup = mapGroup;
        this.mapCaseStd =new Map<String,Case>();
    }
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query='SELECT Id, Owner.Name, Owner.Id, ParentId FROM case WHERE RecordType.Developername = \'Liste_da_Sede\' AND SFA_ListeCaricate__c=\''+tipo_lista+'\'  AND ParentId=null';
        System.debug(query);
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<case> scope) {
        for(case c: scope) {
            for(Integer g=0; g< listInOut.size(); g++) {
                SFAListaDaSedeReadHelper f = listInOut.get(g);
                if(c.Owner.Id==mapGroup.get(AccountUtils.getBranchExternalId(f.codice_filiale)).Id){
                    mapCaseStd.put(AccountUtils.getBranchExternalId(f.codice_filiale), c);
                }
            }
        }
    }
    global void finish(Database.BatchableContext bc){ 
        System.debug('listInError: '+listInError.size());
        System.debug('listInOut: '+listInOut.size());
        String idListaDaSede = [SELECT Id from RecordType WHERE DeveloperName = 'Liste_da_Sede'].Id;
        //inserimento Attività Padre (CASE)
        for(SFAListaDaSedeReadHelper a: listInOut) {
            if(!mapCaseStd.containsKey(AccountUtils.getBranchExternalId(a.codice_filiale))) {
                Case casePrt = new Case();
                casePrt.RecordTypeId = idListaDaSede;
                casePrt.Subject = 'Liste da Sede';
                String ownId;
                String branchId;
                if(mapGroup.containsKey(AccountUtils.getBranchExternalId(a.codice_filiale))) {
                    ownId = mapGroup.get(AccountUtils.getBranchExternalId(a.codice_filiale)).Id;  
                }
                for(Account u : mapBranch.get(AccountUtils.getBranchExternalId(a.codice_filiale))) {
                    if(u.OCS_External_Id__c == AccountUtils.getBranchExternalId(a.codice_filiale) && u.OCSAreaId__c == Decimal.valueOf(a.area_filiale) && u.Region_Name__c == a.regione_filiale) {
                        branchId=u.Id;
                        break;
                    }
                }
                //assegno il branch specifico per quell'area e regione, ma non sono sicuro sia necessario nel padre
                casePrt.Branch__c=branchId;
                //l'owner si riferisce al group e quindi ad un record di Group di tipo queue
                casePrt.OwnerId=ownId;
                casePrt.Data_Visibilita__c = data_visibilita; // da verificare se necessario su case padre
                casePrt.SFA_ListeCaricate__c= tipo_lista;
                casePrt.Priority = 'Low';       //aggiunta priorità al case
                
                caseParent.add(casePrt);
                mapCaseStd.put(AccountUtils.getBranchExternalId(a.codice_filiale), casePrt);
            }
        }
        System.debug('Case Parent da inserire '+caseParent.size());
        if(caseParent.size()<=200) {
            try{
               insert caseParent; 
            }catch(Exception e){
               
               system.debug('ERROR_MESSAGE: '+e.getMessage());
               system.debug('ERROR_STRACE: '+e.getStackTraceString()); 
            }
            //insert caseParent;
        }
        else {
            List<Case> t = new List<Case>();
            List<Case> caseInserted = new List<Case>();
            for(Integer i=0; i<caseParent.size();i++) {
                if(i>0 && math.mod(i,199)==0) {
                    insert t;
                    caseInserted.addAll(t);
                    t = new List<Case>();
                } 
                else {
                    t.add(caseParent.get(i));
                }
            }
            if(t.size()>0) {
                insert t;
                caseInserted.addAll(t);
            }
            caseParent = caseInserted.clone();
            caseInserted=null;
        }
        //Aggiungo ai case Padri i case Padri creati ma usando come chiave l'id del gruppo perchè non ho modo di trovarmi da case il DeveloperName
        for(Case c : caseParent) {
            mapCaseStd.put(c.OwnerId, c);
        }
        List<Case> caseChild = new List<Case>();
        //inserimento Attività Figlio (CASE)
        for(SFAListaDaSedeReadHelper a: listInOut) {
            Case caseCld = new Case();
            caseCld.RecordTypeId = idListaDaSede;
            caseCld.Subject = 'Liste da Sede';
            String accId=null;
            String ownId=null;
            String pId=null;
            for(Account u  :accounts) {
                if(u.Codice_Fiscale__c!=null && u.Partita_IVA__c!=null && u.Codice_Fiscale__c.length()>0 && u.Partita_IVA__c.length()>0 && u.Codice_Fiscale__c  == a.accountObj.Codice_Fiscale__c && u.Partita_IVA__c == a.accountObj.Partita_IVA__c) {
                    accId=u.Id;
                    break;
                }
                if(u.Codice_Fiscale__c!=null && u.Codice_Fiscale__c.length()>0 && u.Codice_Fiscale__c  == a.accountObj.Codice_Fiscale__c) {
                    accId=u.Id;
                    break;
                }
                if(u.Partita_IVA__c!=null && u.Partita_IVA__c.length()>0 && u.Partita_IVA__c  == a.accountObj.Partita_IVA__c) {
                    accId=u.Id;
                    break;
                }
                if(u.OCS_External_Id__c!=null && u.OCS_External_Id__c.length()>0 && u.OCS_External_Id__c  == a.accountObj.OCS_External_Id__c) {
                    accId=u.Id;
                    break;
                }
            }
            if(mapGroup.containsKey(AccountUtils.getBranchExternalId(a.codice_filiale))) {
                ownId = mapGroup.get(AccountUtils.getBranchExternalId(a.codice_filiale)).Id;  
            }
            if(mapCaseStd.containsKey(AccountUtils.getBranchExternalId(a.codice_filiale)))
                pId = mapCaseStd.get(AccountUtils.getBranchExternalId(a.codice_filiale)).Id;
            else 
                pId = mapCaseStd.get(mapGroup.get(AccountUtils.getBranchExternalId(a.codice_filiale)).Id).Id;
            String branchId;
            for(Account u : mapBranch.get(AccountUtils.getBranchExternalId(a.codice_filiale))) {
                if(u.OCS_External_Id__c == AccountUtils.getBranchExternalId(a.codice_filiale) && u.OCSAreaId__c == Decimal.valueOf(a.area_filiale) && u.Region_Name__c == a.regione_filiale) {
                    branchId=u.Id;
                    break;
                }
            }
            System.debug('Id finale '+caseCld.AccountId);
            //assegno il dealer al campo AccountId e il branch al Branch__c
            caseCld.AccountId=accId;
            caseCld.Branch__c=branchId;
            //l'owner si riferisce al group e quindi ad un record di Group di tipo queue
 
            caseCld.OwnerId = ownId;
            caseCld.ParentId = pId;
            caseCld.Data_Visibilita__c = data_visibilita;
            caseCld.SFA_ListeCaricate__c= tipo_lista;
            caseCld.Priority = 'Low';                   //aggiunta priorità al case 
            caseCld.DueDate__c = (data_visibilita==null) ? Date.today()+7 : data_visibilita+7;      //aggiungere duedate solo
            caseChild.add(caseCld);
        }
        System.debug('Case Child da inserire '+caseChild.size());
        if(caseChild.size()<=200) {
            insert caseChild;
        }
        else {
            List<Case> t = new List<Case>();
            List<Case> caseInserted = new List<Case>();
            for(Integer i=0; i<caseChild.size();i++) {
                if(i>0 && math.mod(i,199)==0) {
                    insert t;
                    caseInserted.addAll(t);
                    t = new List<Case>();
                } 
                else {
                    t.add(caseChild.get(i));
                }
            }
            if(t.size()>0) {
                insert t;
                caseInserted.addAll(t);
            }
            caseChild = caseInserted.clone();
            caseInserted=null;
        }
        
        SFA_ListeCaricate__c listaCaricate = [SELECT Id, Nome_Lista__c, Data_Caricamento__c, Data_Visibilita__c FROM SFA_ListeCaricate__c WHERE Id = :tipo_lista];
        listaCaricate.Numero_righe__c=this.listInOut.size();
        upsert listaCaricate;
        if(!Test.isRunningTest()) {
            // correzione Dotti per Too many SOQL queries dentro il batch
            Database.executeBatch(new SFAListaDaSedeUpdCaseDisp(mapCaseStd.values()),50);
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