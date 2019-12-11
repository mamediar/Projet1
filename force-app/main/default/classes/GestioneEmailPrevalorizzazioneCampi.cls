global class GestioneEmailPrevalorizzazioneCampi implements QuickAction.QuickActionDefaultsHandler {
    
    global GestioneEmailPrevalorizzazioneCampi() {        
    }
    
    global void onInitDefaults(QuickAction.QuickActionDefaults[] defaults) {
        
        QuickAction.SendEmailQuickActionDefaults sendEmailDefaults = (QuickAction.SendEmailQuickActionDefaults)defaults.get(0);
        EmailMessage emailMessage = (EmailMessage)sendEmailDefaults.getTargetSObject();   
        System.debug('sendEmailDefaults.getActionName() = ' + sendEmailDefaults.getActionName());
        Case c;
        
        Id whichId = sendEmailDefaults.getContextId();
        String whichObj = String.valueOf(whichId.getSObjectType()); 
        
        if('Case'.equalsIgnorecase(whichObj)){         
            c = [Select RecordType.DeveloperName, origin from case where id =: whichId];
        } 
        else if ('EmailMessage'.equalsIgnoreCase(whichObj)){
            String idC = [Select ParentId from EmailMessage where id =: whichId].ParentId;
            c = [Select RecordType.DeveloperName, origin from case where id =: idC];
        }
        
        if('CRM_Gestione_Email'.equalsIgnoreCase(c.recordType.DeveloperName) && 'Email'.equalsIgnoreCase(c.Origin)){  
            
            if (sendEmailDefaults.getActionName().equals('Case.SendEmail') ||
                sendEmailDefaults.getActionName().equals('EmailMessage._Reply') || 
                sendEmailDefaults.getActionName().equals('EmailMessage._ReplyAll')){
                    
                    EmailMessage emailCase = [Select id, toAddress, FromAddress, messageDate, CreatedDate, ccAddress
                                              from EmailMessage where ParentId =: c.id 
                                              ORDER BY CreatedDate ASC Limit 1];
                    
                    List<CRM_QueueMailFaxConfig__c> queueMail = [Select Email_per_risposta__c from CRM_QueueMailFaxConfig__c 
                                                                 where Mailbox__c =: emailCase.toAddress];
                    String emailPerRisposta = '';
                    if(queueMail[0].Email_per_risposta__c != null && !''.equalsIgnoreCase(queueMail[0].Email_per_risposta__c))
                         emailPerRisposta = queueMail[0].Email_per_risposta__c;                       
                                       
                    emailMessage.FromAddress = emailPerRisposta;
                    emailMessage.ValidatedFromAddress = emailPerRisposta;        
                    emailMessage.BccAddress = '';
                    emailMessage.ToAddress = emailCase.fromAddress;
                    emailMessage.ccAddress = emailCase.ccAddress;
                    
                }                    
        }       
    }
    
}