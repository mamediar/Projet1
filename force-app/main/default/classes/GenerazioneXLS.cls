public class GenerazioneXLS {
    public static void generaExcelExtentionObject(String excelPageName, String objId, String pdfFileName){
        system.debug('GenerazionePDF generaPDFlow params: ');
       CompassUtils.attachFile(CompassUtils.fileNewInstance(excelPageName, objId, pdfFileName, 'xls'), objId);
    }
    public static void generaExcelCustomVisualforcepage(String excelPageName, Map<String,String> mapParameters, String pdfFileName,List<Id> objectsId)
    {
        CompassUtils.attachFileMultiObject(CompassUtils.fileNewInstance(excelPageName, mapParameters, pdfFileName, 'xls'), objectsId);
    }
 	
}