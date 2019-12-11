/**
 * @File Name          : OCSVariazioneModInvioECInvoker.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 17/10/2019, 12:02:09
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    11/10/2019   Federico Negro     Initial Version
**/
public class OCSVariazioneModInvioECInvoker {


//********************
// REQUEST
//********************
	public class Request extends OCSRequest {

		public VariazioneModalitaInvioECRequestDTO variazioneModalitaInvioECRequest {get; set;}

		public Request() {
			serviceId = 'variazioneModalitaInvioEC';
			variazioneModalitaInvioECRequest = new VariazioneModalitaInvioECRequestDTO();
            //System.debug ('***** Variazione modalità invio EC: '+  variazioneModalitaInvioECRequest); 
		}

	}

    public class VariazioneModalitaInvioECRequestDTO {    
        public String provenienza {get; set;}
        public String tipoIntermediario {get; set;}
        public String intermediario {get; set;}
        public String procedura {get; set;}
        public String numPratica {get; set;}
        public String pan {get; set;}
        public String modInvioEC {get; set;}
        public String overrideCommProd {get; set;}
        public String commInvioEC {get; set;}
        public String tipoDestEC {get; set;}
        public String tipoDestECFlag {get; set;}
        public String email {get; set;}
        public String utente {get; set;}
    }

    //********************
    // RESPONSE DTO
    //********************
	public class Response extends OCSResponse {

		@AuraEnabled
		public VariazioneModalitaInvioECResponseDTO variazioneModalitaInvioECResponse {get; set;} 
    
		public override boolean isOK() {    
			return super.isOK() && variazioneModalitaInvioECResponse.AS400Status.equalsIgnoreCase('');
		}     


		public override string getMessage() {
			return super.getMessage().equalsIgnoreCase('success') ? variazioneModalitaInvioECResponse.AS400Errore : super.getMessage();
		}   

	}

    public class VariazioneModalitaInvioECResponseDTO {        	
        @AuraEnabled public String AS400Status{get;set;}
        @AuraEnabled public String AS400Errore{get;set;}   
        @AuraEnabled public String panNuovo{get;set;}
    }
	    
    
    //********************
    // INVOKER
    //********************

	public static Response invoke (VariazioneModalitaInvioECRequestDTO objectIn){

		Request req = new Request();		
		req.variazioneModalitaInvioECRequest = objectIn; 
        //System.debug('Response: ' + req.variazioneModalitaInvioECRequest.utente + ' mail ' + req.variazioneModalitaInvioECRequest.email);
		return 	(Response)ApiUtils.callApi ('ocs.'+req.serviceId,req, Response.class, 'C' );


	}


/***********************
*   CHIAMATA PER TEST
************************/
	
/*
    	OCSVariazioneModInvioECInvoker.Request req = new OCSVariazioneModInvioECInvoker.Request();

        req.variazioneModalitaInvioECRequest.provenienza='CA';
        req.variazioneModalitaInvioECRequest.tipoIntermediario='AG';
      	req.variazioneModalitaInvioECRequest.intermediario='12';
        req.variazioneModalitaInvioECRequest.procedura='CA';
        req.variazioneModalitaInvioECRequest.numPratica='8180824247';
        req.variazioneModalitaInvioECRequest.pan='';
        req.variazioneModalitaInvioECRequest.modInvioEC='I';
        req.variazioneModalitaInvioECRequest.overrideCommProd='N';
        req.variazioneModalitaInvioECRequest.commInvioEC='';
        req.variazioneModalitaInvioECRequest.tipoDestEC='';
        req.variazioneModalitaInvioECRequest.tipoDestECFlag='';
        req.variazioneModalitaInvioECRequest.email='pasquale.cangianiello@compass.it';
        req.variazioneModalitaInvioECRequest.utente='null';
        
        OCSVariazioneModInvioECInvoker.Response res = OCSVariazioneModInvioECInvoker.invoke(req.variazioneModalitaInvioECRequest);
        
        System.debug('RISPOSTA = '+res);
*/
	
}