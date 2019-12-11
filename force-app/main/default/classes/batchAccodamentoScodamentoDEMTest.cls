/**
 * @File Name          : batchAccodamentoScodamentoDEMTest.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : CISSE Ahmet
 * @Last Modified On   : 20/09/2019 à 17:17:03
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    28/05/2019 à 16:27:10   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
@isTest
private class batchAccodamentoScodamentoDEMTest {

	@testSetup
	static void setup() {
        
        
        
        ID PersonAccountId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
		// Create records for test.
		Account[] accts = new List < Account > ();

		Account a1 = new Account(
		FirstName = 'test1', DEM_Da_Inviare__c = false, BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911134' , 
        RecordTypeId = PersonAccountId, LastName = 'TestPAcc' , DEM_Da_Inviare__pc = true , PersonEmail = 'test@test.it' );

		Account a2 = new Account(
		FirstName = 'test2', DEM_Da_Inviare__c = true, BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911135' , 
        RecordTypeId = PersonAccountId, LastName = 'TestPAcc' , DEM_Da_Inviare__pc = true , PersonEmail = 'test@test.it');

		accts.add(a1);
		accts.add(a2);

		insert accts;

        /*
		Contact[] contacts = new List < Contact > ();

		Contact con1 = new Contact(
		FirstName = 'Joe', LastName = 'Smith', Email='ahmed.cisse@terangacloud.com', Phone = '415.555.1212', DEM_Da_Inviare__c = false, Ultima_DEM_Inserita__c = DateTime.now(), AccountId = a1.ID);

		Contact con2 = new Contact(
		FirstName = 'Ahmet', LastName = 'CISSE', Email='ahmed.cisse@terangacloud.com', Phone = '415.655.1312', DEM_Da_Inviare__c = true, Ultima_DEM_Inserita__c = DateTime.newInstance(2019, 5, 8, 10, 8, 16), AccountId = a2.ID);

		contacts.add(con1);
		contacts.add(con2);

		insert contacts; */

		AccountRichiesteDEM__c accountRichiesteDEM = new AccountRichiesteDEM__c();
		accountRichiesteDEM.Account__c = a1.ID;
		accountRichiesteDEM.DEM_Value__c = 'nameOfCampaignForTest1';
		accountRichiesteDEM.DEM_Param_1__c = 'demParam1';
		accountRichiesteDEM.DEM_Param_2__c = 'demParam2';
		accountRichiesteDEM.DEM_Param_3__c = 'demParam3';
		accountRichiesteDEM.DEM_Param_4__c = 'demParam4';
		accountRichiesteDEM.DEM_Param_5__c = 'demParam5';
		accountRichiesteDEM.DEM_Data_invio__c = Date.today();

		insert accountRichiesteDEM;

		AccountRichiesteDEM__c accountRichiesteDEM2 = new AccountRichiesteDEM__c();
		accountRichiesteDEM2.Account__c = a2.ID;
		accountRichiesteDEM2.DEM_Value__c = 'nameOfCampaignForTest2';
		accountRichiesteDEM2.DEM_Param_1__c = 'demParam1';
		accountRichiesteDEM2.DEM_Param_2__c = 'demParam2';
		accountRichiesteDEM2.DEM_Param_3__c = 'demParam3';
		accountRichiesteDEM2.DEM_Param_4__c = 'demParam4';
		accountRichiesteDEM2.DEM_Param_5__c = 'demParam5';
		accountRichiesteDEM2.DEM_Data_invio__c = Date.today();

		insert accountRichiesteDEM2;

	}
	static testmethod void test() {
        //Create Email Template for test
        EmailTemplate EmailTemplate_01 = new EmailTemplate();
        EmailTemplate_01.DeveloperName = 'nameOfCampaignForTest1';
        EmailTemplate_01.FolderId      = UserInfo.getUserId();
        EmailTemplate_01.TemplateType  = 'Text';
        EmailTemplate_01.Name          = 'nameOfCampaignForTest1';
        EmailTemplate_01.IsActive      = true;
        insert EmailTemplate_01;
        
        EmailTemplate EmailTemplate_02 = new EmailTemplate();
        EmailTemplate_02.DeveloperName = 'nameOfCampaignForTest2';
        EmailTemplate_02.FolderId      = UserInfo.getUserId();
        EmailTemplate_02.TemplateType  = 'Text';
        EmailTemplate_02.Name          = 'nameOfCampaignForTest2';
        EmailTemplate_02.IsActive      = true;
        insert EmailTemplate_02;
        
		System.assertEquals(2, [Select count() From Account], 'Number of Accounts != 2');
		System.assertEquals(2, [Select count() From Contact], 'Nummber Of Contacts != 2');
		System.assertEquals(2, [Select count() From AccountRichiesteDEM__c], 'Number Of AccountRichiesteDEM__c != 2');

		Test.startTest();
		batchAccodamentoScodamentoDEM basd = new batchAccodamentoScodamentoDEM();
		Id batchId = Database.executeBatch(basd);
		Test.stopTest();
        
        String sch = '0  00 1 3 * ?';
        System.schedule('test', sch, new ScheduleBatchAccodamentoScodamentoDEM() );
        
		// after the testing stops, assert records were updated properly
		//System.assertEquals(0, [Select count() From AccountRichiesteDEM__c], 'AccountRichiesteDEM__c is not deleted');
	}
}