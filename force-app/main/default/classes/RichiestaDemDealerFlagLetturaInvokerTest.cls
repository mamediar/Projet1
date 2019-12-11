@isTest
public class RichiestaDemDealerFlagLetturaInvokerTest {



      @TestSetup
      static void makeData(){
        String responseApi = '{"resultCode":0,"resultMessage":"Ok","richiestaDematerializzazioneDealerFlagLetturaResponse":{"esito":"KO"}}';
        
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,
                                          Test_Response__c= responseApi,
                                          Test_Request__c = 'testRequest',
                                          Mock__c = false,
                                          User__c = 'CDSLF00',
                                          Password__c = 'P00FLSDC' ,
                                          Name =RichiestaDemDealerFlagLetturaInvoker.SERVICE_NAME,
                                          Ref__c='CompassInternal',
                                          EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test1;
        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert uti;
        
    }
 
   @isTest
   public static void testKO() {


        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname=RichiestaDemDealerFlagLetturaInvoker.SERVICE_NAME;
        Test.setMock(HttpCalloutMock.class,UMR);

        RichiestaDemDealerFlagLetturaInvoker.Request req = new RichiestaDemDealerFlagLetturaInvoker.Request('CV','16039294','20190912');
 
        RichiestaDemDealerFlagLetturaInvoker.Response res = RichiestaDemDealerFlagLetturaInvoker.invoke(req);
        System.debug('isOK:'+res.isOK());
        System.debug('getMessage():'+res.getMessage());
        if (res.richiestaDematerializzazioneDealerFlagLetturaResponse!=null) {
                System.debug('esito:'+res.richiestaDematerializzazioneDealerFlagLetturaResponse.esito); 
        }      
        System.assert(!res.isOK());
        test.stopTest();  

    }
}