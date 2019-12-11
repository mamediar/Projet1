public class ovverideEventNewController {

    @AuraEnabled
    public static String getFiliale() {
        String FilialeId;
        User u= [SELECT Id,Name,DefaultQueueId__c FROM User WHERE Id =: UserInfo.getUserId()];
        if(u!=null){
            String OCSExternalId = u.DefaultQueueId__c == null ? '' : u.DefaultQueueId__c;
            if(OCSExternalId!=null){
                FilialeId = [SELECT Id FROM Account WHERE OCS_External_Id__c=: OCSExternalId].Id;
            }
        }
       
        return FilialeId == null ? '' : FilialeId;
    }
    
}