public class OCSRecuperaLogAzioniIntermedRequest extends OCSRequest {

	public RecuperaLogAzioniIntermediarioRequestDTO recuperaLogAzioniIntermediarioRequest {get; set;}

	public OCSRecuperaLogAzioniIntermedRequest() {
		serviceId = 'recuperaLogAzioniIntermediario';
		recuperaLogAzioniIntermediarioRequest = new RecuperaLogAzioniIntermediarioRequestDTO();
	}

	public class RecuperaLogAzioniIntermediarioRequestDTO {
        public String codIntermediario {get; set;}
    }

}