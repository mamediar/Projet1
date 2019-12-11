/**
 * @File Name          : PV1772DaCustomerServAFilialeInsTest.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 4/11/2019, 17:47:44
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    31/10/2019   Federico Negro     Initial Version
**/

@isTest (SeeAllData=true)
private class PV1772DaCustomerServAFilialeInsTest {

	static boolean truefalse;
	static String Categoria='1772';

	@isTest static void testOK() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV1772DaCustomerServAFilialeIns.PV1772DaCustomerServAFilialeInsForm form = new PV1772DaCustomerServAFilialeIns.PV1772DaCustomerServAFilialeInsForm();
		form = (PV1772DaCustomerServAFilialeIns.PV1772DaCustomerServAFilialeInsForm) pVtestFactory.initForm(Categoria, form);

		form.pratica.tipoPratica = 'CO';
		form.pratica.numPratica = '1';
		form.cliente.ndg = '1';
        form.codFiliale = 'F147';

		Test.startTest();

        List<Account> filiali = PV1772DaCustomerServAFilialeIns.recuperaFiliali();

		PV1772DaCustomerServAFilialeIns.conferma(form);

        //case creato da batch
        form.codFiliale = '';

        PV1772DaCustomerServAFilialeIns.conferma(form);

		Test.stopTest();

	}

}