public class OCSRecuperaIndirizziClienteRequest extends OCSRequest{
    @AuraEnabled public RecuperaIndirizziClienteRequestDTO recuperaIndirizziClienteRequest {get;set;}
    
    public OCSRecuperaIndirizziClienteRequest(){
        this.serviceId='recuperaIndirizziCliente';
        this.recuperaIndirizziClienteRequest=new RecuperaIndirizziClienteRequestDTO();
    }
    
    public class RecuperaIndirizziClienteRequestDTO{
        @AuraEnabled public String codCliente {get;set;}
    }

}