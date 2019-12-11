@isTest
public class OCSGestioneNoteResponseTest {
    @isTest
    static void test()
    {
		OCSGestioneNoteResponse note = new OCSGestioneNoteResponse();
        note.gestioneNoteResponse = new OCSGestioneNoteResponse.infonota();
        note.gestioneNoteResponse.as400Status = 'Ok';
        note.gestioneNoteResponse.as400Errore = '';
        note.isOK();
    }
}