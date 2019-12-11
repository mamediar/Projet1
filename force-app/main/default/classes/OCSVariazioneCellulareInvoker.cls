public class OCSVariazioneCellulareInvoker {


//********************
// REQUEST
//********************
	public class Request extends OCSRequest {

		public OCSVariazioneCellulareRequestDTO variazioneCellulareRequest {get; set;}

		public Request() {
			serviceId = 'variazioneCellulare';
			variazioneCellulareRequest = new OCSVariazioneCellulareRequestDTO();
		}

	}

  public class OCSVariazioneCellulareRequestDTO {      				
		public String provenienza {get; set;}
		public String tipoIntermediario {get; set;}
		public String intermediario {get; set;}
		public String procedura {get; set;}
		public String numPratica {get; set;}
		public String cellulare {get; set;}
		public String pan {get; set;}
		public String operatoreTel {get; set;}
		public String codRifExt {get; set;}
		public String utente {get; set;}
    }

//********************
// RESPONSE DTO
//********************

	public class Response extends OCSResponse {
		@AuraEnabled
		public VariazioneCellulareResponseDTO variazioneCellulareResponse {get; set;} 
    
		public override boolean isOK() {           
			return super.isOK();
		}     


		public override string getMessage() {
			return super.getMessage().equalsIgnoreCase('success') ? variazioneCellulareResponse.as400Errore : super.getMessage();
		}    
		
	}
	
    public class VariazioneCellulareResponseDTO {        	
			@AuraEnabled public String as400Status{get;set;}
			@AuraEnabled public String as400Errore{get;set;}
    }
	    
    


//********************
// INVOKER
//********************

	public static Response invoke (OCSVariazioneCellulareRequestDTO objectIn){

		Request req = new Request();		
		req.variazioneCellulareRequest = objectIn; 
		return 	(Response)ApiUtils.callApi ('ocs.'+req.serviceId,req, Response.class, 'C' );
	}


/***********************
*   CHIAMATA PER TEST
************************/

	
/*
    OCSVariazioneCellulareInvoker.Request req = new OCSVariazioneCellulareInvoker.Request();

		req.variazioneCellulareRequest.flagForzaValidazione = 'S'; 
		req.variazioneCellulareRequest.flagFisso = ''; 
		req.variazioneCellulareRequest.flagCellulare = ''; 
		req.variazioneCellulareRequest.flagAlternativo = 'M'; 
		req.variazioneCellulareRequest.flagFax = ''; 
		req.variazioneCellulareRequest.codCliente = '1234'; 
		req.variazioneCellulareRequest.telFisso = ''; 
		req.variazioneCellulareRequest.telCellulare = ''; 
		req.variazioneCellulareRequest.telAlternativo = '333555888'; 
		req.variazioneCellulareRequest.telFax = '';  	
		OCSVariazioneCellulareInvoker.invoke(req.variazioneCellulareRequest);
*/
	

}