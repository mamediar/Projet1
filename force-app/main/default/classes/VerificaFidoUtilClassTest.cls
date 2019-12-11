/**
 * @File Name          : VerificaFidoUtilClassTest.cls
 * @Description        : 
 * @Author             : Lorenzo Marzocchi
 * @Group              : 
 * @Last Modified By   : Lorenzo Marzocchi
 * @Last Modified On   : 2019-9-3 11:42:46
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    2019-9-3   Lorenzo Marzocchi     Initial Version
**/
@isTest
public class VerificaFidoUtilClassTest {
	@TestSetup
    static void setup(){   
        if(([SELECT Id FROM User WHERE DefaultQueueId__c = 'F00-TEST']).size()==0){
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User utenteMaster = new User(
                FirstName= 'Test',
                LastName= 'Test',
                Username= 'test@compass.com.test',
                Email= 'test@lynxspa.com',
                Alias= 'test',
                TimeZoneSidKey= 'Europe/Rome',
                LocaleSidKey= 'it_IT',
                EmailEncodingKey= 'ISO-8859-1',
                ProfileId= p.Id,
                LanguageLocaleKey= 'en_US',
                DefaultQueueId__c= 'F00-TEST'
            );
            insert utenteMaster;
        }
        if(([SELECT Id FROM Fido_Risk__c]).size()==0){
            Fido_Risk__c fidoR = new Fido_Risk__c(
                Outcome__c = 'OK',
                OCS_Code__c = '800000329783'
            );
            Fido_Risk__c fidoRko = new Fido_Risk__c(
                Outcome__c = 'KO',
                OCS_Code__c = '800000329784',
                Reason__c = 'itsatest'
            );
            insert new List<Fido_Risk__c> {fidoR,fidoRko};
        }

    }
/*	
    @isTest
	static void VerifyAumentoFidoTest(){
		User u = [SELECT Id FROM User WHERE LastName = 'Test'];
		OCSSchedaClienteResponse.PSVDatiPraticaDTO pratica=new OCSSchedaClienteResponse.PSVDatiPraticaDTO();
		pratica.numPratica='800000329783';
		pratica.codCliente='000';
        //OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numPratica)
        String response2 = '{"resultCode":0,"resultMessage":"Ok","datiCartaDatiFinanziariResponse":{"numeroPratica":"800000329783","filiale":"","emettitore":"1","dispTotale":"500000", "fidoTotale":"0","as400Status":"OK"}}';
		//OCSRecuperaDelinquencyInvoker.callGetDelinquency(codCliente)
        String response3 = '{"resultCode":0,"resultMessage":"Ok","recuperaDelinquencyResponse":{"currentDelinquencyCliente":"0","maxDelinquencyCliente":"0","elencoPratiche":[{"tipoPratica":"CA","numPratica":"800000329783","currentDelinquency":"0","maxDelinquency":"0"}]}}';
        //OCSRecuperaFasciaTassoCrifInvoker.callGetFasciaTassoCrif(codCliente)
		String response4 = '{"resultCode":0,"resultMessage":"Ok","recuperaFasciaTassoCrifResponse":{"codFasciaTasso":"P","as400Errore":"","as400Status":"OK"}}';
        //OCSRecuperaSaldoClienteInvoker.callGetSaldoCliente(codCliente)
		String response5 = '{"resultCode":0,"resultMessage":"Ok","recuperaSaldoClienteResponse":{"elencoPratiche":[{"numPratica":"800000329783","tipoPratica":"CA","saldo":"50000","stato":"70","attributo":"XZ","scaduto":"1","finanziato":"500000"}]}}';

		ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.cartaDatiFinanziari',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/cartaDatiFinanziari');
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response3 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDelinquency',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaDelinquency');
        ApiRest__c test3 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response4 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaFasciaTassoCrif',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaFasciaTassoCrif');
        ApiRest__c test4 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response5 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaSaldoCliente',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaSaldoCliente');
        insert new List<ApiRest__c>{test1,test2,test3,test4};
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.cartaDatiFinanziari','ocs.recuperaDelinquency','ocs.recuperaFasciaTassoCrif','ocs.recuperaSaldoCliente'});
        Test.setMock(HttpCalloutMock.class,UMR);
        
        Test.startTest();
		System.runAs(u) {
            VerificaFidoUtilClass.CheckFidoWrapper Wr= VerificaFidoUtilClass.VerifyAumentoFido(pratica);
            System.assertEquals(5000, Wr.disponibilita);
          //  System.assertEquals('Aumento fido OK', Wr.messaggioErroreShort);
        }
        Test.stopTest();

	}

    @isTest
	static void VerifyAumentoFidoNoStep1Test(){
		User u = [SELECT Id FROM User WHERE LastName = 'Test'];
		OCSSchedaClienteResponse.PSVDatiPraticaDTO pratica=new OCSSchedaClienteResponse.PSVDatiPraticaDTO();
		pratica.numPratica='800000329783';
		pratica.codCliente='000';
        //OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numPratica)
        String response2 = '{"resultCode":0,"resultMessage":"Ok","datiCartaDatiFinanziariResponse":{"numeroPratica":"800000329783","filiale":"","emettitore":"117","dispTotale":"500000", "fidoTotale":"0","as400Status":"OK"}}';
		//OCSRecuperaDelinquencyInvoker.callGetDelinquency(codCliente)
        String response3 = '{"resultCode":0,"resultMessage":"Ok","recuperaDelinquencyResponse":{"currentDelinquencyCliente":"0","maxDelinquencyCliente":"0","elencoPratiche":[{"tipoPratica":"CA","numPratica":"800000329783","currentDelinquency":"0","maxDelinquency":"0"}]}}';
        //OCSRecuperaFasciaTassoCrifInvoker.callGetFasciaTassoCrif(codCliente)
		String response4 = '{"resultCode":0,"resultMessage":"Ok","recuperaFasciaTassoCrifResponse":{"codFasciaTasso":"P","as400Errore":"","as400Status":"OK"}}';
        //OCSRecuperaSaldoClienteInvoker.callGetSaldoCliente(codCliente)
		String response5 = '{"resultCode":0,"resultMessage":"Ok","recuperaSaldoClienteResponse":{"elencoPratiche":[{"numPratica":"800000329783","tipoPratica":"CA","saldo":"50000","stato":"70","attributo":"XZ","scaduto":"1","finanziato":"500000"}]}}';

		ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.cartaDatiFinanziari',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/cartaDatiFinanziari');
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response3 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDelinquency',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaDelinquency');
        ApiRest__c test3 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response4 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaFasciaTassoCrif',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaFasciaTassoCrif');
        ApiRest__c test4 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response5 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaSaldoCliente',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaSaldoCliente');
        insert new List<ApiRest__c>{test1,test2,test3,test4};
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.cartaDatiFinanziari','ocs.recuperaDelinquency','ocs.recuperaFasciaTassoCrif','ocs.recuperaSaldoCliente'});
        Test.setMock(HttpCalloutMock.class,UMR);
        
        Test.startTest();
		System.runAs(u) {
            VerificaFidoUtilClass.CheckFidoWrapper Wr= VerificaFidoUtilClass.VerifyAumentoFido(pratica);
            System.assertEquals(5000, Wr.disponibilita);
           // System.assertEquals('Aumento fido KO Emettitore non valido', Wr.messaggioErroreShort);
        }
        Test.stopTest();

	}

    @isTest
	static void VerifyAumentoFidoNoStep2Test(){
		User u = [SELECT Id FROM User WHERE LastName = 'Test'];
		OCSSchedaClienteResponse.PSVDatiPraticaDTO pratica=new OCSSchedaClienteResponse.PSVDatiPraticaDTO();
		pratica.numPratica='800000329783';
		pratica.codCliente='000';
        //OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numPratica)
        String response2 = '{"resultCode":0,"resultMessage":"Ok","datiCartaDatiFinanziariResponse":{"numeroPratica":"800000329783","filiale":"","emettitore":"3300","dispTotale":"500000", "fidoTotale":"0","as400Status":"OK"}}';
		//OCSRecuperaDelinquencyInvoker.callGetDelinquency(codCliente)
        String response3 = '{"resultCode":0,"resultMessage":"Ok","recuperaDelinquencyResponse":{"currentDelinquencyCliente":"0","maxDelinquencyCliente":"0","elencoPratiche":[{"tipoPratica":"CA","numPratica":"800000329783","currentDelinquency":"0","maxDelinquency":"0"}]}}';
        //OCSRecuperaFasciaTassoCrifInvoker.callGetFasciaTassoCrif(codCliente)
		String response4 = '{"resultCode":0,"resultMessage":"Ok","recuperaFasciaTassoCrifResponse":{"codFasciaTasso":"P","as400Errore":"","as400Status":"OK"}}';
        //OCSRecuperaSaldoClienteInvoker.callGetSaldoCliente(codCliente)
		String response5 = '{"resultCode":0,"resultMessage":"Ok","recuperaSaldoClienteResponse":{"elencoPratiche":[{"numPratica":"800000329783","tipoPratica":"CA","saldo":"50000","stato":"70","attributo":"XZ","scaduto":"1","finanziato":"500000"}]}}';

		ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.cartaDatiFinanziari',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/cartaDatiFinanziari');
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response3 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDelinquency',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaDelinquency');
        ApiRest__c test3 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response4 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaFasciaTassoCrif',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaFasciaTassoCrif');
        ApiRest__c test4 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response5 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaSaldoCliente',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaSaldoCliente');
        insert new List<ApiRest__c>{test1,test2,test3,test4};
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.cartaDatiFinanziari','ocs.recuperaDelinquency','ocs.recuperaFasciaTassoCrif','ocs.recuperaSaldoCliente'});
        Test.setMock(HttpCalloutMock.class,UMR);
        
        Test.startTest();
		System.runAs(u) {
            VerificaFidoUtilClass.CheckFidoWrapper Wr= VerificaFidoUtilClass.VerifyAumentoFido(pratica);
            System.assertEquals(5000, Wr.disponibilita);
           // System.assertEquals('Emettitore non rilevato', Wr.messaggioErroreShort);
        }
        Test.stopTest();

	}

    @isTest
	static void VerifyAumentoFidoNoStep3Test(){
		User u = [SELECT Id FROM User WHERE LastName = 'Test'];
		OCSSchedaClienteResponse.PSVDatiPraticaDTO pratica=new OCSSchedaClienteResponse.PSVDatiPraticaDTO();
		pratica.numPratica='800000329783';
		pratica.codCliente='000';
        //OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numPratica)
        String response2 = '{"resultCode":0,"resultMessage":"Ok","datiCartaDatiFinanziariResponse":{"numeroPratica":"800000329783","filiale":"","emettitore":"1","dispTotale":"500000", "fidoTotale":"500000","as400Status":"OK"}}';
		//OCSRecuperaDelinquencyInvoker.callGetDelinquency(codCliente)
        String response3 = '{"resultCode":0,"resultMessage":"Ok","recuperaDelinquencyResponse":{"currentDelinquencyCliente":"0","maxDelinquencyCliente":"0","elencoPratiche":[{"tipoPratica":"CA","numPratica":"800000329783","currentDelinquency":"0","maxDelinquency":"0"}]}}';
        //OCSRecuperaFasciaTassoCrifInvoker.callGetFasciaTassoCrif(codCliente)
		String response4 = '{"resultCode":0,"resultMessage":"Ok","recuperaFasciaTassoCrifResponse":{"codFasciaTasso":"P","as400Errore":"","as400Status":"OK"}}';
        //OCSRecuperaSaldoClienteInvoker.callGetSaldoCliente(codCliente)
		String response5 = '{"resultCode":0,"resultMessage":"Ok","recuperaSaldoClienteResponse":{"elencoPratiche":[{"numPratica":"800000329783","tipoPratica":"CA","saldo":"50000","stato":"70","attributo":"XZ","scaduto":"1","finanziato":"500000"}]}}';

		ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.cartaDatiFinanziari',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/cartaDatiFinanziari');
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response3 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDelinquency',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaDelinquency');
        ApiRest__c test3 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response4 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaFasciaTassoCrif',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaFasciaTassoCrif');
        ApiRest__c test4 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response5 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaSaldoCliente',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaSaldoCliente');
        insert new List<ApiRest__c>{test1,test2,test3,test4};
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.cartaDatiFinanziari','ocs.recuperaDelinquency','ocs.recuperaFasciaTassoCrif','ocs.recuperaSaldoCliente'});
        Test.setMock(HttpCalloutMock.class,UMR);
        
        Test.startTest();
		System.runAs(u) {
            VerificaFidoUtilClass.CheckFidoWrapper Wr= VerificaFidoUtilClass.VerifyAumentoFido(pratica);
            System.assertEquals(5000, Wr.disponibilita);
            //System.assertEquals('Aumento fido KO Fido al massimo', Wr.messaggioErroreShort);
        }
        Test.stopTest();

	}

    @isTest
	static void VerifyAumentoFidoKo1Test(){
		User u = [SELECT Id FROM User WHERE LastName = 'Test'];
		OCSSchedaClienteResponse.PSVDatiPraticaDTO pratica=new OCSSchedaClienteResponse.PSVDatiPraticaDTO();
		pratica.numPratica='800000329784';
		pratica.codCliente='000';
        //OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numPratica)
        String response2 = '{"resultCode":0,"resultMessage":"Ok","datiCartaDatiFinanziariResponse":{"numeroPratica":"800000329784","filiale":"","emettitore":"1","dispTotale":"500000", "fidoTotale":"0","as400Status":"OK"}}';
		//OCSRecuperaDelinquencyInvoker.callGetDelinquency(codCliente)
        String response3 = '{"resultCode":0,"resultMessage":"Ok","recuperaDelinquencyResponse":{"currentDelinquencyCliente":"0","maxDelinquencyCliente":"0","elencoPratiche":[{"tipoPratica":"CA","numPratica":"800000329783","currentDelinquency":"0","maxDelinquency":"0"}]}}';
        //OCSRecuperaFasciaTassoCrifInvoker.callGetFasciaTassoCrif(codCliente)
		String response4 = '{"resultCode":0,"resultMessage":"Ok","recuperaFasciaTassoCrifResponse":{"codFasciaTasso":"P","as400Errore":"","as400Status":"OK"}}';
        //OCSRecuperaSaldoClienteInvoker.callGetSaldoCliente(codCliente)
		String response5 = '{"resultCode":0,"resultMessage":"Ok","recuperaSaldoClienteResponse":{"elencoPratiche":[{"numPratica":"800000329783","tipoPratica":"CA","saldo":"50000","stato":"70","attributo":"XZ","scaduto":"1","finanziato":"500000"}]}}';

		ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.cartaDatiFinanziari',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/cartaDatiFinanziari');
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response3 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDelinquency',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaDelinquency');
        ApiRest__c test3 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response4 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaFasciaTassoCrif',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaFasciaTassoCrif');
        ApiRest__c test4 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response5 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaSaldoCliente',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaSaldoCliente');
        insert new List<ApiRest__c>{test1,test2,test3,test4};
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.cartaDatiFinanziari','ocs.recuperaDelinquency','ocs.recuperaFasciaTassoCrif','ocs.recuperaSaldoCliente'});
        Test.setMock(HttpCalloutMock.class,UMR);
        
        Test.startTest();
		System.runAs(u) {
            VerificaFidoUtilClass.CheckFidoWrapper Wr= VerificaFidoUtilClass.VerifyAumentoFido(pratica);
            System.assertEquals(5000, Wr.disponibilita);
            //System.assertEquals('itsatest', Wr.messaggioErroreShort);
        }
        Test.stopTest();

	}

    @isTest
	static void VerifyAumentoFidoKo2Test(){
		User u = [SELECT Id FROM User WHERE LastName = 'Test'];
		OCSSchedaClienteResponse.PSVDatiPraticaDTO pratica=new OCSSchedaClienteResponse.PSVDatiPraticaDTO();
		pratica.numPratica='800000329784';
		pratica.codCliente='000';
        //OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numPratica)
        String response2 = '{"resultCode":0,"resultMessage":"Ok","datiCartaDatiFinanziariResponse":{"numeroPratica":"800000329785","filiale":"","emettitore":"1","dispTotale":"500000", "fidoTotale":"0","as400Status":"OK"}}';
		//OCSRecuperaDelinquencyInvoker.callGetDelinquency(codCliente)
        String response3 = '{"resultCode":0,"resultMessage":"Ok","recuperaDelinquencyResponse":{"currentDelinquencyCliente":"0","maxDelinquencyCliente":"0","elencoPratiche":[{"tipoPratica":"CA","numPratica":"800000329783","currentDelinquency":"0","maxDelinquency":"0"}]}}';
        //OCSRecuperaFasciaTassoCrifInvoker.callGetFasciaTassoCrif(codCliente)
		String response4 = '{"resultCode":0,"resultMessage":"Ok","recuperaFasciaTassoCrifResponse":{"codFasciaTasso":"P","as400Errore":"","as400Status":"OK"}}';
        //OCSRecuperaSaldoClienteInvoker.callGetSaldoCliente(codCliente)
		String response5 = '{"resultCode":0,"resultMessage":"Ok","recuperaSaldoClienteResponse":{"elencoPratiche":[{"numPratica":"800000329783","tipoPratica":"CA","saldo":"50000","stato":"70","attributo":"XZ","scaduto":"1","finanziato":"500000"}]}}';

		ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.cartaDatiFinanziari',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/cartaDatiFinanziari');
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response3 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDelinquency',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaDelinquency');
        ApiRest__c test3 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response4 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaFasciaTassoCrif',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaFasciaTassoCrif');
        ApiRest__c test4 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response5 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaSaldoCliente',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaSaldoCliente');
        insert new List<ApiRest__c>{test1,test2,test3,test4};
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.cartaDatiFinanziari','ocs.recuperaDelinquency','ocs.recuperaFasciaTassoCrif','ocs.recuperaSaldoCliente'});
        Test.setMock(HttpCalloutMock.class,UMR);
        
        Test.startTest();
		System.runAs(u) {
            VerificaFidoUtilClass.CheckFidoWrapper Wr= VerificaFidoUtilClass.VerifyAumentoFido(pratica);
            System.assertEquals(5000, Wr.disponibilita);
          //  System.assertEquals('Rischio', Wr.messaggioErroreShort);
        }
        Test.stopTest();

	}


    @isTest
	static void VerifyRejectionForScadutoParamTest(){
		User u = [SELECT Id FROM User WHERE LastName = 'Test'];
		OCSSchedaClienteResponse.PSVDatiPraticaDTO pratica=new OCSSchedaClienteResponse.PSVDatiPraticaDTO();
		pratica.numPratica='800000329783';
		pratica.codCliente='000';
        //OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numPratica)
        String response2 = '{"resultCode":0,"resultMessage":"Ok","datiCartaDatiFinanziariResponse":{"numeroPratica":"800000329783","filiale":"","emettitore":"1","dispTotale":"500000", "fidoTotale":"0","as400Status":"OK"}}';
		//OCSRecuperaDelinquencyInvoker.callGetDelinquency(codCliente)
        String response3 = '{"resultCode":0,"resultMessage":"Ok","recuperaDelinquencyResponse":{"currentDelinquencyCliente":"0","maxDelinquencyCliente":"0","elencoPratiche":[{"tipoPratica":"CA","numPratica":"800000329783","currentDelinquency":"0","maxDelinquency":"0"}]}}';
        //OCSRecuperaFasciaTassoCrifInvoker.callGetFasciaTassoCrif(codCliente)
		String response4 = '{"resultCode":0,"resultMessage":"Ok","recuperaFasciaTassoCrifResponse":{"codFasciaTasso":"P","as400Errore":"","as400Status":"OK"}}';
        //OCSRecuperaSaldoClienteInvoker.callGetSaldoCliente(codCliente)
		String response5 = '{"resultCode":0,"resultMessage":"Ok","recuperaSaldoClienteResponse":{"elencoPratiche":[{"numPratica":"800000329783","tipoPratica":"CA","saldo":"50000","stato":"70","attributo":"XZ","scaduto":"6","finanziato":"500000"}]}}';

		ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.cartaDatiFinanziari',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/cartaDatiFinanziari');
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response3 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDelinquency',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaDelinquency');
        ApiRest__c test3 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response4 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaFasciaTassoCrif',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaFasciaTassoCrif');
        ApiRest__c test4 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response5 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaSaldoCliente',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaSaldoCliente');
        insert new List<ApiRest__c>{test1,test2,test3,test4};
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.cartaDatiFinanziari','ocs.recuperaDelinquency','ocs.recuperaFasciaTassoCrif','ocs.recuperaSaldoCliente'});
        Test.setMock(HttpCalloutMock.class,UMR);
        
        Test.startTest();
		System.runAs(u) {
            VerificaFidoUtilClass.CheckFidoWrapper Wr= VerificaFidoUtilClass.VerifyAumentoFido(pratica);
            System.assertEquals(5000, Wr.disponibilita);
        //    System.assertEquals('Aumento fido KO Pratiche scadute presenti', Wr.messaggioErroreShort);
        }
        Test.stopTest();
	} 

    @isTest
	static void VerifyRejectionForDelinquencyParamTest(){
		User u = [SELECT Id FROM User WHERE LastName = 'Test'];
		OCSSchedaClienteResponse.PSVDatiPraticaDTO pratica=new OCSSchedaClienteResponse.PSVDatiPraticaDTO();
		pratica.numPratica='800000329783';
		pratica.codCliente='000';
        //OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numPratica)
        String response2 = '{"resultCode":0,"resultMessage":"Ok","datiCartaDatiFinanziariResponse":{"numeroPratica":"800000329783","filiale":"","emettitore":"1","dispTotale":"500000", "fidoTotale":"0","as400Status":"OK"}}';
		//OCSRecuperaDelinquencyInvoker.callGetDelinquency(codCliente)
        String response3 = '{"resultCode":0,"resultMessage":"Ok","recuperaDelinquencyResponse":{"currentDelinquencyCliente":"2","maxDelinquencyCliente":"2","elencoPratiche":[{"tipoPratica":"CA","numPratica":"800000329783","currentDelinquency":"2","maxDelinquency":"2"}]}}';
        //OCSRecuperaFasciaTassoCrifInvoker.callGetFasciaTassoCrif(codCliente)
		String response4 = '{"resultCode":0,"resultMessage":"Ok","recuperaFasciaTassoCrifResponse":{"codFasciaTasso":"P","as400Errore":"","as400Status":"OK"}}';
        //OCSRecuperaSaldoClienteInvoker.callGetSaldoCliente(codCliente)
		String response5 = '{"resultCode":0,"resultMessage":"Ok","recuperaSaldoClienteResponse":{"elencoPratiche":[{"numPratica":"800000329783","tipoPratica":"CA","saldo":"50000","stato":"70","attributo":"XZ","scaduto":"1","finanziato":"500000"}]}}';

		ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.cartaDatiFinanziari',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/cartaDatiFinanziari');
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response3 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDelinquency',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaDelinquency');
        ApiRest__c test3 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response4 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaFasciaTassoCrif',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaFasciaTassoCrif');
        ApiRest__c test4 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response5 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaSaldoCliente',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaSaldoCliente');
        insert new List<ApiRest__c>{test1,test2,test3,test4};
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.cartaDatiFinanziari','ocs.recuperaDelinquency','ocs.recuperaFasciaTassoCrif','ocs.recuperaSaldoCliente'});
        Test.setMock(HttpCalloutMock.class,UMR);
        
        Test.startTest();
		System.runAs(u) {
            VerificaFidoUtilClass.CheckFidoWrapper Wr= VerificaFidoUtilClass.VerifyAumentoFido(pratica);
            System.assertEquals(5000, Wr.disponibilita);
        //    System.assertEquals('Aumento fido KO Delinquency presenti', Wr.messaggioErroreShort);
        }
        Test.stopTest();
	} 

    @isTest
	static void VerifyRejectionForTassoCRIFParamTest(){
		User u = [SELECT Id FROM User WHERE LastName = 'Test'];
		OCSSchedaClienteResponse.PSVDatiPraticaDTO pratica=new OCSSchedaClienteResponse.PSVDatiPraticaDTO();
		pratica.numPratica='800000329783';
		pratica.codCliente='000';
        //OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numPratica)
        String response2 = '{"resultCode":0,"resultMessage":"Ok","datiCartaDatiFinanziariResponse":{"numeroPratica":"800000329783","filiale":"","emettitore":"1","dispTotale":"500000", "fidoTotale":"0","as400Status":"OK"}}';
		//OCSRecuperaDelinquencyInvoker.callGetDelinquency(codCliente)
        String response3 = '{"resultCode":0,"resultMessage":"Ok","recuperaDelinquencyResponse":{"currentDelinquencyCliente":"0","maxDelinquencyCliente":"0","elencoPratiche":[{"tipoPratica":"CA","numPratica":"800000329783","currentDelinquency":"0","maxDelinquency":"0"}]}}';
        //OCSRecuperaFasciaTassoCrifInvoker.callGetFasciaTassoCrif(codCliente)
		String response4 = '{"resultCode":0,"resultMessage":"Ok","recuperaFasciaTassoCrifResponse":{"codFasciaTasso":"A","as400Errore":"","as400Status":"OK"}}';
        //OCSRecuperaSaldoClienteInvoker.callGetSaldoCliente(codCliente)
		String response5 = '{"resultCode":0,"resultMessage":"Ok","recuperaSaldoClienteResponse":{"elencoPratiche":[{"numPratica":"800000329783","tipoPratica":"CA","saldo":"50000","stato":"70","attributo":"XZ","scaduto":"1","finanziato":"500000"}]}}';

		ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.cartaDatiFinanziari',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/cartaDatiFinanziari');
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response3 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDelinquency',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaDelinquency');
        ApiRest__c test3 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response4 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaFasciaTassoCrif',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaFasciaTassoCrif');
        ApiRest__c test4 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response5 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaSaldoCliente',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaSaldoCliente');
        insert new List<ApiRest__c>{test1,test2,test3,test4};
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.cartaDatiFinanziari','ocs.recuperaDelinquency','ocs.recuperaFasciaTassoCrif','ocs.recuperaSaldoCliente'});
        Test.setMock(HttpCalloutMock.class,UMR);
        
        Test.startTest();
		System.runAs(u) {
            VerificaFidoUtilClass.CheckFidoWrapper Wr= VerificaFidoUtilClass.VerifyAumentoFido(pratica);
            System.assertEquals(5000, Wr.disponibilita);
           // System.assertEquals('Aumento fido KO Fascia CRIF insoddisfacente', Wr.messaggioErroreShort);
        }
        Test.stopTest();
	} 

    @isTest
	static void VerifyRejectionForBloccoTest(){
		User u = [SELECT Id FROM User WHERE LastName = 'Test'];
		OCSSchedaClienteResponse.PSVDatiPraticaDTO pratica=new OCSSchedaClienteResponse.PSVDatiPraticaDTO();
		pratica.numPratica='800000329783';
		pratica.codCliente='000';
        //OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numPratica)
        String response2 = '{"resultCode":0,"resultMessage":"Ok","datiCartaDatiFinanziariResponse":{"numeroPratica":"800000329783","filiale":"","emettitore":"1","dispTotale":"500000", "blocco":"XX","as400Status":"OK"}}';
		//OCSRecuperaDelinquencyInvoker.callGetDelinquency(codCliente)
        String response3 = '{"resultCode":0,"resultMessage":"Ok","recuperaDelinquencyResponse":{"currentDelinquencyCliente":"0","maxDelinquencyCliente":"0","elencoPratiche":[{"tipoPratica":"CA","numPratica":"800000329783","currentDelinquency":"0","maxDelinquency":"0"}]}}';
        //OCSRecuperaFasciaTassoCrifInvoker.callGetFasciaTassoCrif(codCliente)
		String response4 = '{"resultCode":0,"resultMessage":"Ok","recuperaFasciaTassoCrifResponse":{"codFasciaTasso":"P","as400Errore":"","as400Status":"OK"}}';
        //OCSRecuperaSaldoClienteInvoker.callGetSaldoCliente(codCliente)
		String response5 = '{"resultCode":0,"resultMessage":"Ok","recuperaSaldoClienteResponse":{"elencoPratiche":[{"numPratica":"800000329783","tipoPratica":"CA","saldo":"50000","stato":"70","attributo":"XZ","scaduto":"1","finanziato":"500000"}]}}';

		ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.cartaDatiFinanziari',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/cartaDatiFinanziari');
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response3 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDelinquency',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaDelinquency');
        ApiRest__c test3 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response4 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaFasciaTassoCrif',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaFasciaTassoCrif');
        ApiRest__c test4 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response5 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaSaldoCliente',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaSaldoCliente');
        insert new List<ApiRest__c>{test1,test2,test3,test4};
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.cartaDatiFinanziari','ocs.recuperaDelinquency','ocs.recuperaFasciaTassoCrif','ocs.recuperaSaldoCliente'});
        Test.setMock(HttpCalloutMock.class,UMR);
        
        Test.startTest();
		System.runAs(u) {
            VerificaFidoUtilClass.CheckFidoWrapper Wr= VerificaFidoUtilClass.VerifyAumentoFido(pratica);
            System.assertEquals(5000, Wr.disponibilita);
     //       System.assertEquals('Aumento fido KO Blocchi presenti', Wr.messaggioErroreShort);
        }
        Test.stopTest();
	} 
  */      
}