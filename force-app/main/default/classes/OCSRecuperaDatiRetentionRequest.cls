public class OCSRecuperaDatiRetentionRequest extends OCSRequest {
    
    public RecuperaDatiRetentionRequest recuperaDatiRetentionRequest {get; set;}
    public OCSRecuperaDatiRetentionRequest()
    {
        serviceId = 'recuperaDatiRetention';
        recuperaDatiRetentionRequest = new RecuperaDatiRetentionRequest();
    }
    public class RecuperaDatiRetentionRequest
    {
    	public String codCliente {get; set;}
        public String tipoPratica {get; set;}
        public String numPratica {get; set;}
    }
}