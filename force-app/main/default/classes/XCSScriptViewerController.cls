public class XCSScriptViewerController {

    @AuraEnabled
    public static String getScript(String recordId){
        
        Case cs = [SELECT Id, categoriaExternalId__c FROM Case WHERE Id =: recordId];
        
        XCS_Script__c script = [SELECT Id, Text__c FROM XCS_Script__c WHERE CaseActivityType__c =: cs.categoriaExternalId__c];
        
        return script.Text__c;
    }
}