/**
 * @File Name          : PV3257VariazioneModInvioECTest.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 25/10/2019, 09:00:08
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    14/10/2019   Federico Negro     Initial Version
**/

@isTest (SeeAllData=true)
private class PV3257VariazioneModInvioECTest{
  
	static boolean truefalse;
	static String Categoria='3257';
	static String response1='{"resultCode":0,"resultMessage":"Ok","variazioneModalitaInvioECResponse":{"panNuovo":null,"as400Errore":"","as400Status":""}}';
	static String response2='{"resultCode":0,"resultMessage":"Ok","variazioneModalitaInvioECResponse":{"panNuovo":null,"as400Errore":"0246 Nr. pratica non presente in archivio","as400Status":"KO"}}';
	
	@isTest static void testOK() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV3257VariazioneModInvioECInserimento.PV3257VariazioneModInvioECForm form = new PV3257VariazioneModInvioECInserimento.PV3257VariazioneModInvioECForm();
		form = (PV3257VariazioneModInvioECInserimento.PV3257VariazioneModInvioECForm) pVtestFactory.initForm(Categoria, form);

        form.modalitaNuova='I';
        form.modalitaVecchia='M';
		form.pratica.numPratica='8180824247';
		form.emailCarta='pasquale.cangianiello@compass.it';

		pVtestFactory.pushApiList(response1,'ocs.variazioneModInvioECOK');
		pVtestFactory.finalizeApiList();

		Test.startTest();

			PV3257VariazioneModInvioECInserimento.conferma(form);
			OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO testoutput1 = PV3257VariazioneModInvioECInserimento.recuperaDatiFinanziari(form.pratica.numPratica);
			OCSRecuperaInfoCartaResponse.RecuperaInfoCartaResponse testoutput2 = PV3257VariazioneModInvioECInserimento.recuperaInfoCarta(form.pratica.numPratica);
			
		Test.stopTest();

	}

	@isTest static void testKO() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV3257VariazioneModInvioECInserimento.PV3257VariazioneModInvioECForm form = new PV3257VariazioneModInvioECInserimento.PV3257VariazioneModInvioECForm();
		form = (PV3257VariazioneModInvioECInserimento.PV3257VariazioneModInvioECForm) pVtestFactory.initForm(Categoria, form);
		
        form.modalitaNuova='I';
        form.modalitaVecchia='I';
		form.pratica.numPratica='1';
		form.emailCarta='pasquale.cangianiello@compass.it';

		pVtestFactory.pushApiList(response2,'ocs.variazioneModInvioECKO');
		pVtestFactory.finalizeApiList();

		Test.startTest();

		//primo caso con response KO
		try{
			PV3257VariazioneModInvioECInserimento.conferma(form);
		} catch(Exception e) {
			System.assertNotEquals(e.getMessage(),'');
		}

		//secondo caso con form null per testare eccezione
		try{
			PV3257VariazioneModInvioECInserimento.conferma(null);
		} catch(Exception e) {
			System.assertNotEquals(e.getMessage(),'');
		}

		Test.stopTest();

	}

}