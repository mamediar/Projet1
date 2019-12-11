@isTest
public class OCSCambioStatoPraticaInvokerTest {
     @isTest static void test()
     {
		ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='{"resultCode":0,"resultMessage":"Ok","ebavaradpv1Response":{"msfres_STATUS":"OK","mfterr_OMSFERR_OCCURS":[{"msferr_CODICE":"0"}]},"msfologon_SESSION_ID":"788ec2e42093697fc3bcfaf45050f174"}',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ricerca.ocs.cambioStatoPratica',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
       	insert test1; 
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ricerca.ocs.cambioStatoPratica';
        Test.setMock(HttpCalloutMock.class,UMR);
        List<Contract> lCon = new List<Contract>();
        Contract c = new Contract();
        c.ContractNumber__c = '12';
        c.Procedure__c = 'CO';      
        lCon.add(c); 
        OCSCambioStatoFilterList ris =  OCSCambioStatoPraticaInvoker.multiInvoke(lCon,'D');
		test.stopTest();
     }
    @isTest static void testoknull()
    {
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='{"resultCode":0,"resultMessage":"Ok","ebavaradpv1Response":{"msfres_STATUS":"OK","mfterr_OMSFERR_OCCURS":null},"msfologon_SESSION_ID":"788ec2e42093697fc3bcfaf45050f174"}',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ricerca.ocs.cambioStatoPratica',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
       	insert test1; 
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ricerca.ocs.cambioStatoPratica';
        Test.setMock(HttpCalloutMock.class,UMR);
        List<Contract> lCon = new List<Contract>();
        Contract c = new Contract();
        c.ContractNumber__c = '12';
        c.Procedure__c = 'CO';      
        lCon.add(c); 
        OCSCambioStatoFilterList ris =  OCSCambioStatoPraticaInvoker.multiInvoke(lCon,'D');
		test.stopTest();
    }
    @isTest static void testException()
    {
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='{"resultCode":0,"resultMessage":"Ok","ebavaradpv1Response":{"msfres_STATUS":"OK","mfterr_OMSFERR_OCCURS":null},"msfologon_SESSION_ID":"788ec2e42093697fc3bcfaf45050f174"}',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ricerca.ocs.cambioStatoPratica',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
       	insert test1; 
        test.startTest();
       // UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ricerca.ocs.cambioStatoPratica'});
       // Test.setMock(HttpCalloutMock.class,UMR);
        List<Contract> lCon = new List<Contract>();
        Contract c = new Contract();
        c.ContractNumber__c = '12';
        c.Procedure__c = 'CO';      
        lCon.add(c); 
        OCSCambioStatoFilterList ris =  OCSCambioStatoPraticaInvoker.multiInvoke(lCon,'D');
		test.stopTest();
    }
}