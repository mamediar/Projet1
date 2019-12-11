/**
 * @File Name          : OCSRecuperaConvSpeseAzzeraRecInvoker.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 16/10/2019, 15:27:50
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    16/10/2019   Federico Negro     Initial Version
**/
public class OCSRecuperaConvSpeseAzzeraRecInvoker {

//********************
// REQUEST
//********************

	public class Request extends OCSRequest {

		public String numPratica {get; set;}
		public String tipoPratica {get; set;}
		public String tipoSpesa {get; set;}
		public String vecchioProgressivo {get; set;}

			public Request() {
				serviceId = 'recuperaConversioneSpeseAzzeramentoRecupero';
			}

	}


//********************
// RESPONSE DTO
//********************

	public class Response extends OCSResponse {

		@AuraEnabled public String AS400Status{get;set;}
		@AuraEnabled public String AS400Errore{get;set;}    
		@AuraEnabled public String nuovoProgressivo{get;set;}   

			public override boolean isOK() {    
				return super.isOK() && AS400Status.equalsIgnoreCase('ok');
			}     

			public override string getMessage() {
				return super.getMessage().equalsIgnoreCase('success') ? AS400Errore : super.getMessage();
			}   
	}


//********************
// INVOKER
//********************

	public static Response invoke (String numPratica,string tipoPratica,string tipoSpesa,string vecchioProgressivo){

		Request req = new Request();	

		req.numPratica=numPratica;
		req.tipoPratica=tipoPratica;
		req.tipoSpesa=tipoSpesa;
		req.vecchioProgressivo=vecchioProgressivo;

		
		return 	(Response)ApiUtils.callApi ('ocs.recuperaConvSpeseAzzeraRecupero',req, Response.class, 'C' );
	}
	
}

/***********************
*   CHIAMATA PER TEST
************************/

/*
    	OCSRecuperaConvSpeseAzzeraRecInvoker.Request req = new OCSRecuperaConvSpeseAzzeraRecInvoker.Request();

      	String numPratica='1100000034';
        String tipoPratica='CA';
        String tipoSpesa='S';
        String vecchioProgressivo='1';
	
		OCSRecuperaConvSpeseAzzeraRecInvoker.Response res = OCSRecuperaConvSpeseAzzeraRecInvoker.invoke(numPratica, tipoPratica, tipoSpesa, vecchioProgressivo);
		System.debug('RISPOSTA : ' + res);
*/