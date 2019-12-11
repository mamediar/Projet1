public class SFAConvenzVisualizReportCervedCntroller {

    @AuraEnabled
    public static String getFile(String caseId ) {
        String reportFileId=SFAConvenzionamento.getConvenzioneDati(caseId).reportFileId;
        return CompassUtils.getReportUrl(reportFileId);
	}
 
 }