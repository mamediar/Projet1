@isTest
public class OCS_OCS_COPSVDTA_V1InvokerTest {
    @isTest
    static void test(){
        
        String response = '{"resultCode":0,"resultMessage":"Ok","copsvdtaresponse":{"mftpsres_STATUS":"KO","mftpsres_PROCEDURA":"CO","mfterr_OMSFERR_OCCURS":[{"msferr_N_RECORD":1,"msferr_TIPO":"E"}]}}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.OCS_COPSVDTA_V1',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test1;
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.OCS_COPSVDTA_V1';
        Test.setMock(HttpCalloutMock.class,UMR);
       
        OCS_OCS_COPSVDTA_V1Invoker.callAggiornaDati(0,'','','','',0,'');
        test.stopTest();	
    
    }
}