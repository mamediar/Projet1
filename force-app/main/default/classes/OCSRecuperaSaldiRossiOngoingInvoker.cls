public class OCSRecuperaSaldiRossiOngoingInvoker {
    
    public static OCSRecuperaSaldiRossiOngoingResponse recuperaSaldiRossiOngoing() {  
        
        OCSRecuperaSaldiRossiOngoingRequest req = new OCSRecuperaSaldiRossiOngoingRequest();   		     
        OCSRecuperaSaldiRossiOngoingResponse response = (OCSRecuperaSaldiRossiOngoingResponse)ApiUtils.callApi('ocs.recuperaSaldiRossiOngoing', req, OCSRecuperaSaldiRossiOngoingResponse.class);
        return response;
        
    }

}