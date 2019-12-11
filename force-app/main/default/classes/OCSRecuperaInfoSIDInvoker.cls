public class OCSRecuperaInfoSIDInvoker {
 	
    @auraEnabled public static OCSRecuperaInfoSIDResponse recuperaInfoSID(String numeroPrat) {        
        OCSRecuperaInfoSIDRequest req = new OCSRecuperaInfoSIDRequest();
        req.recuperaInfoSIDRequest.numeroPratica = numeroPrat;   		     
        OCSRecuperaInfoSIDResponse response = (OCSRecuperaInfoSIDResponse)ApiUtils.callApi('ocs.recuperaInfoSID', req, OCSRecuperaInfoSIDResponse.class);
        
        return response;
    }
}