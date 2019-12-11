public class OCSrecuperaDatiUtenteZucchettiInvoker {
    public static OCSrecuperaDatiUtenteZucchettiResponse callRecuperaDatiUtenteZucchetti(OCSrecuperaDatiUtenteZucchettiRequest request){
        return (OCSrecuperaDatiUtenteZucchettiResponse)ApiUtils.callApi('ocs.recuperaDatiUtenteZucchetti',request,OCSrecuperaDatiUtenteZucchettiResponse.class);
    }
    
    public static OCSrecuperaDatiUtenteZucchettiResponse callRecuperaDatiUtenteZucchetti(String codiceUtente){
        OCSrecuperaDatiUtenteZucchettiRequest request=new OCSrecuperaDatiUtenteZucchettiRequest();
        request.recuperaDatiUtenteZucchettiRequest.codiceUtente=codiceUtente;
        OCSrecuperaDatiUtenteZucchettiResponse res= callRecuperaDatiUtenteZucchetti(request);
        return res;
    }
}