@isTest
public class DocumentResultTest {
    @isTest static void test(){
        DocumentResult d=new DocumentResult();
        d.response=new OCSRientroDocumentiPraticaResponse();
        d.codiceDocumento='TST';
    }
}