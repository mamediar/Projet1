public class CaseUtils {
 
    //Proiezioni Query
    
  public static final string SELECTCLIENTENONTROVATO = 'id,AccountId,Account.Privacy_SMS__pc,Account.Telefono_Cellulare__c,Categoria_Riferimento__r.External_Id__c,TentativoNum__c,OwnerId';
    public static final string GESTIONE_INVIO_SMS = 'id,AccountId,Account.Telefono_Cellulare__c,Categoria_Riferimento__r.External_Id__c,Account.PersonMobilePhone,SMSInviatiNum__c';
    public static FINAL String SELECT_PROCESSTYPE = 'id,processType__c';
    public static FINAL String SELECT_ACCOUNT_FIELD = 'id,processType__c,Account.getCodice_Cliente__c ';
    
    
    //ConfigCaseCommonAction Constant
    
    public static final String COMMON_ACTION_CLIENTE_NON_TROVATO_RECORDTYPE = 'ClienteNonTrovato';
    public static final String COMMON_ACTION_GESTIONE_INVIO_SMS_RECORDTYPE = 'GestioneInvioSMS';

    // ProcessType
    // 
    
    public static final String GESTIONE_FAX_PROCESSTYPE_DA_CONTROLLARE = 'FaxCQ_Da_Controllare';
    public static final String GESTIONE_FAX_PROCESSTYPE_INVIABILE = 'FaxCQ_Inviabile_Outsourcer';
    public static final String GESTIONE_FAX_PROCESSTYPE_INVIATO = 'FaxCQ_Inviato_Outsourcer';
    public static final String GESTIONE_FAX_PROCESSTYPE_CONTESTATO = 'FaxCQ_Contestato_DaVisionare';
    public static final String GESTIONE_FAX_PROCESSTYPE_RICONTROLLATO = 'FaxCQ_Ricontrollato';
    
    // messaggi
     
    public static final String LIMITE_TENTATIVI_RAGGIUNTO = 'Il limite di tentativi è già stato raggiunto';
    public static final String AZIONE_NON_TROVATA = 'Non è stata configurata nessuna azione per questa tipologia di case';
    public static final String MESSAGGIO_CASO_CHIUSO = 'Il caso è stato chiuso';
    public static final String TELEFONO_NON_CONFORME = '- Telefono non conforme\n';
    public static final String PRIVACY_NON_SELEZIONATA = 'Per effettuare una richiesta è necessario prestare o negare il consenso al trattamento dei dati personali';
    public static final String INSERIRE_TELEFONO = 'Inserire numero telefono';
    public static final String SELEZIONARE_UN_SMS = 'Selezionare un SMS da inviare';
    public static final String TOAST_SUCCESS = 'Successo';
   
    
    // Activity Types
    public static final String SFA_SEGNALAZ_DEALER = 'SFA_SEGNALAZ_DEALER';   
    public static final String SFA_NEW_DEALER_PROSPECT = 'SFA_NEW_DEALER_PROSPECT';
  public static final String SFA_NEW_DEALER_ACQUISITION = 'SFA_NEW_DEALER_ACQUISITION';    
    public static final String SFA_GESTIONE_DOSSIER_DEALER = 'SFA_GESTIONE_DOSSIER_DEALER';
    public static final String SFA_GESTIONE_ACCOLLO_DEALER = 'SFA_GESTIONE_ACCOLLO_DEALER';
    public static final String CRM_POSTVENDITA = 'CRM_POSTVENDITA';
    
    // Stati
    public static final String APERTO = 'New';
    public static final String CHIUSO = 'Closed';
    public static final String ANNULLATO = 'Annullato';
    public static final String ERROREATTIVITA = 'ErrorCreatingActivity';
    public static final String DA_PROCESSARE = 'PV_Da_Processare';
    public static final String SOSPESO = 'Sospeso';
    public static final String LAVORATA = 'Lavorato';
    public static final String GESTITO = 'Gestito';
    public static final String INOLTRATO = 'Inoltrato';
    public static final String RICEVUTO = 'Ricevuto';

    // Subject
    public static final String SFA_SUBJECT_NEW_DEALER_PROSPECT = 'Nuovo Prospect Convenzionato';
    public static final String SFA_SUBJECT_NEW_DEALER_ACQUISITION = 'Nuova Acquisizione Convenzionato';
    public static final String SFA_SUBJECT_SEGNALAZ_DEALER = 'Segnalazione Convenzionato';
    public static final String SFA_SUBJECT_GESTIONE_DOSSIER = 'Gestione Dossier';
    public static final String SFA_SUBJECT_GESTIONE_ACCOLLO = 'Gestione Accollo';
    public static final String SFA_SUBJECT_GESTIONE_DOSSIER_FIT = 'Dossier convenzionamento';
    public static final String SFA_SUBJECT_GESTIONE_ACCOLLO_FIT = 'Accollo documenti';
    

    public static Case getCase(String recordTypeName, String categoryExternalId)
    {        
        return new Case(RecordTypeId=RecordTypeUtil.getCaseRecordType(recordTypeName), 
                        Categoria_Riferimento__r=XCS_CategoriaUtil.getCategoryForExternalId(categoryExternalId));
    }    
    
    public static Case createCaseRitornoPostale(Map<String,String> params) {
        
         Case caseRitornoPostale = new Case();
        
        caseRitornoPostale.put('RecordTypeId', RecordTypeUtil.getCaseRecordType('CRMRitorniPostali'));
        for(String strFieldName : params.keySet()) { 
            String strFieldValue = params.get(strFieldName);
            caseRitornoPostale.put(strFieldName, strFieldValue);    
        }
                
        return caseRitornoPostale;
        
    }
    
    public static String getAccountAssigment(String caseId)
    {
        return [select accountId from case where id = :caseId].accountId;
    }
    //Cambia Lo stato del Case, che come Id ha 'caseId', in 'status'.
    public static void changeStatus(String caseId,String status){
        Case c = new Case(Id = caseId,Status = status);
        update(c);
    } 
    
    //Ritorna il Case passato aggiornandoli lo stato ma senza operare un update.
    public static Case changeStatus(Case c,String status){
        c.Status=status;
        return(c);
    }     
    //Cambia l'activity Type del Case, che come Id ha 'caseId', in 'activityType'.
    public static void changeActivityType(String caseId,String activityType){
        Case c = new Case(Id = caseId,ActivityType__c  = activityType);
        update(c);
    } 
     //Chiude il Case che come Id ha 'caseId'
    public static void closeCase(String caseId){
        Case c = new Case(Id = caseId,Status = CHIUSO);
        update(c);
        System.debug('CaseUtils closeCase input: '+caseId+'\nCase: '+c);
    }
    //Ritorna true se il Caso con Id 'caseId' ha lo stato uguale a 'status', altrimenti false.
    public static Boolean checkStatus(String caseId,String status){
        Case c = [SELECT Id,Status FROM Case WHERE Id =: caseId];
        return (c.Status.equals(status));
    }
    
    public static void esitaCase(String caseId,String esito){
        Case c = [SELECT Id, Esito__c FROM Case WHERE Id =: caseId];
        c.Esito__c = esito;
        update(c);
    }
    public static void cancellaCase(String caseId)
    {
        Case c = new Case(id=caseId);
        Delete c;
    }
    
    public static void esitaCase(String caseId,String esito,String note){
        System.debug('case utils id = ' + caseId);
        Case c = [SELECT Id, Esito__c,Note__c FROM Case WHERE Id =: caseId];
        c.Esito__c = esito;
        c.Note__c=note;
        update(c);
    }
    
    public static List<Case> caseListForAccountidOwner(String selector,List<Account> accountList ,List<Group> groupList)
    {
      return Database.query('Select ' + selector + ' From Case Where AccountId IN :accountList AND OwnerId IN :groupList');           
    }
    
    public static List<Case> caseListForCategoryAndCategory(String selector,String categoryExternalId,List<Group> groupList)
    {
        return Database.query('Select ' + selector + ' From Case Where Categoria_riferimento__r.External_Id__c = :categoryExternalId AND OwnerId IN :groupList');
    }
    
    public static Case caseGenericQueryById(String selector,String recordId)
    {
        return Database.query('Select ' + selector + ' From Case Where Id = :recordId');  
    }
    
    public static void aggiornaDispositionCase(String caseId,Id dispositionId){   //Disposition__c è una lookup verso l'oggetto XCS_Disposition
        System.debug('case utils id = ' + caseId);
        Case c = new Case(ID = caseId, Disposition__c = dispositionId);    
        update(c);
    }  
    
    public static void aggiornaDispositionCase(String caseId,String disposition){   //Disposition__c è una lookup verso l'oggetto XCS_Disposition
        System.debug('case utils id = ' + caseId);
        aggiornaDispositionCase(caseId,disposition,true);
    }
    
    public static Case aggiornaDispositionCase(String caseId,String disposition, Boolean doUpdate){   //Disposition__c è una lookup verso l'oggetto XCS_Disposition
        //System.debug('case utils id = ' + caseId);
        Id dispositionId = [SELECT Id FROM XCS_Disposition__c WHERE External_Id__c =: disposition][0].Id;
        System.debug('***************disposition trovata: = ' + dispositionId);
        Case c = new Case(ID = caseId, Disposition__c = dispositionId);
        if(doUpdate){update(c);}       
        return c;
    }

    public static Case aggiornaDispositionCase(Case c,String disposition, Boolean doUpdate){   //Disposition__c è una lookup verso l'oggetto XCS_Disposition
        //System.debug('case utils id = ' + caseId);
        Id dispositionId = [SELECT Id FROM XCS_Disposition__c WHERE External_Id__c =: disposition][0].Id;
        System.debug('***************disposition trovata: = ' + dispositionId);
        c.Disposition__c = dispositionId;
        if(doUpdate){update(c);}
        return c;
    }    
   
    public static void aggiornaDispositionCase(String caseId,XCS_Disposition__c disposition)
    {
       Case c = new Case(ID = caseId,disposition__c = disposition.id);
       if(!String.isEmpty(disposition.CaseStatus__c))
       {
          c.status = disposition.CaseStatus__c; 
       }
       update c; 
    }
    
    public static void aggiornaDispositionCase(String caseId,XCS_Disposition__c disposition,String note)
    {
        Case c = new Case(ID = caseId,disposition__c = disposition.id,note__c = note);  
       if(!String.isEmpty(disposition.CaseStatus__c))
       {
          c.status = disposition.CaseStatus__c; 
       }
       update c; 
    }
    
    public static void aggiornaDispositionCase(String caseId,Id dispositionId,String note){   //Disposition__c è una lookup verso l'oggetto XCS_Disposition
        System.debug('case utils id = ' + caseId);
        Case c = new Case (ID = caseId, Disposition__c = dispositionId,Note__c = note);
        update(c);
    } 
    

    
    public static String getDispositionExternalId(Id dispositionId){   //Disposition__c è una lookup verso l'oggetto XCS_Disposition
        String dispositionExternalId = [SELECT Id, External_Id__c FROM XCS_Disposition__c WHERE Id =:dispositionId][0].External_Id__c;
        return dispositionExternalId;
    }

    
    public static void assignToQueue(String caseId,String queueDevName){
        Case c = assignToQueueNoUpdate(caseId, queueDevName);
        update(c);
    }
    
    public static Case assignToQueue(Case c,String queueDevName){       
        Group queue = [select Id, Name, DeveloperName from Group where DeveloperName=:queueDevName and Type='queue'][0];
        c.OwnerId = queue.Id;
        return c;
    }


    // created by Dotti (30-9-2019)
    public static Case assignToFilialeQueueByDealer(Case c,String dealerOcsExternalId){       
        // Copiato da SFACambioAutoRirercaParticaController getFilialeQueueByDealer()
        String filialeQueue = [select Id, Branch__r.OCS_External_Id__c from Account where RecordType.Name = 'Dealer' AND OCS_External_Id__c = :dealerOcsExternalId][0].Branch__r.OCS_External_Id__c;
        if(!String.isEmpty(filialeQueue)){
            c = CaseUtils.assignToQueue(c,filialeQueue);
        }
        return c;    
    }


    
    public static Case assignToQueueNoUpdate(String caseId,String queueDevName){
        Case c = [SELECT Id, OwnerId FROM Case WHERE Id =: caseId];
        String queueId=[select Id from Group where DeveloperName=:queueDevName and Type='queue'][0].Id;
        System.debug('QUEUEID: ' + queueId);
        c.OwnerId=queueId;
        return c;
    }    
     
    public static Case assignToQueueNoUpdate(case c,String queueDevName){
        String queueId=[select Id from Group where DeveloperName=:queueDevName and Type='queue'][0].Id;
        System.debug('QUEUEID: ' + queueId);
        c.OwnerId=queueId;
        return c;
    }    
    
    public static void assignToParentQueue(String caseId){
        String uId=UserInfo.getUserId();
        String queueDevName=[select CreatedBy.DefaultQueueId__c from case where Id=:caseId].CreatedBy.DefaultQueueId__c;
        System.debug('--assignToParentQueue queueDevName: '+queueDevName);
        if(queueDevName!=null && !queueDevName.equals('')){
            assignToQueue(caseId,queueDevName);
        }
    }
    
    public static Boolean getFlagCarte(String caseId){
        Boolean res=[select FlagCarteDaRitirare__c from Case where Id=:caseId].FlagCarteDaRitirare__c;
        return res!=null?res:false;
    }
    
    public static String getEsito(String caseId){
        String res=[select Esito__c from Case where Id=:caseId].Esito__c;
        return res!=null?res:'';
    }
    
    public static String getOwnerName(String caseId){
        return [SELECT Owner.Name FROM Case WHERE Id =: caseId].Owner.Name;
    }
    //Cambia Lo stato del Case, che come Id ha 'caseId', in 'status'.
    public static void updateListCase(List<Case> cases){        
        update(cases);
    }
    
    public static String getOCSIdAccount(String caseId){
        String res=[select Account.Id from Case where Id=:caseId].Account.Id;
        return res!=null?res:'';
    }
    
    public static String getCaseNumber(String caseId){
        String res=[select CaseNumber from Case where Id=:caseId].CaseNumber;
        return res!=null?res:'';
    }
    
    public static String getOCSAccountId(String caseId){
        String res=[select Account.getCodice_Cliente__c from Case where Id=:caseId].Account.getCodice_Cliente__c;
        return res!=null?res:'';
    }
    
    public static String getStatus(String caseId){
        Case c = [SELECT Id,Status FROM Case WHERE Id =: caseId];
        return (c.Status);
    }
    
    public static void writeNotes(String caseId,String notes){
        Case c=[select Id,Note__c from Case where Id=:caseId][0];
        c.Note__c=notes;
        update c;
    }
    
    //prende n Case in base al numero passato in ingresso e cambia l'ownership con l'Id dello user Loggato popolando il campo Owner_User__c
    public static List<Case> changeOwner(integer i, id codaSelezionata, String direzione){
        String userID = Userinfo.getUserId();
        String stato = 'Closed';
        String iCase = 'SELECT Id, Owner_User__c FROM Case where Owner_User__c = null AND Status !=:stato  AND OwnerId =:codaSelezionata  ORDER BY CreatedDate ' + direzione + ' LIMIT ' + i;
        List<Case> lCase = Database.query(iCase);
        if(lCase.size() > 0){
            for(Case c : lCase)
            {
                c.Owner_User__c = userID;   
            }
            update lCase;
        }
        return lCase;
    }
    
    public static void popolateOwner(String caseId){
        Case c=[SELECT Id, Owner_User__c FROM Case where Id=:caseId][0];
    popolateOwner(c);
    }    
    
    public static case popolateOwner(Case c){
        String userID = Userinfo.getUserId();
        c.Owner_User__c = userID;
        update c;
        return c;
    }    
    
    public static Case makeReclamo(){
        Case res=new Case();
        res.ActivityType__c='CRM_RECLAMI';
        res.RecordTypeId=[select Id from RecordType where Name='CRM_Reclami'].Id;
        res.Type='CRM';
        res.Subject='Reclamo';
        return res;
    }
    
     // METODI PER I COMPONENTI DI AZIONI GENERICHE DEL CASE
    
    public static ConfigCaseCommonAction__c getRecordByCaseCategoryAndOwnerDeveloperName(String recordtypeName,String caseCategoryExternalId, String ownerDeveloperName)
    {
        List<ConfigCaseCommonAction__c> q = [Select id, TentativiMax__c,DispositionToAssign__c,CaseStatusToAssign__c From ConfigCaseCommonAction__c Where Recordtype.DeveloperName = :recordtypeName AND CaseCategoryExternalId__c = :caseCategoryExternalId AND QueueDeveloperName__c = :ownerDeveloperName];
        return (q != null && !q.isEmpty()) ? q.get(0) : null;
    }
    
    public static ConfigCaseCommonAction__c getChildRecordByParentIdAndAttempt(String parentId,Integer tentativoNum)
    {
        List<ConfigCaseCommonAction__c> lista = [Select id, RangeMin__c,RangeMax__c,SMSTemplateDeveloperName__c,NoteTemplateDeveloperName__c,DispositionToAssign__c from ConfigCaseCommonAction__c Where parent__c = :parentId AND RangeMin__c <= :tentativoNum AND RangeMax__c >= :tentativoNum];
        return (lista == null || lista.isEmpty() ? null: lista[0]);
    }
    public static List<ConfigCaseCommonAction__c> getChildsFromParent(String parentId)
    {
        return[Select id, RangeMin__c,RangeMax__c,SMSTemplateDeveloperName__c,NoteTemplateDeveloperName__c,DispositionToAssign__c from ConfigCaseCommonAction__c where parent__c = :parentId];
    }
    public static ConfigCaseCommonAction__c getRecordByRecordtypeAndRange(String recordtypeName, Integer tentativoNum)
    {
        List<ConfigCaseCommonAction__c> results= [SELECT CaseStatusToAssign__c, DispositionToAssign__c, TentativiMax__c, SMSTemplateDeveloperName__c, NoteTemplateDeveloperName__c, OCSTemplateDeveloperName__c FROM ConfigCaseCommonAction__c WHERE RecordType.DeveloperName = :recordtypeName AND RangeMin__c <= :tentativoNum AND RangeMax__c >= :tentativoNum];
        return (results != null && !results.isEmpty()) ? results.get(0) : null;
    }
    
    
}