@isTest
public class OCSRecuperaDatiPostvenditaInvokerTest {
    
    @isTest
    public static void test() {
         
        /*Response completa: {"resultCode":0,"resultMessage":"Ok","pratiche":[{"numPratica":"800000329783","codCliente":"9529124","abi":"0","cab":"0","numConto":"","iban":"","statoPratica":"90","tipoPagamento":"BP","prodotto":"4D","filiale":"223","dataEstinzione":"","tipoPratica":"CO","dataCaricamento":833925626454,"pan":"","convenzionato":"212217","puntoVendita":"0","venditore":"0","agente":"7085406","subAgente":"272166","flagRecupero":"N","classifRecupero":null,"societa":"Linea","elencoCoobbligati":null,"codStatoPratica":"90","codAttributoPratica":"","desStatoPratica":"Estinta","desAttributoPratica":"","codRecuperatore":"","desRecuperatore":"","canale":"   "}],"cliente":[{"cognome":"UTMOBZE","codCliente":"9529151","nome":"LERRIO","dataNascita":"0","luogoNascita":"","provNascita":"","sesso":"M","codFiscale":"","piva":"","indirizzo":"VIA ROMA 4","cap":"16149","localita":"GENOVA","provincia":"GE","paeseEstero":"086","email":"","tipoDocumento":"","numDocumento":"","ufficioRilascio":"","luogoRilascio":"","provRilascio":"","dataRilascio":"0","denominazioneAzienda":"UTMOBZE LERRIO","formaGiuridica":"","tipoAnagrafica":"P","dataScadenza":"0","telefonoCasa":"010 475464","telCellulare":"","tipoRapporto":"","dataDepennamento":"0","ndg":"0"}]}
         */
        
        String response = '{"resultCode":0,"resultMessage":"Ok","pratiche":[{"numPratica":"800000329783","codCliente":"9529124"}],"cliente":[{"cognome":"UTMOBZE","codCliente":"9529151","nome":"LERRIO"';
        //-- - INIZIO MODIFICA
        //-- - Autor        : Giuseppe Carrubba
        //-- - Date         : 04/06/2019
        //-- - Description  : aggiunto Ref__c dentro test1, aggiunto ApiUtil__c test2 
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Ref__c='CompassInternal', Name ='ocs.recuperaDatiPostvendita',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        ApiUtil__c test2 = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert test1;
        insert test2;
        //-- - FINE MODIFICA
        //--------------------------------------------------------------------
        
        test.startTest();
        OCSRecuperaDatiPostvenditaRequest req = new OCSRecuperaDatiPostvenditaRequest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.recuperaDatiPostvendita';
        Test.setMock(HttpCalloutMock.class,UMR);
        
        Map<String,String> mapRequest = new Map<String,String> {'numPratica' => '1111111' , 'flagInfoCliente' => '241'};
            
        OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV(req); 
        OCSRecuperaDatiPostVenditaInvoker.callRecDatiPV('9529151');
        OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV(mapRequest);
        test.stopTest();
    }
    
}