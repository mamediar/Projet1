public class OCSRecuperaEstrattoContoPDFInvoker {
    	
	public static OCSRecuperaEstrattoContoPDFResponse invoke(String codCliente, String numPratica, String mese, String anno)
    {
        OCSRecuperaEstrattoContoPDFRequest req = new OCSRecuperaEstrattoContoPDFRequest();        
        req.recuperaEstrattoContoPDFRequest.codCliente = codCliente;
        req.recuperaEstrattoContoPDFRequest.numPratica = numPratica;
		req.recuperaEstrattoContoPDFRequest.mese = mese;
        req.recuperaEstrattoContoPDFRequest.anno = anno;
        return (OCSRecuperaEstrattoContoPDFResponse)apiutils.callApi('ocs.recuperaEstrattoContoPDF', req, OCSRecuperaEstrattoContoPDFResponse.class);
    } 
	
}