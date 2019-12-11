public class OCSRecuperaEstrattoContoPDFResponse extends OCSResponse {
    
    @AuraEnabled
    public RecuperaEstrattoContoPDFResponse recuperaEstrattoContoPDFResponse {get; set;}
        
    public OCSRecuperaEstrattoContoPDFResponse(){
    	recuperaEstrattoContoPDFResponse = new RecuperaEstrattoContoPDFResponse();            
    }
    
    public class RecuperaEstrattoContoPDFResponse{    
    	@AuraEnabled	
        public String stream {get; set;}
    }
}