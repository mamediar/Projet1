/**
 * @File Name          : PV2870RiemissionePINInserimentoTest.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 25/10/2019, 11:46:10
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    21/10/2019   Federico Negro     Initial Version
**/
@isTest (SeeAllData=true)
private class PV2870RiemissionePINInserimentoTest{
  
	static boolean truefalse;
	static String Categoria='2870';
	static String response1='{"resultCode":0,"resultMessage":"Ok","ristampaPinResponse":{"as400Errore":"","as400Status":""}}';
	static String response2='{"resultCode":0,"resultMessage":"Ok","recuperaIndirizziClienteResponse":{"elencoIndirizzi":[{"tipoIndirizzo":"R","indirizzo":"VIA ROMA 3","civico":null,"cap":"91025","localita":"MARSALA","provincia":"TP","nazione":null,"capRischio":"N"}]}}';
	static String response3='{"resultCode":0,"resultMessage":"Ok","ristampaPinResponse":{"as400Status":"KO","as400Errore":"Messaggio non previsto : ERR"}}';
	
	@isTest static void testOK() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV2870RiemissionePINInserimento.PV2870RiemissionePINInserimentoForm form = new PV2870RiemissionePINInserimento.PV2870RiemissionePINInserimentoForm();
		form = (PV2870RiemissionePINInserimento.PV2870RiemissionePINInserimentoForm) pVtestFactory.initForm(Categoria, form);

		form.pratica.numPratica='16122169920';
        form.cliente.codCliente='9099297';

		/*pVtestFactory.pushApiList(response1,'ocs.riemissionePINOK');
		pVtestFactory.finalizeApiList();*/

		Map<String,List<String>> serviceIdResMap = new Map<String,List<String>>(); //mappa con i nomi dei servizi e la lista di response

		//servizio variazione telefoni
        List<String> res1=new List<String>();
        res1.add(response1);
		serviceIdResMap.put('ristampaPin', res1);

		//servizio carta dati finanziari
		List<String> res2=new List<String>();
        res2.add(response2);
		serviceIdResMap.put('recuperaIndirizziCliente', res2);
		
		UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(serviceIdResMap);
		Test.setMock(HttpCalloutMock.class,UMR);

		Test.startTest();

            String addresComplete = PV2870RiemissionePINInserimento.recuperaIndirizzoCompleto(form.cliente.codCliente);
			PV2870RiemissionePINInserimento.conferma(form);

		Test.stopTest();

	}

	@isTest static void testKO() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV2870RiemissionePINInserimento.PV2870RiemissionePINInserimentoForm form = new PV2870RiemissionePINInserimento.PV2870RiemissionePINInserimentoForm();
		form = (PV2870RiemissionePINInserimento.PV2870RiemissionePINInserimentoForm) pVtestFactory.initForm(Categoria, form);
		
        form.pratica.numPratica='32177458072';
		form.cliente.codCliente='15050611';

		pVtestFactory.pushApiList(response3,'ocs.riemissionePINKO');
		pVtestFactory.finalizeApiList();

		Test.startTest();

		OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO testoutput1 = PV2870RiemissionePINInserimento.recuperaDatiFinanziari(form.pratica.numPratica);
		OCSRecuperaInfoCartaResponse.RecuperaInfoCartaResponse testoutput2 = PV2870RiemissionePINInserimento.recuperaInfoCarta(form.pratica.numPratica);

		try{

			PV2870RiemissionePINInserimento.conferma(form);
			
		} catch(Exception e) {
			System.assertNotEquals(e.getMessage(),'');
		}
		
		//caso con form null per testare eccezionne
		try{

			PV2870RiemissionePINInserimento.conferma(null);
			
		} catch(Exception e) {
			System.assertNotEquals(e.getMessage(),'');
		}

		Test.stopTest();
	}
	
}