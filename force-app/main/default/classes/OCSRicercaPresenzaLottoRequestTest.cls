@isTest
public class OCSRicercaPresenzaLottoRequestTest 
{
	@isTest
    static void test(){
    	OCSRicercaPresenzaLottoRequest ogg = new OCSRicercaPresenzaLottoRequest();
    	ogg.authorization = 'ok';
    	ogg.ebagetadlv1Request.msfilogon_UTENTE = '';
        ogg.ebagetadlv1Request.mfbayadlo_IN_PRATICA = '';
        ogg.ebagetadlv1Request.mfbayadlo_IN_PROCEDURA = '';
        ogg.ebagetadlv1Request.msflogon_TMP_KEY = '';
        ogg.ebagetadlv1Request.msfilogon_SENDER_TIPO = '';
        ogg.ebagetadlv1Request.msfilogon_SENDER_CODICE = 0;
        ogg.ebagetadlv1Request.msfilogon_CANALE_ACQUISIZ = '';
    }
}