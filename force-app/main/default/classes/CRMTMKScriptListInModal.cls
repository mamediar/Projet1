public with sharing class CRMTMKScriptListInModal {
    
    @AuraEnabled
    public static List<XCS_Script__c> listScriptInModal(String codiceAzione, String codiceTMK,String codiceProdotto,String campType,Date startDate,Date endDate){
        System.debug(codiceAzione + ' '  + codiceTMK +' '+ codiceProdotto + ' '+ campType);
        return XCSScriptUtil.listScriptinModal(codiceAzione,codiceTMK,codiceProdotto,campType,startDate,endDate);        
    }
    @AuraEnabled
    public static string codProdPadre(String codProdFiglio){
        return [SELECT parent__r.RSS_External_Id__c from Product2 where RSS_External_Id__c =:codProdFiglio].parent__r.RSS_External_Id__c;
        
    }
}