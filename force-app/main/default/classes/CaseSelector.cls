//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 11/06/2019
//-- - Description  : Handle Case Selector
//----------------------------------------------------------------------

public with sharing class CaseSelector {
  
  
  /*Author: Sana Badji
  Retrieve update cases belong to family
  */
      public static   List<Case>  getPropuitFamily (Set<Id> caseIds, String family ){
        List<Case> getPropuitFamily =
                        [SELECT Id, OwnerId,Product__r.Family,AccountId,LastModifiedDate FROM 
                          Case WHERE  Id IN :caseIds AND Product__r.Family =:family];  
                 
        return getPropuitFamily;
    }


  /*
  Author: Sana Badji
  Retrieve List step  by Case ID
  */
      public static   RO_CRMRich_online_steplog__c  getStep (String step ){
          RO_CRMRich_online_steplog__c steplogByStep = [SELECT RO_CRMStep__c 
          FROM RO_CRMRich_online_steplog__c WHERE  RO_CRMStep__c =:step]; 
                 
        return steplogByStep;
    }

 /*
  Author: Sana Badji
  Retrieve List RO_CRMRich_online_steplog__c    by Case ID
  */
      public static  List<RO_CRMRich_online_steplog__c>  selectorRichOnlineStepLog (Set<Id> caseIds){
          List<RO_CRMRich_online_steplog__c> richOnlineStepLog = [SELECT RO_CRMStep__c,
          RO_CRMRichiesta_Online__r.NumeroPratica__c,RO_CRMRichiesta_Online__c,
          RO_CRMRichiesta_Online__r.Product__r.DEMAnomalie__c , RO_CRMRichiesta_Online__r.Product__r.Family,
          RO_CRMRichiesta_Online__r.AccountId,RO_CRMRichiesta_Online__r.LastModifiedDate
          FROM RO_CRMRich_online_steplog__c WHERE RO_CRMRichiesta_Online__c IN :CaseIds]; 
        return richOnlineStepLog;
    }

}