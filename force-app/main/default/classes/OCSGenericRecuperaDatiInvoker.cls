public class OCSGenericRecuperaDatiInvoker {


//********************
// REQUEST
//********************
	public class Request extends OCSRequest {

		public String nomeRichiesta {get; set;}
		public List<GenericRecuperaDatiRequestDTO> genericRecuperaDatiRequestDTO {get; set;}

		public Request() {

			serviceId = 'genericRecuperaDati';
			nomeRichiesta = '';
			genericRecuperaDatiRequestDTO = new List<GenericRecuperaDatiRequestDTO>();
		}

	}

	public class GenericRecuperaDatiRequestDTO {

		public String input_1 {get; set;}
		public String input_2 {get; set;}
		public String input_3 {get; set;}
		public String input_4 {get; set;}
		public String input_5 {get; set;}
	}

//********************
// RESPONSE DTO
//********************

	public class Response extends OCSResponse {
		@AuraEnabled
		public List<GenericRecuperaDatiResponseDTO> genericRecuperaDatiResponseDTO {get; set;}

	}
	public class GenericRecuperaDatiResponseDTO {
		@AuraEnabled public String out_1 {get; set;}
		@AuraEnabled public String out_2 {get; set;}
		@AuraEnabled public String out_3 {get; set;}
		@AuraEnabled public String out_4 {get; set;}
		@AuraEnabled public String out_5 {get; set;}
		@AuraEnabled public String out_6 {get; set;}
		@AuraEnabled public String out_7 {get; set;}
		@AuraEnabled public String out_8 {get; set;}
		@AuraEnabled public String out_9 {get; set;}
		@AuraEnabled public String out_10 {get; set;}
	}



//********************
// INVOKER
//********************

	public static Response invoke (String nomeRichiesta, List<GenericRecuperaDatiRequestDTO> listObjectIn ) {

		Request req = new Request();

		req.nomeRichiesta = nomeRichiesta;
		req.genericRecuperaDatiRequestDTO = listObjectIn;

		return  (Response)ApiUtils.callApi ('ocs.'+req.serviceId, req, Response.class, 'C' );

	}





    /*

    DA RIMUOVERE
    */
	public static Response invoke (String nomeRichiesta, String input_1,
									String input_2,  String input_3,
									String input_4,  String input_5 ) {

		Request req = new Request();

		req.nomeRichiesta = nomeRichiesta;
		req.genericRecuperaDatiRequestDTO.add(valorizzaElemento(input_1, input_2, input_3, input_4, input_5));


		Response resp =  (Response)ApiUtils.callApi (req, Response.class, 'C' );

		system.debug('Response: ' + resp.genericRecuperaDatiResponseDTO);
		return resp;

	}



	private static GenericRecuperaDatiRequestDTO valorizzaElemento( String input_1,
	                                            String input_2,  String input_3,
	                                            String input_4,  String input_5 ){
		GenericRecuperaDatiRequestDTO elemento = new GenericRecuperaDatiRequestDTO();
		elemento.input_1 = input_1;
		elemento.input_2 = input_2;
		elemento.input_3 = input_3;
		elemento.input_4 = input_4;
		elemento.input_5 = input_5;
		return elemento;

	}


	/**********************
	*  CHIAMATA PER I TEST
	***********************/
	// OCSGenericRecuperaDatiInvoker.invoke('recuperaLivelloFirma', 'CO', '10782939','','','');
}