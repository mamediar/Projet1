@isTest
public class OCSInviaSMSInvokerTest {
    
        @isTest
    static void test(){
		/*ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='{"resultCode":0,"resultMessage":"Ok","flagEsito":"Ok"}',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.inviaSMS',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
       	insert test1;
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.inviaSMS';
        Test.setMock(HttpCalloutMock.class,UMR);*/
        //OCSInviaSMSResponse SMS = OCSInviaSMSInvoker.InviaSMS('WEB2','3498307332','','','testo1');
       //test.stopTest();	
        
        
        OCSInviaSMSInvoker.InviaSMS('WEB2','3498307332','','','testo1');
        
        
    }

}