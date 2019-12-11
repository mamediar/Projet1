@isTest
public with sharing class OCSRecuperaDatiCartaDealerInvokerTest {


     @testSetup
	 private static void testsetup(){
        String responseApi = '{"resultCode":0,"resultMessage":"Ok","recuperaDatiCartaDealerResponse":{"numeroPratica":"103135280390","codCliente":"5479910","codDealer":"167442","codProdotto":"05","statoDealer":"AT","telCellulare":"392044612"}}';
        
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,
                                          Test_Response__c= responseApi,
                                          Test_Request__c = 'testRequest',
                                          Mock__c = false,
                                          User__c = 'CDSLF00',
                                          Password__c = 'P00FLSDC' ,
                                          Name =OCSRecuperaDatiCartaDealerInvoker.SERVICE_NAME,
                                          Ref__c='CompassInternal',
                                          EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test1;

        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      

        insert uti;
        
    }

    @isTest
    public static void testOK(){

        Test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname=OCSRecuperaDatiCartaDealerInvoker.SERVICE_NAME;
        Test.setMock(HttpCalloutMock.class,UMR);
        OCSRecuperaDatiCartaDealerInvoker.Response res = OCSRecuperaDatiCartaDealerInvoker.invoke('103135280390');
//        System.debug('res:'+res);
        Boolean isFound = false;
        if (res.isOk() && res.recuperaDatiCartaDealerResponse!=null) {
           // read all field
           System.debug(res.recuperaDatiCartaDealerResponse.numeroPratica);
           System.debug(res.recuperaDatiCartaDealerResponse.codCliente);
           System.debug(res.recuperaDatiCartaDealerResponse.codDealer);
           System.debug(res.recuperaDatiCartaDealerResponse.codProdotto);
           System.debug(res.recuperaDatiCartaDealerResponse.descProdotto);
           System.debug(res.recuperaDatiCartaDealerResponse.dataRichiesta);
           System.debug(res.recuperaDatiCartaDealerResponse.fido);
           System.debug(res.recuperaDatiCartaDealerResponse.ragioneSociale);
           System.debug(res.recuperaDatiCartaDealerResponse.ragioneSocialeDealer);
           System.debug(res.recuperaDatiCartaDealerResponse.statoDealer);
           System.debug(res.recuperaDatiCartaDealerResponse.telCellulare);
           System.debug(res.recuperaDatiCartaDealerResponse.telDatore);
           System.debug(res.recuperaDatiCartaDealerResponse.telCase);
           isFound = true;
        }
        Test.stopTest();
        System.assert(isFound);
 
    }
}