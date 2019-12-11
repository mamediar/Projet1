/**
 * @File Name          : PV3260AumentoFidoInserimentoTest.cls
 * @Description        : 
 * @Author             : Lorenzo Marzocchi
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 25/10/2019, 10:51:02
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-8-26 15:18:49   Lorenzo Marzocchi     Initial Version
**/
@isTest (SeeAllData=true)
private class PV3260AumentoFidoInserimentoTest {
  
	static boolean truefalse;
	static String Categoria='3260';
	static String response1='{"resultCode":0,"resultMessage":"Ok","variazioneFidoResponse": {"as400Errore": "","as400Status": "OK"}}';
	static String response2='{"resultCode":0,"resultMessage":"Ok","variazioneFidoResponse": {"as400Status": "KO","as400Errore": "2259 Saldo totale superiore a fido complessivo"}}';
	//recupera dati finanziari
	static String response3='{"resultCode":0,"resultMessage":"Ok","datiCartaDatiFinanziariResponse":{"numeroPratica":"32134009083","filiale":"106","emettitore":"32","intestazione1":"SAEOBZA HISAYUKI"}}';
	
	@isTest static void testOK() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV3260AumentoFidoInserimento.PV3260AumentoFidoForm form = new PV3260AumentoFidoInserimento.PV3260AumentoFidoForm();
		form = (PV3260AumentoFidoInserimento.PV3260AumentoFidoForm) pVtestFactory.initForm(Categoria, form);
		
        form.riservaPrincipale = '';
        form.riservaSalvadanaio = '';
        form.rataMinima = '200';
        form.fidoTotale = '5000';
        form.riservaInternetFido = '';
        form.riservaMulticontoFido = '';
        form.pratica.numPratica = '1';

		/*pVtestFactory.pushApiList(response1,'ocs.afok');
		pVtestFactory.finalizeApiList();*/

		Map<String,List<String>> serviceIdResMap = new Map<String,List<String>>(); //mappa con i nomi dei servizi e la lista di response

		//servizio variazione telefoni
        List<String> res1=new List<String>();
        res1.add(response1);
		serviceIdResMap.put('variazioneFido', res1);

		//servizio carta dati finanziari
		List<String> res3=new List<String>();
        res3.add(response3);
		serviceIdResMap.put('cartaDatiFinanziari', res3);
		
		UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(serviceIdResMap);
		Test.setMock(HttpCalloutMock.class,UMR);

		Test.startTest();

		PSV_Limite_Credito__mdt testoutput = PV3260AumentoFidoInserimento.getStep('3');
		OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO testoutput2 = PV3260AumentoFidoInserimento.recuperaDatiFinanziari('32134009083');
		PV3260AumentoFidoInserimento.conferma(form);

		Test.stopTest();

	}

	@isTest static void testKO() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV3260AumentoFidoInserimento.PV3260AumentoFidoForm form = new PV3260AumentoFidoInserimento.PV3260AumentoFidoForm();
		form = (PV3260AumentoFidoInserimento.PV3260AumentoFidoForm) pVtestFactory.initForm(Categoria, form);
		
        form.riservaPrincipale = '1';
        form.riservaSalvadanaio = '1';
        form.rataMinima = '200';
        form.fidoTotale = '5000';
        form.riservaInternetFido = '1';
        form.riservaMulticontoFido = '1';
        form.pratica.numPratica = '1';

		pVtestFactory.pushApiList(response2,'ocs.afko');
		pVtestFactory.finalizeApiList();

		Test.startTest();
		
		//test response KO
		try{
			PV3260AumentoFidoInserimento.conferma(form);
		}
		catch(Exception e)
		{
			System.assertNotEquals(e.getMessage(),'');
		}

		//test form null per scatenare eccezione
		try{
			PV3260AumentoFidoInserimento.conferma(null);
		}
		catch(Exception e)
		{
			System.assertNotEquals(e.getMessage(),'');
		}
		
		//test ko verificheAF
		try{
			VerificaFidoUtilClass.CheckFidoWrapper testoutput1 = PV3260AumentoFidoInserimento.verificheAF('1','1');
		}
		catch(Exception e)
		{
			System.assertNotEquals(e.getMessage(),'');
		}

		Test.stopTest();

	}

}