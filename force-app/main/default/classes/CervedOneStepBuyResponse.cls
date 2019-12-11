public class CervedOneStepBuyResponse extends OCSResponse {

	public CervedOneStepBuyResponseDTO cervedOneStepBuyResponse {get; set;}
    
    public CervedOneStepBuyResponse() {

        this.cervedOneStepBuyResponse = new CervedOneStepBuyResponseDTO();
       
	}
    
    public class CervedOneStepBuyResponseDTO {
		public Long requestCode {get; set;}
	}

}