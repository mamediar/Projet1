@isTest
public class OCSRientroDocumentiPraticaResponseTest {
    @isTest static void test(){
        OCSRientroDocumentiPraticaResponse r=new OCSRientroDocumentiPraticaResponse();
        r.errore='OK';
        r.getMessage();
    }
}