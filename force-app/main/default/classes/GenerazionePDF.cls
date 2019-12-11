public class GenerazionePDF {
    
    @InvocableMethod
    public static void generaPDFlow(List<PDFData> params){
        system.debug('GenerazionePDF generaPDFlow params: ' + params);
       CompassUtils.attachFile(CompassUtils.fileNewInstance(params[0].pdfPageName, params[0].objID, params[0].pdfFileName, 'pdf'), params[0].objID);
    }
    
   
    public class PDFData{
        @InvocableVariable
        public String pdfPageName;
        @InvocableVariable
        public String objID;
        @InvocableVariable
        public String pdfFileName;
    }
}