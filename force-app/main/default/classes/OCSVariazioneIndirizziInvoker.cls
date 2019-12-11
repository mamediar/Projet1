public class OCSVariazioneIndirizziInvoker {


//********************
// REQUEST
//********************
	public class Request extends OCSRequest {

		public OCSVariazioneIndirizziRequestDTO variazioneIndirizziRequest {get; set;}

		public Request() {
			serviceId = 'variazioneIndirizzi';
			variazioneIndirizziRequest = new OCSVariazioneIndirizziRequestDTO();
		}

	}

    
    public class OCSVariazioneIndirizziRequestDTO {      
						
		public String flagResidenza {get; set;}
		public String flagDomicilio {get; set;}
		public String flagIndPrecedente {get; set;}
		public String codCliente {get; set;}
		public String residenzaIndirizzo1 {get; set;} 
		public String residenzaIndirizzo2 {get; set;} 
		public String residenzaCap {get; set;} 
		public String residenzaLocalita {get; set;} 
		public String residenzaProvincia {get; set;} 
		public String domicilioIndirizzo1 {get; set;} 
		public String domicilioIndirizzo2 {get; set;} 
		public String domicilioCap {get; set;} 
		public String domicilioLocalita {get; set;} 
		public String domicilioProvincia {get; set;} 
		public String precedenteIndirizzo1 {get; set;} 
		public String precedenteIndirizzo2 {get; set;} 
		public String precedenteCap {get; set;} 
		public String precedenteLocalita {get; set;} 
		public String precedenteProvincia {get; set;}

    }
	
	
	

//********************
// RESPONSE DTO
//********************

	public class Response extends OCSResponse {
		@AuraEnabled
		public VariazioneIndirizziResponseDTO variazioneIndirizziResponse {get; set;} 
    /*
		public override boolean isOK() {    
			return super.isOK() && variazioneIndirizziResponse.esitoElaborazione.equalsIgnoreCase('ok');
		} */
	}
	
    public class VariazioneIndirizziResponseDTO {        	
		@AuraEnabled public String dataElaborazione{get;set;}
		@AuraEnabled public String oraElaborazione{get;set;}
		@AuraEnabled public String utenteElaborazione{get;set;}
		@AuraEnabled public String esitoElaborazione{get;set;}         
	}
	    

//********************
// INVOKER
//********************

    public static Response invoke(OCSVariazioneIndirizziRequestDTO objectIn){
        Request req = new Request();
        req.variazioneIndirizziRequest = objectIn;
	
		return  (Response)ApiUtils.callApi ('ocs.'+req.serviceId,req, Response.class, 'C' );
    }

/**********************
*  CHIAMATA PER I TEST
***********************/
/*
OCSVariazioneIndirizziInvoker.Request req = new OCSVariazioneIndirizziInvoker.Request();
req.variazioneIndirizziRequest.flagResidenza = 'S';
req.variazioneIndirizziRequest.flagDomicilio = 'M';
req.variazioneIndirizziRequest.flagIndPrecedente = 'A';
req.variazioneIndirizziRequest.codCliente = '1234';
req.variazioneIndirizziRequest.residenzaIndirizzo1 = '';
req.variazioneIndirizziRequest.residenzaIndirizzo2 = '';
req.variazioneIndirizziRequest.residenzaCap = '20020';
req.variazioneIndirizziRequest.residenzaLocalita = 'LAINATE';
req.variazioneIndirizziRequest.residenzaProvincia = 'MI';
req.variazioneIndirizziRequest.domicilioIndirizzo1 = 'VIALE CERTOSA 14';
req.variazioneIndirizziRequest.domicilioIndirizzo2 = '';
req.variazioneIndirizziRequest.domicilioCap = '20155';
req.variazioneIndirizziRequest.domicilioLocalita = 'MILANO';
req.variazioneIndirizziRequest.domicilioProvincia = 'MI';
req.variazioneIndirizziRequest.precedenteIndirizzo1 = '';
req.variazioneIndirizziRequest.precedenteIndirizzo2 = '';
req.variazioneIndirizziRequest.precedenteCap = '';
req.variazioneIndirizziRequest.precedenteLocalita = '';
req.variazioneIndirizziRequest.precedenteProvincia = '';
OCSVariazioneIndirizziInvoker.invoke(req.variazioneIndirizziRequest);
*/


}