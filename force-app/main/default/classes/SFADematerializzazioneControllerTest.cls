@isTest
public with sharing class SFADematerializzazioneControllerTest {

    @isTest
    public static void test1(){
        XCS_Categoria__c cat2 = new XCS_Categoria__c(External_Id__c = 'AT0122');
        insert cat2;
        Case cas = TestDataFactory.insertCase();
        cas.Categoria_Riferimento__c = cat2.id;
        update cas;
        Test.startTest();
        Case res = SFADematerializzazioneController.getDematerializzazione(cas.id);
        Test.stopTest();
        System.assert(res!=null);
    }

    @isTest
    public static void test2(){
        Case cas = TestDataFactory.insertCase();
        Test.startTest();
        SFADematerializzazioneController.process(cas.id);
        Test.stopTest();
        Case res = [SELECT Id, Status FROM CASE];
        System.assert('Closed'==res.Status);
    }

    @isTest
    public static void test3(){
        String responseApi = '{"resultCode":0,"resultMessage":"Ok","inserimentoRichiestaDematerializzazioneDealerResponse":{"esito":"OK","desErrore":""}}';        
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,
                                          Test_Response__c= responseApi,
                                          Test_Request__c = 'testRequest',
                                          Mock__c = false,
                                          User__c = 'CDSLF00',
                                          Password__c = 'P00FLSDC' ,
                                          Name =InserimentoRichiestaDemDealerInvoker.SERVICE_NAME,
                                          Ref__c='CompassInternal',
                                          EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test1;
        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert uti;
        Account delaer = TestDataFactory.insertDealer();
        Test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname=InserimentoRichiestaDemDealerInvoker.SERVICE_NAME;
        Test.setMock(HttpCalloutMock.class,UMR);
        String res = SFADematerializzazioneController.insertRichiestaDem(delaer.id);
        Test.stopTest();
        System.assert(res==null);
    }



}