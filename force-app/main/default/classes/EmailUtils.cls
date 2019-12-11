public class EmailUtils {
    
    public static Messaging.SingleEmailMessage generateEmail(String emailTemplateDeveloperName, List<String> emailAddresses) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String defaultContactId = [SELECT Id FROM Contact WHERE Account.OCS_External_Id__c = 'N00000'][0].Id;
        String q = 'SELECT Id, Name, DeveloperName, Subject, Body FROM EmailTemplate WHERE DeveloperName =: emailTemplateDeveloperName';
        EmailTemplate emailTemplate = (EmailTemplate)Database.query(q)[0];
 
        email.setTargetObjectId(defaultContactId);
        email.setTemplateId(emailTemplate.Id);
        email.setTreatTargetObjectAsRecipient(false);
        email.setToAddresses(emailAddresses);
        email.saveAsActivity = false;
         
        return email;
    }   
    
     public static Messaging.SingleEmailMessage generateEmail(String emailTemplateDeveloperName, List<String> emailAddresses, Id whatId) {
        Messaging.SingleEmailMessage email = generateEmail(emailTemplateDeveloperName, emailAddresses);
        email.setWhatId(whatId);
        return email;        
    }  

    public static Messaging.SingleEmailMessage generateEmail(String emailTemplateDeveloperName, List<String> emailAddresses, List<String> ccAddress) {
        Messaging.SingleEmailMessage email = generateEmail(emailTemplateDeveloperName, emailAddresses);
        email.setCcAddresses(ccAddress);
        return email;
    }

    public static Messaging.SingleEmailMessage generateEmail(String emailTemplateDeveloperName, List<String> emailAddresses, List<String> ccAddress, Id whatId) {
        Messaging.SingleEmailMessage email = generateEmail(emailTemplateDeveloperName, emailAddresses);
        email.setCcAddresses(ccAddress);
        email.setWhatId(whatId);
        return email;        
    }   
    
    
    public static Messaging.SingleEmailMessage generateEmail(String emailTemplateDeveloperName, List<String> emailAddresses, List<id> attachments) {
        Messaging.SingleEmailMessage email = generateEmail(emailTemplateDeveloperName, emailAddresses);
        email.setEntityAttachments(attachments);
		return email;
    }
    public static Messaging.SingleEmailMessage generateEmailNoEmailTemplate(List<String> emailAddress,List<String> ccEmailAddress,List<String> bccEmailAddress, String subject, String body)
    {
     	Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setBccAddresses(bccEmailAddress);
        email.setCcAddresses(ccEmailAddress);
        email.setToAddresses(emailAddress);
        email.setSubject(subject);
        email.setHtmlBody(body);
        return email;
    }
    
    public static Messaging.SingleEmailMessage generateEmail(String emailTemplateDeveloperName, List<String> emailAddresses, List<id> attachments, List<String> ccAddress) {
        Messaging.SingleEmailMessage email = generateEmail(emailTemplateDeveloperName, emailAddresses, attachments);
        email.setCcAddresses(ccAddress);
        
        return email;
    }
    
    public static Messaging.SingleEmailMessage generateEmailReclami(List<String> toList, List<String> ccList, List<String> bccList, String plainBody, List<Id> idsAttachments, String subject) {
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setEntityAttachments(idsAttachments);
        email.setToAddresses(toList);
        email.setCcAddresses(ccList);
        email.setBccAddresses(bccList);
        email.setPlainTextBody(plainBody);
        email.setSubject(subject);
        
        return email;
    }
    
    public static Messaging.SingleEmailMessage generateEmailReclamiFandT(List<String> toAddress, String body, String subject) {
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();       
        email.setToAddresses(toAddress);
        email.setPlainTextBody(body);
        email.setSubject(subject);
        
        return email;
    }

    public static Messaging.SingleEmailMessage generateEmailReclamiCambioCoda(List<String> toAddress, String body, String subject) {
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();       
        email.setToAddresses(toAddress);
        email.setPlainTextBody(body);
        email.setSubject(subject);
        
        return email;
    }
    
    public static void sendEmail(Messaging.SingleEmailMessage[] messageToSend) {        
        String mockmail = CompassParametersUtils.getValue('inviomail.mock');        
		list<String> ccSender;
        list<String> bccSender;
        if(!String.isEmpty(mockmail)){
            System.debug('invio email mockato verso:: '+mockmail);
            for(Messaging.SingleEmailMessage email:messageToSend){
                ccSender = new List<String>();
                bccSender = new List<String>();
                if(email.getBccAddresses() != null){
                    for ( String b : email.getBccAddresses())
                    {
                        bccSender.add(b + '.invalid');
                    }
                }
                if(email.getCcAddresses() != null){
                    for( String cc : email.getCcAddresses())
                    {
                        ccSender.add(cc + '.invalid');
                    }
                }
                email.setToAddresses(new String []{mockmail});
               
                email.setBccAddresses(bccSender);
                email.setCcAddresses(ccSender);
                system.debug('email to send :' + email);
            }                        
        }
		
        Messaging.sendEmail(messageToSend);         
        
    }    
    
    public static void sendEmail(Messaging.SingleEmailMessage messageToSend) {  
        sendEmail(new Messaging.SingleEmailMessage[] {messageToSend});
    }


    public static List<String> listEmailAdmin(){
         List<String> listEmail = new List<String>();
         List<User> listAdmin = [SELECT Name, Email FROM User WHERE ProfileId IN (SELECT ID  FROM Profile WHERE name = 'System Administrator')];
         if (listAdmin!=null) {
             for (User user:listAdmin) {
                 string emailAdmin = user.Email;
                 if (!String.isEmpty(emailAdmin)) {
                     System.debug('sending email to:'+emailAdmin);
                     listEmail.add(emailAdmin);
                 }
             }
         }
         return listEmail;
    }

}