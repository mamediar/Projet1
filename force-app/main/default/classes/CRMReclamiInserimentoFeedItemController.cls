public without sharing class CRMReclamiInserimentoFeedItemController {
    
    @AuraEnabled
    public static List<Reclami_Timestamp__c> getFeedItem(String recordId){ 
        return  [SELECT Id, CaseId__c, Data__c, Evento__c, Utente__r.Name FROM Reclami_Timestamp__c
                                       where CaseId__c =: recordId  order by CreatedDate desc];
    }    
                
}