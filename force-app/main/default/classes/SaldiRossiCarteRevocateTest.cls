@IsTest(SeeAllData=true)
public class SaldiRossiCarteRevocateTest {
    
    @isTest
    public static void ocsRecuperaSaldiRossiCarteRevocateTest() {
        
        try {
            Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
            
            ApiRest__c apiRest1 = [Select id, name, EndPoint__c, Test_Response__c, Method__c, Mock__c, Password__c, Ref__c, User__c from ApiRest__c where name = 'ocs.recuperaSaldiRossiCarteRevocate'];
            apiRest1.EndPoint__c = 'ocs.recuperaSaldiRossiCarteRevocate';
            apiRest1.Test_Response__c = '';
            apiRest1.Method__c = 'POST'; 
            apiRest1.Mock__c = false; 
            apiRest1.Password__c = 'P00FLSDC';
            apiRest1.Ref__c = 'CompassInternal'; 
            apiRest1.User__c = 'CDSLF00';
            
            update apiRest1;
            
            List<String> responses = new List<String>();
            responses.add('{"resultCode":0,"resultMessage":"Ok","recuperaSaldiRossiResponse":{"elencoSaldiRossi":[{"importoSaldo":"501.00","dataRevocaCarta":"20190404","codCliente":"887667","cognome":"NNAA","nome":"CALOGERO FILIPPO","dataNascita":"19410315","luogoNascita":"CERCOLA","provNascita":"NA","sesso":"M","codFiscale":"NNACGR41C15C495A","indirizzo":"VIA ROMA 1","cap":"80040","localita":"MASSA DI SOMMA","provincia":"NA","email":"","denominazioneAzienda":"NNAA CALOGERO FILIPPO","telefonoCasa":"081 5301901","telCellulare":"320 5310976","numPratica":"1100778736","abi":"0","cab":"0","numConto":"","iban":"","tipoPagamento":"BP","filiale":"200","tipoPratica":"CA"},{"importoSaldo":"27.50","dataRevocaCarta":"20190415","codCliente":"1556930","cognome":"CARRIZS","nome":"LINKAN","dataNascita":"19410111","luogoNascita":"SANTA MARIA A VICO","provNascita":"CE","sesso":"M","codFiscale":"CRRLKN41A11I233N","indirizzo":"VIA VERDI 19","cap":"81028","localita":"SANTA MARIA A VICO","provincia":"CE","email":"","denominazioneAzienda":"CARRIZS LINKAN","telefonoCasa":"0823 778933","telCellulare":"","numPratica":"1100817286","abi":"0","cab":"0","numConto":"","iban":"","tipoPagamento":"BP","filiale":"200","tipoPratica":"CA"},{"importoSaldo":"2.50","dataRevocaCarta":"20160523","codCliente":"1950697","cognome":"CAOCRA","nome":"PERLA","dataNascita":"19340221","luogoNascita":"BELLINZAGO NOVARESE","provNascita":"NO","sesso":"F","codFiscale":"CCRPRL34B61A752P","indirizzo":"VIA VERDI 1","cap":"28043","localita":"BELLINZAGO NOVARESE","provincia":"NO","email":"","denominazioneAzienda":"CAOCRA PERLA","telefonoCasa":"0321 983169","telCellulare":"333 4813614","numPratica":"1101023686","abi":"3204","cab":"45170","numConto":"000000006525","iban":"IT60J0320445170000000006525","tipoPagamento":"RI","filiale":"200","tipoPratica":"CA"},{"importoSaldo":"-4861.18","dataRevocaCarta":"20190405","codCliente":"2057202","cognome":"GEINACCI","nome":"VITANGELO","dataNascita":"19350420","luogoNascita":"BRESCIA","provNascita":"BS","sesso":"M","codFiscale":"GNCVNG35D20B157V","indirizzo":"VIA INDIPENDENZA 5","cap":"25135","localita":"BRESCIA","provincia":"BS","email":"GEINACCI.VITANGELO@provider.com","denominazioneAzienda":"GEINACCI VITANGELO","telefonoCasa":"030 329956","telCellulare":"349 5870388","numPratica":"1101566072","abi":"3440","cab":"11200","numConto":"000000169900","iban":"IT24K0344011200000000169900","tipoPagamento":"RI","filiale":"200","tipoPratica":"CA"},{"importoSaldo":"15.42","dataRevocaCarta":"20190404","codCliente":"13313875","cognome":"MUAUSESI","nome":"KOSWATTA MUHANDIRAMG","dataNascita":"19770421","luogoNascita":"L\'AQUILA","provNascita":"AQ","sesso":"F","codFiscale":"MSSKWT77D61A345E","indirizzo":"VIA VERDI 1","cap":"67100","localita":"L\'AQUILA","provincia":"AQ","email":"","denominazioneAzienda":"MUAUSESI KOSWATTA MUHANDIRAMG","telefonoCasa":"","telCellulare":"329 3610817","numPratica":"3192049875","abi":"7601","cab":"3600","numConto":"000057363863","iban":"IT74B0760103600000057363863","tipoPagamento":"BP","filiale":"314","tipoPratica":"CA"},{"importoSaldo":"24.67","dataRevocaCarta":"20190418","codCliente":"12156190","cognome":"VRIANA","nome":"STURNINO","dataNascita":"19420527","luogoNascita":"ALTAVILLA MILICIA","provNascita":"PA","sesso":"M","codFiscale":"VRNSRN42E27A229X","indirizzo":"VIA ROMA 7","cap":"90010","localita":"ALTAVILLA MILICIA","provincia":"PA","email":"","denominazioneAzienda":"VRIANA STURNINO","telefonoCasa":"","telCellulare":"348 3286105","numPratica":"3192201120","abi":"7601","cab":"4600","numConto":"000040373557","iban":"IT36S0760104600000040373557","tipoPagamento":"RI","filiale":"158","tipoPratica":"CA"},{"importoSaldo":"15.42","dataRevocaCarta":"20190413","codCliente":"12822414","cognome":"LEUSIBGNI","nome":"BARIZA","dataNascita":"19720413","luogoNascita":"CAGLIARI","provNascita":"CA","sesso":"F","codFiscale":"LSBBRZ72D53B354M","indirizzo":"VIA VERDI 19","cap":"09126","localita":"CAGLIARI","provincia":"CA","email":"LEUSIBGNI.BARIZA@provider.com","denominazioneAzienda":"LEUSIBGNI BARIZA","telefonoCasa":"","telCellulare":"328 9121458","numPratica":"3192202078","abi":"7601","cab":"4800","numConto":"000062769666","iban":"IT66B0760104800000062769666","tipoPagamento":"RI","filiale":"77","tipoPratica":"CA"},{"importoSaldo":"12.33","dataRevocaCarta":"20190417","codCliente":"4637695","cognome":"VAAPNI","nome":"ENRICHETTA FEDORA","dataNascita":"19311201","luogoNascita":"RADDUSA","provNascita":"CT","sesso":"F","codFiscale":"VPNNCH31T41H154N","indirizzo":"VIA VERDI 52","cap":"45030","localita":"OCCHIOBELLO","provincia":"RO","email":"","denominazioneAzienda":"VAAPNI ENRICHETTA FEDORA","telefonoCasa":"0425 728005","telCellulare":"393 9296421","numPratica":"3192355827","abi":"7601","cab":"12200","numConto":"000069370724","iban":"IT49L0760112200000069370724","tipoPagamento":"RI","filiale":"160","tipoPratica":"CA"},{"importoSaldo":"25.90","dataRevocaCarta":"20190406","codCliente":"12684024","cognome":"DIOINEALT","nome":"RAFFAELINA","dataNascita":"19430322","luogoNascita":"TORINO","provNascita":"TO","sesso":"F","codFiscale":"DNLRFL43C62L219B","indirizzo":"VIA INDIPENDENZA 9","cap":"00185","localita":"ROMA","provincia":"RM","email":"DIOINEALT.RAFFAELINA@provider.com","denominazioneAzienda":"DIOINEALT RAFFAELINA","telefonoCasa":"06 4012591","telCellulare":"348 7921672","numPratica":"3192572405","abi":"7601","cab":"3200","numConto":"000023348774","iban":"IT23X0760103200000023348774","tipoPagamento":"RI","filiale":"72","tipoPratica":"CA"}]}}');
            serviceIdResponseMap.put('recuperaSaldiRossi', responses);
            
            ApiRest__c apiRest2 = [Select id, name, EndPoint__c, Test_Response__c, Method__c, Mock__c, Password__c, Ref__c, User__c from ApiRest__c where name = 'ocs.sbloccaSaldiRossi'];
            apiRest2.EndPoint__c = 'ocs.sbloccaSaldiRossi';
            apiRest2.Test_Response__c = '';
            apiRest2.Method__c = 'POST'; 
            apiRest2.Mock__c = false; 
            apiRest2.Password__c = 'P00FLSDC';
            apiRest2.Ref__c = 'CompassInternal'; 
            apiRest2.User__c = 'CDSLF00';
            
            update apiRest2;
            
            List<String> responses2 = new List<String>();
            responses2.add('{"resultCode":0,"resultMessage":"Ok","sbloccaSaldiRossiResponse":{"ultimaPraticaElaborata":null,"ultimaDataRevocaCarta":null}}');
            serviceIdResponseMap.put('sbloccaSaldiRossi', responses2);
            
            Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
            test.startTest();  
            
            SaldiRossiCarteRevocate saldiRossiCarteRevocate = new SaldiRossiCarteRevocate();
            saldiRossiCarteRevocate.execute(null);
            
            test.stopTest();
            
        } catch (Exception e) {
            e.getMessage(); 
        }
    }
    
