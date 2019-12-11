public class OCSRecuperaInfoSIDRequest extends OCSRequest{ 

    @auraEnabled
    public RecuperaInfoSIDRequestDTO recuperaInfoSIDRequest {get; set;}
  
    public OCSRecuperaInfoSIDRequest() {
        
        serviceId = 'recuperaInfoSID';
        recuperaInfoSIDRequest = new RecuperaInfoSIDRequestDTO();
       
    }
    
    
    public class RecuperaInfoSIDRequestDTO {
        
        public String numeroPratica {get; set;}
        
    }
    
    
}