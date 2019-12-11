public class OCSStampaLetteraResponse extends OCSResponse {

        public infoLettera stampaLetteraResponse {get; set;}  
    
    public class infoLettera {
    public String dataElaborazione {get; set;}
    public String oraElaborazione {get; set;}
    public String utenteElaborazione {get; set;}
    public String esitoElaborazione {get; set;}
    }
    
    
  public override boolean isOK()
    {            
       stampaLetteraResponse = new infoLettera();
        return  super.isOk();
    }

    
    
}