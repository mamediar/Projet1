public class OCSStampaLetteraInvoker {
    
       public static OCSStampaLetteraResponse stampaLettera (String codLettera,string numPratica,string tipoPratica)
    {        
        OCSStampaLetteraRequest req = new OCSStampaLetteraRequest();
        req.serviceId = 'stampaLettera';
        req.StampaLetteraRequest.codLettera = codLettera;   
        req.StampaLetteraRequest.numPratica = numPratica ;
        req.StampaLetteraRequest.tipoPratica = tipoPratica ;
        
        return (OCSStampaLetteraResponse)ApiUtils.callApi
               ('ocs.stampaLettera',req, OCSStampaLetteraResponse.class );
    }

}