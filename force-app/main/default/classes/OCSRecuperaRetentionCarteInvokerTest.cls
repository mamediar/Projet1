@isTest
public class OCSRecuperaRetentionCarteInvokerTest 
{
    @isTest
    static void test(){
        
        String response = '{"resultCode":0,"resultMessage":"Ok","recuperaRetentionCarteResponse":{"elencoCarte":[{"numCarta":"24100015679","statoCarta":"70","bloccoCarta":"LS","prodottoCarta":"01","esitoRetention":"","valoreRetention":"","prodottoAttributo":""}]}}';
        ApiRest__c ar = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaRetentionCarte',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert ar;
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.recuperaRetentionCarte';
        Test.setMock(HttpCalloutMock.class,UMR);
        OCSRecuperaRetentionCarteInvoker.invoke('1348');     
        test.stopTest();	  
    }
    
}