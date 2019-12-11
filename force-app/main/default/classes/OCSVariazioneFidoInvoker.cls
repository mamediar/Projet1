/**
 * @File Name          : OCSVariazioneFidoInvoker.cls
 * @Description        : 
 * @Author             : Lorenzo Marzocchi
 * @Group              : 
 * @Last Modified By   : Lorenzo Marzocchi
 * @Last Modified On   : 2019-8-13 16:17:35
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-8-13 16:17:35   Lorenzo Marzocchi     Initial Version
**/
public class OCSVariazioneFidoInvoker {


//********************
// REQUEST
//********************
	public class Request extends OCSRequest {

		public VariazioneFidoRequestDTO variazioneFidoRequest {get; set;}

		public Request() {
			serviceId = 'variazioneFido';
			variazioneFidoRequest = new VariazioneFidoRequestDTO();
            system.debug ('***** FIDO:'+  variazioneFidoRequest); 
		}

	}

    public class VariazioneFidoRequestDTO {      				
        public String provenienza {get; set;}
        public String tipoIntermediario {get; set;}
        public String intermediario {get; set;}
        public String procedura {get; set;}
        public String numPratica {get; set;}
        public String creditLimit {get; set;}
        public String risPrinc {get; set;}
        public String risSalvad {get; set;}
        public String risInternet {get; set;}
        public String pagMinImporto {get; set;}
        public String modalita {get; set;}
        public String risMulticonto {get; set;}
        public String codRifExt {get; set;}
        public String codRifExt2 {get; set;}
        public String utente {get; set;}
    }

    //********************
    // RESPONSE DTO
    //********************
	public class Response extends OCSResponse {
		@AuraEnabled
		public VariazioneFidoResponseDTO variazioneFidoResponse {get; set;} 
    
		public override boolean isOK() {    
			return super.isOK() && variazioneFidoResponse.AS400Status.equalsIgnoreCase('ok');
		}     


		public override string getMessage() {
			return super.getMessage().equalsIgnoreCase('success') ? variazioneFidoResponse.AS400Errore : super.getMessage();
		}   
		
	}



	
    public class VariazioneFidoResponseDTO {        	
			@AuraEnabled public String AS400Status{get;set;}
			@AuraEnabled public String AS400Errore{get;set;}        
    }
	    
    


    //********************
    // INVOKER
    //********************

	public static Response invoke (VariazioneFidoRequestDTO objectIn){

		Request req = new Request();		
		req.variazioneFidoRequest = objectIn; 
		return 	(Response)ApiUtils.callApi ('ocs.'+req.serviceId,req, Response.class, 'C' );
	}


/***********************
*   CHIAMATA PER TEST
************************/

	
/*
    	OCSVariazioneFidoInvoker.Request req = new OCSVariazioneFidoInvoker.Request();

      	req.variazioneFidoRequest.intermediario='12';
        req.variazioneFidoRequest.provenienza='CA';
        req.variazioneFidoRequest.tipoIntermediario='AG';
        req.variazioneFidoRequest.procedura='CA';
        req.variazioneFidoRequest.numPratica='51100039773';
        req.variazioneFidoRequest.codRifExt='';
        req.variazioneFidoRequest.codRifExt2='';
        req.variazioneFidoRequest.creditLimit='480000';
        req.variazioneFidoRequest.modalita='';
        req.variazioneFidoRequest.pagMinImporto='10000';
        req.variazioneFidoRequest.risInternet='';
        req.variazioneFidoRequest.risMulticonto='';
        req.variazioneFidoRequest.risPrinc='';
        req.variazioneFidoRequest.risSalvad='';
	
		OCSVariazioneFidoInvoker.invoke(req.variazioneFidoRequest);
*/
	

}