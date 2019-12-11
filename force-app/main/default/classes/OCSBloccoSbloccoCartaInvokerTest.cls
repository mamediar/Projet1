@IsTest
public with sharing class OCSBloccoSbloccoCartaInvokerTest {

    @TestSetup
    public static void setup() {
        insert new ApiRest__c(Name = 'ocs.bloccoSbloccoCarta', Ref__c = 'CompassInternal', EndPoint__c = 'Test', Method__c = 'POST', User__c = 'Test', Password__c = 'Test');
        insert new ApiUtil__c(Name = 'CompassInternal', Ref__c = 'CompassInternal', EndPoint__c = 'Test', User__c = 'Test', Password__c = 'Test');
    }

    @IsTest
    public static void bloccoSbloccoCartaTest() {
        Test.startTest();
        OCSBloccoSbloccoCartaInvoker.Response response = getOCSBloccoSbloccoCartaInvokerResponse();
        Test.setMock(HttpCalloutMock.class, new BloccoSbloccoCartaInvokerMock(JSON.serialize(response)));
        OCSBloccoSbloccoCartaInvoker.BloccoSbloccoCartaRequestDTO bloccoSbloccoCartaRequestDTO = new OCSBloccoSbloccoCartaInvoker.BloccoSbloccoCartaRequestDTO();
        bloccoSbloccoCartaRequestDTO.numeroCarta = '0123456789';
        bloccoSbloccoCartaRequestDTO.tipoOperazione = 'I';
        bloccoSbloccoCartaRequestDTO.bloccoCarta = 'PE';
        bloccoSbloccoCartaRequestDTO.utente = null;
        response = OCSBloccoSbloccoCartaInvoker.invoke(bloccoSbloccoCartaRequestDTO);
        Test.stopTest();
        System.assertEquals(true, response != null && response.statusCode == 200);
    }

    private class BloccoSbloccoCartaInvokerMock implements HttpCalloutMock {

        public String body { get; set;}

        public BloccoSbloccoCartaInvokerMock(String body) {
            this.body = body;
        }

        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setStatus('OK');
            response.setStatusCode(200);
            response.setBody(this.body);
            return response;
        }
    }

    private static OCSBloccoSbloccoCartaInvoker.Response getOCSBloccoSbloccoCartaInvokerResponse() {
        OCSBloccoSbloccoCartaInvoker.Response response = new OCSBloccoSbloccoCartaInvoker.Response();
        response.resultCode = 0;
        response.resultMessage = 'OK';
        response.datiBloccoSbloccoCartaResponse = new OCSBloccoSbloccoCartaInvoker.BloccoSbloccoCartaResponseDTO();
        response.datiBloccoSbloccoCartaResponse.bloccoCarta = 'IV';
        response.datiBloccoSbloccoCartaResponse.as400Status = 'KO';
        response.datiBloccoSbloccoCartaResponse.as400Errore = '7786 Blocco già presente sulla carta';
        return response;
    }

}