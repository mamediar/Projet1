/**
 * @File Name          : PV1752RiattrSistParitatioTest.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 25/10/2019, 11:55:18
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    22/10/2019   Federico Negro     Initial Version
**/

@isTest (SeeAllData=true)
public class PV1752RiattrSistParitarioTest {

    static boolean truefalse;
	static String Categoria='1752';

    @isTest static void testRimborso() {

        PVtestFactory pVtestFactory = new PVtestFactory();

        PV1752RiattrImpSistPartitarioInserimento.PV1752RiattrImpSistPartitarioForm form = new PV1752RiattrImpSistPartitarioInserimento.PV1752RiattrImpSistPartitarioForm();

        form = (PV1752RiattrImpSistPartitarioInserimento.PV1752RiattrImpSistPartitarioForm) pVtestFactory.initForm(Categoria, form);
        
        form.note = 'richiesta creata automaticamente';

		form.pratica.tipoPratica = 'CA';
		form.pratica.numPratica = '1';
		
        form.hasRimborso=false;
        form.modalitaRimborso = 'Assegno';
		form.noteRimborso = 'Modalità rimborso: Assegno\nDi seguito è riportato l"indirizzo di spedizione eventualmente modificato su richiesta del cliente.\nDI SALVO ROSA\nVIALE GIOVANNI AMENDOLA 24\n19121 LA SPEZIA (SP)\n';
        form.importo = 142.16;

        Test.startTest();
            //caso 1 normal
			PV1752RiattrImpSistPartitarioInserimento.conferma(form);

            //caso 2 per testare eventuali condizioni
            form.dataIncasso=Date.valueOf('2019-08-01');
            form.modalitaRimborso='';

            PV1752RiattrImpSistPartitarioInserimento.conferma(form);

            //caso 3 con form null per testare eccezione
		    try{
			    PV1752RiattrImpSistPartitarioInserimento.conferma(null);
		    } catch(Exception e) {
			    System.assertNotEquals(e.getMessage(),'');
		    }
			
		Test.stopTest();

    } 

}