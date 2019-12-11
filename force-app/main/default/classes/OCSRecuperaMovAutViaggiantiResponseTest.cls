@isTest
public class OCSRecuperaMovAutViaggiantiResponseTest {
    
    @isTest
    public static void test(){
        
        OCSRecuperaMovAutViaggiantiResponse mv = new OCSRecuperaMovAutViaggiantiResponse();       
        OCSRecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO mvViag= new OCSRecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO();
        
        OCSRecuperaMovAutViaggiantiResponse.AutorizzazioneViaggianteDTO mvAutViag = new OCSRecuperaMovAutViaggiantiResponse.AutorizzazioneViaggianteDTO();
        
        mvAutViag.autorizzazione = '';
        mvAutViag.intermediario = '';
        mvAutViag.codEsercente = '';
        mvAutViag.desEsercente = '';
        mvAutViag.importo = '';
        mvAutViag.importoSegno = '';
        mvAutViag.importoDivisaEstera = '';
        mvAutViag.divisa = '';
        mvAutViag.stato = '';
        mvAutViag.esito = '';
        mvAutViag.codAzione = '';
        mvAutViag.desAzione = '';
        mvAutViag.data = '12345679';
        mvAutViag.ora = '12345';
        String getData = mvAutViag.data;
        String getOra = mvAutViag.ora;
        mvAutViag.ora = '123456';
        getOra = mvAutViag.ora;
        mvAutViag.data = null;
        getData =mvAutViag.data;
        
    }  
}