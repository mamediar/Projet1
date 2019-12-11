public class OCSRecuperaInfoCartaInvoker {
    // company da impostare a F per Futuro, C per Compass
    
    public static OCSRecuperaInfoCartaResponse callRecInfoCarta(OCSRecuperaInfoCartaRequest data,String company){
        return (OCSRecuperaInfoCartaResponse)ApiUtils.callApi('ocs.recuperaInfoCarta',data,OCSRecuperaInfoCartaResponse.class,company);
    }
    
    public static OCSRecuperaInfoCartaResponse callRecInfoCarta(String numCarta,String company){
        return callRecInfoCarta(buildReq(numCarta),company);
    }
    
    public static List<OCSRecuperaInfoCartaResponse> callRecInfoCarta(List<String> data,String company){
        List<OCSRecuperaInfoCartaResponse> res=new List<OCSRecuperaInfoCartaResponse>();
        for(String s:data){
            res.add(callRecInfoCarta(s,company));
        }
        return res;
    }
    
    public static OCSRecuperaInfoCartaResponse callRecInfoCarta(String numCarta){
        return callRecInfoCarta(buildReq(numCarta),'C');
    }
    
    public static List<OCSRecuperaInfoCartaResponse> callRecInfoCarta(List<String> data){
        List<OCSRecuperaInfoCartaResponse> res=new List<OCSRecuperaInfoCartaResponse>();
        for(String s:data){
            res.add(callRecInfoCarta(s));
        }
        return res;
    }
    
    private static OCSRecuperaInfoCartaRequest buildReq(String numCarta){
        OCSRecuperaInfoCartaRequest data=new OCSRecuperaInfoCartaRequest();
        data.recuperaInfoCartaRequest.numCarta=numCarta;
        return data;
    }
}