    @IsTest
    public static void ocsNoResults() {
        
        try {
            Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
            
            ApiRest__c apiRest1 = [Select id, name, EndPoint__c, Test_Response__c, Method__c, Mock__c, Password__c, Ref__c, User__c from ApiRest__c where name = 'ocs.recuperaSaldiRossiCarteRevocate'];
            
            apiRest1.EndPoint__c = 'ocs.recuperaSaldiRossiCarteRevocate';
            apiRest1.Test_Response__c = '';
            apiRest1.Method__c = 'POST'; 
            apiRest1.Mock__c = false; 
            apiRest1.Password__c = 'P00FLSDC';
            apiRest1.Ref__c = 'CompassInternal'; 
            apiRest1.User__c = 'CDSLF00';
            
            update apiRest1;
            
            List<String> responses = new List<String>();
            responses.add('{"resultCode":0,"resultMessage":"Ok","recuperaSaldiRossiResponse":{"elencoSaldiRossi": null}}');
            serviceIdResponseMap.put('recuperaSaldiRossi', responses);
            
            Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
            test.startTest();      
            SaldiRossiCarteRevocate saldiRossiCarteRevocate = new SaldiRossiCarteRevocate();
            saldiRossiCarteRevocate.execute(null);
            test.stopTest();
            
        } catch (Exception e) {
            e.getMessage();
        }
        
    }
    
