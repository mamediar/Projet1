public class OCSRecuperaSaldiRossiCarteAttiveInvoker {
    
    public static OCSRecuperaSaldiRossiCarteAttiveResponse recuperaSaldiRossiCarteAttive() {  
        
      	OCSRecuperaSaldiRossiCarteAttiveRequest req = new OCSRecuperaSaldiRossiCarteAttiveRequest();   		     
       	OCSRecuperaSaldiRossiCarteAttiveResponse response = (OCSRecuperaSaldiRossiCarteAttiveResponse)ApiUtils.callApi('ocs.recuperaSaldiRossiCarteAttive', req, OCSRecuperaSaldiRossiCarteAttiveResponse.class);
        return response;
        
    }

}