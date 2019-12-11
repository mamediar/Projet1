public class OCSRecuperaLogAzioniIntermedInvoker {
	
	public static OCSRecuperaLogAzioniIntermedResponse recuperaLogAzioniIntermediario(String codiceIntermediario) {

		OCSRecuperaLogAzioniIntermedRequest request = new OCSRecuperaLogAzioniIntermedRequest();
		request.recuperaLogAzioniIntermediarioRequest.codIntermediario = codiceIntermediario;
		System.Debug('recuperaLogAzioniIntermediarioRequest : '+request);
		OCSRecuperaLogAzioniIntermedResponse response = (OCSRecuperaLogAzioniIntermedResponse)ApiUtils.callApi('ocs.recuperaLogAzioniIntermediario', request, OCSRecuperaLogAzioniIntermedResponse.class);

        return response;
	}
}