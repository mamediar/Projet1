public class OCSrecuperaBlocchiCartaInvoker {

	//********************
	// REQUEST
	//********************

	public class Request extends OCSRequest {

		public RecuperaBlocchiCartaRequestDTO recuperaBlocchiCartaRequest { get; set; }

		public Request(RecuperaBlocchiCartaRequestDTO recuperaBlocchiCartaRequestDTO) {
			this.serviceId = 'recuperaBlocchiCarta';
			this.recuperaBlocchiCartaRequest = recuperaBlocchiCartaRequestDTO;
		}
	}

	public class RecuperaBlocchiCartaRequestDTO {
		public String numCarta { get; set; }
		public String filtroBlocchi { get; set; }
	}


	//********************
	// RESPONSE DTO
	//********************

	public class Response extends OCSResponse {
		public RecuperaBlocchiCartaResponseDTO recuperaBlocchiCartaResponse { get; set; }
	}

	public class RecuperaBlocchiCartaResponseDTO {
		public List<BloccoCarta> elencoBlocchi { get; set; }
	}

	public class BloccoCarta {
		public String keyCode { get; set; }
		public String valore { get; set; }
		public String descrizione { get; set; }
	}


	//********************
	// INVOKER
	//********************

	public static Response invoke(RecuperaBlocchiCartaRequestDTO RecuperaBlocchiCartaRequestDTO) {
		Request request = new Request(RecuperaBlocchiCartaRequestDTO);
		return (Response) ApiUtils.callApi ('ocs.' + request.serviceId, request, Response.class, 'C');
	}
}