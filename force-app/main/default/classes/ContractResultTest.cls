@isTest
public class ContractResultTest {
    @isTest static void test(){
        ContractResult c=new ContractResult();
        c.contract = new Contract();
        c.response = new OCSCambioStatoPraticaResponse();
        DocumentResult d=new DocumentResult();
        d.codiceDocumento='TST';
        d.response=new OCSRientroDocumentiPraticaResponse();
        DocumentResult dTwo = new DocumentResult();
        DocumentResult dThree = new DocumentResult();
        
        OCSRientroDocumentiPraticaResponse testData = new OCSRientroDocumentiPraticaResponse();
        testData.statusCode=200;
        testData.resultCode=0;
        dTwo.response= testData;
        
        OCSRientroDocumentiPraticaResponse testDataKO = new OCSRientroDocumentiPraticaResponse();
        testDataKO.statusCode=200;
        testDataKO.resultCode=0;
        testDataKO.errore='KO';
        dThree.response = testDataKO;
        
        
        List<DocumentResult> l=new List<DocumentResult>();
        l.add(d);
        l.add(dTwo);
        l.add(dThree);
        
        c.setDocResult(l);
        c.isOk();
        c.getIsOk();
        
        
    }
}