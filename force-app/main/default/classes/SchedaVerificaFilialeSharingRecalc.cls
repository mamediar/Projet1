global class SchedaVerificaFilialeSharingRecalc implements Database.Batchable<sObject>{
   	public Date startCreatedDate;
    public Date endCreatedDate;
    public String emailAddress = '';
    public Map<String,Id> mapRole;
    public SchedaVerificaFilialeSharingRecalc(Date startCreatedDate, Date endCreatedDate){
        this.startCreatedDate = startCreatedDate;
        this.endCreatedDate   = endCreatedDate;
        emailAddress = [SELECT ID,Email FROM USER WHERE id=:UserInfo.getUserId()].Email;
        List<Group> groupListCoordinatori = [select id,type,DeveloperName from group where type='role' and DeveloperName like '%COORD_AREA_%'];
        mapRole = new Map<String,Id>();
        for(Group coord : groupListCoordinatori){
            mapRole.put(coord.DeveloperName,coord.ID);
        }
    }
    
    public SchedaVerificaFilialeSharingRecalc(){

        emailAddress = [SELECT ID,Email FROM USER WHERE id=:UserInfo.getUserId()].Email;
        List<Group> groupListCoordinatori = [select id,type,DeveloperName from group where type='role' and DeveloperName like '%COORD_AREA_%'];
        mapRole = new Map<String,Id>();
        for(Group coord : groupListCoordinatori){
            mapRole.put(coord.DeveloperName,coord.ID);
        }
    }
    
    // String to hold email address that emails will be sent to. 
    // Replace its value with a valid email address.
    
    
    // The start method is called at the beginning of a sharing recalculation.
    // This method returns a SOQL query locator containing the records 
    // to be recalculated. 
    global Database.QueryLocator start(Database.BatchableContext BC){
        if(endCreatedDate != null || startCreatedDate ==null){
            return Database.getQueryLocator([SELECT Id, Filiale__c, Filiale__r.OCSAreaId__c
                                         FROM Scheda_Verifica_Filiale__c where
                                             	Createddate >= :startCreatedDate AND
                                             	Createddate <= :endCreatedDate AND 
                                             	Filiale__r.OCSAreaId__c != NULL
                                         	ORDER BY Filiale__r.OCSAreaId__c]);
        } else{
            return Database.getQueryLocator([SELECT Id, Filiale__c, Filiale__r.OCSAreaId__c
                                         		FROM Scheda_Verifica_Filiale__c 
                                             	WHERE Filiale__r.OCSAreaId__c != NULL
                                         	ORDER BY Filiale__r.OCSAreaId__c]);
        }
          
    }
    
    // The executeBatch method is called for each chunk of records returned from start.  
    global void execute(Database.BatchableContext BC, List<sObject> scope){
       System.debug('mappa ruoli-->'+mapRole);
        // Create a map for the chunk of records passed into method.
        Map<ID, Scheda_Verifica_Filiale__c> schedaMap = new Map<ID, Scheda_Verifica_Filiale__c>((List<Scheda_Verifica_Filiale__c>)scope);  
        
        // Create a list of Scheda_Verifica_Filiale__Share objects to be inserted.
        List<Scheda_Verifica_Filiale__Share> newSchedaShrs = new List<Scheda_Verifica_Filiale__Share>();
               
        // Locate all existing sharing records for the scheda records in the batch.
        // Only records using an Apex sharing reason for this app should be returned. 
        List<Scheda_Verifica_Filiale__Share> oldSchedaShrs = [SELECT Id FROM Scheda_Verifica_Filiale__Share WHERE ParentId IN 
             :schedaMap.keySet() AND RowCause='Manual']; 
        
        // Construct new sharing records for the hiring manager and recruiter 
        // on each scheda record.
        for(Scheda_Verifica_Filiale__c scheda : schedaMap.values()){
            Scheda_Verifica_Filiale__Share schedaShr = new Scheda_Verifica_Filiale__Share();
            
            // Set the ID of user (hiring manager) on the scheda record being granted access.
            String role = 'COORD_AREA_'+(Integer)scheda.Filiale__r.OCSAreaId__c;
            System.debug('role-->'+role);
            schedaShr.UserOrGroupId = mapRole.get(role);
            
            // The hiring manager on the scheda should always have 'Read Only' access.
            schedaShr.AccessLevel = 'Edit';
            
            // The ID of the record being shared
            schedaShr.ParentId = scheda.Id;
            
            
            // Add sharing record to list for insertion.
            newSchedaShrs.add(schedaShr);
           
        }
        
        try {
           // Delete the existing sharing records.
           // This allows new sharing records to be written from scratch.
           System.debug('elimino gli sharing:'+oldSchedaShrs);
            Delete oldSchedaShrs;
            System.debug('devo inserire i record:'+newSchedaShrs);
           // Insert the new sharing records and capture the save result. 
           // The false parameter allows for partial processing if multiple records are 
           // passed into operation. 
           Database.SaveResult[] lsr = Database.insert(newSchedaShrs,false);
           
           // Process the save results for insert.
           for(Database.SaveResult sr : lsr){
               if(!sr.isSuccess()){
                   // Get the first save result error.
                   Database.Error err = sr.getErrors()[0];
                   /*
                   // Check if the error is related to trivial access level.
                   // Access levels equal or more permissive than the object's default 
                   // access level are not allowed. 
                   // These sharing records are not required and thus an insert exception 
                   // is acceptable. 
                   if(!(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  
                                     &&  err.getMessage().contains('AccessLevel'))){
                       // Error is not related to trivial access level.
                       // Send an email to the Apex scheda's submitter.
                     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                     String[] toAddresses = new String[] {emailAddress}; 
                     mail.setToAddresses(toAddresses); 
                     mail.setSubject('Apex Sharing Recalculation Exception');
                     mail.setPlainTextBody(
                       'The Apex sharing recalculation threw the following exception: ' + 
                             err.getMessage());
                     Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
                   	System.debug('error-->'+err.getMessage());
                   
               } else {
                   System.debug('sharing aggiunto-->'+sr);
               }
           }   
        } catch(DmlException e) {
           // Send an email to the Apex scheda's submitter on failure.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {emailAddress}; 
            mail.setToAddresses(toAddresses); 
            mail.setSubject('Apex Sharing Recalculation Exception');
            mail.setPlainTextBody(
              'The Apex sharing recalculation threw the following exception: ' + 
                        e.getMessage());
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
    
    // The finish method is called at the end of a sharing recalculation.
    global void finish(Database.BatchableContext BC){  
        // Send an email to the Apex scheda's submitter notifying of scheda completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {emailAddress}; 
        mail.setToAddresses(toAddresses); 
        mail.setSubject('Apex Sharing Recalculation Completed.');
        mail.setPlainTextBody
                      ('The Apex sharing recalculation finished processing');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
}