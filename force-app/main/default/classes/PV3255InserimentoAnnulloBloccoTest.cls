@IsTest
public with sharing class PV3255InserimentoAnnulloBloccoTest {

    @TestSetup
    public static void setup() {
        insert new List<ApiRest__c>{
                new ApiRest__c(Name = 'ocs.recuperaBlocchiCarta', Ref__c = 'CompassInternal', EndPoint__c = 'Test', Method__c = 'POST', User__c = 'Test', Password__c = 'Test'),
                new ApiRest__c(Name = 'ocs.bloccoSbloccoCarta', Ref__c = 'CompassInternal', EndPoint__c = 'Test', Method__c = 'POST', User__c = 'Test', Password__c = 'Test')
        };

        insert new ApiUtil__c(Name = 'CompassInternal', Ref__c = 'CompassInternal', EndPoint__c = 'Test', User__c = 'Test', Password__c = 'Test');
        insert new Account(Name = 'Test Account', Codice_Ufficio__c = 'CCInterno', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Uffici_e_Altro').getRecordTypeId());

        XCS_Template__c xcsTemplate = new XCS_Template__c();
        insert xcsTemplate;

        insert new XCS_Categoria__c(Name = 'Inserimento blocco', XCS_Template__c = xcsTemplate.Id, External_Id__c = '3255');
    }

    @IsTest
    public static void test1() {
        Test.startTest();
        List<PV3255InserimentoAnnulloBlocco.BloccoCarta> blocchi = PV3255InserimentoAnnulloBlocco.getBlocchiCarte('0123456789', '', 116);
        Test.stopTest();

        System.assertEquals(true, blocchi != null && !blocchi.isEmpty());
    }

    @IsTest
    public static void test2() {
        Test.startTest();
        OCSRecuperaBlocchiCartaInvoker.Response response = getOCSRecuperaBlocchiCartaInvokerResponse();
        Test.setMock(HttpCalloutMock.class, new RecuperaBlocchiCartaInvokerMock(JSON.serialize(response)));
        List<PV3255InserimentoAnnulloBlocco.BloccoCarta> blocchi = PV3255InserimentoAnnulloBlocco.getBlocchiCarte('0123456789', '', 117);
        Test.stopTest();

        System.assertEquals(true, blocchi != null && !blocchi.isEmpty() && blocchi[0].keyCode == 'CF' && blocchi[0].descrizione == 'Conferma Firma');
    }

    @IsTest
    public static void test3() {
        Test.startTest();
        OCSRecuperaBlocchiCartaInvoker.Response response = getOCSRecuperaBlocchiCartaInvokerResponse();
        response.recuperaBlocchiCartaResponse = null;
        Test.setMock(HttpCalloutMock.class, new RecuperaBlocchiCartaInvokerMock(JSON.serialize(response)));
        List<PV3255InserimentoAnnulloBlocco.BloccoCarta> blocchi = PV3255InserimentoAnnulloBlocco.getBlocchiCarte('0123456789', '', 117);
        Test.stopTest();

        System.assertEquals(true, blocchi == null);
    }

    @IsTest
    public static void test4() {
        Test.startTest();
        OCSRecuperaBlocchiCartaInvoker.Response response = getOCSRecuperaBlocchiCartaInvokerResponse();
        response.recuperaBlocchiCartaResponse.elencoBlocchi = null;
        Test.setMock(HttpCalloutMock.class, new RecuperaBlocchiCartaInvokerMock(JSON.serialize(response)));
        List<PV3255InserimentoAnnulloBlocco.BloccoCarta> blocchi = PV3255InserimentoAnnulloBlocco.getBlocchiCarte('0123456789', '', 117);
        Test.stopTest();

        System.assertEquals(true, blocchi != null && blocchi.isEmpty());
    }

    @IsTest
    public static void test5() {
        Test.startTest();
        OCSBloccoSbloccoCartaInvoker.Response response = getOCSBloccoSbloccoCartaInvokerResponse();
        Test.setMock(HttpCalloutMock.class, new BloccoSbloccoCartaInvokerMock(JSON.serialize(response)));
        PV3255InserimentoAnnulloBlocco.BloccoSbloccoCartaResult result = PV3255InserimentoAnnulloBlocco.bloccoSbloccoCarta('0123456789', 'I', 'IV', null);
        Test.stopTest();

        System.assertEquals(true, result != null);
    }

    @IsTest
    public static void test6() {
        Test.startTest();
        OCSBloccoSbloccoCartaInvoker.Response response = getOCSBloccoSbloccoCartaInvokerResponse();
        response.datiBloccoSbloccoCartaResponse = null;
        Test.setMock(HttpCalloutMock.class, new BloccoSbloccoCartaInvokerMock(JSON.serialize(response)));
        PV3255InserimentoAnnulloBlocco.BloccoSbloccoCartaResult result = PV3255InserimentoAnnulloBlocco.bloccoSbloccoCarta('0123456789', 'I', 'IV', null);
        Test.stopTest();

        System.assertEquals(true, result == null);
    }

    @IsTest
    public static void test7() {
        Test.startTest();
        PV3255InserimentoAnnulloBlocco.PV3255InserimentoAnnulloBloccoForm form = initForm();

        try {
            PV3255InserimentoAnnulloBlocco.conferma(form);
        }
        catch (Exception e) {
            System.debug('[PV3255InserimentoAnnulloBloccoTest - test7] : ' + e.getMessage());
        }
        Test.stopTest();
    }

    @IsTest
    public static void test8() {
        Test.startTest();
        PV3255InserimentoAnnulloBlocco pv3255 = new PV3255InserimentoAnnulloBlocco();
        PV3255InserimentoAnnulloBlocco.PV3255InserimentoAnnulloBloccoForm form = initForm();
        Case pvCase = pv3255.completaCasePostVendita(new Case(), form);
        XCS_Messaggio__c xcsMessaggio = pv3255.preparaMessaggioOCS(form, new XCS_Messaggio__c());
        String notaSpecificaPV = pv3255.recuperaNotaSpecificaPV(form, pvCase);
        Test.stopTest();

        System.assertEquals(true, pvCase != null);
        System.assertEquals(true, xcsMessaggio != null);
        System.assertEquals(true, notaSpecificaPV != null);
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

    private static PV3255InserimentoAnnulloBlocco.PV3255InserimentoAnnulloBloccoForm initForm() {
        PV3255InserimentoAnnulloBlocco.PV3255InserimentoAnnulloBloccoForm form = new  PV3255InserimentoAnnulloBlocco.PV3255InserimentoAnnulloBloccoForm();
        form = (PV3255InserimentoAnnulloBlocco.PV3255InserimentoAnnulloBloccoForm) new PVTestFactory().initForm('3255', form);
        form.bloccoCarta = new PV3255InserimentoAnnulloBlocco.BloccoCarta();
        form.bloccoCarta.keyCode = 'CF';
        form.bloccoCarta.descrizione = 'Conferma Firma';
        return form;
    }
}