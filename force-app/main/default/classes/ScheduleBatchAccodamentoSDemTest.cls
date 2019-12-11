/**
 * @File Name          : ScheduleBatchAccodamentoSDemTest.cls
 * @Description        : 
 * @Author             : CISSE Ahmet
 * @Group              : 
 * @Last Modified By   : CISSE Ahmet
 * @Last Modified On   : 24/09/2019 à 10:32:18
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    23/09/2019   CISSE Ahmet     Initial Version
**/
@isTest
private class ScheduleBatchAccodamentoSDemTest {
	@testSetup
	static void setup() {
		// Create records for test.
		Account[] accts = new List < Account > ();

		Account a1 = new Account(
		Name = 'test1', DEM_Da_Inviare__c = false, BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911134');

		Account a2 = new Account(
		Name = 'test2', DEM_Da_Inviare__c = true, BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911135');

		accts.add(a1);
		accts.add(a2);

		insert accts;

		Contact[] contacts = new List < Contact > ();

		Contact con1 = new Contact(
		FirstName = 'Joe', LastName = 'Smith', Email='ahmed.cisse@terangacloud.com', Phone = '415.555.1212', DEM_Da_Inviare__c = false, Ultima_DEM_Inserita__c = DateTime.now(), AccountId = a1.ID);

		Contact con2 = new Contact(
		FirstName = 'Ahmet', LastName = 'CISSE', Email='ahmed.cisse@terangacloud.com', Phone = '415.655.1312', DEM_Da_Inviare__c = true, Ultima_DEM_Inserita__c = DateTime.newInstance(2019, 5, 8, 10, 8, 16), AccountId = a2.ID);

		contacts.add(con1);
		contacts.add(con2);

		insert contacts;

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
    // Dummy CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
	public static datetime dt = datetime.now();
    public static String CRON_EXP = '59 '+dt.minute()+' '+dt.hour()+' '+dt.day()+' '+dt.month()+' '+'?';
    static testmethod void testScheduledJob() {
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest',
            CRON_EXP, 
            new ScheduleBatchAccodamentoScodamentoDEM());         
      
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                FROM CronTrigger WHERE Id = :jobId];
                
      System.assertEquals(CRON_EXP, ct.CronExpression);
      System.assertEquals(0, ct.TimesTriggered);
    }
}