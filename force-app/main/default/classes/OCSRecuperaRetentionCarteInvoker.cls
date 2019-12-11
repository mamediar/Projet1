public class OCSRecuperaRetentionCarteInvoker 
{
	public static OCSRecuperaRetentionCarteResponse invoke(String codCliente)
    {
        OCSRecuperaRetentionCarteRequest req = new OCSRecuperaRetentionCarteRequest();
        req.codCliente = codCliente;
        return (OCSRecuperaRetentionCarteResponse) apiutils.callApi('ocs.recuperaRetentionCarte', req, OCSRecuperaRetentionCarteResponse.class);
    }
    
}