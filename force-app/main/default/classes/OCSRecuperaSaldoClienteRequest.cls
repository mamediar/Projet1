public class OCSRecuperaSaldoClienteRequest extends OCSRequest{
     
    public recuperaSaldoClienteRequest recuperaSaldoClienteRequest{get;set;}

    public OCSRecuperaSaldoClienteRequest(){
		  this.serviceId='recuperaSaldoCliente';
          this.recuperaSaldoClienteRequest= new recuperaSaldoClienteRequest();
    }
    
    public class recuperaSaldoClienteRequest{
        public String codCliente{get;set;}
    }
}