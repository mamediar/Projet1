@isTest
public class OCSGestioneNoteRequestTest {
@isTest
    static void test(){
    	OCSGestioneNoteRequest ogg = new OCSGestioneNoteRequest();
    	ogg.gestioneNoteRequest.utente = '';
        ogg.gestioneNoteRequest.codCliente = '';
        ogg.gestioneNoteRequest.numPratica = '66161310104';
        ogg.gestioneNoteRequest.tipoPratica = 'CA';
        ogg.gestioneNoteRequest.modalita = 'A';
        ogg.gestioneNoteRequest.tipoNote = 'P';
        ogg.gestioneNoteRequest.note = 'VENDITA';
    }
}