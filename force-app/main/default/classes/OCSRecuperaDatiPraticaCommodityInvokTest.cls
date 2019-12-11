@isTest
public with sharing class OCSRecuperaDatiPraticaCommodityInvokTest {



     @testSetup
	 private static void testsetup(){
        String responseApi = '{"resultCode":0,"resultMessage":"Ok","recuperaDatiPraticaCommodityResponse":{"datiPraticaCommodityDTO":{"numPratica":"20417681","codCliente":"19112773","cognome":"RAOPSTALLA","importoRata":"20021"}}}';
        
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,
                                          Test_Response__c= responseApi,
                                          Test_Request__c = 'testRequest',
                                          Mock__c = false,
                                          User__c = 'CDSLF00',
                                          Password__c = 'P00FLSDC' ,
                                          Name =OCSRecuperaDatiPraticaCommodityInvoker.SERVICE_NAME,
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
        UMR.apiname=OCSRecuperaDatiPraticaCommodityInvoker.SERVICE_NAME;
        Test.setMock(HttpCalloutMock.class,UMR);
        Boolean isFound = false;
        OCSRecuperaDatiPraticaCommodityInvoker.Response res =  OCSRecuperaDatiPraticaCommodityInvoker.invoke('20417681');
        if (res.isOk() && res.recuperaDatiPraticaCommodityResponse!=null && res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO!=null) {
           // read all field
           System.debug(res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.numeroPratica);
           System.debug(res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.codCliente);
           System.debug(res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.cognome);
           System.debug(res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.nome);
           System.debug(res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.ragioneSociale);
           System.debug(res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.telefonoCasa);
           System.debug(res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.codDealer);
           System.debug(res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.statoDealer);
           System.debug(res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.telCellulare);
           System.debug(res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.telDatore);
           System.debug(res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.codClienteCoob);
           System.debug(res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.cognomeCoob);
           System.debug(res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.nomeCoob);
           System.debug(res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.ragioneSocialeCoob);
           System.debug(res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.telefonoCasaCoob);
           System.debug(res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.telCellulareCoob);
           System.debug(res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.telDatoreCoob);
           System.debug(res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.dataLiquidazione);
           System.debug(res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.descrizioneBene);
           System.debug(res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.codDestFinanziamento);
           System.debug(res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.descDestFinanziamento);
           System.debug(res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.tipoProdotto);
           System.debug(res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.numRata);
           System.debug(res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.importoRata);
           System.debug(res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.finanziato);
           System.debug(res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.ragioneSocialeDealer);
           System.debug(res.recuperaDatiPraticaCommodityResponse.datiPraticaCommodityDTO.canale);
  
           isFound = true;
        }
        Test.stopTest();
        System.assert(isFound);
        
        }
}