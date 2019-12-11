/**
 * @File Name          : CaricareListaDEMControllerTest.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 10/06/2019 à 17:24:03
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    29/05/2019 à 10:41:44   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
@isTest
public class CaricareListaDEMControllerTest {
    @testSetup
	static void setup() {
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

		Account a6 = new Account(
		Name = 'test6', DEM_Da_Inviare__c = true,  BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911139');

		Account a7 = new Account(
		Name = 'test6', DEM_Da_Inviare__c = true,  BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911140');

		accts.add(a1);
		accts.add(a2);
		accts.add(a3);
		accts.add(a4);
		accts.add(a5);
		accts.add(a6);
		accts.add(a7);

		insert accts;

		Contact[] contacts = new List < Contact > ();
		Contact con1 = new Contact(
		FirstName = 'Joe', LastName = 'Smith', Phone = '415.555.1212', DEM_Da_Inviare__c = false, Ultima_DEM_Inserita__c = DateTime.now(), AccountId = a1.ID);
		Contact con2 = new Contact(
		FirstName = 'Ahmet', LastName = 'CISSE', Phone = '415.655.1312', DEM_Da_Inviare__c = true, Ultima_DEM_Inserita__c = DateTime.newInstance(2019, 5, 8, 10, 8, 16), AccountId = a2.ID);

		Contact con3 = new Contact(
		FirstName = 'Joe', LastName = 'Smith', Phone = '415.555.1212', DEM_Da_Inviare__c = false, Ultima_DEM_Inserita__c = DateTime.newInstance(2019, 5, 8, 10, 8, 16), AccountId = a3.ID);
		Contact con4 = new Contact(
		FirstName = 'Ahmet', LastName = 'CISSE', Phone = '415.655.1312', DEM_Da_Inviare__c = false, Ultima_DEM_Inserita__c = DateTime.now(), AccountId = a4.ID);

		Contact con5 = new Contact(
		FirstName = 'Joe', LastName = 'Smith', Phone = '415.555.1212', DEM_Da_Inviare__c = true, Ultima_DEM_Inserita__c = DateTime.newInstance(2019, 5, 8, 10, 8, 16), AccountId = a5.ID);
		Contact con6 = new Contact(
		FirstName = 'Ahmet', LastName = 'CISSE', Phone = '415.655.1312', DEM_Da_Inviare__c = true, Ultima_DEM_Inserita__c = DateTime.now(), AccountId = a6.ID);

		Contact con7 = new Contact(
		FirstName = 'Ahmet', LastName = 'CISSE', Phone = '415.655.1312', DEM_Da_Inviare__c = true, Ultima_DEM_Inserita__c = null, AccountId = a7.ID);
		contacts.add(con1);
		contacts.add(con2);
		contacts.add(con3);
		contacts.add(con4);
		contacts.add(con5);
		contacts.add(con6);
		contacts.add(con7);

		insert contacts;
	}
    /*
	static testmethod void test1() {
		String fileContent1 = 'codiceCliente, file is empty, file is empty,file is empty,file is empty,file is empty, file is empty, file is empty' + '\r\n';

		String fileContent2 = 'codiceCliente, dEMParam1, dEMParam2,dEMParam3,dEMParam4,dEMParam5, dEMDatainvio, nameOfCampagne' + '\r\n';
		fileContent2 = fileContent2 + '11911134, Date is befor today, Date is befor today, Date is befor today, Date is befor today, Date is befor today,' + Date.today().addDays( - 1) + ', nameForTest' + '\r\n';

		String fileContent3 = 'codiceCliente, dEMParam1, dEMParam2,dEMParam3,dEMParam4,dEMParam5, dEMDatainvio, nameOfCampagne' + '\r\n';
		fileContent3 = fileContent3 + '11911135, Date is after today, Date is after today, Date is after today, Date is after today, Date is after today, ' + Date.today().addDays(1) + ', nameForTest' + '\r\n';
		fileContent3 = fileContent3 + '11911137, Date is today And DEM_Da_Inviare is false, Date is today And DEM_Da_Inviare is false, Date is today And DEM_Da_Inviare is false, Date is today And DEM_Da_Inviare is false, Date is today And DEM_Da_Inviare is false, ' + Date.today() + ', nameForTest' + '\r\n';
		fileContent3 = fileContent3 + '11911138, Date is today And DEM_Da_Inviare is false And Counter>6hours, Date is today And DEM_Da_Inviare is false And Counter>6hours, Date is today And DEM_Da_Inviare is false And Counter>6hours, Date is today And DEM_Da_Inviare is false And Counter>6hours, Date is today And DEM_Da_Inviare is false And Counter>6hours, ' + Date.today() + ', nameForTest' + '\r\n';
		fileContent3 = fileContent3 + '11911139, Date is today And DEM_Da_Inviare is false And Counter<6hours, Date is today And DEM_Da_Inviare is false And Counter<6hours, Date is today And DEM_Da_Inviare is false And Counter<6hours, Date is today And DEM_Da_Inviare is false And Counter<6hours, Date is today And DEM_Da_Inviare is false And Counter<6hours, ' + Date.today() + ', nameForTest' + '\r\n';
		fileContent3 = fileContent3 + '11911140, Date is today And DEM_Da_Inviare is true And Counter is reseted, Date is today And DEM_Da_Inviare is true And Counter is reseted, Date is today And DEM_Da_Inviare is true And Counter is reseted, Date is today And DEM_Da_Inviare is true And Counter is reseted, Date is today And DEM_Da_Inviare is true And Counter is reseted, ' + Date.today() + ', nameForTest' + '\r\n';

		String fileContent4 = 'codiceCliente, dEMParam1, dEMParam2,dEMParam3,dEMParam4,dEMParam5, dEMDatainvio, nameOfCampagne' + '\r\n';
		fileContent4 = fileContent4 + '11911136, name of campaign is missing, name of campaign is missing, name of campaign is missing, name of campaign is missing, name of campaign is missing,' + Date.today() + ',         ' + '\r\n';

		Test.startTest();
		CaricareListaDEMController.returnMessage = CaricareListaDEMController.readFromFileAndSave(fileContent1);
		//System.assertEquals(CaricareListaDEMController.returnMessage.successMsg, 'The file is empty.', 'The file is not empty');

		CaricareListaDEMController.returnMessage = CaricareListaDEMController.readFromFileAndSave(fileContent2);
		//System.assertEquals(CaricareListaDEMController.returnMessage.successMsg, 'File data is not correct at line 2. DEM_Data_invio__c is earlier than today. Please Check and correct.', 'It is not equal');

		CaricareListaDEMController.returnMessage = CaricareListaDEMController.readFromFileAndSave(fileContent4);
		//System.assertEquals(CaricareListaDEMController.returnMessage.successMsg, 'File data is not correct at line 2 Please Check and correct.', 'It is not equal');

		CaricareListaDEMController.returnMessage = CaricareListaDEMController.readFromFileAndSave(fileContent3);
		//System.assertEquals(CaricareListaDEMController.returnMessage.successMsg, 'Update is done Successfully!', 'Update is not done');

		List < Account > accountsToUpdate = [Select Id, getCodice_Cliente__c,  DEM_Da_Inviare__c,  Ultima_DEM_Inserita__pc From Account];
		System.assertEquals(7, accountsToUpdate.size(), 'Nomber of accounts != 7');

		List < AccountRichiesteDEM__c > insertedAccountRichiesteDEM = [Select Id, DEM_Value__c, DEM_Param_1__c, DEM_Param_2__c, DEM_Param_3__c, DEM_Param_4__c, DEM_Param_5__c, DEM_Data_invio__c, Account__c From AccountRichiesteDEM__c];
		//System.assertEquals(3, insertedAccountRichiesteDEM.size(), 'Nomber of AccountRichiesteDEM__c != 3');

        CaricareListaDEMController.readingAndControlOnTheCSVfile(fileContent1,'DEM_Clenti');
        CaricareListaDEMController.readingAndControlOnTheCSVfile(fileContent1,'DEM_Clenti_NO');
		Test.stopTest();
	}
    */
    static testmethod void test2()
    {
           Test.startTest();
        
           String fileContent5 = 'column1;column2;column3;column4;column5;column6;column7;column8'+'\r\n';
           CaricareListaDEMController.readingAndControlOnTheCSVfile(fileContent5,'DEM_Clenti');

        
           Test.stopTest();
    }
}