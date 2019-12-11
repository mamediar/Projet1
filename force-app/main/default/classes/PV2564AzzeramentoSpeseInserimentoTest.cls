/**
 * @File Name          : PV2564AzzeramentoSpeseInserimentoTest.cls
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 25/10/2019, 15:10:36
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    20/10/2019   Andrea Vanelli     Initial Version
**/
@isTest (SeeAllData=true)
private class PV2564AzzeramentoSpeseInserimentoTest {

	static boolean truefalse;
	static String Categoria='2564';

	@isTest static void testOK() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV2564AzzeramentoSpeseInserimento.PV2564AzzeramentoSpeseInserimentoForm form = new PV2564AzzeramentoSpeseInserimento.PV2564AzzeramentoSpeseInserimentoForm();
		form = (PV2564AzzeramentoSpeseInserimento.PV2564AzzeramentoSpeseInserimentoForm) pVtestFactory.initForm(Categoria, form);

		form.pratica.tipoPratica = 'CO';
		form.pratica.numPratica = '1';
		form.cliente.ndg = '1';
        form.ufficioDestinazione = 'PHC';

		form.sottotipologiaMdt = new PostvenditaConfig_subtype__mdt();
		form.sottotipologiaMdt.uniqueId__c= 18;

        form.speseList = new List<OCSRecuperaSpeseAzzeraRecInvoker.SpesaRecuperoDTO>();
        OCSRecuperaSpeseAzzeraRecInvoker.SpesaRecuperoDTO spesa = new OCSRecuperaSpeseAzzeraRecInvoker.SpesaRecuperoDTO();
        form.speseList.add(spesa);

		Test.startTest();

		OCSRecuperaSpeseAzzeraRecInvoker.Response x = PV2564AzzeramentoSpeseInserimento.recuperaSpeseAzzeramentoRecupero(form.pratica.numPratica,form.pratica.tipoPratica);
		PV2564AzzeramentoSpeseInserimento.conferma(form);

		Test.stopTest();

	}

}