public class OCSAnnullaCancellazionePraticaInvoker {


//********************
// REQUEST
//********************
	public class Request extends OCSRequest {

		public AnnullaCancellazionePraticaDTO annullaCancellazionePraticaRequest {get; set;}

		public Request() {
			serviceId = 'annullaCancellazionePratica';
			annullaCancellazionePraticaRequest = new AnnullaCancellazionePraticaDTO();
		}

	}

	public class AnnullaCancellazionePraticaDTO {      
		public String tipoPratica {get; set;}
		public String numPratica {get; set;}
		public String dataInserimento {get; set;}

    }

//********************
// RESPONSE DTO
//********************

	public class Response extends OCSResponse {
		@AuraEnabled
		public AnnullaCancellazionePraticaResponseDTO annullaCancellazionePraticaResponse {get; set;} 
		
		/*
		public override boolean isOK() {    
			return super.isOK() && annullaCancellazionePraticaResponse.esito.equalsIgnoreCase('ok');
		} */
	}
	
	public class AnnullaCancellazionePraticaResponseDTO {        	
		@AuraEnabled public String esito{get;set;}         
    }



//********************
// INVOKER
//********************
	public static Response invoke (String tipoPratica, String numPratica, String dataInserimento ) {

		Request req = new Request();

		req.annullaCancellazionePraticaRequest.tipoPratica = tipoPratica; 
		req.annullaCancellazionePraticaRequest.numPratica = numPratica; 
		req.annullaCancellazionePraticaRequest.dataInserimento = dataInserimento; 


		return  (Response)ApiUtils.callApi ('ocs.annullaCancellazionePratica',req, Response.class, 'C' );

	}


//************************
// TEST
//*************************
//OCSAnnullaCancellazionePraticaInvoker.invoke('','1234','20190503');
}