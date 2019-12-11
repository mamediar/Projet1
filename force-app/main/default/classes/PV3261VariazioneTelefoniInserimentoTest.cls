/**
 * @File Name          : PV3261VariazioneTelefoniInserimentoTest.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 25/10/2019, 12:16:43
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    21/10/2019   Federico Negro     Initial Version
**/

@isTest (SeeAllData=true)
private class PV3261VariazioneTelefoniInserimentoTest{
  
	static boolean truefalse;
	static String Categoria='3261';

	//variazione telefoni
	static String response1='{"resultCode":0,"resultMessage":"Ok","variazioneTelefoniResponse":{"dataElaborazione":"20191021","oraElaborazione":"10324563","utenteElaborazione":"WB","esitoElaborazione":"OK"}}';
	
	//recupera dati finanziari
	static String response2='{"resultCode":0,"resultMessage":"Ok","datiCartaDatiFinanziariResponse":{"numeroPratica":"32134009083","filiale":"106","emettitore":"32","intestazione1":"SAEOBZA HISAYUKI"}}';
	
	//ocs.recuperaDatiPostvendita
    static String response3='{"resultCode":0,"resultMessage":"Ok","pratiche":[{"numPratica":"32134009083","codCliente":"9099297","tipoPratica":"CA","codStatoPratica":"20","statoPratica":"20XU"}],"cliente":[{"cognome":"SAEOBZA","codCliente":"9099297","nome":"HISAYUKI"}]}';
	
	//recuperaDatiCliente
	static String response4='{"resultCode":0,"resultMessage":"Ok","recuperaDatiClienteResponse":{"telefonoCasa":"","telefonoAlternativo":"3930188791","telCellulare":"331 2517086","fax":""}}';
	
	//variiazione cellulari
	static String response5='{"resultCode":0,"resultMessage":"Ok","variazioneCellulareResponse":{}}';
	

	@isTest static void testOK() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV3261VariazioneTelefoniInserimento.PV3261VariazioneTelefoniInserimentoForm form = new PV3261VariazioneTelefoniInserimento.PV3261VariazioneTelefoniInserimentoForm();
		form = (PV3261VariazioneTelefoniInserimento.PV3261VariazioneTelefoniInserimentoForm) pVtestFactory.initForm(Categoria, form);
		
		form.categoriaPV=PVInserimentoController.getCommonComponents(Categoria);

		form.praticheCA=new List<OCSPratica>();
		OCSPratica pratica1 = new OCSPratica();
		form.praticheCA.add(pratica1);
		form.cliente.codCliente='9099297';
		form.annulla='N';
		form.variazioneCel='S';
        form.forzatura='N';
        form.flagFisso='';
		form.flagCellulare = ''; 
		form.flagAlternativo = 'M'; 
		form.flagFax = '';
		form.variazioni='';
		form.operatoreTel='';
		form.noteAggiornamentoCA='';

		form.datiCliente= new OCSRecuperaDatiClienteResponse.recuperaDatiClienteResponse();
		form.datiCliente.telefonoCasa='';
		form.datiCliente.telCellulare='';
		form.datiCliente.telefonoAlternativo='3388995471';
		
		Map<String,List<String>> serviceIdResMap = new Map<String,List<String>>(); //mappa con i nomi dei servizi e la lista di response

			//servizio variazione telefoni
			List<String> res1=new List<String>();
			res1.add(response1);
			serviceIdResMap.put('variazioneTelefoni', res1);

			//servizio carta dati finanziari
			List<String> res2=new List<String>();
			res2.add(response2);
			res2.add(response2);
			serviceIdResMap.put('cartaDatiFinanziari', res2);

			//servizio recupera dati PV
			List<String> res3=new List<String>();
			res3.add(response3);
			serviceIdResMap.put('recuperaDatiPostvendita', res3);

			//servizio reupera dati cliente
			List<String> res4=new List<String>();
			res4.add(response4);
			serviceIdResMap.put('recuperaDatiCliente', res4);

			//servizio variazione cellulari
			List<String> res5=new List<String>();
			res5.add(response5);
			serviceIdResMap.put('variazioneCellulare', res5);

        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(serviceIdResMap);
		Test.setMock(HttpCalloutMock.class,UMR);
	
		Test.startTest();

			OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO testoutput2 = PV3261VariazioneTelefoniInserimento.recuperaDatiFinanziari(form.pratica.numPratica); //funzia
			PV3261VariazioneTelefoniInserimento.VariazioneTelefoniCheckOutput testoutput1 = PV3261VariazioneTelefoniInserimento.recuperaDatiCliente(form.cliente.codCliente);
			PV3261VariazioneTelefoniInserimento.conferma(form); 

		Test.stopTest();

	}

	@isTest static void testKO() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV3261VariazioneTelefoniInserimento.PV3261VariazioneTelefoniInserimentoForm form = new PV3261VariazioneTelefoniInserimento.PV3261VariazioneTelefoniInserimentoForm();
		form = (PV3261VariazioneTelefoniInserimento.PV3261VariazioneTelefoniInserimentoForm) pVtestFactory.initForm(Categoria, form);
		
        form.categoriaPV=PVInserimentoController.getCommonComponents(Categoria);

		//form.praticheCA=new List<OCSPratica>();

		form.cliente.codCliente='0';

		form.annulla='N';
		form.variazioneCel='N';
        form.forzatura='N';
        form.flagFisso='';
		form.flagCellulare = ''; 
		form.flagAlternativo = 'M'; 
		form.flagFax = '';
		form.variazioni='';
		form.operatoreTel='';

		form.datiCliente= new OCSRecuperaDatiClienteResponse.recuperaDatiClienteResponse();
		form.datiCliente.telefonoCasa='';
		form.datiCliente.telCellulare='';
		form.datiCliente.telefonoAlternativo='3388995471';
		
		form.pratica.tipoPratica = 'CA';
		form.pratica.numPratica='16173114510';

		pVtestFactory.pushApiList(response2,'ocs.variazioneTelefoniKO'); 
		pVtestFactory.finalizeApiList();

		Test.startTest();

		//caso con response che genera eccezione
		try{
            PV3261VariazioneTelefoniInserimento.conferma(form);
		} catch(Exception e) {
			System.assertNotEquals(e.getMessage(),'');
		}

		Test.stopTest();
	}
	
}