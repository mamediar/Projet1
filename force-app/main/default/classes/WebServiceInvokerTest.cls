@IsTest
public with sharing class WebServiceInvokerTest {

    @TestSetup
    public static void setup() {
        insert new List<ApiRest__c>{
                new ApiRest__c(Name = 'ocs.recuperaBlocchiCarta', Ref__c = 'CompassInternal', EndPoint__c = 'Test', Method__c = 'POST', User__c = 'Test', Password__c = 'Test'),
                new ApiRest__c(Name = 'ocs.bloccoSbloccoCarta', Ref__c = 'CompassInternal', EndPoint__c = 'Test', Method__c = 'POST', User__c = 'Test', Password__c = 'Test'),
                new ApiRest__c(Name = 'ocs.recuperaIndirizziCliente', Ref__c = 'CompassInternal', EndPoint__c = 'Test', Method__c = 'POST', User__c = 'Test', Password__c = 'Test'),
                new ApiRest__c(Name = 'ocs.recuperaInfoCarta', Ref__c = 'CompassInternal', EndPoint__c = 'Test', Method__c = 'POST', User__c = 'Test', Password__c = 'Test'),
                new ApiRest__c(Name = 'ocs.cartaDatiFinanziari', Ref__c = 'CompassInternal', EndPoint__c = 'Test', Method__c = 'POST', User__c = 'Test', Password__c = 'Test'),
                new ApiRest__c(Name = 'ocs.recuperaDatiPostvendita', Ref__c = 'CompassInternal', EndPoint__c = 'Test', Method__c = 'POST', User__c = 'Test', Password__c = 'Test'),
                new ApiRest__c(Name = 'ocs.azionePreFurto', Ref__c = 'CompassInternal', EndPoint__c = 'Test', Method__c = 'POST', User__c = 'Test', Password__c = 'Test')
        };
        insert new ApiUtil__c(Name = 'CompassInternal', Ref__c = 'CompassInternal', EndPoint__c = 'Test', User__c = 'Test', Password__c = 'Test');
    }

    @IsTest
    public static void recuperaBlocchiCartaTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WebServiceMock(''));
        HttpResponse response = WebServiceInvoker.recuperaBlocchiCarta('0123456789', '');
        Test.stopTest();
        System.assertEquals(true, response != null && response.getStatusCode() == 200);
    }

    @IsTest
    public static void bloccoSbloccoCartaTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WebServiceMock(''));
        HttpResponse response = WebServiceInvoker.bloccoSbloccoCarta('0123456789', 'I', 'IV', null);
        Test.stopTest();
        System.assertEquals(true, response != null && response.getStatusCode() == 200);
    }

    @IsTest
    public static void recuperaIndirizziClienteTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WebServiceMock(''));
        HttpResponse response = WebServiceInvoker.recuperaIndirizziCliente('0123456789');
        Test.stopTest();
        System.assertEquals(true, response != null && response.getStatusCode() == 200);
    }

    @IsTest
    public static void recuperaInfoCartaTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WebServiceMock(''));
        HttpResponse response = WebServiceInvoker.recuperaInfoCarta('0123456789', '');
        Test.stopTest();
        System.assertEquals(true, response != null && response.getStatusCode() == 200);
    }

    @IsTest
    public static void cartaDatiFinanziariTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WebServiceMock(''));
        HttpResponse response = WebServiceInvoker.cartaDatiFinanziari('0123456789');
        Test.stopTest();
        System.assertEquals(true, response != null && response.getStatusCode() == 200);
    }

    @IsTest
    public static void recuperaDatiPostvenditaTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WebServiceMock(''));
        HttpResponse response = WebServiceInvoker.recuperaDatiPostvendita('0123456789');
        Test.stopTest();
        System.assertEquals(true, response != null && response.getStatusCode() == 200);
    }

    @IsTest
    public static void azionePreFurtoTest() {
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WebServiceMock(''));
        HttpResponse response = WebServiceInvoker.azionePreFurto('CA', 'AG', '12', '3109269996', 'F', 'S', '20160913', '0', '', 'S', null);
        Test.stopTest();
        System.assertEquals(true, response != null && response.getStatusCode() == 200);
    }

    private class WebServiceMock implements HttpCalloutMock {

        public String body { get; set;}

        public WebServiceMock(String body) {
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
}