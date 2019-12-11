public class OCSRecuperaRitorniPostaliInvoker {
    
    public static OCSRecuperaRitorniPostaliResponse recuperaRitorniPostali() {  
        
        OCSRecuperaRitorniPostaliRequest req = new OCSRecuperaRitorniPostaliRequest();   		     
        OCSRecuperaRitorniPostaliResponse response = (OCSRecuperaRitorniPostaliResponse)ApiUtils.callApi('ocs.recuperaRitorniPostali', req, OCSRecuperaRitorniPostaliResponse.class);
        return response;
        
    }
    
}