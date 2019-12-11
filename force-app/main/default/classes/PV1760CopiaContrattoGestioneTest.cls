/**
 * @File Name          : PV1760CopiaContrattoGestioneTest.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 24/10/2019, 15:12:18
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    24/10/2019   Federico Negro     Initial Version
**/

@isTest (SeeAllData=true)
private class PV1760CopiaContrattoGestioneTest {

    static String Categoria='1760';

	@isTest static void testOK() {

        PVtestFactory pVtestFactory = new PVtestFactory();

        PV1760CopiaContrattoGestione.PV1760CopiaContrattoGestioneForm form = new PV1760CopiaContrattoGestione.PV1760CopiaContrattoGestioneForm();

        form = (PV1760CopiaContrattoGestione.PV1760CopiaContrattoGestioneForm) pVtestFactory.initForm(Categoria, form);

        form.note = 'test';

        PV1760CopiaContrattoGestione.ComunicazioniOCSListDTO comunicazioniOCS = new PV1760CopiaContrattoGestione.ComunicazioniOCSListDTO();

        comunicazioniOCS.Codice='';
        comunicazioniOCS.Tipologia='';
       
// preparo un case
		Case caseObj = new Case(
			Categoria_Riferimento__c =  form.categoriaPV.Id,
			Step_PV__c = '2',
			Status = CaseUtils.APERTO
			);


		Test.startTest();
		PV1760CopiaContrattoGestione.saveCase( form,  caseObj);

		Test.stopTest();
	}
}