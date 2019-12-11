public class OCSInfoCancPraticaFlagLetturaInvoker {


//********************
// REQUEST
//********************
	public class Request extends OCSRequest {

		public InfoCancellazionePraticaFlagLetturaRequestDTO infoCancellazionePraticaFlagLetturaRequest {get; set;}

		public Request() {
			serviceId = 'infoCancellazionePraticaFlagLettura';
			infoCancellazionePraticaFlagLetturaRequest = new InfoCancellazionePraticaFlagLetturaRequestDTO();
		}

	}

  public class InfoCancellazionePraticaFlagLetturaRequestDTO {      				
		public String tipoPratica {get; set;}
		public String numPratica {get; set;}
		public String dataInserimento {get; set;}
    }

//********************
// RESPONSE DTO
//********************

	public class Response extends OCSResponse {
		@AuraEnabled
		public InfoCancellazionePraticaFlagLetturaResponseDTO infoCancellazionePraticaFlagLetturaResponse {get; set;} 

		public override string getMessage() {
			return super.getMessage().equalsIgnoreCase('success') ? infoCancellazionePraticaFlagLetturaResponse.esito : super.getMessage();
		}    
		
	}
	
    public class InfoCancellazionePraticaFlagLetturaResponseDTO {        	
			@AuraEnabled public String esito{get;set;}			
    }
	    
    


//********************
// INVOKER
//********************

	public static Response invoke (InfoCancellazionePraticaFlagLetturaRequestDTO objectIn){
		Request req = new Request();		
		req.infoCancellazionePraticaFlagLetturaRequest = objectIn; 
		return 	(Response)ApiUtils.callApi ('ocs.infoCancPraticaFlagLettura', req, Response.class, 'C' );
	}


/***********************
*   CHIAMATA PER TEST
************************/
/*
    OCSInfoCancPraticaFlagLetturaInvoker.Request req = new OCSInfoCancPraticaFlagLetturaInvoker.Request();

    req.infoCancellazionePraticaFlagLetturaRequest.numPratica  = '16504435'; 
    req.infoCancellazionePraticaFlagLetturaRequest.tipoPratica = 'CO'; 
    req.infoCancellazionePraticaFlagLetturaRequest.dataInserimento = '20160805'; 
    
    OCSInfoCancPraticaFlagLetturaInvoker.invoke(req.infoCancellazionePraticaFlagLetturaRequest);
*/
	

}