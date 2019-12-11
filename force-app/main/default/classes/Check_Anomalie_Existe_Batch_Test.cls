@isTest
public  class Check_Anomalie_Existe_Batch_Test {
     @TestSetup
    static void makeData(){
         List<Case> cases = new List<Case>{
         new Case(NumeroPratica__c='10000008',RO_Vecchio_Cellulare__c='773739676'),
         new Case(NumeroPratica__c='100')
     };
     insert cases;
}
@isTest
static void executeBatch(){
    List<Case> cases = [SELECT Id FROM Case];
      Set<Id> idCases = new Set<Id>{
          cases[0].Id, cases[1].Id
      };
    Test.startTest();
     Check_Anomalie_Existe_Batch bc = new Check_Anomalie_Existe_Batch(idCases);
     Id idbatch = Database.executeBatch(bc);

    Test.stopTest();

}

}