/**
 * @File Name          : PV3257VariazioneModInvioECTest.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 25/10/2019, 09:10:02
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    14/10/2019   Federico Negro     Initial Version
**/

@isTest (SeeAllData=true)
private class PV3264VariazioneRataMinimaTest{
  
	static boolean truefalse;
	static String Categoria='3264';
	static String response1='{"resultCode":0,"resultMessage":"Ok","variazioneRataMinimaResponse":{"as400Status":"OK","as400Errore":""}}';
	static String response2='{"resultCode":0,"resultMessage":"Ok","variazioneRataMinimaResponse":{"as400Status":"KO","as400Errore":"2918 Fido fuori limite"}}';
	
	@isTest static void testOK() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV3264VariazioneRataMinimaInserimento.PV3264VariazioneRataMinimaInserimentoForm form = new PV3264VariazioneRataMinimaInserimento.PV3264VariazioneRataMinimaInserimentoForm();
		form = (PV3264VariazioneRataMinimaInserimento.PV3264VariazioneRataMinimaInserimentoForm) pVtestFactory.initForm(Categoria, form);

		form.pratica.numPratica='52181699858';
		form.rataNew='10000';
        form.rataOld='67';
        form.percentualeNew='500';
        form.percentualeOld='10';

		pVtestFactory.pushApiList(response1,'ocs.variazioneRataMinimaOK');
		pVtestFactory.finalizeApiList();

		Test.startTest();

			PV3264VariazioneRataMinimaInserimento.conferma(form);
			OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO testoutput1 = PV3264VariazioneRataMinimaInserimento.recuperaDatiFinanziari(form.pratica.numPratica);
			OCSRecuperaInfoCartaResponse.RecuperaInfoCartaResponse testoutput2 = PV3264VariazioneRataMinimaInserimento.recuperaInfoCarta(form.pratica.numPratica);
			PSV_Limite_Credito__mdt testoutput3 = PV3264VariazioneRataMinimaInserimento.getRataMinima('52');

		Test.stopTest();

	}

	@isTest static void testKO() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV3264VariazioneRataMinimaInserimento.PV3264VariazioneRataMinimaInserimentoForm form = new PV3264VariazioneRataMinimaInserimento.PV3264VariazioneRataMinimaInserimentoForm();
		form = (PV3264VariazioneRataMinimaInserimento.PV3264VariazioneRataMinimaInserimentoForm) pVtestFactory.initForm(Categoria, form);
		
        form.pratica.numPratica='52181699858';
		form.rataNew='5000';
        form.rataOld='';
        form.percentualeNew='';
        form.percentualeOld='';

		pVtestFactory.pushApiList(response2,'ocs.variazioneRataMinimaKO');
		pVtestFactory.finalizeApiList();

		Test.startTest();

		//caso con response null
		try{

			PV3264VariazioneRataMinimaInserimento.conferma(form);
			
		} catch(Exception e) {
			System.assertNotEquals(e.getMessage(),'');
		}

		//secondo caso con form null per testare eccezione
		try{
			PSV_Limite_Credito__mdt testoutput3 = PV3264VariazioneRataMinimaInserimento.getRataMinima('0');
			PV3264VariazioneRataMinimaInserimento.conferma(null);
			
		} catch(Exception e) {
			System.assertNotEquals(e.getMessage(),'');
		}

		Test.stopTest();
	}
	
}