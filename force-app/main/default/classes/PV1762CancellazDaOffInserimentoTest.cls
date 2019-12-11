/**
 * @File Name          : PV1762CancellazDaOffInserimentoTest.cls
 * @Description        : 
 * @Author             : Lorenzo Marzocchi
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 25/10/2019, 14:17:03
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-6-19 17:16:11   Lorenzo Marzocchi     Initial Version
**/
@isTest (SeeAllData=true)
private class PV1762CancellazDaOffInserimentoTest {
	static boolean truefalse;
	static String Categoria='1762';
	static String response1='{"resultCode":0,"resultMessage":"Ok","variazioneOffertePromozionaliResponse":{"dataElaborazione":"20191022","oraElaborazione":"17142623","utenteElaborazione":"WB","esitoElaborazione":"OK"}}';
	static String response2='{"resultCode":0,"resultMessage":"Ok","variazioneOffertePromozionaliResponse":{"dataElaborazione":"","oraElaborazione":"","utenteElaborazione":"","esitoElaborazione":"ko"}}';

		@isTest static void testOK() {

		PVtestFactory pVtestFactory = new PVtestFactory();
		// AGGIUNGERE IL FORM SPECIFICO
		 PV1762CancellazDaOffertePromoInserimento.PV1762CancellazDaOffertePromoForm form = new PV1762CancellazDaOffertePromoInserimento.PV1762CancellazDaOffertePromoForm();
		 form = (PV1762CancellazDaOffertePromoInserimento.PV1762CancellazDaOffertePromoForm) pVtestFactory.initForm(Categoria, form);
		// AGGIUNGERE I CAMPI SPECIFICI DEL FORM
		
		form.reasonMdt=new PostvenditaConfig_reason__mdt();
		form.reasonMdt.dispositionId__c = 4352;

		pVtestFactory.pushApiList(response1,'ocs.cancPromOK');
		pVtestFactory.finalizeApiList();

		Test.startTest();

		// CHIAMARE I METODI PER COPRIRE IL CODICE DELL APEX
		PV1762CancellazDaOffertePromoInserimento.conferma(form);

		Test.stopTest();
	}

	@isTest static void testKO() {

		PVtestFactory pVtestFactory = new PVtestFactory();
		// AGGIUNGERE IL FORM SPECIFICO
		 PV1762CancellazDaOffertePromoInserimento.PV1762CancellazDaOffertePromoForm form = new PV1762CancellazDaOffertePromoInserimento.PV1762CancellazDaOffertePromoForm();
		 form = (PV1762CancellazDaOffertePromoInserimento.PV1762CancellazDaOffertePromoForm) pVtestFactory.initForm(Categoria, form);
		// AGGIUNGERE I CAMPI SPECIFICI DEL FORM
		
		form.reasonMdt=new PostvenditaConfig_reason__mdt();
		form.reasonMdt.dispositionId__c = 4352;

		pVtestFactory.pushApiList(response2,'ocs.cancPromKO');
		pVtestFactory.finalizeApiList();

		Test.startTest();
		try{
			PV1762CancellazDaOffertePromoInserimento.conferma(form);
		} catch(Exception e) {
			System.assertNotEquals(e.getMessage(),'');
		}
		
		Test.stopTest();
	}

}