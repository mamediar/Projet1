/**
 * @File Name          : OCSrecuperaDatiStampaPraticaInvoker.cls
 * @Description        : 
 * @Author             : Lorenzo Marzocchi
 * @Group              : 
 * @Last Modified By   : Lorenzo Marzocchi
 * @Last Modified On   : 2019-9-23 14:00:30
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    2019-9-23   Lorenzo Marzocchi     Initial Version
**/
public class OCSrecuperaDatiStampaPraticaInvoker {


//********************
// REQUEST
//********************
	public class Request extends OCSRequest {

		public recuperaDatiStampaPraticaRequestDTO recuperaDatiStampaPraticaRequest {get; set;}

		public Request() {
			serviceId = 'recuperaDatiStampaPratica';
			recuperaDatiStampaPraticaRequest = new recuperaDatiStampaPraticaRequestDTO();
		}
		
		public Request(recuperaDatiStampaPraticaRequestDTO objectIn) {        
			serviceId = 'recuperaDatiStampaPratica';
			recuperaDatiStampaPraticaRequest = objectIn;
		}

	}

	public class recuperaDatiStampaPraticaRequestDTO {      				
      public String input_numPratica {get; set;}
      public String tipoPratica {get; set;}
    }

//********************
// RESPONSE DTO
//********************

	public class Response extends OCSResponse {
		@AuraEnabled
		public recuperaDatiStampaPraticaResponseDTO recuperaDatiStampaPraticaResponse {get; set;}
        		
	}
	
    public class recuperaDatiStampaPraticaResponseDTO {        	
      @AuraEnabled public String AS400Status{get;set;}
      @AuraEnabled public String AS400Errore{get;set;}
      @AuraEnabled public String tipoFirma{get;set;}
    }
	    
    


//********************
// INVOKER
//********************
	public static Response invoke (recuperaDatiStampaPraticaRequestDTO objectIn ) {        

		Request req = new Request();       
    req.recuperaDatiStampaPraticaRequest = objectIn;

		return (Response)ApiUtils.callApi ('ocs.'+req.serviceId, req, Response.class, 'C' );

	}



	/**
	*  TEST
	**/
	/*
	OCSrecuperaDatiStampaPraticaInvoker.Request req = new OCSrecuperaDatiStampaPraticaInvoker.Request();
	req.recuperaDatiStampaPraticaRequest.input_numPratica = '1234567';
	req.recuperaDatiStampaPraticaRequest.tipoPratica = 'CO';
	OCSrecuperaDatiStampaPraticaInvoker.invoke(req.recuperaDatiStampaPraticaRequest);
	*/


}