public class picklistProductForCampaignController {
   	@auraEnabled 
    public static List<Product2> prod(){
       return  [SELECT Id, Name, RSS_External_Id__c FROM Product2];
       
    }
    @auraEnabled
    public static void updates(String idcamp, Id prod){
        system.debug('rwgsag' + prod  + ' ' +  idcamp);
        Campaign c = [SELECT Id, ProductCode__r.RSS_External_Id__c FROM Campaign where Id =: idcamp];
        c.ProductCode__c = prod;
        update c;
    }

}