@isTest
public with sharing class SFAComunicazioneUtenzeControllerTest {


    @TestSetup
    static void makeData(){
        XCS_Categoria__c cat = new XCS_Categoria__c(External_Id__c = 'AT0114');
        insert cat;
        XCS_Categoria__c cat2 = new XCS_Categoria__c(External_Id__c = 'AT0122');
        insert cat2;
    }

    @isTest
    public static void test1(){
        Case cas = TestDataFactory.insertCase();
        Test.startTest();
        Case res = SFAComunicazioneUtenzeController.getComunicazione(cas.id);
        Test.stopTest();
        System.assert(res!=null);
    }

    @isTest
    public static void test2(){
        Case cas = TestDataFactory.insertCase();
        Comunicazione_Utenze__c com = new Comunicazione_Utenze__c(Canale__c = '2',	Utenza__c= '323232',CaseAttivit_di_Riferimento__c = cas.id);
        insert com;
        Test.startTest();
        List<Comunicazione_Utenze__c> lista = SFAComunicazioneUtenzeController.listUtenzeNominative(cas.id);
        Test.stopTest();
        System.assert(lista.size()==1);
    }

    @isTest
    public static void test3(){
        Case cas = TestDataFactory.insertCase();
        Comunicazione_Utenze__c com = new Comunicazione_Utenze__c(Canale__c = '2',	Utenza__c= '323232',CaseAttivit_di_Riferimento__c = cas.id);
        insert com;
        Test.startTest();
        String body64 = SFAComunicazioneUtenzeController.getBase64PDFUtenzeNominative(cas.id);
        Test.stopTest();
        System.assert(body64!=null);
    }


    @isTest
    public static void test4(){
        String responseApi = '{"resultCode":0,"resultMessage":"Ok","verificaRequisitiDematerializzazioneDealerResponse":{"esito":"KO","desErrore":"Nessuna utenza nominale trovata"}}';    
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,
                                          Test_Response__c= responseApi,
                                          Test_Request__c = 'testRequest',
                                          Mock__c = false,
                                          User__c = 'CDSLF00',
                                          Password__c = 'P00FLSDC' ,
                                          Name =VerificaRequisitiDemDealerInvoker.SERVICE_NAME,
                                          Ref__c='CompassInternal',
                                          EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test1;
        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert uti;
        Account delaer = TestDataFactory.insertDealer();
        Case cas = TestDataFactory.insertCase();
        cas.AccountId = delaer.id;
        update cas;
        Test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname=VerificaRequisitiDemDealerInvoker.SERVICE_NAME;
        Test.setMock(HttpCalloutMock.class,UMR);
        String result = SFAComunicazioneUtenzeController.process(cas.id);
        Test.stopTest();
        System.assert(result!=null);
    }


}