public class OCSRecuperaSaldiRossiInvoker {
    
    public static OCSRecuperaSaldiRossiCarteRevocateRes recuperaSaldiRossiCarteRevocate() {  
        
      	OCSRecuperaSaldiRossiCarteRevocateReq req = new OCSRecuperaSaldiRossiCarteRevocateReq();   		     
       	OCSRecuperaSaldiRossiCarteRevocateRes response = (OCSRecuperaSaldiRossiCarteRevocateRes)ApiUtils.callApi('ocs.recuperaSaldiRossiCarteRevocate', req, OCSRecuperaSaldiRossiCarteRevocateRes.class);
        return response;
        
    }

}