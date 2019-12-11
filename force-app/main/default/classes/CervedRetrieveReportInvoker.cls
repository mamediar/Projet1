public class CervedRetrieveReportInvoker {

	public static CervedRetrieveReportResponse retrieveGlobalExpert(Long reportCode, String documentFormat, Boolean dataObject, String documentType) {

		CervedRetrieveReportRequest request = new CervedRetrieveReportRequest();
		request.cervedRetrieveReportRequest.reportCode = reportCode;
		request.cervedRetrieveReportRequest.documentFormat = documentFormat;
		request.cervedRetrieveReportRequest.dataObject = dataObject;
		request.cervedRetrieveReportRequest.documentType = documentType;
		
		return (CervedRetrieveReportResponse) ApiUtils.callApi('cerved.retrieveReport', request, CervedRetrieveReportResponse.class);

    }

}