public class OCSRecuperaStatoRichiestePSVInvoker 
{
	public static OCSRecuperaStatoRichiestePSVResponse Invoke(String tipoPratica,String numPratica,String codAzione, String dataAzione)
    {
     	OCSRecuperaStatoRichiestePSVRequest req = new OCSRecuperaStatoRichiestePSVRequest();
       	req.recuperaStatoRichiestePSVRequest.tipoPratica = tipoPratica;
        req.recuperaStatoRichiestePSVRequest.numPratica = numPratica;
        req.recuperaStatoRichiestePSVRequest.codAzione = codAzione;
        req.recuperaStatoRichiestePSVRequest.dataAzione = dataAzione;
        return (OCSRecuperaStatoRichiestePSVResponse)ApiUtils.callApi('ocs.recuperaStatoRichiestePSV',req,OCSRecuperaStatoRichiestePSVResponse.class);
    }
    
}