public class CervedRetrieveReportResponse extends OCSResponse {

	public CervedRetrieveReportResponseDTO cervedRetrieveReportResponse {get; set;}
    
    public CervedRetrieveReportResponse() {

        this.cervedRetrieveReportResponse = new CervedRetrieveReportResponseDTO();
       
	}
    
    public class CervedRetrieveReportResponseDTO {
		public Blob document {get; set;}
	}

}