public class OCSAcquistiErogazioneDirettaInvoker {


//********************
// REQUEST
//********************
	public class Request extends OCSRequest {

		public DatiAcquistiErogazioneDirettaRequestDTO datiAcquistiErogazioneDirettaRequest {get; set;}

		public Request() {
			serviceId = 'acquistiErogazioneDiretta';        
            datiAcquistiErogazioneDirettaRequest = new DatiAcquistiErogazioneDirettaRequestDTO();
		}

	}

    public class DatiAcquistiErogazioneDirettaRequestDTO {      
		
		public String intermediario {get; set;}
		public String numeroCarta {get; set;}
		public String importo {get; set;}
		public String codiceCampagna {get; set;}
		public String destErogazione {get; set;}
		public String modalitaErogazione {get; set;}
		public String flagCommissioniErogazione {get; set;}
		public String dataScadenza {get; set;}
		public String dataNascita {get; set;}
		public String numRate {get; set;}
		public String iban {get; set;}
		public String canale {get; set;}
		public String utente {get; set;}		
    }

//********************
// RESPONSE DTO
//********************

	public class Response extends OCSResponse {
		@AuraEnabled    
		public DatiAcquistiErogazioneDirettaResponseDTO datiAcquistiErogazioneDirettaResponse {get; set;} 
		
		
		public override boolean isOK() {           
			return super.isOK();
		}     


		public override string getMessage() {
			return super.getMessage().equalsIgnoreCase('success') && isOK() ? 'Emettitore/ autor:' + datiAcquistiErogazioneDirettaResponse.emettitore +'/' + datiAcquistiErogazioneDirettaResponse.autor : datiAcquistiErogazioneDirettaResponse.as400Errore;
		} 
		

	}
	
	public class DatiAcquistiErogazioneDirettaResponseDTO {
		@AuraEnabled public String emettitore{get;set;}
		@AuraEnabled public String protocollo{get;set;}
		@AuraEnabled public String autor{get;set;}
		@AuraEnabled public String as400Status{get;set;}    
		@AuraEnabled public String as400Errore{get;set;}

	}
	



//********************
// INVOKER
//********************


	public static Response invoke (DatiAcquistiErogazioneDirettaRequestDTO objectIn ) {	
		Request req = new Request();
		req.datiAcquistiErogazioneDirettaRequest = objectIn;
		return 	(Response)ApiUtils.callApi ('ocs.'+req.serviceId,req, Response.class, 'C' );
		//return  (Response)ApiUtils.callApi ('ocs.acquistiErogazioneDiretta',req, Response.class, 'C' );

	}


    /***
     * chiamata per i test TEST
     * */
    /*
    OCSAcquistiErogazioneDirettaInvoker.Request req = new OCSAcquistiErogazioneDirettaInvoker.Request();
    
    req.datiAcquistiErogazioneDirettaRequest.intermediario = '12';
    req.datiAcquistiErogazioneDirettaRequest.numeroCarta = '15137651686';
    req.datiAcquistiErogazioneDirettaRequest.importo = '1';
    req.datiAcquistiErogazioneDirettaRequest.codiceCampagna = '';
    req.datiAcquistiErogazioneDirettaRequest.destErogazione = 'CL';
    req.datiAcquistiErogazioneDirettaRequest.modalitaErogazione = 'D';
    req.datiAcquistiErogazioneDirettaRequest.flagCommissioniErogazione = 'N';
    req.datiAcquistiErogazioneDirettaRequest.dataScadenza = '201908';
    req.datiAcquistiErogazioneDirettaRequest.dataNascita = '19300424';
    req.datiAcquistiErogazioneDirettaRequest.numRate = '0';
    req.datiAcquistiErogazioneDirettaRequest.iban = 'IT48W1927501600CC0010058392';
    req.datiAcquistiErogazioneDirettaRequest.canale = 'CP3';
    req.datiAcquistiErogazioneDirettaRequest.utente = '';
    
    OCSAcquistiErogazioneDirettaInvoker.invoke(req.datiAcquistiErogazioneDirettaRequest);     
     */

}