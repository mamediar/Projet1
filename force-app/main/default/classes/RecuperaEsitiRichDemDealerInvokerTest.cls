@isTest
public class RecuperaEsitiRichDemDealerInvokerTest {
 
       @TestSetup
      public static void makeData(){
         String responseApi = '{"resultCode":0,"resultMessage":"Ok","recuperaEsitiRichiestaDematerializzazioneDealerResponse":{"elenco":[{"tipoIntermediario":"CV","codIntermediario":"63738","dataInserimento":"20190717","flagDematerializzazione":"S"}]}}';
        
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
        
    }
  
    @isTest
    public static void testKO() {


        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname=RecuperaEsitiRichiestaDemDealerInvoker.SERVICE_NAME;
        Test.setMock(HttpCalloutMock.class,UMR);

        RecuperaEsitiRichiestaDemDealerInvoker.Request req = new RecuperaEsitiRichiestaDemDealerInvoker.Request();
 
        RecuperaEsitiRichiestaDemDealerInvoker.Response res = RecuperaEsitiRichiestaDemDealerInvoker.invoke(req);
        System.debug('isOK:'+res.isOK());
        System.debug('getMessage():'+res.getMessage());
        boolean isFound = false;
        if (res.recuperaEsitiRichiestaDematerializzazioneDealerResponse!=null && res.recuperaEsitiRichiestaDematerializzazioneDealerResponse.elenco!=null) {
            for (RecuperaEsitiRichiestaDemDealerInvoker.EsitoRichiestaDemDealerDTO dto:res.recuperaEsitiRichiestaDematerializzazioneDealerResponse.elenco) {
                isFound = true;
            }
        }  
        System.assert(isFound);
        test.stopTest();
      

    }


    @isTest static void readDTO() {
        test.startTest();
        RecuperaEsitiRichiestaDemDealerInvoker.EsitoRichiestaDemDealerDTO dto = new   RecuperaEsitiRichiestaDemDealerInvoker.EsitoRichiestaDemDealerDTO();
        System.debug(dto.tipoIntermediario);
        System.debug(dto.codIntermediario);
        System.debug(dto.dataInserimento);
        System.debug(dto.utenteRichiedente);
        System.debug(dto.flagDematerializzazione);
        System.debug(dto.esitoDematerializzazione);
        System.debug(dto.dataElaborazioneOCS);
        test.stopTest();
    }


}