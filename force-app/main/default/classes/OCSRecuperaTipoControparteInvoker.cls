public class OCSRecuperaTipoControparteInvoker { 
    public static OCSRecuperaTipoControparteResponse callRecTipoContr(OCSRecuperaTipoControparteRequest request){
        return (OCSRecuperaTipoControparteResponse)ApiUtils.callApi('ocs.recuperaTipoControparte', request, OCSRecuperaTipoControparteResponse.class);
    }
    
    public static OCSRecuperaTipoControparteResponse callRecTipoContr(String codCliente){
        OCSRecuperaTipoControparteRequest request=new OCSRecuperaTipoControparteRequest();
        request.recuperaTipoControparteRequest.codCliente=codCliente;
        return(callRecTipoContr(request));
    }
}