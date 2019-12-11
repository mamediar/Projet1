public class OCSRecuperaDatiRetentionInvoker 
{
    public static OCSRecuperaDatiRetentionResponse invoke(String codCliente,String tipoPratica,String numPratica)
    {
        OCSRecuperaDatiRetentionRequest req = new OCSRecuperaDatiRetentionRequest();
        req.recuperaDatiRetentionRequest.codCliente = codCliente;
        req.recuperaDatiRetentionRequest.tipoPratica = tipoPratica;
        req.recuperaDatiRetentionRequest.numPratica = numPratica;
        return (OCSRecuperaDatiRetentionResponse)apiutils.callApi('ocs.recuperaDatiRetention', req, OCSRecuperaDatiRetentionResponse.class);
    }
}