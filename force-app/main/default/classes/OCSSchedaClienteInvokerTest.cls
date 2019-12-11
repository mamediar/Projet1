@isTest
public class OCSSchedaClienteInvokerTest {

    @TestSetup
    static void setup(){   
        if(([SELECT Id FROM User WHERE Username = 'test@compass.com.test']).size()==0){
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User utenteAdmin = new User(
                FirstName= 'Test',
                LastName= 'Test',
                Username= 'test@compass.com.test',
                Email= 'test@lynxspa.com',
                Alias= 'test',
                TimeZoneSidKey= 'Europe/Rome',
                LocaleSidKey= 'it_IT',
                EmailEncodingKey= 'ISO-8859-1',
                ProfileId= p.Id,
                LanguageLocaleKey= 'en_US'
            );
            insert utenteAdmin;
        }
    }
    
    @isTest
    static void test() {
        User u = [SELECT Id FROM User WHERE LastName = 'Test']; 
        
        String response = '{"resultCode":0,"resultMessage":"Ok","pratiche":[{"numPratica":"4239596","codCliente":"8180824247","abi":"2008","cab":"23599","numConto":"000003188903"}],"cliente":[{"cognome":"FAIGLLO","codCliente":"8180824247","nome":"LUSSORIO"}]}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.schedaCliente',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test1;
        OCSSchedaClienteResponse dati;
        Test.startTest();
		System.runAs(u) {
            UtilityMockResponse UMR = new UtilityMockResponse();
            UMR.apiname='ocs.schedaCliente';
            Test.setMock(HttpCalloutMock.class,UMR);
            OCSSchedaClienteResponse myResponse = OCSSchedaClienteInvoker.callGetSchedaCliente('8180824247');
            dati = myResponse; 
        }
		Test.stopTest();

        OCSSchedaClienteResponse.PSVDatiPraticaDTO praticheList= new OCSSchedaClienteResponse.PSVDatiPraticaDTO();
        System.assertEquals(1,dati.pratiche.size());
        System.assertEquals('4239596',dati.pratiche[0].numPratica);
        System.assertEquals('8180824247',dati.pratiche[0].codCliente);
        System.assertEquals('2008',dati.pratiche[0].abi);
        System.assertEquals('23599',dati.pratiche[0].cab);
        System.assertEquals('000003188903',dati.pratiche[0].numConto);
        System.assertEquals(null,dati.pratiche[0].iban);
        System.assertEquals(null,dati.pratiche[0].statoPratica);
        System.assertEquals(null,dati.pratiche[0].tipoPagamento);
        System.assertEquals(null,dati.pratiche[0].prodotto);
        System.assertEquals(null,dati.pratiche[0].filiale);
        System.assertEquals(null,dati.pratiche[0].dataEstinzione);
        System.assertEquals(null,dati.pratiche[0].tipoPratica);
        System.assertEquals(null,dati.pratiche[0].dataCaricamento);
        System.assertEquals(null,dati.pratiche[0].pan);
        System.assertEquals(null,dati.pratiche[0].convenzionato);
        System.assertEquals(null,dati.pratiche[0].puntoVendita);
        System.assertEquals(null,dati.pratiche[0].venditore);
        System.assertEquals(null,dati.pratiche[0].agente);
        System.assertEquals(null,dati.pratiche[0].subAgente);
        System.assertEquals(null,dati.pratiche[0].flagRecupero);
        System.assertEquals(null,dati.pratiche[0].classifRecupero);
        System.assertEquals(null,dati.pratiche[0].societa);
        OCSSchedaClienteResponse.PSVDatiClienteDTO coobbligato= new OCSSchedaClienteResponse.PSVDatiClienteDTO();
        dati.pratiche[0].elencoCoobbligati= new List<OCSSchedaClienteResponse.PSVDatiClienteDTO>{coobbligato};
        System.assertEquals(1,dati.pratiche[0].elencoCoobbligati.size());
        System.assertEquals(null,dati.pratiche[0].codStatoPratica);
        System.assertEquals(null,dati.pratiche[0].codAttributoPratica);
        System.assertEquals(null,dati.pratiche[0].desStatoPratica);
        System.assertEquals(null,dati.pratiche[0].desAttributoPratica);
        System.assertEquals(null,dati.pratiche[0].codRecuperatore);
        System.assertEquals(null,dati.pratiche[0].desRecuperatore);
        System.assertEquals(null,dati.pratiche[0].canale);
        System.assertEquals('FAIGLLO',dati.cliente[0].cognome);
        System.assertEquals('8180824247',dati.cliente[0].codCliente);
        System.assertEquals('LUSSORIO',dati.cliente[0].nome);
        System.assertEquals(null,dati.cliente[0].dataNascita);
        System.assertEquals(null,dati.cliente[0].luogoNascita);
        System.assertEquals(null,dati.cliente[0].provNascita);
        System.assertEquals(null,dati.cliente[0].sesso);
        System.assertEquals(null,dati.cliente[0].codFiscale);
        System.assertEquals(null,dati.cliente[0].piva);
        System.assertEquals(null,dati.cliente[0].indirizzo);
        System.assertEquals(null,dati.cliente[0].cap);
        System.assertEquals(null,dati.cliente[0].localita);
        System.assertEquals(null,dati.cliente[0].provincia);
        System.assertEquals(null,dati.cliente[0].paeseEstero);
        System.assertEquals(null,dati.cliente[0].email);
        System.assertEquals(null,dati.cliente[0].tipoDocumento);
        System.assertEquals(null,dati.cliente[0].numDocumento);
        System.assertEquals(null,dati.cliente[0].ufficioRilascio);
        System.assertEquals(null,dati.cliente[0].luogoRilascio);
        System.assertEquals(null,dati.cliente[0].provRilascio);
        System.assertEquals(null,dati.cliente[0].dataRilascio);
        System.assertEquals(null,dati.cliente[0].denominazioneAzienda);
        System.assertEquals(null,dati.cliente[0].formaGiuridica);
        System.assertEquals(null,dati.cliente[0].tipoAnagrafica);
        System.assertEquals(null,dati.cliente[0].dataScadenza);
        System.assertEquals(null,dati.cliente[0].telefonoCasa);
        System.assertEquals(null,dati.cliente[0].telCellulare);
        System.assertEquals(null,dati.cliente[0].telAlternativo);
        System.assertEquals(null,dati.cliente[0].telFax);
        System.assertEquals(null,dati.cliente[0].tipoRapporto);
        System.assertEquals(null,dati.cliente[0].dataDepennamento);
        System.assertEquals(null,dati.cliente[0].indirizzoDomicilio);
        System.assertEquals(null,dati.cliente[0].capDomicilio);
        System.assertEquals(null,dati.cliente[0].localitaDomicilio);
        System.assertEquals(null,dati.cliente[0].provinciaDomicilio);
        System.assertEquals(null,dati.cliente[0].flagIstruttoriPratiche);
        System.assertEquals(null,dati.cliente[0].flagRilevaQualit);
        System.assertEquals(null,dati.cliente[0].flagOffCommInt);
        System.assertEquals(null,dati.cliente[0].flagOffCommIntAut);
        System.assertEquals(null,dati.cliente[0].flagOffCommEst);
        System.assertEquals(null,dati.cliente[0].flagOffCommEstAut);
        System.assertEquals(null,dati.cliente[0].flagAcServiziAltri);
        System.assertEquals(null,dati.cliente[0].flagDatiSensibili);
        System.assertEquals(null,dati.cliente[0].flagInformativaSic);
    }

    @isTest
    static void withParamsTest() {
        User u = [SELECT Id FROM User WHERE LastName = 'Test']; 
        
        String response = '{"resultCode":0,"resultMessage":"Ok","pratiche":[{"numPratica":"4239596","codCliente":"8180824247","abi":"2008","cab":"23599","numConto":"000003188903"}],"cliente":[{"cognome":"FAIGLLO","codCliente":"8180824247","nome":"LUSSORIO"}]}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.schedaCliente',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
        insert test1;
        OCSSchedaClienteResponse dati;
        Test.startTest();
		System.runAs(u){
            UtilityMockResponse UMR = new UtilityMockResponse();
            UMR.apiname='ocs.schedaCliente';
            Test.setMock(HttpCalloutMock.class,UMR);
            OCSSchedaClienteResponse myResponse = OCSSchedaClienteInvoker.callGetSchedaCliente('8180824247','4239596','','','FAIGLLO','LUSSORIO','','','','','','','','');
            dati = myResponse; 
        }
    }

    


}