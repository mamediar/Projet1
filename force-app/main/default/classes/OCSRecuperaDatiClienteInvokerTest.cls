@isTest
public class OCSRecuperaDatiClienteInvokerTest {
    
     @isTest
    static void test(){
     
        String response = '{"resultCode":0,"resultMessage":"Ok","recuperaDatiClienteResponse":{"telefonoCasa":"0432 502058","telefonoAlternativo":"","telCellulare":"335 6343911","fax":""}}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDatiCliente',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test1;
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.recuperaDatiCliente';
        Test.setMock(HttpCalloutMock.class,UMR);
       
        OCSRecuperaDatiClienteInvoker.recuperaDatiCliente('1348');
        
        
        test.stopTest();	
        
        
    }

}