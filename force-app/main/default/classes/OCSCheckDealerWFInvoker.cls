public class OCSCheckDealerWFInvoker {


//********************
// REQUEST
//********************
	public class Request extends OCSRequest {

		public String pv {get; set;}
		public String cv {get; set;}
		public String sa {get; set;}
		public String ag {get; set;}

		public Request() {
			serviceId = 'checkDealerWF';
		}

	}



//********************
// RESPONSE DTO
//********************

	public class Response extends OCSResponse {
		@AuraEnabled
		public String flagEsiste {get; set;} 
    
		
	}
	

	    
    


//********************
// INVOKER
//********************

	public static Response invoke (String pv, String cv,String sa,String ag){

		Request req = new Request();		
		req.pv = pv; 
		req.cv = cv; 
		req.sa = sa; 
		req.ag = ag; 
		system.debug('*******NAME: '+'ocs.'+req.serviceId);
		return 	(Response)ApiUtils.callApi ('ocs.'+req.serviceId, req, Response.class, 'C' );
	}


/***********************
*   CHIAMATA PER TEST
************************/

	
/*
OCSCheckDealerWFInvoker.invoke('1','1','1','341717'); // Caso con Flag di risposta a n
OCSCheckDealerWFInvoker.invoke('1','396865','1','1'); // Caso con Flag di risposta a S

*/
	

}