public class OCSLiquidazioneAcquistiInvoker {


//********************
// REQUEST
//********************
	public class Request extends OCSRequest {

		public DatiLiquidazioneAcquistiRequestDTO datiLiquidazioneAcquistiRequest {get; set;}

		public Request() {
			serviceId = 'liquidazioneAcquisti';
			datiLiquidazioneAcquistiRequest = new DatiLiquidazioneAcquistiRequestDTO();
		}
		
		public Request(DatiLiquidazioneAcquistiRequestDTO objectIn) {        
			serviceId = 'liquidazioneAcquisti';
			datiLiquidazioneAcquistiRequest = objectIn;
		}

	}

	public class DatiLiquidazioneAcquistiRequestDTO {      				
      public String emettitore {get; set;}
      public String protocollo {get; set;}
      public String formaPagamento {get; set;}
      public String tipoDestErogazione {get; set;}
      public String docDaEmettere {get; set;}
      public String bancaInterna {get; set;}
      public String utente {get; set;}
    }

//********************
// RESPONSE DTO
//********************

	public class Response extends OCSResponse {
		@AuraEnabled
		public DatiLiquidazioneAcquistiResponseDTO datiLiquidazioneAcquistiResponse {get; set;}
		
		/*
		public override boolean isOK() {    
			return super.isOK() && datiLiquidazioneAcquistiResponse.AS400Status.equalsIgnoreCase('ok');
		}
		
		
		public override string getMessage() {
			return super.getMessage().equalsIgnoreCase('success') && isOK() ? super.getMessage() : datiLiquidazioneAcquistiResponse.AS400Errore;
		} */
		
	}
	
    public class DatiLiquidazioneAcquistiResponseDTO {        	
      @AuraEnabled public String AS400Status{get;set;}
      @AuraEnabled public String AS400Errore{get;set;}
    }
	    
    


//********************
// INVOKER
//********************
	public static Response invoke (DatiLiquidazioneAcquistiRequestDTO objectIn ) {        

		Request req = new Request();       
    req.datiLiquidazioneAcquistiRequest = objectIn;

		return (Response)ApiUtils.callApi ('ocs.'+req.serviceId, req, Response.class, 'C' );

	}



	/**
	*  TEST
	**/
	/*
	OCSLiquidazioneAcquistiInvoker.Request req = new OCSLiquidazioneAcquistiInvoker.Request();
	req.datiLiquidazioneAcquistiRequest.emettitore = '15';
	req.datiLiquidazioneAcquistiRequest.protocollo = '1387977';
	req.datiLiquidazioneAcquistiRequest.formaPagamento = 'C';
	req.datiLiquidazioneAcquistiRequest.bancaInterna = '25';
	req.datiLiquidazioneAcquistiRequest.tipoDestErogazione = 'CL';
	req.datiLiquidazioneAcquistiRequest.docDaEmettere = 'D';
	req.datiLiquidazioneAcquistiRequest.utente = '';
	OCSLiquidazioneAcquistiInvoker.invoke(req.datiLiquidazioneAcquistiRequest);
	*/


}