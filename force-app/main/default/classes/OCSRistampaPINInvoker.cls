/**
 * @File Name          : OCSRistampaPINInvoker.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 12/9/2019, 14:39:24
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    12/9/2019   sabrina vitali     Initial Version
**/
public class OCSRistampaPINInvoker {


//********************
// REQUEST
//********************
	public class Request extends OCSRequest {

		public RistampaPinRequestDTO ristampaPinRequest {get; set;}

		public Request() {
			serviceId = 'ristampaPin';
			ristampaPinRequest = new RistampaPinRequestDTO();
		}

	}

  public class RistampaPinRequestDTO {      				
		public String intermediario {get; set;}
		public String provenienza {get; set;}
		public String tipoIntermediario {get; set;}
		public String numCarta {get; set;}
		public String pan {get; set;}
		public String ricalcoloPin {get; set;}
		public String rifEsterno2 {get; set;}
		public String addebitoCommissioni {get; set;}
    }

//********************
// RESPONSE DTO
//********************

	public class Response extends OCSResponse {
		@AuraEnabled
		public RistampaPinResponseDTO ristampaPinResponse {get; set;} 
    
		public override boolean isOK() {           
			return super.isOK();
		}     


		public override string getMessage() {
			return super.getMessage().equalsIgnoreCase('success') ? ristampaPinResponse.as400Errore : super.getMessage();
		}    
		
	}
	
    public class RistampaPinResponseDTO {        	
			@AuraEnabled public String as400Status{get;set;}
			@AuraEnabled public String as400Errore{get;set;}
    }
	    
    


//********************
// INVOKER
//********************

	public static Response invoke (RistampaPinRequestDTO objectIn){

		Request req = new Request();		
		req.ristampaPinRequest = objectIn; 
		return 	(Response)ApiUtils.callApi ('ocs.'+req.serviceId,req, Response.class, 'C' );
	}


}