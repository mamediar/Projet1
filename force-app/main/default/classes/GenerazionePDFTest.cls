@isTest
public class GenerazionePDFTest {
    @isTest static void test(){
        Account acct = new Account(Name='TEST_ACCT');
        insert acct;
        
        GenerazionePDF.PDFData d=new GenerazionePDF.PDFData();
        d.pdfPageName='InvioLottiPDF';
        d.objId=acct.Id;
        d.pdfFileName='TestName';
        List<GenerazionePDF.PDFData> params=new List<GenerazionePDF.PDFData>();
        params.add(d);
        
        GenerazionePDF.generaPDFlow(params);
    }
}