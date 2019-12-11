/**
 * ***********************************************************************************
 *     * @author abdoulaye.diopdev3@compass.com.dev
 *     * @date  14/10/2019
 *     * @description 
 * ************************************************************************************
 **/
 @isTest
public with sharing class RicicliPerEsitiSchedulableTest {
    
    /**
     * @Author Abdoulaye DIOP
     * @date  14/10/2019
     **/
    @TestSetup
    static void makeData(){

        // Create an account Object
		Account accoObj = new Account();
		accoObj.Name = 'testAcc';
		accoObj.Type = 'CM';
		accoObj.BillingCountry = 'United States';
		insert accoObj;

		// Create a contact Object
		Contact conObj = new Contact();
		conObj.FirstName = 'test';
		conObj.LastName = 'testLastname';
		conObj.AccountId = accoObj.Id;
		conObj.Email = 'abc@gmail.com';
		insert conObj;

        //get a goup Object  DeveloperName = 'Q337'
		Group gr = [SELECT Id, Name, DeveloperName FROM Group WHERE Type = 'Queue' AND DeveloperName = 'Q337'];

        Id idRecordTypeCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CRM Richiesta Online').getRecordTypeId();

        // Create a case a object Q337
		Case caseObj = new Case();
        caseObj.RecordTypeId = idRecordTypeCase;
		caseObj.ContactId = conObj.Id;
		caseObj.Status = 'Open';
		caseObj.Subject = 'test';
		caseObj.Description = 'desc';
		caseObj.OwnerId = gr.Id;
		caseObj.Tentativo__c = 2;
		caseObj.TentativoNonRicorda__c =75;
		insert caseObj;
    }

    /**
     * @Author Abdoulaye DIOP
     * @date  14/10/2019
     **/
    @isTest
    static void executeTest(){
        Case cas = [SELECT Id FROM Case LIMIT 1];
        Set<Id> idsCase = new Set<Id>();
        String developerName = 'Q337';
        idsCase.add(cas.Id);
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        RicicliPerEsitiSchedulable rPES = new RicicliPerEsitiSchedulable(idsCase, developerName, 1, 2);

        Test.startTest();
        String jobId = System.schedule('jobName', CRON_EXP, rPES);
        Test.stopTest();
        System.assertNotEquals(jobId, null);
    }
}