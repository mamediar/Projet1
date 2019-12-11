public class OCSRecuperaSaldoClienteInvoker {
    public static OCSRecuperaSaldoClienteResponse callGetSaldoCliente(OCSRecuperaSaldoClienteRequest request){
        return (OCSRecuperaSaldoClienteResponse)ApiUtils.callApi('ocs.recuperaSaldoCliente',request,OCSRecuperaSaldoClienteResponse.class);
    }
    
    public static OCSRecuperaSaldoClienteResponse callGetSaldoCliente(String codCliente){
        OCSRecuperaSaldoClienteRequest request=new OCSRecuperaSaldoClienteRequest(); 
        request.recuperaSaldoClienteRequest.codCliente=codCliente; 
        OCSRecuperaSaldoClienteResponse res= callGetSaldoCliente(request);
        return res;
    }
}