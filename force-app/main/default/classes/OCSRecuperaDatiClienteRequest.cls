public class OCSRecuperaDatiClienteRequest extends OCSRequest {
    public String authorization {get; set;}
    public RecuperaDatiClienteRequest recuperaDatiClienteRequest {get; set;}
    
    public OCSRecuperaDatiClienteRequest(){
        serviceId = 'recuperaDatiCliente';
        recuperaDatiClienteRequest = new RecuperaDatiClienteRequest();
    }
    
    public class RecuperaDatiClienteRequest{
        public String codCliente {get; set;}
    }
}