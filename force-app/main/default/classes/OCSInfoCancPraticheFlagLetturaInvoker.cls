/**
 * @File Name          : OCSInfoCancPraticheFlagLetturaInvoker.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 22/10/2019, 11:54:58
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    18/10/2019   sabrina vitali     Initial Version
**/
public class OCSInfoCancPraticheFlagLetturaInvoker {

//********************
// REQUEST
//********************
	public class Request extends OCSRequest {

		public InfoCancellazionePraticheFlagLetturaRequestDTO infoCancellazionePraticheFlagLetturaRequest {get; set;}

		public Request() {
			serviceId = 'infoCancellazionePraticheFlagLettura';
			infoCancellazionePraticheFlagLetturaRequest = new InfoCancellazionePraticheFlagLetturaRequestDTO();
		}
	}

    public class InfoCancellazionePraticheFlagLetturaRequestDTO {      				
        public CancellazionePraticaDTO[] elenco {get; set;}
        
        public InfoCancellazionePraticheFlagLetturaRequestDTO(){
       		elenco = new List<CancellazionePraticaDTO>();
        }   
        
    }
    
    public class CancellazionePraticaDTO{
		public String tipoPratica {get; set;}
		public String numPratica {get; set;}
        public String ufficio {get; set;}
		public String dataInserimento {get; set;}
        public String esito {get; set;}
    }

//********************
// RESPONSE DTO
//********************

	public class Response extends OCSResponse {
		@AuraEnabled
		public InfoCancellazionePraticheFlagLetturaResponseDTO infoCancellazionePraticheFlagLetturaResponse {get; set;} 
	}
	
	    
    public class InfoCancellazionePraticheFlagLetturaResponseDTO {      				
        public String procedura {get;set;}
        public CancellazionePraticaDTO[] elenco {get; set;}
        
        public InfoCancellazionePraticheFlagLetturaResponseDTO(){
       		elenco = new List<CancellazionePraticaDTO>();
        }   
        
    }
    
    


//********************
// INVOKER
//********************

	public static Response invoke (InfoCancellazionePraticheFlagLetturaRequestDTO objectIn){
		Request req = new Request();		
		req.infoCancellazionePraticheFlagLetturaRequest = objectIn; 
        //non utilizzo serviceId perchè ho utilizzato un nome abbreviato in ApiRest (troppo lungo)
		//return 	(Response)ApiUtils.callApi ('ocs.'+req.serviceId, req, Response.class, 'C' );
        return 	(Response)ApiUtils.callApi ('ocs.'+'infoCancellazionePraticheFlgLett', req, Response.class, 'C' );
        
	}


/***********************
*   CHIAMATA PER TEST
************************/
/*
    OCSInfoCancPraticheFlagLetturaInvoker.Request req = new OCSInfoCancPraticheFlagLetturaInvoker.Request();

    req.infoCancellazionePraticheFlagLetturaRequest.numPratica  = '16504435'; 
    req.infoCancellazionePraticheFlagLetturaRequest.tipoPratica = 'CO'; 
    req.infoCancellazionePraticheFlagLetturaRequest.dataInserimento = '20160805'; 
    req.infoCancellazionePraticheFlagLetturaRequest.ufficio = ''; 
    req.infoCancellazionePraticheFlagLetturaRequest.esito = ''; 
    
    OCSInfoCancPraticheFlagLetturaInvoker.invoke(req.infoCancellazionePraticheFlagLetturaRequest);

    OCSInfoCancPraticheFlagLetturaInvoker.Request req = new OCSInfoCancPraticheFlagLetturaInvoker.Request();
    OCSInfoCancPraticheFlagLetturaInvoker.InfoCancellazionePraticheFlagLetturaRequestDTO elencoPratiche = new OCSInfoCancPraticheFlagLetturaInvoker.InfoCancellazionePraticheFlagLetturaRequestDTO();
    elencoPratiche.tipoSpesa='S';
    elencoPratiche.progressivo='319141';
    
    req.infoCancellazionePraticheFlagLetturaRequest.procedura = '';
    req.infoCancellazionePraticheFlagLetturaRequest.elenco.add(elencoPratiche);
    
    OCSInfoCancPraticheFlagLetturaInvoker.Response resp = OCSInfoCancPraticheFlagLetturaInvoker.invoke(req.infoCancellazionePraticheFlagLetturaRequest);
    system.debug ('*****'+resp.infoCancellazionePraticheFlagLetturaResponse);
    system.debug ('*****'+resp.infoCancellazionePraticheFlagLetturaResponse.elenco[0]);   

*/
	

}