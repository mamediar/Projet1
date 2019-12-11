@isTest
public  class Ricicli_Per_Esiti_Batch_Test {
    
    @TestSetup
    static void makeData(){
        List<Case> casesList = new List<Case>{
            new Case(Tentativo__c = 1 ),
            new Case(Tentativo__c =4 ),
            new Case(Tentativo__c =3 )
        };
        insert casesList;
        
    }

    @isTest
    static void test(){
        List<Case> cases =[SELECT Id FROM Case];
        Map<Id, Case> mapCase = new Map<Id, Case>(cases);
        Test.startTest();
        Ricicli_Per_Esiti_Batch batch = new Ricicli_Per_Esiti_Batch(mapCase.keySet(),'Q525',3,1 );
        Id idBatch = Database.executeBatch(batch);
        Test.stopTest();
        System.assertNotEquals(null, idBatch);
    }
    @isTest
    static void test2(){
        List<Case> cases =[SELECT Id FROM Case];
        Map<Id, Case> mapCase = new Map<Id, Case>(cases);
        Test.startTest();
        Ricicli_Per_Esiti_Batch batch = new Ricicli_Per_Esiti_Batch(mapCase.keySet(),'Q525',6,0 );
        Id idBatch = Database.executeBatch(batch);
        Test.stopTest();
       // System.assertEquals(1, Ricicli_Per_Esiti_Batch.caseToUpdates.size(),'######## pass');

    }
}