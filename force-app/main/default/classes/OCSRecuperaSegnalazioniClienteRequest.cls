public class OCSRecuperaSegnalazioniClienteRequest extends OCSRequest{
	@AuraEnabled
    public OCSRecuperaSegnalazioniClienteRequestData recuperaSegnalazioniClienteRequest{get;set;}
    
    public OCSRecuperaSegnalazioniClienteRequest(){
        this.serviceId='recuperaSegnalazioniCliente';
        this.recuperaSegnalazioniClienteRequest=new OCSRecuperaSegnalazioniClienteRequestData();
    }
    
    public class OCSRecuperaSegnalazioniClienteRequestData{
        @AuraEnabled
        public String codCliente{get;set;}
    }
}