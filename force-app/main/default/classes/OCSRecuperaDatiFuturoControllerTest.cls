@isTest
public class OCSRecuperaDatiFuturoControllerTest {
    
    
    @isTest
    public static void testGetClientiWithOneClient(){
        String response = '{"resultCode": 0,"resultMessage": "Ok","pratiche": [{"numPratica": "68203","codCliente": "123456","flagRecupero": "N"}],"cliente": [{ "cognome": "FAIPOLREETO","codCliente": "123456"}]}';
        
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDatiFuturo',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        Insert test1;
        
        Test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.recuperaDatiFuturo';
        Test.setMock(HttpCalloutMock.class, UMR);
        
        Map<String,String> data = new Map<String,String> {'cognomeCliente' => 'ProvaFuturo', 'numPratica' => '682030', 'flagInfoCliente' => 'true'};
            
            OCSRecuperaDatiFuturoController.getClienti(data, '');
        
        Test.stopTest();    
    }
    
    @isTest
    public static void testGetClientiWithTwoClients(){
        String response = '{"resultCode": 0,"resultMessage": "Ok","pratiche": [{"numPratica": "68203","codCliente": "123456","flagRecupero": "N"}],"cliente": [{ "cognome": "FAIPOLREETO","codCliente": "123456"}, { "cognome": "ProvaCognome","codCliente": "000000"}]}';
        
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDatiFuturo',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        Insert test1;
        
        Test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.recuperaDatiFuturo';
        Test.setMock(HttpCalloutMock.class, UMR);
        
        OCSRecuperaDatiFuturoController.getClienti(new Map<String,String>(),'');
        
        Test.stopTest();    
    }
    
    @isTest
    public static void testGetInputAccountOCSId(){
        Account acc = new Account(Name='Prova');
        Insert acc;
        OCSRecuperaDatiFuturoController.getInputAccountOCSId(acc.Id);
        
    }
}