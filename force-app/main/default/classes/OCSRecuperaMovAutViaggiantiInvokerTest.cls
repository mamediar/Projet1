@isTest
public class OCSRecuperaMovAutViaggiantiInvokerTest {
    
    @isTest
    static void test(){
        
        String response = '{"resultCode":0,"resultMessage":"Ok","recuperaMovimentiAutorizzazioniViaggiantiResponse":{"recuperaMovViaggiantiResponse":{"elencoMovimenti":[],"as400Errore":null},"recuperaAutViaggiantiResponse":{"elencoAutorizzazioni":[{"autorizzazione":"2"}]}}}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaMovAutViaggianti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');        
        insert test1;
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.recuperaMovAutViaggianti';
        Test.setMock(HttpCalloutMock.class,UMR);    
        
        OCSRecuperaMovAutViaggiantiInvoker.recuperaMovAutViaggianti('1348');
        OCSRecuperaMovAutViaggiantiInvoker.recuperaMovAutViaggianti('1348',true,true);
        
        
        test.stopTest();	

        
        
        
    }
    
}