@isTest
public with sharing class SFADematerializzazioneRecupEsitiTest {

    @TestSetup
    static void makeData(){
        String responseApi = '{"resultCode":0,"resultMessage":"Ok","recuperaEsitiRichiestaDematerializzazioneDealerResponse":{"elenco":[{"tipoIntermediario":"CV","codIntermediario":"16342975","dataInserimento":"20190717","flagDematerializzazione":"S"}]}}';        
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,
                                          Test_Response__c= responseApi,
                                          Test_Request__c = 'testRequest',
                                          Mock__c = false,
                                          User__c = 'CDSLF00',
                                          Password__c = 'P00FLSDC' ,
                                          Name =RecuperaEsitiRichiestaDemDealerInvoker.SERVICE_NAME,
                                          Ref__c='CompassInternal',
                                          EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test1;     
        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert uti;

        String responseApi2 = '{"resultCode":0,"resultMessage":"Ok","richiestaDematerializzazioneDealerFlagLetturaResponse":{"esito":"KO"}}';
        
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,
                                          Test_Response__c= responseApi2,
                                          Test_Request__c = 'testRequest',
                                          Mock__c = false,
                                          User__c = 'CDSLF00',
                                          Password__c = 'P00FLSDC' ,
                                          Name =RichiestaDemDealerFlagLetturaInvoker.SERVICE_NAME,
                                          Ref__c='CompassInternal',
                                          EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test2;
 
    }

  
    @isTest
    public static void test1(){
        Account dealer = TestDataFactory.insertDealer();
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{RecuperaEsitiRichiestaDemDealerInvoker.SERVICE_NAME,RichiestaDemDealerFlagLetturaInvoker.SERVICE_NAME});
        XCS_Categoria__c cat2 = new XCS_Categoria__c(External_Id__c = 'AT0122');
        insert cat2;
        Case cas = new Case();
        cas.Status = 'New';
        cas.Subject = 'Test';
        cas.Esito__c='Esito';
        cas.Categoria_Riferimento__c = cat2.id;
        cas.AccountId = dealer.id;
        insert cas; 
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,UMR);       
        SchedulableContext sc = null;
        SFADematerializzazioneRecuperaEsiti bat = new SFADematerializzazioneRecuperaEsiti();
        bat.execute(sc);
        Test.stopTest();
        List<Case> lista = [SELECT ID, Esito__c FROM CASE WHERE Esito__c = 'S'];
        System.assert(lista!=null && lista.size()==1);

    }


}