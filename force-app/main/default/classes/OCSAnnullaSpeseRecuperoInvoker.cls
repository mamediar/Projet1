public class OCSAnnullaSpeseRecuperoInvoker {

    //********************
    // REQUEST
    //********************
	public class Request extends OCSRequest {

		public AnnullaSpeseRecuperoRequestDTO annullaSpeseRecuperoRequest {get; set;}  

		public Request() {
			serviceId = 'annullaSpeseRecupero';
            annullaSpeseRecuperoRequest = new AnnullaSpeseRecuperoRequestDTO();
		}

	}

    public class AnnullaSpeseRecuperoRequestDTO {      
				
		public String tipoPratica {get; set;}
		public String numPratica {get; set;}
	    public SpesaRecuperoDaAnnullareDTO[] elencoSpeseDaAnnullare {get; set;}

        public AnnullaSpeseRecuperoRequestDTO(){
       		elencoSpeseDaAnnullare = new List<SpesaRecuperoDaAnnullareDTO>();
        }   
    }

    public class SpesaRecuperoDaAnnullareDTO {      				
		public String tipoSpesa {get; set;}
		public String progressivo {get; set;}
    }
    

    //********************
    // RESPONSE DTO
    //********************
	public class Response extends OCSResponse {
		@AuraEnabled public AnnullaSpeseRecuperoResponseDTO annullaSpeseRecuperoResponse {get; set;} 
	}

    public class AnnullaSpeseRecuperoResponseDTO{
        @AuraEnabled public List<String> elencoErrori{get;set;}	

        public AnnullaSpeseRecuperoResponseDTO() {        	
            elencoErrori = new List<String>();
        }	          
    }
    
	
	    

    //********************
    // INVOKER
    //********************
	public static Response invoke (AnnullaSpeseRecuperoRequestDTO objectIn){

        Request req = new Request();		
        req.annullaSpeseRecuperoRequest = objectIn; 
        return 	(Response)ApiUtils.callApi ('ocs.'+req.serviceId,req, Response.class, 'C' );
	}

	
/***********************
*   CHIAMATA PER TEST
************************/
/*
OCSAnnullaSpeseRecuperoInvoker.Request req = new OCSAnnullaSpeseRecuperoInvoker.Request();
OCSAnnullaSpeseRecuperoInvoker.SpesaRecuperoDaAnnullareDTO elencoSpeseDaAnnullareIn	 = new OCSAnnullaSpeseRecuperoInvoker.SpesaRecuperoDaAnnullareDTO();
elencoSpeseDaAnnullareIn.tipoSpesa='S';
elencoSpeseDaAnnullareIn.progressivo='319141';

req.annullaSpeseRecuperoRequest.tipoPratica = 'CA';
req.annullaSpeseRecuperoRequest.numPratica = '2102414072';
req.annullaSpeseRecuperoRequest.elencoSpeseDaAnnullare.add(elencoSpeseDaAnnullareIn);



OCSAnnullaSpeseRecuperoInvoker.Response resp = OCSAnnullaSpeseRecuperoInvoker.invoke(req.annullaSpeseRecuperoRequest);
system.debug ('*****'+resp.annullaSpeseRecuperoResponse);
system.debug ('*****'+resp.annullaSpeseRecuperoResponse.elencoErrori[0]);   
*/
}