/**
 * @File Name          : PV3481AttivazioneCartaInserimentoTest.cls
 * @Description        :
 * @Author             : Lorenzo Marzocchi
 * @Group              :
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 25/10/2019, 14:09:55
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author                        Modification
 *==============================================================================
 * 1.0    2019-6-19 14:36:05   Lorenzo Marzocchi     Initial Version
 **/
@isTest (SeeAllData=true)
private class PV3481AttivazioneCartaInserimentoTest {
	static boolean truefalse;
	static String Categoria='3481';
	static String response1 = '{"resultCode":0,"resultMessage":"Ok","datiAttivazioneCartaDiCreditoResponse":{"statoCarta":"50","as400Status":"","as400Errore":""}}';
    static String response2 = '{"resultCode": 0,"resultMessage": "Ok","datiAttivazioneCartaDiCreditoResponse": {"statoCarta": "30","as400Status": "KO","as400Errore": "7436 Tessera già attiva"}}';
	@isTest static void testOK() {

		PVtestFactory pVtestFactory = new PVtestFactory();
		// AGGIUNGERE IL FORM SPECIFICO
		PV3481AttivazioneCartaInserimento.PV3481AttivazioneCartaForm form = new PV3481AttivazioneCartaInserimento.PV3481AttivazioneCartaForm();
		form = (PV3481AttivazioneCartaInserimento.PV3481AttivazioneCartaForm) pVtestFactory.initForm(Categoria, form);
		
		// AGGIUNGERE I CAMPI SPECIFICI DEL FORM
		form.pratica.numPratica='8180824247';
		
		form.pratica.statoPratica='30';
		form.statoCartaAttuale= '30';
		form.datiFinanziari = new OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO();
		form.datiFinanziari.dataScadenza = '20500101';

		pVtestFactory.pushApiList(response1,'ocs.attivaCartaOK');
		pVtestFactory.finalizeApiList();
       
		Test.startTest();

		// CHIAMARE I METODI PER COPRIRE IL CODICE DELL APEX
        OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO x = PV3481AttivazioneCartaInserimento.recuperaDatiFinanziari(form.pratica.numPratica);
		PV3481AttivazioneCartaInserimento.conferma(form);

		Test.stopTest();
	}

	@isTest static void testKO() {

		PVtestFactory pVtestFactory = new PVtestFactory();
		// AGGIUNGERE IL FORM SPECIFICO
		PV3481AttivazioneCartaInserimento.PV3481AttivazioneCartaForm form = new PV3481AttivazioneCartaInserimento.PV3481AttivazioneCartaForm();
		form = (PV3481AttivazioneCartaInserimento.PV3481AttivazioneCartaForm) pVtestFactory.initForm(Categoria, form);
		
		// AGGIUNGERE I CAMPI SPECIFICI DEL FORM
		form.pratica.numPratica='8180824247';
		
		form.pratica.statoPratica='30';
		form.statoCartaAttuale= '30';
		form.datiFinanziari = new OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO();
		form.datiFinanziari.dataScadenza = '20500101';

		pVtestFactory.pushApiList(response2,'ocs.attivaCartaKO');
		pVtestFactory.finalizeApiList();
       
		Test.startTest();

		try{
			PV3481AttivazioneCartaInserimento.conferma(form);
		} catch(Exception e) {
			System.assertNotEquals(e.getMessage(),'');
		}

		Test.stopTest();
	}

}