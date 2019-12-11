public class OCSRecuperaIndirizziClienteInvoker {
    public static OCSRecuperaIndirizziClienteResponse callRecIndirizzi(OCSRecuperaIndirizziClienteRequest req,String company){
        return (OCSRecuperaIndirizziClienteResponse)ApiUtils.callApi('ocs.recuperaIndirizziCliente',req,OCSRecuperaIndirizziClienteResponse.class, company);
    }
    
    public static OCSRecuperaIndirizziClienteResponse callRecIndirizzi(String codCliente){
        return callRecIndirizzi(buildReq(codCliente),'C');
    }
    
    public static OCSRecuperaIndirizziClienteResponse callRecIndirizzi(String codCliente,String company){
        return callRecIndirizzi(buildReq(codCliente),company);
    }
    
    private static OCSRecuperaIndirizziClienteRequest buildReq(String codCliente){
        OCSRecuperaIndirizziClienteRequest req=new OCSRecuperaIndirizziClienteRequest();
        req.recuperaIndirizziClienteRequest.codCliente=codCliente;
        return req;
    }

}