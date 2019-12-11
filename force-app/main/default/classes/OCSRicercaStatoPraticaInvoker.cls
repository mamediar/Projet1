public class OCSRicercaStatoPraticaInvoker 
{
    public static OCSRicercaStatoPraticaResponse ricercaStatoPratica (String numPratica)
    {        
        OCSRicercaStatoPraticaRequest req = new OCSRicercaStatoPraticaRequest();
        req.serviceId = 'recuperaStatoPratica';
        req.numPratica =  numPratica;
        String apiResult = ApiUtils.callApi('ricerca.ocs.recuperaStatoPratica', req);
        system.debug(apiresult);
        OCSRicercaStatoPraticaResponse pratica = (OCSRicercaStatoPraticaResponse)JSON.deserialize(apiResult, OCSRicercaStatoPraticaResponse.class);
     	 
        return pratica;
    }
    
    

}