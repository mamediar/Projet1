@isTest
public class VenditaAssicurazioniActionTest {
    
    @isTest
    public static void preRedirectTest(){
        String response = '{"resultCode":0,"resultMessage":"Ok","recuperaDatiClienteResponse":{"privacyOffCommInterne":"S","privacyOffCommEsterne":"S","privacyServiziAltri":"S","privacyRilevQualita":"S"}}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDatiCliente',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test1;
        Account tempAccount = new Account(Name = 'testAccount', Codice_Cliente__c = 'CU123456789');
        insert tempAccount;
        VenditaAssicurazioniAction venAssAction = new VenditaAssicurazioniAction();
        venAssAction.setAccount(tempAccount);
        
        Test.startTest();
        
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname = 'ocs.recuperaDatiCliente';
        Test.setMock(HttpCalloutMock.class,UMR);
        venAssAction.preRedirect();
            
        Test.stopTest();
        
    }
}