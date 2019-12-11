/**
 * @File Name          : PV3388VariazioneEmailActionTest.cls
 * @Description        :
 * @Author             : Lorenzo Marzocchi
 * @Group              :
 * @Last Modified By   : Lorenzo Marzocchi
 * @Last Modified On   : 2019-6-19 14:08:12
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author                        Modification
 *==============================================================================
 * 1.0    2019-6-18 16:37:21   Lorenzo Marzocchi     Initial Version
 **/
@isTest (SeeAllData=true)
private class PV3388VariazioneEmailActionTest {
	static boolean truefalse;
	static String Categoria='3388';
	static String response1='{"resultCode":0,"resultMessage":"Ok","datiVariazioneMailClienteResponse": {"as400Errore": "MAIL AGGIORNATA","as400Status": "OK"}}';
	static String response2='{"resultCode":20000,"resultMessage":"Ko","datiVariazioneMailClienteResponse": {"as400Errore": "MAIL NON AGGIORNATA","as400Status": "KO"}}';

	@isTest static void testOK() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV3388VariazioneEmailInserimento.PV3388VariazioneEmailForm form = new PV3388VariazioneEmailInserimento.PV3388VariazioneEmailForm();
		form = (PV3388VariazioneEmailInserimento.PV3388VariazioneEmailForm) pVtestFactory.initForm(Categoria, form);
		form.mailNuova = 'ciccio@ciccio.it';

		pVtestFactory.pushApiList(response1,'ocs.variazioneMailOK');
		pVtestFactory.finalizeApiList();

		Test.startTest();

		PV3388VariazioneEmailInserimento.conferma(form);
		truefalse= PV3388VariazioneEmailInserimento.isAccountPresente(form.cliente.codCliente);
		truefalse= PV3388VariazioneEmailInserimento.isRecuperoCredenzialiPresente(form.cliente.codCliente);

		Test.stopTest();

	}

	@isTest static void testKO() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV3388VariazioneEmailInserimento.PV3388VariazioneEmailForm form = new PV3388VariazioneEmailInserimento.PV3388VariazioneEmailForm();
		form = (PV3388VariazioneEmailInserimento.PV3388VariazioneEmailForm) pVtestFactory.initForm(Categoria, form);
		form.mailNuova = 'ciccio@ciccio.it';

		pVtestFactory.pushApiList(response2,'ocs.variazioneMailKO');
		pVtestFactory.finalizeApiList();

		Test.startTest();

		try{
			PV3388VariazioneEmailInserimento.conferma(form);
		}
		catch(Exception e)
		{
			System.assertNotEquals(e.getMessage(),'');
		}

		Test.stopTest();

	}

}