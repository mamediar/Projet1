public class OCSRecuperaDelinquencyRequest extends OCSRequest{
    
    public recuperaDelinquencyRequest recuperaDelinquencyRequest{get;set;}

    public OCSRecuperaDelinquencyRequest(){
        this.serviceId='recuperaDelinquency';
        this.recuperaDelinquencyRequest=new recuperaDelinquencyRequest();
    }

    public class recuperaDelinquencyRequest{
        public String codCliente{get;set;}
        public String tipoPratica{get;set;}
        public String numPratica{get;set;}
    }
}