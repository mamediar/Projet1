/**
 * @File Name          : DF_LCP_LoadFileDFController_Test.cls
 * @Description        : 
 * @Author             : CISSE Ahmet
 * @Group              : 
 * @Last Modified By   : CISSE Ahmet
 * @Last Modified On   : 08/08/2019 à 09:21:14
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    08/08/2019 à 08:05:16   CISSE Ahmet     Initial Version
**/
@isTest
public class DF_LCP_LoadFileDFController_Test {
    @testSetup
	static void setup() {
        // Create records for test.     
        Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();        
		Account[] accts = new List < Account > ();

        Account a1 = new Account(
		Name = 'test1', DEM_Da_Inviare__c = false,  BillingCity = 'San Francisco', OCS_External_Id__c = 'C19200437');
		Account a2 = new Account(
		Name = 'test2', DEM_Da_Inviare__c = true, BillingCity = 'San Francisco', OCS_External_Id__c = 'C19285245');
        Account a3 = new Account(
		Name = 'test3', DEM_Da_Inviare__c = true, BillingCity = 'San Francisco', OCS_External_Id__c = 'C15363777');

        a1.RecordTypeId = accountRecordTypeId;
        a2.RecordTypeId = accountRecordTypeId;
        a3.RecordTypeId = accountRecordTypeId;

        accts.add(a1);
		accts.add(a2);
        accts.add(a3);

        insert accts;

        XCS_Categoria__c categoria = new XCS_Categoria__c(Name = 'Gestione Dossier Convenzionamento');

        insert categoria;
    }

    static testmethod void saveInDossierAndAccount_test() {

        Map < String, Object > response = new Map < String, Object > ();
        
        List < String > data = new List< String >();
        List < String > codiceOcsInCSVfile = new List< String >();
        List < String > linesWithErrors = new List< String >();

        data.add('SA; 19285245; FONTANESI SILVIA DIN; 01321060459; 01321060459; 022; 2015-03-12; prova \r\n');
        data.add('SA; 15363592; FONTANESI SILVIA DIN; 01321060459; 01321060459; 022; 2018-03-12; prova\r\n');
        codiceOcsInCSVfile.add('19200437');
        codiceOcsInCSVfile.add('19285245');
        codiceOcsInCSVfile.add('15363592');
        linesWithErrors.add('SA; 19200437; FONTANESI SILVIA DIN; 01321060459; 01321060459; 022; 2017-03-12 \r\n');
        test.startTest();
        response = DF_LCP_LoadFileDFController.saveInDossierAndAccount(data, codiceOcsInCSVfile, linesWithErrors);
        test.stopTest();

        System.assertEquals(true, response.get('error'), 'false');
        System.assertEquals(1, response.get('lineError'), 'it is not 1');
        System.assertEquals(2, response.get('lineSuccess'), 'it is not 2');
    }
}