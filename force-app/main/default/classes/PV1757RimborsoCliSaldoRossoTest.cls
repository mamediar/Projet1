/**
 * @File Name          : PV1757RimborsoCliSaldoRossoInserimentoTest.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 25/10/2019, 12:07:07
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    22/10/2019   Federico Negro     Initial Version
**/

@isTest (SeeAllData=true)
public class PV1757RimborsoCliSaldoRossoTest {

     static boolean truefalse;
	static String Categoria='1757';

    @isTest static void testRimborso() {

        PVtestFactory pVtestFactory = new PVtestFactory();

        PV1757RimborsoCliSaldoRossoInserimento.PV1757RimborsoCliSaldoRossoForm form = new PV1757RimborsoCliSaldoRossoInserimento.PV1757RimborsoCliSaldoRossoForm();

        form = (PV1757RimborsoCliSaldoRossoInserimento.PV1757RimborsoCliSaldoRossoForm) pVtestFactory.initForm(Categoria, form);

        form.cliente = new OCSCliente();
		form.cliente.email = 'POSTVENDITA@EMAIL.TEST';
		form.cliente.codCliente = '1';
		form.cliente.cognome = 'COGNOME';
		form.cliente.nome = 'NOME';
		form.cliente.denominazioneAzienda = 'NOME COGNOME';
		form.cliente.dataNascita = '20100101';

        form.note = 'richiesta creata automaticamente';

        form.pratica = new OCSPratica();
		form.pratica.tipoPratica = 'CA';
		form.pratica.numPratica = '1';

        form.dataRid = Date.today().addDays(-2);
        form.modalitaRimborso = 'Assegno';
		form.noteRimborso = 'Modalità rimborso: Assegno\nDi seguito è riportato l"indirizzo di spedizione eventualmente modificato su richiesta del cliente.\nDI SALVO ROSA\nVIALE GIOVANNI AMENDOLA 24\n19121 LA SPEZIA (SP)\n';
        form.importo = 142.16;

        Test.startTest();
            //caso 1 normal
			
            PV1757RimborsoCliSaldoRossoInserimento.conferma(form);

            //caso 3 con form null per testare eccezione
		    try{
			    PV1757RimborsoCliSaldoRossoInserimento.conferma(null);
		    } catch(Exception e) {
			    System.assertNotEquals(e.getMessage(),'');
		    }
			
		Test.stopTest();

    } 

}