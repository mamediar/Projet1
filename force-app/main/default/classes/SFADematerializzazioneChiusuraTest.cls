@isTest
public with sharing class SFADematerializzazioneChiusuraTest {



   @isTest
    public static void test1(){
        Account dealer = TestDataFactory.insertDealer();
        XCS_Categoria__c cat2 = new XCS_Categoria__c(External_Id__c = 'AT0122');
        insert cat2;
        Case cas = new Case();
        cas.Status = 'New';
        cas.Subject = 'Test';
        cas.Esito__c='Esito';
        cas.Categoria_Riferimento__c = cat2.id;
        cas.AccountId = dealer.id;
        Date dataRicez = Date.today().addDays(-30);
        cas.Data_Ricezione__c = dataRicez;
        insert cas; 
        Test.startTest();
        Id batchJobId = Database.executeBatch(new SFADematerializzazioneChiusura(), 1);
        Test.stopTest();
        List<Case> lista = [SELECT ID, Esito__c FROM CASE WHERE Status = 'Closed'];
        System.assert(lista!=null && lista.size()==1);
    }

  @isTest
    public static void testFAKE(){
        XCS_Categoria__c cat2 = new XCS_Categoria__c(External_Id__c = 'AT0122');
        insert cat2;
 
        Test.startTest();
        SFADematerializzazioneChiusura bat = new SFADematerializzazioneChiusura();
         bat.execute(null);
        Test.stopTest();

    }
}