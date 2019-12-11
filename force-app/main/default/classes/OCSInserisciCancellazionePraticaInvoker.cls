public class OCSInserisciCancellazionePraticaInvoker {


//********************
// REQUEST
//********************
	public class Request extends OCSRequest {

		public InserisciCancellazionePraticaRequestDTO inserisciCancellazionePraticaRequest {get; set;}

		public Request() {
			serviceId = 'inserisciCancellazionePratica';
			inserisciCancellazionePraticaRequest = new InserisciCancellazionePraticaRequestDTO();
		}

	}

    public class InserisciCancellazionePraticaRequestDTO {      				
		public String tipoPratica {get; set;}
		public String numPratica {get; set;}
        public String ufficio {get; set;}
		public String dataInserimento {get; set;}
    }

//********************
// RESPONSE DTO
//********************

	public class Response extends OCSResponse {
		@AuraEnabled
		public InserisciCancellazionePraticaResponseDTO inserisciCancellazionePraticaResponse {get; set;} 

		public override string getMessage() {
			return super.getMessage().equalsIgnoreCase('success') ? inserisciCancellazionePraticaResponse.esito : super.getMessage();
		}    
		
	}
	
    public class InserisciCancellazionePraticaResponseDTO {        	
			@AuraEnabled public String esito{get;set;}			
    }
	    
    


//********************
// INVOKER
//********************

	public static Response invoke (InserisciCancellazionePraticaRequestDTO objectIn){
		Request req = new Request();		
		req.inserisciCancellazionePraticaRequest = objectIn; 
		return 	(Response)ApiUtils.callApi ('ocs.'+req.serviceId, req, Response.class, 'C' );
	}


/***********************
*   CHIAMATA PER TEST
************************/
/*
    OCSInserisciCancellazionePraticaInvoker.Request req = new OCSInserisciCancellazionePraticaInvoker.Request();

    req.inserisciCancellazionePraticaRequest.numPratica  = '16504435'; 
    req.inserisciCancellazionePraticaRequest.tipoPratica = 'CO'; 
    req.inserisciCancellazionePraticaRequest.dataInserimento = '20160805'; 
    req.inserisciCancellazionePraticaRequest.ufficio = ''; 
    
    OCSInserisciCancellazionePraticaInvoker.invoke(req.inserisciCancellazionePraticaRequest);
*/
	

}