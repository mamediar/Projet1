@isTest
public class UtilityMockResponseTest {
	
    @isTest
    static void test(){
        
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='{"resultCode":0,"resultMessage":"Ok","ebagetadlv1Response":{"mfbayadlo_OU_LOTTO":0,"msfologon_STATUS":""}}',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ricerca.ocs.ricercaPresenzaLotto',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute'); 
     	insert test1;
        HTTPRequest hr = new HTTPRequest();
        hr.setEndpoint('https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
        UtilityMockResponse umr = new UtilityMockResponse();
        umr.apiname = 'ricerca.ocs.ricercaPresenzaLotto';
        HTTPResponse hrer = umr.respond(hr);
    }
}