/**
 * @File Name          : PV1751GirocontoIncassoTest.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 25/10/2019, 11:03:20
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    25/10/2019   Federico Negro     Initial Version
**/
@isTest (SeeAllData=true)
public class PV1751GirocontoIncassoTest {

    static boolean truefalse;
    static String Categoria='1751';

    @isTest static void testGiroconto() {

        PVtestFactory pVtestFactory = new PVtestFactory();

        PV1751GirocontoIncassoInserimento.PV1751GirocontoIncassoForm form = new PV1751GirocontoIncassoInserimento.PV1751GirocontoIncassoForm();

        form = (PV1751GirocontoIncassoInserimento.PV1751GirocontoIncassoForm) pVtestFactory.initForm(Categoria, form);
        
        // note operatore/batch
        form.note = 'richiesta creata automaticamente';
        
        // specifici per ogni PV 
        form.pratica.tipoPratica = 'CA';
        form.pratica.numPratica = '2106662676';

        //dati specifici PV
        form.modalitaRimborso = 'Assegno';
        form.noteRimborso = 'Modalità rimborso: Assegno\nDi seguito è riportato l"indirizzo di spedizione eventualmente modificato su richiesta del cliente.\nDI SALVO ROSA\nVIALE GIOVANNI AMENDOLA 24\n19121 LA SPEZIA (SP)\n';
        form.hasRimborso = true;
        form.totImporto = 142.16;
        form.totRimborso = 120.62;

        //pratiche destinazione
        PV1751GirocontoIncassoInserimento.PraticaDestinazione praticaDe = new PV1751GirocontoIncassoInserimento.PraticaDestinazione();
        PV1751GirocontoIncassoInserimento.PraticaDestinazione praticaDe2 = new PV1751GirocontoIncassoInserimento.PraticaDestinazione();
        form.praticheDestinazione = new List<PV1751GirocontoIncassoInserimento.PraticaDestinazione>();
        praticaDe.numPratica = '0123456';
        praticaDe.tipoPratica = 'CO';
        praticaDe.tipoCompensazione = 'IN';
        praticaDe.anzianitaInsoluto = '2';
        praticaDe.totaleSpesa = 12.40;
        praticaDe.importoCompensazione = 12.40;
        form.praticheDestinazione.add(praticaDe);

        praticaDe2.numPratica = '6543210';
        praticaDe2.tipoPratica = 'CA';
        praticaDe2.tipoCompensazione = 'SP';
        praticaDe2.totaleSpesa = 5.20;
        praticaDe2.importoCompensazione = 5.20;
        form.praticheDestinazione.add(praticaDe2);

        Test.startTest();

            PV1751GirocontoIncassoInserimento.conferma(form);
            
        Test.stopTest();

    } 

}