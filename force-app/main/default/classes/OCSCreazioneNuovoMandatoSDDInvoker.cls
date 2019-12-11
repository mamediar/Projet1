public class OCSCreazioneNuovoMandatoSDDInvoker {

//********************
// REQUEST
//********************
	public class Request extends OCSRequest {
		@AuraEnabled
		public CreazioneNuovoMandatoSDDRequestDTO creazioneNuovoMandatoSDDRequest  {get; set;}

		public Request() {
			serviceId = 'creazioneNuovoMandatoSDD';
			creazioneNuovoMandatoSDDRequest = new CreazioneNuovoMandatoSDDRequestDTO();
		}
	}

	public class CreazioneNuovoMandatoSDDRequestDTO {
		@AuraEnabled public String tipoPratica {get; set;}
		@AuraEnabled public String numPratica {get; set;}
	}

//********************
// RESPONSE DTO
//********************

	public class Response extends OCSResponse {
		@AuraEnabled
		public CreazioneNuovoMandatoSDDResponseDTO creazioneNuovoMandatoSDDResponse {get; set;}

/*
		public override boolean isOK() {
			return super.isOK() && creazioneNuovoMandatoSDDResponse.esito.equalsIgnoreCase('ok');
		}

		public override string getMessage() {
			return super.getMessage().equalsIgnoreCase('success') ? creazioneNuovoMandatoSDDResponse.desErrore : super.getMessage();
		}*/

	}

	public class CreazioneNuovoMandatoSDDResponseDTO {
		@AuraEnabled public String esito {get; set;}
		@AuraEnabled public String mandato {get; set;}
		@AuraEnabled public String desErrore {get; set;}

	}





//********************
// INVOKER
//********************
	public static Response invoke (String tipoPratica, String numPratica ) {

		Request req = new Request();

		req.creazioneNuovoMandatoSDDRequest.tipoPratica = tipoPratica;
		req.creazioneNuovoMandatoSDDRequest.numPratica = numPratica;

		return  (Response)ApiUtils.callApi ('ocs.'+req.serviceId, req, Response.class, 'C' );

	}

	//********************
	// TEST
	//********************
	//OCSCreazioneNuovoMandatoSDD.call('CO','123');
}