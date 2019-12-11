/**
 * @File Name          : OCSInserisciCancellazionePraticheInvoker.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 22/10/2019, 11:54:46
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    22/10/2019   sabrina vitali     Initial Version
**/
public class OCSInserisciCancellazionePraticheInvoker {

//********************
// REQUEST
//********************
	public class Request extends OCSRequest {

		public InserisciCancellazionePraticheRequestDTO inserisciCancellazionePraticheRequest {get; set;}

		public Request() {
			serviceId = 'inserisciCancellazionePratiche';
			inserisciCancellazionePraticheRequest = new InserisciCancellazionePraticheRequestDTO();
		}
	}

    public class InserisciCancellazionePraticheRequestDTO {      				
        public CancellazionePraticaDTO[] elenco {get; set;}
        
        public InserisciCancellazionePraticheRequestDTO(){
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
		public InserisciCancellazionePraticheResponseDTO inserisciCancellazionePraticheResponse {get; set;} 
	}
	
	    
    public class InserisciCancellazionePraticheResponseDTO {      				
        public String procedura {get;set;}
        public CancellazionePraticaDTO[] elenco {get; set;}
        
        public InserisciCancellazionePraticheResponseDTO(){
       		elenco = new List<CancellazionePraticaDTO>();
        }   
        
    }
    
    


//********************
// INVOKER
//********************

	public static Response invoke (InserisciCancellazionePraticheRequestDTO objectIn){
		Request req = new Request();		
		req.inserisciCancellazionePraticheRequest = objectIn; 
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
    req.inserisciCancellazionePraticaRequest.esito = ''; 
    
    OCSInserisciCancellazionePraticaInvoker.invoke(req.inserisciCancellazionePraticaRequest);

    OCSInserisciCancellazionePraticaInvoker.Request req = new OCSInserisciCancellazionePraticaInvoker.Request();
    OCSInserisciCancellazionePraticaInvoker.InserisciCancellazionePraticheRequestDTO elencoPratiche = new OCSInserisciCancellazionePraticaInvoker.InserisciCancellazionePraticheRequestDTO();
    elencoPratiche.tipoSpesa='S';
    elencoPratiche.progressivo='319141';
    
    req.inserisciCancellazionePraticheRequest.procedura = '';
    req.inserisciCancellazionePraticheRequest.elenco.add(elencoPratiche);
    
    
    
    OCSInserisciCancellazionePraticaInvoker.Response resp = OCSInserisciCancellazionePraticaInvoker.invoke(req.inserisciCancellazionePraticheRequest);
    system.debug ('*****'+resp.inserisciCancellazionePraticheResponse);
    system.debug ('*****'+resp.inserisciCancellazionePraticheResponse.elenco[0]);   

*/
	

}