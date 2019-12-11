public class OCSRecuperaFasciaTassoCrifInvoker {
    public static OCSRecuperaFasciaTassoCrifResponse callGetFasciaTassoCrif(OCSRecuperaFasciaTassoCrifRequest request){
        return (OCSRecuperaFasciaTassoCrifResponse)ApiUtils.callApi('ocs.recuperaFasciaTassoCrif',request,OCSRecuperaFasciaTassoCrifResponse.class);
    }
    
    public static OCSRecuperaFasciaTassoCrifResponse callGetFasciaTassoCrif(String codCliente){
        OCSRecuperaFasciaTassoCrifRequest request=new OCSRecuperaFasciaTassoCrifRequest();
        request.recuperaFasciaTassoCrifRequest.codCliente=codCliente;
        OCSRecuperaFasciaTassoCrifResponse res= callGetFasciaTassoCrif(request);
        return res;
    }
}