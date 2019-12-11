/**
 * @File Name          : PV1760CopiaContrattoInserimentoTest.cls
 * @Description        :
 * @Author             : Lorenzo Marzocchi
 * @Group              :
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 25/10/2019, 09:58:44
 * @Modification Log   :
 * Ver       Date            Author                         Modification
 * 1.0    2019-9-20   Lorenzo Marzocchi     Initial Version
 **/

@isTest (SeeAllData=true)
private class PV1760CopiaContrattoInserimentoTest {

	static boolean truefalse;
	static String Categoria='1760';
	static String response1='{"resultCode":0,"resultMessage":"Ok","recuperaDatiStampaPraticaResponse":{"tipoFirma":"C"}}';

	@isTest static void testOK() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV1760CopiaContrattoInserimento.PV1760CopiaContrattoForm form = new PV1760CopiaContrattoInserimento.PV1760CopiaContrattoForm();
		form = (PV1760CopiaContrattoInserimento.PV1760CopiaContrattoForm) pVtestFactory.initForm(Categoria, form);

		form.pratica.numPratica = '1';

		form.destinatario ='Sender';
		form.indirizzo ='123';
		form.FEA ='FEA';
		form.statoLotto ='IDM';

		pVtestFactory.pushApiList(response1,'ocs.copiaContrattoOK');
		pVtestFactory.finalizeApiList();
	
		Test.startTest();

		PV1760CopiaContrattoInserimento.conferma(form);
		String TEST1 = PV1760CopiaContrattoInserimento.recuperaDatiStampaPratica('1','CA');
		String TEST2 = PV1760CopiaContrattoInserimento.recuperaStatoLotto('1');

		//caso con form null per testare eccezione
		try{
			
			PV1760CopiaContrattoInserimento.conferma(null);
		} catch(Exception e) {
			System.assertNotEquals(e.getMessage(),'');
		}

		Test.stopTest();

	}

}