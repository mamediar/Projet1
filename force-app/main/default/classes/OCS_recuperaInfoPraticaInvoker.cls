public class OCS_recuperaInfoPraticaInvoker {
    public static OCS_recuperaInfoPraticaResponse callAggiornaDati(OCS_recuperaInfoPraticaRequest request,String company){
        return (OCS_recuperaInfoPraticaResponse)ApiUtils.callApi('ocs.recuperaInfoPratica',request,OCS_recuperaInfoPraticaResponse.class,company);
    }
    
    public static OCS_recuperaInfoPraticaResponse callAggiornaDati(String numeroPratica){
        OCS_recuperaInfoPraticaResponse res=callAggiornaDati(buildReq(numeroPratica),'C');
        return res;
    }
    
    public static OCS_recuperaInfoPraticaResponse callAggiornaDati(String numeroPratica,String company){
        return callAggiornaDati(buildReq(numeroPratica),company);
    }
    
    private static OCS_recuperaInfoPraticaRequest buildReq(String numeroPratica){
        OCS_recuperaInfoPraticaRequest request=new OCS_recuperaInfoPraticaRequest();
		request.recuperaInfoPraticaRequest.numPratica = numeroPratica;
        return request;
    }
}