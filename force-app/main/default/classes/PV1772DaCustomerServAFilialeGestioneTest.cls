/**
 * @File Name          : PV1772DaCustomerServAFilialeGestioneTest.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 4/11/2019, 17:52:10
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    31/10/2019   Federico Negro     Initial Version
**/

@isTest (SeeAllData=true)
private class PV1772DaCustomerServAFilialeGestioneTest {

    static String Categoria='1772';

	@isTest static void testOK() {

        PVtestFactory pVtestFactory = new PVtestFactory();

        PV1772DaCustomerServAFilialeGestione.PV1772DaCustomerServAFilialeGestioneForm form = new PV1772DaCustomerServAFilialeGestione.PV1772DaCustomerServAFilialeGestioneForm();

        form = (PV1772DaCustomerServAFilialeGestione.PV1772DaCustomerServAFilialeGestioneForm) pVtestFactory.initForm(Categoria, form);

        form.note = 'test';
       
// preparo un case
		Case caseObj = new Case(
			Categoria_Riferimento__c =  form.categoriaPV.Id,
			Step_PV__c = '2',
			Status = CaseUtils.APERTO
			);


		Test.startTest();
		//invia a filiale
        PV1772DaCustomerServAFilialeGestione.saveCase( form,  caseObj);

       

        try{
        // secondo caso con form null e che manda in errore
           
		    PV1772DaCustomerServAFilialeGestione.saveCase( null,  caseObj);
		} catch(Exception e) {
			System.assertNotEquals(e.getMessage(),'');
		}

		Test.stopTest();
	}
}