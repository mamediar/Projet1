@isTest
public class VerificaRequisitiDemDealerInvokerTest {



     @TestSetup
	 static void makeData(){
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
        
    }

    @IsTest
    public static void testKO() {
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname=VerificaRequisitiDemDealerInvoker.SERVICE_NAME;
        Test.setMock(HttpCalloutMock.class,UMR);


        VerificaRequisitiDemDealerInvoker.Request req = new VerificaRequisitiDemDealerInvoker.Request('CV','16039294');
 //       VerificaRequisitiDemDealerInvoker.Request req = new VerificaRequisitiDemDealerInvoker.Request('CV','63738');
 
        VerificaRequisitiDemDealerInvoker.Response res = VerificaRequisitiDemDealerInvoker.invoke(req);
        System.debug('isOK:'+res.isOK());
        System.debug('getMessage():'+res.getMessage());
        if (res.verificaRequisitiDematerializzazioneDealerResponse!=null) {
                System.debug('esito:'+res.verificaRequisitiDematerializzazioneDealerResponse.esito); 
                System.debug('desErrore:'+res.verificaRequisitiDematerializzazioneDealerResponse.desErrore); 
        }        
        System.assert(!res.isOK());
        test.stopTest();

    }


    @isTest static void readDTO() {
        test.startTest();
        VerificaRequisitiDemDealerInvoker.VerificaRequisitiDemDealerRequestDTO dto = new VerificaRequisitiDemDealerInvoker.VerificaRequisitiDemDealerRequestDTO();
        System.debug(dto.tipoIntermediario);
        System.debug(dto.codIntermediario);
        VerificaRequisitiDemDealerInvoker.VerificaRequisitiDemDealerResponseDTO dtoRes = new VerificaRequisitiDemDealerInvoker.VerificaRequisitiDemDealerResponseDTO();
        System.debug(dtoRes.esito);
        System.debug(dtoRes.desErrore);
        test.stopTest();
    }
/*
    public static void testAnagraficaInesistente() {

        VerificaRequisitiDemDealerInvoker.Request req = new VerificaRequisitiDemDealerInvoker.Request('CV','829G0009W8');
 
        VerificaRequisitiDemDealerInvoker.Response res = VerificaRequisitiDemDealerInvoker.invoke(req);
        System.debug('isOK:'+res.isOK());
        System.debug('getMessage():'+res.getMessage());
        if (res.verificaRequisitiDematerializzazioneDealerResponse!=null) {
                System.debug('esito:'+res.verificaRequisitiDematerializzazioneDealerResponse.esito); 
                System.debug('desErrore:'+res.verificaRequisitiDematerializzazioneDealerResponse.desErrore); 
        }        

    }

    public static void testNessunaUtenzaNominale() {

        VerificaRequisitiDemDealerInvoker.Request req = new VerificaRequisitiDemDealerInvoker.Request('CV','16039294');
 
        VerificaRequisitiDemDealerInvoker.Response res = VerificaRequisitiDemDealerInvoker.invoke(req);
        System.debug('isOK:'+res.isOK());
        System.debug('getMessage():'+res.getMessage());
        if (res.verificaRequisitiDematerializzazioneDealerResponse!=null) {
                System.debug('esito:'+res.verificaRequisitiDematerializzazioneDealerResponse.esito); 
                System.debug('desErrore:'+res.verificaRequisitiDematerializzazioneDealerResponse.desErrore); 
        }        

    }
*/
}