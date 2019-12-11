public class OCSVariazioneTelefoniInvoker {


//********************
// REQUEST
//********************
	public class Request extends OCSRequest {

		public OCSVariazioneTelefoniRequestDTO variazioneTelefoniRequest {get; set;}

		public Request() {
			serviceId = 'variazioneTelefoni';
			variazioneTelefoniRequest = new OCSVariazioneTelefoniRequestDTO();
		}

	}

  public class OCSVariazioneTelefoniRequestDTO {      				
		public String flagForzaValidazione {get; set;}
		public String flagFisso {get; set;}
		public String flagCellulare {get; set;}
		public String flagAlternativo {get; set;}
		public String flagFax {get; set;}
		public String codCliente {get; set;}
		public String telFisso {get; set;}
		public String telCellulare {get; set;}
		public String telAlternativo {get; set;}
		public String telFax {get; set;}
    }

//********************
// RESPONSE DTO
//********************

	public class Response extends OCSResponse {
		@AuraEnabled
		public VariazioneTelefoniResponseDTO variazioneTelefoniResponse {get; set;} 
    
		public override boolean isOK() {    
			return super.isOK() && variazioneTelefoniResponse.esitoElaborazione.equalsIgnoreCase('ok');
		}     


		public override string getMessage() {
			return super.getMessage().equalsIgnoreCase('success') ? variazioneTelefoniResponse.esitoElaborazione : super.getMessage();
		}    
		
	}
	
    public class VariazioneTelefoniResponseDTO {        	
			@AuraEnabled public String dataElaborazione{get;set;}
			@AuraEnabled public String oraElaborazione{get;set;}
			@AuraEnabled public String utenteElaborazione{get;set;}
			@AuraEnabled public String esitoElaborazione{get;set;}         
    }
	    
    


//********************
// INVOKER
//********************

	public static Response invoke (OCSVariazioneTelefoniRequestDTO objectIn){

		Request req = new Request();		
		req.variazioneTelefoniRequest = objectIn; 
		return 	(Response)ApiUtils.callApi ('ocs.'+req.serviceId,req, Response.class, 'C' );
	}


/***********************
*   CHIAMATA PER TEST
************************/

	
/*
    OCSVariazioneTelefoniInvoker.Request req = new OCSVariazioneTelefoniInvoker.Request();

		req.variazioneTelefoniRequest.flagForzaValidazione = 'S'; 
		req.variazioneTelefoniRequest.flagFisso = ''; 
		req.variazioneTelefoniRequest.flagCellulare = ''; 
		req.variazioneTelefoniRequest.flagAlternativo = 'M'; 
		req.variazioneTelefoniRequest.flagFax = ''; 
		req.variazioneTelefoniRequest.codCliente = '1234'; 
		req.variazioneTelefoniRequest.telFisso = ''; 
		req.variazioneTelefoniRequest.telCellulare = ''; 
		req.variazioneTelefoniRequest.telAlternativo = '333555888'; 
		req.variazioneTelefoniRequest.telFax = '';  	
		OCSVariazioneTelefoniInvoker.invoke(req.variazioneTelefoniRequest);
*/
	

}