/**
 * @File Name          : PV1768RipristinoRIDGestioneTest.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 25/10/2019, 14:49:02
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    24/10/2019   Federico Negro     Initial Version
**/

 @isTest (SeeAllData=true)
private class PV1768RipristinoRIDGestioneTest {

    static String Categoria='1768';

	@isTest static void testOK() {

        PVtestFactory pVtestFactory = new PVtestFactory();

        PV1768RipristinoRIDGestione.PV1768RipristinoRIDGestioneForm form = new PV1768RipristinoRIDGestione.PV1768RipristinoRIDGestioneForm();

        form = (PV1768RipristinoRIDGestione.PV1768RipristinoRIDGestioneForm) pVtestFactory.initForm(Categoria, form);
        form.note = 'test';
        form.esito = 'OK';

        PV1768RipristinoRIDGestione ridGestione = new PV1768RipristinoRIDGestione();

// preparo un case
		Case caseObj = new Case(
			Categoria_Riferimento__c =  form.categoriaPV.Id,
			Step_PV__c = '2',
			Status = CaseUtils.APERTO
			);


		Test.startTest();
		PV1768RipristinoRIDGestione.saveCase( form,  caseObj);

        try{
        // secondo caso con form null e che manda in errore
            
		    PV1768RipristinoRIDGestione.saveCase( null,  caseObj);
		}
		catch(Exception e)
		{
			System.assertNotEquals(e.getMessage(),'');
		}

		Test.stopTest();
	}

}