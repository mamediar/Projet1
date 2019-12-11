@isTest
public with sharing class SFAListaDaSedeUpdCaseDispTest {


    @isTest
   public static void runBatchTest() {
        XCS_Categoria__c categoria = new XCS_Categoria__c(External_Id__c = '1',Name ='cat');
        insert categoria;   
        Case c = new Case(Subject = 'test', Status = 'New', Priority = 'Medium', Categoria_Riferimento__c = categoria.id, Da_Esitare__c = 0);
        insert c;
        List<Case> cases = new List<Case> ();
        cases.add(c);
        Test.startTest();
        SFAListaDaSedeUpdCaseDisp bat = new SFAListaDaSedeUpdCaseDisp(cases);
        database.executebatch(bat,1000);
        Test.stopTest();
        // verify
        Case caseOutput = [SELECT Id,Da_Esitare__c FROM Case WHERE id=:c.id LIMIT 1];
        System.assert(caseOutput.Da_Esitare__c == 0);

   }
}