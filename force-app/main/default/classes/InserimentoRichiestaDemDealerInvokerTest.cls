@IsTest
public with sharing class InserimentoRichiestaDemDealerInvokerTest {


        

      @TestSetup
      static void makeData(){
         String responseApi = '{"resultCode":0,"resultMessage":"Ok","inserimentoRichiestaDematerializzazioneDealerResponse":{"esito":"KO","desErrore":"Nessuna utenza nominale trovata"}}';
        
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
        
    }
   
    @IsTest
    public static void testKO() {


        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname=InserimentoRichiestaDemDealerInvoker.SERVICE_NAME;
        Test.setMock(HttpCalloutMock.class,UMR);

        InserimentoRichiestaDemDealerInvoker.Request req = new InserimentoRichiestaDemDealerInvoker.Request('CV','16039294','CD2483');
 
        InserimentoRichiestaDemDealerInvoker.Response res = InserimentoRichiestaDemDealerInvoker.invoke(req);
        System.debug('isOK:'+res.isOK());
        System.debug('getMessage():'+res.getMessage());
        if (res.inserimentoRichiestaDematerializzazioneDealerResponse!=null) {
                System.debug('esito:'+res.inserimentoRichiestaDematerializzazioneDealerResponse.esito); 
                System.debug('desErrore:'+res.inserimentoRichiestaDematerializzazioneDealerResponse.desErrore); 
        }        
        System.assert(!res.isOK());
        test.stopTest();

    }


}