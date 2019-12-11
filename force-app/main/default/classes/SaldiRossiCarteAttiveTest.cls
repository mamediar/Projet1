@IsTest(SeeAllData=true)
public class SaldiRossiCarteAttiveTest {
    
    @isTest
    public static void ocsRecuperaSaldiRossiCarteAttiveTest() {
        
        try {
            Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
            
            ApiRest__c apiRest1 = [Select id, name, EndPoint__c, Test_Response__c, Method__c, Mock__c, Password__c, Ref__c, User__c from ApiRest__c where name = 'ocs.recuperaSaldiRossiCarteAttive'];
            System.debug('DM - ***************************** - ' + apiRest1.Name);
            apiRest1.EndPoint__c = 'ocs.recuperaSaldiRossiCarteAttive';
            apiRest1.Test_Response__c = '';
            apiRest1.Method__c = 'POST'; 
            apiRest1.Mock__c = false; 
            apiRest1.Password__c = 'P00FLSDC';
            apiRest1.Ref__c = 'CompassInternal'; 
            apiRest1.User__c = 'CDSLF00';
            
            update apiRest1;
            
            List<String> responses = new List<String>();
            responses.add('{"resultCode":0,"resultMessage":"Ok","recuperaSaldiRossiOngoingResponse":{"elencoSaldiRossi":[{"periodo":"201903","tipoRecord":"TE","tipoPraticaTe":"CO","numPraticaTe":"14519274","primaEstrazioneTe":"201903","statoPraticaTe":"40","bloccoPraticaTe":"  ","saldoTe":"-59894","compensabileTe":"0","progressivoDe":"0","tipoPraticaDe":"  ","numPraticaDe":"0","statoPraticaDe":"  ","bloccoPraticaDe":"  ","tipoCompensazioneDe":"  ","anzianitaInsolutoDe":"0","totaleSpesaDe":"0","compensazionePropostaDe":"0","dataEstrazione":"20190411","abi":"8673","cab":"21501","numConto":"073000102830","iban":"IT58F0867321501073000102830","tipoPagamento":"RI","filiale":"168","codCliente":"15258228","cognome":"Cragno","nome":"Luca","dataNascita":"20001004","luogoNascita":"PRATO","provNascita":"PO","sesso":"M","codFiscale":"CRGLCU00R04G999S","indirizzo":"VIA VERDI 52","cap":"59100","localita":"PRATO","provincia":"FI","email":"","denominazioneAzienda":"Luca Cragno","telefonoCasa":"0574 617832","telCellulare":"328 7896315"},{"periodo":"201903","tipoRecord":"TE","tipoPraticaTe":"CO","numPraticaTe":"17408092","primaEstrazioneTe":"201903","statoPraticaTe":"91","bloccoPraticaTe":"  ","saldoTe":"-84393","compensabileTe":"0","progressivoDe":"0","tipoPraticaDe":"  ","numPraticaDe":"0","statoPraticaDe":"  ","bloccoPraticaDe":"  ","tipoCompensazioneDe":"  ","anzianitaInsolutoDe":"0","totaleSpesaDe":"0","compensazionePropostaDe":"0","dataEstrazione":"20190411","abi":"3069","cab":"53100","numConto":"100000001564","iban":"IT56V0306953100100000001564","tipoPagamento":"RI","filiale":"014","codCliente":"17197435","cognome":"Capece","nome":"Nicola","dataNascita":"19960219","luogoNascita":"GORLE","provNascita":"BG","sesso":"","codFiscale":"CPCNCL96B19E103K","indirizzo":"PIAZZA REPUBBLICA 1","cap":"24020","localita":"GORLE","provincia":"BG","email":"","denominazioneAzienda":"Nicola Capece","telefonoCasa":"035 256778","telCellulare":""},{"periodo":"201903","tipoRecord":"DE","tipoPraticaTe":"CO","numPraticaTe":"19619956","primaEstrazioneTe":"201903","statoPraticaTe":"91","bloccoPraticaTe":"  ","saldoTe":"-8750","compensabileTe":"1018","progressivoDe":"1","tipoPraticaDe":"CO","numPraticaDe":"11795683","statoPraticaDe":"90","bloccoPraticaDe":"  ","tipoCompensazioneDe":"SP","anzianitaInsolutoDe":"0","totaleSpesaDe":"1018","compensazionePropostaDe":"1018","dataEstrazione":"20190411","abi":"2008","cab":"40171","numConto":"000400692569","iban":"IT85I0200840171000400692569","tipoPagamento":"RI","filiale":"148","codCliente":"4893740","cognome":"MCAORSZNI","nome":"HAIDEH","dataNascita":"19810507","luogoNascita":"SAN GIUSEPPE VESUVIANO","provNascita":"NA","sesso":"F","codFiscale":"MCRHDH81E47H931A","indirizzo":"VIA ROMA 2","cap":"80040","localita":"SAN GENNARO VESUVIANO","provincia":"NA","email":"MCAORSZNI.HAIDEH@provider.com","denominazioneAzienda":"MCAORSZNI HAIDEH","telefonoCasa":"","telCellulare":"351 0946921"},{"periodo":"201903","tipoRecord":"TE","tipoPraticaTe":"CO","numPraticaTe":"19619956","primaEstrazioneTe":"201903","statoPraticaTe":"91","bloccoPraticaTe":"  ","saldoTe":"-8750","compensabileTe":"1018","progressivoDe":"0","tipoPraticaDe":"  ","numPraticaDe":"0","statoPraticaDe":"  ","bloccoPraticaDe":"  ","tipoCompensazioneDe":"  ","anzianitaInsolutoDe":"0","totaleSpesaDe":"0","compensazionePropostaDe":"0","dataEstrazione":"20190411","abi":"2008","cab":"40171","numConto":"000400692569","iban":"IT85I0200840171000400692569","tipoPagamento":"RI","filiale":"148","codCliente":"4893740","cognome":"MCAORSZNI","nome":"HAIDEH","dataNascita":"19810507","luogoNascita":"SAN GIUSEPPE VESUVIANO","provNascita":"NA","sesso":"F","codFiscale":"MCRHDH81E47H931A","indirizzo":"VIA ROMA 2","cap":"80040","localita":"SAN GENNARO VESUVIANO","provincia":"NA","email":"MCAORSZNI.HAIDEH@provider.com","denominazioneAzienda":"MCAORSZNI HAIDEH","telefonoCasa":"","telCellulare":"351 0946921"}]}}');
            serviceIdResponseMap.put('recuperaSaldiRossiCarteAttive', responses);
            
            ApiRest__c apiRest2 = [Select id, name, EndPoint__c, Test_Response__c, Method__c, Mock__c, Password__c, Ref__c, User__c from ApiRest__c where name = 'ocs.sbloccaSaldiRossiOngoing'];
            System.debug('DM - ***************************** - ' + apiRest2.Name);
            apiRest2.EndPoint__c = 'ocs.sbloccaSaldiRossiOngoing';
            apiRest2.Test_Response__c = '';
            apiRest2.Method__c = 'POST'; 
            apiRest2.Mock__c = false; 
            apiRest2.Password__c = 'P00FLSDC';
            apiRest2.Ref__c = 'CompassInternal'; 
            apiRest2.User__c = 'CDSLF00';
            
            update apiRest2;
            
            List<String> responses2 = new List<String>();
            responses2.add('{"resultCode":0,"resultMessage":"Ok","sbloccaSaldiRossiOngoingResponse":{"ultimaPraticaElaborata":null,"ultimaDataRevocaCarta":null}}');
            serviceIdResponseMap.put('sbloccaSaldiRossiOngoing', responses2);
            System.debug('DM - ***************************** - step 1');
            Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
            test.startTest();  
            System.debug('DM - ***************************** - step 2');
            SaldiRossiCarteAttive saldiRossiCarteAttive = new SaldiRossiCarteAttive();
            saldiRossiCarteAttive.execute(null);
            
            test.stopTest();
            System.debug('DM - ***************************** - step 3');
        } catch (Exception e) {
            e.getMessage(); 
        }
    }
    
