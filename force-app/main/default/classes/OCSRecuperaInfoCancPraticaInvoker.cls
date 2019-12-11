/**
 * @File Name          : OCSRecuperaInfoCancPraticaInvoker.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 1/10/2019, 16:42:23
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    1/10/2019   sabrina vitali     Initial Version
**/
public class OCSRecuperaInfoCancPraticaInvoker {


//********************
// REQUEST
//********************
	public class Request extends OCSRequest {

		public RecuperaInfoCancellazionePraticaRequestDTO recuperaInfoCancellazionePraticaRequest {get; set;}

		public Request() {
			serviceId = 'recuperaInfoCancellazionePratica';
			recuperaInfoCancellazionePraticaRequest = new RecuperaInfoCancellazionePraticaRequestDTO();
		}

	}

  public class RecuperaInfoCancellazionePraticaRequestDTO {      						
    }

//********************
// RESPONSE DTO
//********************

	public class Response extends OCSResponse {
		@AuraEnabled
		public RecuperaInfoCancellazionePraticaResponseDTO recuperaInfoCancellazionePraticaResponse {get; set;} 		
	}


    public class RecuperaInfoCancellazionePraticaResponseDTO{
        @AuraEnabled public List<InfoCancellazionePraticaDTO> elencoPratiche{get;set;}	

        public RecuperaInfoCancellazionePraticaResponseDTO() {        	
            elencoPratiche = new List<InfoCancellazionePraticaDTO>();
        }	          
    }

    public class InfoCancellazionePraticaDTO{
        @AuraEnabled public String numPratica{get;set;}
        @AuraEnabled public String tipoPratica{get;set;}
        @AuraEnabled public String dataInserimento{get;set;}
        @AuraEnabled public String flagCancellazionePratica{get;set;}
        @AuraEnabled public String motivoMancataCancellazione{get;set;}
        @AuraEnabled public String tipoPraticaCongiunta{get;set;}
        @AuraEnabled public String numPraticaCongiunta{get;set;}
        @AuraEnabled public String flagCancellazionePraticaCongiunta{get;set;}
        @AuraEnabled public String motivoMancataCancellazioneCongiunta{get;set;}
        @AuraEnabled public String dataElaborazioneOCS{get;set;}
        @AuraEnabled public String flagCancellazioneSic{get;set;}
        @AuraEnabled public String noteCancellazioneSic{get;set;}
        @AuraEnabled public List<InfoCancellazioneAnagraficaDTO> elencoAnagrafiche{get;set;}	

         public InfoCancellazionePraticaDTO() {        	
            elencoAnagrafiche = new List<InfoCancellazioneAnagraficaDTO>();
        }
    }

    public class InfoCancellazioneAnagraficaDTO{
        @AuraEnabled public String tipoPratica{get;set;}
        @AuraEnabled public String numPratica {get;set;}
        @AuraEnabled public String tipoControparte {get;set;}
        @AuraEnabled public String codControparte {get;set;}
        @AuraEnabled public String flagCancellazione {get;set;}
        @AuraEnabled public String motivoMancataCancellazione {get;set;}
        @AuraEnabled public String dataElaborazioneOCS {get;set;}
        @AuraEnabled public String flagCancellazioneSic {get;set;}
        @AuraEnabled public String noteCancellazioneSic {get;set;}
    }

    
       


//********************
// INVOKER
//********************

	public static Response invoke (){

		Request req = new Request();		
		//req.recuperaInfoCancellazionePraticaRequest = objectIn; 
		return 	(Response)ApiUtils.callApi ('ocs.'+req.serviceId,req, Response.class, 'C' );
	}


/***********************
*   CHIAMATA PER TEST
************************/	
/*
    OCSRecuperaInfoCancPraticaInvoker.Request req = new OCSRecuperaInfoCancPraticaInvoker.Request();
    OCSRecuperaInfoCancPraticaInvoker.invoke();
*/
	

}