@IsTest
public with sharing class OCSRecuperaBlocchiCartaInvokerTest {

    @TestSetup
    public static void setup() {
        insert new ApiRest__c(Name = 'ocs.recuperaBlocchiCarta', Ref__c = 'CompassInternal', EndPoint__c = 'Test', Method__c = 'POST', User__c = 'Test', Password__c = 'Test');
        insert new ApiUtil__c(Name = 'CompassInternal', Ref__c = 'CompassInternal', EndPoint__c = 'Test', User__c = 'Test', Password__c = 'Test');
    }

    @IsTest
    public static void recuperaBlocchiCartaTest() {
        Test.startTest();
        OCSRecuperaBlocchiCartaInvoker.Response response = getOCSRecuperaBlocchiCartaInvokerResponse();
        Test.setMock(HttpCalloutMock.class, new RecuperaBlocchiCartaInvokerMock(JSON.serialize(response)));
        OCSRecuperaBlocchiCartaInvoker.RecuperaBlocchiCartaRequestDTO recuperaBlocchiCartaRequestDTO = new OCSRecuperaBlocchiCartaInvoker.RecuperaBlocchiCartaRequestDTO();
        recuperaBlocchiCartaRequestDTO.numCarta = '0123456789';
        recuperaBlocchiCartaRequestDTO.filtroBlocchi = '';
        response = OCSRecuperaBlocchiCartaInvoker.invoke(recuperaBlocchiCartaRequestDTO);
        Test.stopTest();
        System.assertEquals(true, response != null && response.statusCode == 200);
    }


    private class RecuperaBlocchiCartaInvokerMock implements HttpCalloutMock {

        public String body { get; set;}

        public RecuperaBlocchiCartaInvokerMock(String body) {
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

    private static OCSRecuperaBlocchiCartaInvoker.Response getOCSRecuperaBlocchiCartaInvokerResponse() {
        OCSRecuperaBlocchiCartaInvoker.Response response = new OCSRecuperaBlocchiCartaInvoker.Response();
        response.resultCode = 0;
        response.resultMessage = 'OK';
        response.recuperaBlocchiCartaResponse = new OCSRecuperaBlocchiCartaInvoker.RecuperaBlocchiCartaResponseDTO();

        response.recuperaBlocchiCartaResponse.elencoBlocchi = new List<OCSRecuperaBlocchiCartaInvoker.BloccoCarta>();
        OCSRecuperaBlocchiCartaInvoker.BloccoCarta blocco = new OCSRecuperaBlocchiCartaInvoker.BloccoCarta();
        blocco.keyCode = 'CF';
        blocco.valore = '20130426';
        blocco.descrizione = 'Conferma Firma';
        response.recuperaBlocchiCartaResponse.elencoBlocchi.add(blocco);

        return response;
    }
}