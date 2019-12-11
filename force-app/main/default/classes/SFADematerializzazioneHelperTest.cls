@isTest
public with sharing class SFADematerializzazioneHelperTest {


     @TestSetup
	 static void makeData(){
        String responseApi = '{"resultCode":0,"resultMessage":"Ok","verificaRequisitiDematerializzazioneDealerResponse":{"esito":"OK","desErrore":""}}';
        
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
        XCS_Categoria__c cat =  new  XCS_Categoria__c(External_Id__c = '5595');
        insert cat;
    }


    @isTest
    public static void test1(){
  		Account dealer = TestDataFactory.insertDealer();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname=VerificaRequisitiDemDealerInvoker.SERVICE_NAME;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,UMR);
        String res = SFADematerializzazioneHelper.creaAttivitaDematerializzazione(dealer.id);
        System.assert(res==null);
        Test.stopTest();       
    }

}