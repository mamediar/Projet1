public class OCSRecuperaFasciaTassoCrifRequest extends OCSRequest{
    
    public recuperaFasciaTassoCrifRequest recuperaFasciaTassoCrifRequest{get;set;}

    public OCSRecuperaFasciaTassoCrifRequest(){
        this.serviceId='recuperaFasciaTassoCrif';
        this.recuperaFasciaTassoCrifRequest=new recuperaFasciaTassoCrifRequest();
    }

    public class recuperaFasciaTassoCrifRequest{
        public String codCliente{get;set;}
    }
}