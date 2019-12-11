public class OCSRecuperaPacchettiServiziInvoker {
    public static OCSRecuperaPacchettiServiziResponse callRecPacchServ(OCSRecuperaPacchettiServiziRequest req,String company){
        return (OCSRecuperaPacchettiServiziResponse)ApiUtils.callApi('ocs.recuperaPacchettiServizi',req,OCSRecuperaPacchettiServiziResponse.class, company);
    }
    
    public static OCSRecuperaPacchettiServiziResponse callRecPacchServ(String tipoPratica,String numPratica){
        return callRecPacchServ(buildReq(tipoPratica,numPratica),'C');
    }
    
    public static OCSRecuperaPacchettiServiziResponse callRecPacchServ(String tipoPratica,String numPratica,String company){
        return callRecPacchServ(buildReq(tipoPratica,numPratica),company);
    }
    
    private static OCSRecuperaPacchettiServiziRequest buildReq(String tipoPratica,String numPratica){
        OCSRecuperaPacchettiServiziRequest req=new OCSRecuperaPacchettiServiziRequest();
        req.recuperaPacchettiServiziRequest.tipoPratica=tipoPratica;
        req.recuperaPacchettiServiziRequest.numPratica=numPratica;
        return req;
    }
}