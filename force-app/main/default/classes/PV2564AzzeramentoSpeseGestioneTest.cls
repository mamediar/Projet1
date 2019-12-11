/**
 * @File Name          : PV2564AzzeramentoSpeseGestioneTest.cls
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 28/10/2019, 10:12:22
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    20/10/2019   Andrea Vanelli     Initial Version
**/
@isTest (SeeAllData=true)
private class PV2564AzzeramentoSpeseGestioneTest {

	static String Categoria='2564';



	//ocs.eseguiAzioneRecupero 
	static String response1='{"resultCode":0,"resultMessage":"Ok","eseguiAzioneRecuperoResponse":{"esito":"OK","desErrore":""}}';

	//ocs.annullaSpeseRecupero
	static String response2='{"resultCode":0,"resultMessage":"Ok","annullaSpeseRecuperoResponse":{"elencoErrori":["002"]}}';


	@isTest static void testOK() {
		

		PVtestFactory pVtestFactory = new PVtestFactory();
        PV2564AzzeramentoSpeseGestione.PV2564AzzeramentoSpeseGestioneForm form = new PV2564AzzeramentoSpeseGestione.PV2564AzzeramentoSpeseGestioneForm();
        form = (PV2564AzzeramentoSpeseGestione.PV2564AzzeramentoSpeseGestioneForm) pVtestFactory.initForm(Categoria, form);
		
        form.note = 'test';
        form.newStatus = CaseUtils.CHIUSO;
        form.accettarifiuta = 'accetta';

		form.pratica.tipoPratica = 'CO';
		form.pratica.numPratica = '18716892';
		form.pratica.codRecuperatore = 'FID94';

		form.cliente.ndg = '1';
		form.cliente.codCliente = '9099297';

        form.speseList = new List<OCSRecuperaSpeseAzzeraRecInvoker.SpesaRecuperoDTO>();
        OCSRecuperaSpeseAzzeraRecInvoker.SpesaRecuperoDTO spesa = new OCSRecuperaSpeseAzzeraRecInvoker.SpesaRecuperoDTO();
		spesa.saldo = 90;
		spesa.customID = '123456781234567812345678';
		spesa.selezioneOriginale = '';
        form.speseList.add(spesa);



// preparo un case
		Case caseObj = new Case(
			Categoria_Riferimento__c =  form.categoriaPV.Id,
			Step_PV__c = '2',
			Status = CaseUtils.APERTO
			);


		Map<String,List<String>> serviceIdResMap = new Map<String,List<String>>(); //mappa con i nomi dei servizi e la lista di response

			//servizio eseguiAzioneRecupero
			List<String> res1=new List<String>();
			res1.add(response1);
			serviceIdResMap.put('eseguiAzioneRecupero', res1);

			//servizio annullaSpeseRecupero
			List<String> res2=new List<String>();
			res2.add(response2);
			serviceIdResMap.put('annullaSpeseRecupero', res2);

        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(serviceIdResMap);
		Test.setMock(HttpCalloutMock.class,UMR);


		Test.startTest();

		PV2564AzzeramentoSpeseGestione.saveCase( form,  caseObj);

        try{
                // secondo caso con note nulle che manda in erorre
    		form.note = null;
		    PV2564AzzeramentoSpeseGestione.saveCase( form,  caseObj);
		} catch(Exception e) {
			System.assertNotEquals(e.getMessage(),'');
		}

		Test.stopTest();
	}

	
}