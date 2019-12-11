/**
 * @File Name          : PV3256ErogazioneDirettaInserimentoTest.cls
 * @Description        :
 * @Author             : Lorenzo Marzocchi
 * @Group              :
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 25/10/2019, 14:24:51
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author                        Modification
 *==============================================================================
 * 1.0    2019-8-26 17:45:34   Lorenzo Marzocchi     Initial Version
 **/

@isTest (SeeAllData=true)
private class PV3256ErogazioneDirettaInserimentoTest {

	static boolean truefalse;
	static String Categoria='3256';
	static String response1='{"resultCode":0,"resultMessage":"Ok","datiAcquistiErogazioneDirettaResponse":{"emettitore":"0","protocollo":"1","autor":"0","as400Status":"OK","as400Errore":"5644 Stato carta/Azione incompatibili"}}';
	static String response2='{"resultCode":0,"resultMessage":"Ok","datiAcquistiErogazioneDirettaResponse":{"emettitore":"0","protocollo":"0","autor":"0","as400Status":"KO","as400Errore":"5644 Stato carta/Azione incompatibili"}}';

	@isTest static void testOK() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV3256ErogazioneDirettaInserimento.PV3256ErogazioneDirettaForm form = new PV3256ErogazioneDirettaInserimento.PV3256ErogazioneDirettaForm();
		form = (PV3256ErogazioneDirettaInserimento.PV3256ErogazioneDirettaForm) pVtestFactory.initForm(Categoria, form);

		form.pratica.numPratica = '1';

		form.importo= 1;
		form.codiceCampagna= '';
		form.numRate= '';
		form.modalitaErogazione= '';
		form.smsConsenso= 'true';
		form.iban= '';
		form.flagCommissioniErogazione= '';
		form.intermediario= '';
		form.destErogazione= '';
		form.canale= '';
		form.dataScadenza= '';
		form.codiceInternoBanca= '12';
		form.emettitore= '';
		form.testoSMS= '';
		form.numeroCliente= '';


		pVtestFactory.pushApiList(response1,'ocs.erogazioneDirok');
		pVtestFactory.finalizeApiList();

		Test.startTest();

		PV3256ErogazioneDirettaInserimento.conferma(form);
		OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO TEST3 =PV3256ErogazioneDirettaInserimento.recuperaDatiFinanziari('1');
		String TEST2 = PV3256ErogazioneDirettaInserimento.getMinimoErogabile('3');
		boolean X1 = PV3256ErogazioneDirettaInserimento.isAccountPresente('1');

        Map<String,List<Object> >  TEST1 =PV3256ErogazioneDirettaInserimento.getCpayMatrix('1');
        
		Test.stopTest();

	}

	@isTest static void testKO() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV3256ErogazioneDirettaInserimento.PV3256ErogazioneDirettaForm form = new PV3256ErogazioneDirettaInserimento.PV3256ErogazioneDirettaForm();
		form = (PV3256ErogazioneDirettaInserimento.PV3256ErogazioneDirettaForm) pVtestFactory.initForm(Categoria, form);


		form.pratica.numPratica = '1';

		form.importo= 1;
		form.codiceCampagna= '';
		form.numRate= '';
		form.modalitaErogazione= '';
		form.smsConsenso= 'true';
		form.iban= '';
		form.flagCommissioniErogazione= '';
		form.intermediario= '';
		form.destErogazione= '';
		form.canale= '';
		form.dataScadenza= '';
		form.codiceInternoBanca= '12';
		form.emettitore= '';
		form.testoSMS= '';
		form.numeroCliente= '';
        
		pVtestFactory.pushApiList(response2,'ocs.erogaazioneDirko');
		pVtestFactory.finalizeApiList();

		Test.startTest();

		try{
			OCSGenericRecuperaDatiInvoker.GenericRecuperaDatiResponseDTO TEST4 =PV3256ErogazioneDirettaInserimento.verificaMandatoSDDAttivo('CA','1');
		} catch(Exception e) {
			System.assertNotEquals(e.getMessage(),'');
		}
		
		try{
			PV3256ErogazioneDirettaInserimento.conferma(form);
		} catch(Exception e) {
			System.assertNotEquals(e.getMessage(),'');
		}

		Test.stopTest();

	}

}