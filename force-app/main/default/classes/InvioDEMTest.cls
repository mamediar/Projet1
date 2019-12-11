/**
 * @File Name          : InvioDEMTest.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 10/06/2019 à 19:06:28
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    28/05/2019 à 08:54:03   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
@isTest
private class InvioDEMTest {
	static testmethod void testCheck() {
       // Create records for test.     
		Account[] accts = new List < Account > ();

		Account a1 = new Account(
		Name = 'test1', DEM_Da_Inviare__c = false,  BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911134');

		Account a2 = new Account(
		Name = 'test2', DEM_Da_Inviare__c = true, BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911135');

		Account a3 = new Account(
		Name = 'test3', DEM_Da_Inviare__c = false,  BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911136');

		Account a4 = new Account(
		Name = 'test4', DEM_Da_Inviare__c = false,  BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911137');

		Account a5 = new Account(
		Name = 'test5', DEM_Da_Inviare__c = true,  BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911138');

		accts.add(a1);
		accts.add(a2);
		accts.add(a3);
		accts.add(a4);
		accts.add(a5);

		insert accts;

		Contact[] contacts = new List < Contact > ();
		Contact con1 = new Contact(
		FirstName = 'Joe', LastName = 'Smith', Phone = '415.555.1212', DEM_Da_Inviare__c = false, Ultima_DEM_Inserita__c = DateTime.now(), AccountId = a1.ID);
		Contact con2 = new Contact(
		FirstName = 'Ahmet', LastName = 'CISSE', Phone = '415.655.1312', DEM_Da_Inviare__c = false, Ultima_DEM_Inserita__c = DateTime.newInstance(2019, 5, 8, 10, 8, 16), AccountId = a2.ID);

		Contact con3 = new Contact(
		FirstName = 'Joe', LastName = 'Smith', Phone = '415.555.1212', DEM_Da_Inviare__c = true, Ultima_DEM_Inserita__c = DateTime.newInstance(2019, 5, 8, 10, 8, 16), AccountId = a3.ID);
		Contact con4 = new Contact(
		FirstName = 'Ahmet', LastName = 'CISSE', Phone = '415.655.1312', DEM_Da_Inviare__c = true, Ultima_DEM_Inserita__c = DateTime.now(), AccountId = a4.ID);

		Contact con5 = new Contact(
		FirstName = 'Joe', LastName = 'Smith', Phone = '415.555.1212', DEM_Da_Inviare__c = true, Ultima_DEM_Inserita__c = null, AccountId = a5.ID);
		
		contacts.add(con1);
		contacts.add(con2);
		contacts.add(con3);
		contacts.add(con4);
		contacts.add(con5);

		insert contacts;

		Test.startTest();

		System.assertEquals(5, accts.size(), 'accts.size()!=5');
		System.assertEquals(5, contacts.size(), 'accts.size()!=5');

		// Verify a AccountRichiesteDEM__c record is not created yet.
		List < AccountRichiesteDEM__c > accountRichiesteDEMs1 = [Select Id, DEM_Value__c, DEM_Param_1__c, DEM_Param_2__c, DEM_Param_3__c, DEM_Param_4__c, DEM_Param_5__c, Account__c From AccountRichiesteDEM__c];

		System.assertEquals(0, accountRichiesteDEMs1.size(), 'No Record Yet');

		InvioDEM.check(a1.ID, 'nameOfCampaignForTest', 'demParam1', 'demParam2', 'demParam3', 'demParam4', 'demParam5', 
                              'demParam6', 'demParam7', 'demParam8', 'demParam9' , 'demParam10' );

		InvioDEM.check(a2.ID, 'nameOfCampaignForTest', 'demParam1', 'demParam2', 'demParam3', 'demParam4', 'demParam5',
                              'demParam6', 'demParam7', 'demParam8', 'demParam9' , 'demParam10' );

		InvioDEM.check(a3.ID, 'nameOfCampaignForTest', 'demParam1', 'demParam2', 'demParam3', 'demParam4', 'demParam5', 
                              'demParam6', 'demParam7', 'demParam8', 'demParam9' , 'demParam10' );

		InvioDEM.check(a4.ID, 'nameOfCampaignForTest', 'demParam1', 'demParam2', 'demParam3', 'demParam4', 'demParam5', 
                              'demParam6', 'demParam7', 'demParam8', 'demParam9' , 'demParam10' );

		InvioDEM.check(a5.ID, 'nameOfCampaignForTest', 'demParam1', 'demParam2', 'demParam3', 'demParam4', 'demParam5', 
                              'demParam6', 'demParam7', 'demParam8', 'demParam9' , 'demParam10' );

		System.assertEquals(5, accts.size(), 'accts.size()!=5');

		// Verify 1 AccountRichiesteDEM__c record is created now.      
		List < AccountRichiesteDEM__c > accountRichiesteDEMs2 = [Select Id, DEM_Value__c, DEM_Param_1__c, DEM_Param_2__c, DEM_Param_3__c, DEM_Param_4__c, DEM_Param_5__c, Account__c From AccountRichiesteDEM__c];
        system.debug('22_10_2019 accountRichiesteDEMs2->'+accountRichiesteDEMs2);
		//System.assertEquals(3, accountRichiesteDEMs2.size(), 'Number of Record !=3');

		Test.stopTest();
	}
}