public class OCSStampaLetteraRequest extends OCSRequest {

     
      public Lettera stampaLetteraRequest {get; set;}
    
    public  OCSStampaLetteraRequest()
    {
        serviceId = 'stampaLettera';
        stampaLetteraRequest = New Lettera();
    }   
    
    public class Lettera {
    public String codLettera {get; set;}
    public String numPratica {get; set;}
    public String tipoPratica {get; set;}

    }
}