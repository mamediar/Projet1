@isTest
public class OCSVariazioneTelefonoBancaInvokerTest {
    
    @isTest
    public static void testCallVariazioneTelefonoBancaOk(){
        String response = '{    "resultCode": 0, "resultMessage": "Ok",    "variazioneTelefoniResponse": {        "as400Status": "OK",        "as400Errore": ""    }}';
        OCSVariazioneTelefonoBancaRequest request = new OCSVariazioneTelefonoBancaRequest();
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal', Name ='ocs.variazioneTelefonoBanca',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        ApiUtil__c test2 = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert test1;
        insert test2;
        Test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.variazioneTelefonoBanca';
        Test.setMock(HttpCalloutMock.class,UMR);
        String abi = '01000';
        String cab = '01001';
        String telefono = '011 560456';
        request.variazioneTelefonoBancaRequest.abi = abi;
        request.variazioneTelefonoBancaRequest.cab = cab;
        request.variazioneTelefonoBancaRequest.telefono = telefono;
        System.debug('request '+request);
        OCSVariazioneTelefonoBancaResponse res = OCSVariazioneTelefonoBancaInvoker.callVariazioneTelefonoBancaSDD(abi,cab,telefono);
        System.debug('response   : '+res);
        system.assertEquals('OK', res.variazioneTelefoniResponse.as400Status );
        Test.stopTest();
        
    }
}