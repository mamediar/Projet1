@isTest
public with sharing class ScheduleBatchAnomalieDocTest {
    
    @TestSetup
    static void makeData(){
         List<Case> cases = new List<Case>{
         new Case(NumeroPratica__c='10000008',RO_Vecchio_Cellulare__c='773739676'),
         new Case(NumeroPratica__c='100')
     };
     insert cases;
    List<Anomalie_Doc__c> anomalies = new List<Anomalie_Doc__c>{
         new Anomalie_Doc__c(CaseId__c= Cases[0].Id),
         new Anomalie_Doc__c(CaseId__c= cases[1].Id)
     };
     insert anomalies;
        
    }
    @isTest
    static void executeBatch(){
      List<Anomalie_Doc__c> anomalies = [SELECT Id FROM Anomalie_Doc__c];
      Set<Id> idCases = new Set<Id>{
          anomalies[0].Id, anomalies[1].Id
      };
      Test.startTest();
      String sch = '0  00 1 3 * ?';
       System.schedule('test', sch, new ScheduleBatchAnomalieDoc(idCases) );
      Test.stopTest();
    }
}