    @IsTest
    public static void ocsNoResults() {
        
        try {
            Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
            
            ApiRest__c apiRest1 = [Select id, name, EndPoint__c, Test_Response__c, Method__c, Mock__c, Password__c, Ref__c, User__c from ApiRest__c where name = 'ocs.recuperaSaldiRossiCarteAttive'];
            
            apiRest1.EndPoint__c = 'ocs.recuperaSaldiRossiCarteAttive';
            apiRest1.Test_Response__c = '';
            apiRest1.Method__c = 'POST'; 
            apiRest1.Mock__c = false; 
            apiRest1.Password__c = 'P00FLSDC';
            apiRest1.Ref__c = 'CompassInternal'; 
            apiRest1.User__c = 'CDSLF00';
            
            update apiRest1;
            
            List<String> responses = new List<String>();
            responses.add('{"resultCode":0,"resultMessage":"Ok","recuperaSaldiRossiOngoingResponse":{"elencoSaldiRossi": null}}');
            serviceIdResponseMap.put('recuperaSaldiRossiCarteAttive', responses);
            
            Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
            test.startTest();      
            SaldiRossiCarteAttive saldiRossiCarteAttive = new SaldiRossiCarteAttive();
            saldiRossiCarteAttive.execute(null);
            test.stopTest();
            
        } catch (Exception e) {
            e.getMessage();
        }
        
    }
    
    @IsTest
    public static void ocsError() {
        
        try {
            Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
            
            ApiRest__c apiRest1 = [Select id, name, EndPoint__c, Test_Response__c, Method__c, Mock__c, Password__c, Ref__c, User__c from ApiRest__c where name = 'ocs.recuperaSaldiRossiCarteAttive'];
            
            apiRest1.EndPoint__c = 'ocs.recuperaSaldiRossiCarteAttive';
            apiRest1.Test_Response__c = '';
            apiRest1.Method__c = 'POST'; 
            apiRest1.Mock__c = false; 
            apiRest1.Password__c = 'P00FLSDC';
            apiRest1.Ref__c = 'CompassInternal'; 
            apiRest1.User__c = 'CDSLF00';
            
            update apiRest1;
            
            List<String> responses = new List<String>();
            responses.add('{"resultCode":2000,"resultMessage":"Errore: java.lang.Exception","recuperaSaldiRossiOngoingResponse":null}');
            serviceIdResponseMap.put('recuperaSaldiRossiCarteAttive', responses);
            
            Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
            test.startTest();      
            SaldiRossiCarteAttive saldiRossiCarteAttive = new SaldiRossiCarteAttive();
            saldiRossiCarteAttive.execute(null);
            test.stopTest();  
        } catch (Exception e) {
            e.getMessage();
        }
        
    }

    
}