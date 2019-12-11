/**
 * @File Name          : OCSEseguiAzioneRecuperoInvoker.cls
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 16/10/2019, 09:25:12
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    16/10/2019   Andrea Vanelli     Initial Version
**/
public class OCSEseguiAzioneRecuperoInvoker {


//********************
// REQUEST
//********************
	public class Request extends OCSRequest {
        
        public EseguiAzioneRecuperoRequestDTO eseguiAzioneRecuperoRequest{get; set;}

		public Request() {
			serviceId = 'eseguiAzioneRecupero';
            this.eseguiAzioneRecuperoRequest=new EseguiAzioneRecuperoRequestDTO();
		}


	}

	public class EseguiAzioneRecuperoRequestDTO {
		public String tipoPratica {get; set;}
		public String numPratica {get; set;}
		public String azione {get; set;}
		public String esito {get; set;}
		public String tipoScadenza {get; set;}
		public String dataScadenza {get; set;}
		public String oraScadenza {get; set;}
		public String recuperatore {get; set;}
		public String operatore {get; set;}
		public String classificazione {get; set;}
		public String note {get; set;}
	}

//********************
// RESPONSE DTO
//********************

	public class Response extends OCSResponse {
		@AuraEnabled
		public EseguiAzioneRecuperoResponseDTO eseguiAzioneRecuperoResponse {get; set;}

		public Response() {
		}
	}

	public class EseguiAzioneRecuperoResponseDTO {
		// ritorno dal servizio
		@AuraEnabled public String esito {get; set;}
		@AuraEnabled public String desErrore {get; set;}
	}


//********************
// INVOKER
//********************

	public static Response invoke (EseguiAzioneRecuperoRequestDTO objectIn){

		Request req = new Request();
		req.eseguiAzioneRecuperoRequest = objectIn;

		return (Response)ApiUtils.callApi ('ocs.'+req.serviceId,req, Response.class, 'C' );
        
	}


/***********************
 *   CHIAMATA PER TEST
 ************************/
// AV TODO da provare
//OCSEseguiAzioneRecuperoInvoker.invoke();


}