public class OCSRecuperaSegnalazioniClienteInvoker {
    public static OCSRecuperaSegnalazioniClienteResponse callRecSegnClien(OCSRecuperaSegnalazioniClienteRequest request){
        return (OCSRecuperaSegnalazioniClienteResponse)ApiUtils.callApi('ocs.recuperaSegnalazioniCliente',request,OCSRecuperaSegnalazioniClienteResponse.class);
    }
    
    public static OCSRecuperaSegnalazioniClienteResponse callRecSegnClien(String codCliente){
        OCSRecuperaSegnalazioniClienteRequest request=new OCSRecuperaSegnalazioniClienteRequest();
        request.recuperaSegnalazioniClienteRequest.codCliente=codCliente;
        return(callRecSegnClien(request));
    }
}