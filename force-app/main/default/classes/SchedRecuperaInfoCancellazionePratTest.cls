/**
 * @File Name          : SchedRecuperaInfoCancellazionePratTest.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 8/10/2019, 17:13:07
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    3/10/2019   sabrina vitali     Initial Version
**/
@IsTest(SeeAllData=true)
private class SchedRecuperaInfoCancellazionePratTest {
    
    @isTest
    public static void ocsRecuperaInfoCancellazionePratTest() {
        
        try {
            Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
            
            ApiRest__c apiRest1 = [Select id, name, EndPoint__c, Test_Response__c, Method__c, Mock__c, Password__c, Ref__c, User__c from ApiRest__c where name = 'ocs.recuperaInfoCancellazionePratica'];
            
            apiRest1.EndPoint__c = 'ocs.recuperaInfoCancellazionePratica';
            apiRest1.Test_Response__c = '';
            apiRest1.Method__c = 'POST'; 
            apiRest1.Mock__c = false; 
            apiRest1.Password__c = 'P00FLSDC';
            apiRest1.Ref__c = 'CompassInternal'; 
            apiRest1.User__c = 'CDSLF00';
            
            update apiRest1;
            
            List<String> responses = new List<String>();
            //responses.add('{"resultCode":0,"resultMessage":"Ok","recuperaInfoCancellazionePraticaResponse":{"elencoPratiche":[{"tipoPratica":"CA","numPratica":"32197740038","dataInserimento":"20191001","flagCancellazionePratica":"S","motivoMancataCancellazione":"","tipoPraticaCongiunta":"","numPraticaCongiunta":"0","flagCancellazionePraticaCongiunta":"","motivoMancataCancellazioneCongiunta":"","dataElaborazioneOCS":"20191002","flagCancellazioneSic":"N","noteCancellazioneSic":"8396 Errore/rifiuto CRIF","elencoAnagrafiche":[{"tipoPratica":"CA","numPratica":"32197740038","tipoControparte":"CL","codControparte":"19292142","flagCancellazione":"S","motivoMancataCancellazione":"OK","dataElaborazioneOCS":"20191002","flagCancellazioneSic":"","noteCancellazioneSic":""}]}]}}');
            String stringonaJSON;
            stringonaJSON = '{"resultCode":0,"resultMessage":"Ok","recuperaInfoCancellazionePraticaResponse":{"elencoPratiche":[';
            stringonaJSON += '{"tipoPratica":"CO","numPratica":"5441084","dataInserimento":"20191008","flagCancellazionePratica":"N","motivoMancataCancellazione":"","tipoPraticaCongiunta":"","numPraticaCongiunta":"0","flagCancellazionePraticaCongiunta":"","motivoMancataCancellazioneCongiunta":"","dataElaborazioneOCS":"20191008","flagCancellazioneSic":"","noteCancellazioneSic":"","elencoAnagrafiche":[]}';
            stringonaJSON += ',{"tipoPratica":"CO","numPratica":"9696202","dataInserimento":"20191008","flagCancellazionePratica":"N","motivoMancataCancellazione":"cancellazione per BACK","tipoPraticaCongiunta":"","numPraticaCongiunta":"0","flagCancellazionePraticaCongiunta":"","motivoMancataCancellazioneCongiunta":"","dataElaborazioneOCS":"20191008","flagCancellazioneSic":"","noteCancellazioneSic":"","elencoAnagrafiche":[]}';
            stringonaJSON += ',{"tipoPratica":"CO","numPratica":"5436588","dataInserimento":"20191008","flagCancellazionePratica":"N","motivoMancataCancellazione":"PRESENTE ALTRA PRATICA DI FINANZIAMENTO IN LAVORAZIONE","tipoPraticaCongiunta":"","numPraticaCongiunta":"0","flagCancellazionePraticaCongiunta":"","motivoMancataCancellazioneCongiunta":"","dataElaborazioneOCS":"20191008","flagCancellazioneSic":"","noteCancellazioneSic":"","elencoAnagrafiche":[]}';
            stringonaJSON += ',{"tipoPratica":"CO","numPratica":"5707941","dataInserimento":"20191008","flagCancellazionePratica":"S","motivoMancataCancellazione":"","tipoPraticaCongiunta":"","numPraticaCongiunta":"0","flagCancellazionePraticaCongiunta":"","motivoMancataCancellazioneCongiunta":"","dataElaborazioneOCS":"20191008","flagCancellazioneSic":"S","noteCancellazioneSic":"OK","elencoAnagrafiche":[]}';
            stringonaJSON += ',{"tipoPratica":"CO","numPratica":"9694857","dataInserimento":"20191008","flagCancellazionePratica":"S","motivoMancataCancellazione":"","tipoPraticaCongiunta":"","numPraticaCongiunta":"0","flagCancellazionePraticaCongiunta":"","motivoMancataCancellazioneCongiunta":"","dataElaborazioneOCS":"20191008","flagCancellazioneSic":"N","noteCancellazioneSic":"8396 Errore/rifiuto CRIF","elencoAnagrafiche":[]}';
            stringonaJSON += ',{"tipoPratica":"PB","numPratica":"8749588","dataInserimento":"20191008","flagCancellazionePratica":"S","motivoMancataCancellazione":"","tipoPraticaCongiunta":"","numPraticaCongiunta":"0","flagCancellazionePraticaCongiunta":"","motivoMancataCancellazioneCongiunta":"","dataElaborazioneOCS":"20191008","flagCancellazioneSic":"N","noteCancellazioneSic":"0532 Procedura non gestita","elencoAnagrafiche":[]}';
            stringonaJSON += ',{"tipoPratica":"CO","numPratica":"9202932","dataInserimento":"20191008","flagCancellazionePratica":"S","motivoMancataCancellazione":"","tipoPraticaCongiunta":"","numPraticaCongiunta":"0","flagCancellazionePraticaCongiunta":"","motivoMancataCancellazioneCongiunta":"","dataElaborazioneOCS":"20191008","flagCancellazioneSic":"N","noteCancellazioneSic":"nota a caso ","elencoAnagrafiche":[{"tipoPratica":"CO","numPratica":"9202932","tipoControparte":"CL","codControparte":"123456","flagCancellazione":"","motivoMancataCancellazione":"CONTROPARTE PRESENTE IN PROCEDURA CO","dataElaborazioneOCS":"20191008","flagCancellazioneSic":"","noteCancellazioneSic":""},{"tipoPratica":"CO","numPratica":"9202932","tipoControparte":"CL","codControparte":"654321","flagCancellazione":"","motivoMancataCancellazione":"CONTROPARTE PRESENTE IN PROCEDURA CA","dataElaborazioneOCS":"20191008","flagCancellazioneSic":"","noteCancellazioneSic":""}]}';
            stringonaJSON += ']}}';
            responses.add(stringonaJSON);


            serviceIdResponseMap.put('recuperaInfoCancellazionePratica', responses);
            Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
            test.startTest();      
            System.debug('@@@@@@@');
            SchedRecuperaInfoCancellazionePratica schedRecuperaInfoCancellazionePratica = new SchedRecuperaInfoCancellazionePratica();
            schedRecuperaInfoCancellazionePratica.execute(null);
            test.stopTest();
        } catch (Exception e) {
            e.getMessage(); 
        }
    }
    
/*    @IsTest
    public static void ocsNoResults() {
    }
    
    @IsTest
    public static void ocsError() {
    }
*/    
}