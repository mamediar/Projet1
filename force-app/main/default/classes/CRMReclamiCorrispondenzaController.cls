public class CRMReclamiCorrispondenzaController {
    
    @AuraEnabled
    public static List<EmailMessage> getEmails(String recordId){
        return [SELECT Id, Subject, ToAddress, CcAddress, BccAddress, TextBody FROM EmailMessage where parentId =: recordId];
    }
    
}