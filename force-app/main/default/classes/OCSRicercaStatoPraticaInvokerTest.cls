@isTest
public class OCSRicercaStatoPraticaInvokerTest 
{
	@isTest
    static void test(){
		ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='{"resultCode":0,"resultMessage":"Ok","statoPratica":"30RE"}',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ricerca.ocs.recuperaStatoPratica',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
       	insert test1;
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ricerca.ocs.recuperaStatoPratica';
        Test.setMock(HttpCalloutMock.class,UMR);
        OCSRicercaStatoPraticaResponse crspr = OCSRicercaStatoPraticaInvoker.ricercaStatoPratica('121212');
        test.stopTest();	
    }
}