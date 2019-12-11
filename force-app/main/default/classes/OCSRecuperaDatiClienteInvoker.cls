public class OCSRecuperaDatiClienteInvoker {
    
    public static OCSRecuperaDatiClienteResponse recuperaDatiCliente (String codCliente) {        
        OCSRecuperaDatiClienteRequest req = new OCSRecuperaDatiClienteRequest();
        req.recuperaDatiClienteRequest.codCliente = codCliente;
        //system.debug('request '+ req);
        String apiResult = ApiUtils.callApi('ocs.recuperaDatiCliente', req);
        //system.debug('Response: ' + apiresult);
        OCSRecuperaDatiClienteResponse response = (OCSRecuperaDatiClienteResponse)JSON.deserialize(apiResult, OCSRecuperaDatiClienteResponse.class);
        return response;
    }
    
}