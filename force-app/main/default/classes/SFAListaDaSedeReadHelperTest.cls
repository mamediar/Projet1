@IsTest
public with sharing class SFAListaDaSedeReadHelperTest {

    @isTest
    public static void testInit() { 
        Test.startTest();
        SFAListaDaSedeReadHelper helper = new SFAListaDaSedeReadHelper();
        System.debug(helper.accountObj);
        System.debug(helper.area_filiale);
        System.debug(helper.codice_filiale);
        System.debug(helper.regione_filiale);
        System.debug(helper.caseObj);
        Test.stopTest();
    }
}