    @IsTest
    public static void ocsError() {
        
        try {
            Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
            
            ApiRest__c apiRest1 = [Select id, name, EndPoint__c, Test_Response__c, Method__c, Mock__c, Password__c, Ref__c, User__c from ApiRest__c where name = 'ocs.recuperaSaldiRossiCarteRevocate'];
            
            apiRest1.EndPoint__c = 'ocs.recuperaSaldiRossiCarteRevocate';
            apiRest1.Test_Response__c = '';
            apiRest1.Method__c = 'POST'; 
            apiRest1.Mock__c = false; 
            apiRest1.Password__c = 'P00FLSDC';
            apiRest1.Ref__c = 'CompassInternal'; 
            apiRest1.User__c = 'CDSLF00';
            
            update apiRest1;
            
            List<String> responses = new List<String>();
            responses.add('{"resultCode":2000,"resultMessage":"Errore: java.lang.Exception","recuperaSaldiRossiResponse":null}');
            serviceIdResponseMap.put('recuperaSaldiRossi', responses);
            
            Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
            test.startTest();      
            SaldiRossiCarteRevocate saldiRossiCarteRevocate = new SaldiRossiCarteRevocate();
            saldiRossiCarteRevocate.execute(null);
            test.stopTest();  
        } catch (Exception e) {
            e.getMessage();
        }
        
    }
    
}