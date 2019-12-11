/**
 * @File Name          : PV1768RipristinoRIDInsTest.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 25/10/2019, 11:24:23
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    25/10/2019   Federico Negro     Initial Version
**/
@isTest (SeeAllData=true)
private class PV1768RipristinoRIDInsTest{
  
	static boolean truefalse;
	static String Categoria='1768';
	static String response2='{"resultCode":0,"resultMessage":"Ok","variazioneDatiPagamentoResponse":{"as400Status":"KO","as400Errore":"3107 Disposizione RID elettronica."}}';
	
	@isTest static void testOK() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV1768RipristinoRIDInserimento.PV1768RipristinoRIDInserimentoForm form = new PV1768RipristinoRIDInserimento.PV1768RipristinoRIDInserimentoForm();
		form = (PV1768RipristinoRIDInserimento.PV1768RipristinoRIDInserimentoForm) pVtestFactory.initForm(Categoria, form);

        form.pratica.tipoPratica = 'CA';
		form.pratica.numPratica = '32134009083';
        form.pratica.iban = 'IT88E0521616401000006009493';
        form.dataRipristino = '15/08/2019';

		pVtestFactory.pushApiList(response2,'ocs.ripristinoRIDOK');
		pVtestFactory.finalizeApiList();

		Test.startTest();
			
        	PV1768RipristinoRIDInserimento.conferma(form);
        	OCSRecuperaSaldoClienteResponse.RecuperaSaldoClienteResponse testoutput1 = PV1768RipristinoRIDInserimento.recuperaSaldoCliente(form.cliente.codCliente, '');

		//caso con form null per testare eccezione
		try{
			PV1768RipristinoRIDInserimento.conferma(null);
		}
		catch(Exception e) {
			System.assertNotEquals(e.getMessage(),'');
		}

		Test.stopTest();

	}

}