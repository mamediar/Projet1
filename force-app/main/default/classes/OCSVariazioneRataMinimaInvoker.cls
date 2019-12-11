/**
 * @File Name          : OCSVariazioneRataMinimaInvoker.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 18/10/2019, 17:02:16
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    17/10/2019   Federico Negro     Initial Version
**/
public class OCSVariazioneRataMinimaInvoker {


//********************
// REQUEST
//********************
	public class Request extends OCSRequest {

		public VariazioneRataMinimaRequestDTO variazioneRataMinimaRequest {get; set;}

		public Request() {
			serviceId = 'variazioneRataMinima';
			variazioneRataMinimaRequest = new VariazioneRataMinimaRequestDTO();
            //System.debug ('***** Variazione modalità invio EC: '+  variazioneModalitaInvioECRequest); 
		}

	}

    public class VariazioneRataMinimaRequestDTO {    
        public String provenienza {get; set;}
        public String tipoIntermediario {get; set;}
        public String intermediario {get; set;}
        public String procedura {get; set;}
        public String numPratica {get; set;}
        public String pagMinImporto {get; set;}
        public String pagMinPerc {get; set;}
        public String codiceRifExt {get; set;}
        public String codiceRifExt2 {get; set;}
        public String utente {get; set;}
    }

    //********************
    // RESPONSE DTO
    //********************
	public class Response extends OCSResponse {

		@AuraEnabled
		public VariazioneRataMinimaECResponseDTO variazioneRataMinimaResponse {get; set;} 
    
		public override boolean isOK() {    
			return super.isOK() && variazioneRataMinimaResponse.AS400Status.equalsIgnoreCase('OK');
		}     

		public override string getMessage() {
			return super.getMessage().equalsIgnoreCase('success') ? variazioneRataMinimaResponse.AS400Errore : super.getMessage();
		}   
	}

    public class VariazioneRataMinimaECResponseDTO {        	
        @AuraEnabled public String AS400Status{get;set;}
        @AuraEnabled public String AS400Errore{get;set;}   
    }
	    
    
    //********************
    // INVOKER
    //********************

	public static Response invoke (VariazioneRataMinimaRequestDTO objectIn){

		Request req = new Request();		
		req.variazioneRataMinimaRequest = objectIn; 
        //System.debug('Response: ' + req.variazioneModalitaInvioECRequest.utente + ' mail ' + req.variazioneModalitaInvioECRequest.email);
		return 	(Response)ApiUtils.callApi ('ocs.'+req.serviceId,req, Response.class, 'C' );


	}


/***********************
*   CHIAMATA PER TEST
************************/
	
/*
    	OCSVariazioneRataMinimaInvoker.Request req = new OCSVariazioneRataMinimaInvoker.Request();

        req.variazioneRataMinimaRequest.provenienza='CA';
        req.variazioneRataMinimaRequest.tipoIntermediario='AG';
      	req.variazioneRataMinimaRequest.intermediario='12';
        req.variazioneRataMinimaRequest.procedura='CA';
        req.variazioneRataMinimaRequest.numPratica='3106445466';
        req.variazioneRataMinimaRequest.pagMinImporto = '5000';
        req.variazioneRataMinimaRequest.pagMinPerc = '';
        req.variazioneRataMinimaRequest.codiceRifExt = '';
        req.variazioneRataMinimaRequest.codiceRifExt2 = '';
        req.variazioneRataMinimaRequest.utente='null';
        
        OCSVariazioneRataMinimaInvoker.Response res = OCSVariazioneRataMinimaInvoker.invoke(req.variazioneRataMinimaRequest);
        
        System.debug('RISPOSTA = '+res);
*/
	
}