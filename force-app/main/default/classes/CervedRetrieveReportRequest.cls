public class CervedRetrieveReportRequest extends OCSRequest {
	
	public CervedRetrieveReportRequestDTO cervedRetrieveReportRequest;

	public CervedRetrieveReportRequest() {
		serviceId = 'cervedRetrieveReport';
		this.cervedRetrieveReportRequest = new CervedRetrieveReportRequestDTO();
  	}

	public class CervedRetrieveReportRequestDTO {
		public Long reportCode {get; set;}
		public String documentFormat {get; set;}
		public Boolean dataObject {get; set;}
		public String documentType {get; set;}
	}

}