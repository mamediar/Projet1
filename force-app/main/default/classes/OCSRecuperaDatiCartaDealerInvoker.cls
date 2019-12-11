public with sharing class OCSRecuperaDatiCartaDealerInvoker {
  public final static String SERVICE_NAME = 'recuperaDatiCartaDealer';
   
     public class RecuperaDatiCartaDealerResponseDTO{
         public String numeroPratica {get;set;}  
         public String codCliente {get;set;}  
         public String codDealer {get;set;}  
         public String codProdotto {get;set;}  
         public String descProdotto {get;set;}  
         public String dataRichiesta {get;set;}  
         public String fido {get;set;}  
         public String ragioneSociale {get;set;}  
         public String ragioneSocialeDealer {get;set;}  
         public String statoDealer {get;set;}  
         public String telCellulare {get;set;}  
         public String telDatore {get;set;}  
         public String telCase {get;set;}  

         public  RecuperaDatiCartaDealerResponseDTO(){}
     }

     public class RecuperaDatiCartaDealerRequestDTO{
         public String numPratica {get;set;} 
         public RecuperaDatiCartaDealerRequestDTO(){}
     }

    //********************
    // REQUEST
    //********************
    public class Request extends OCSRequest {
        
        public RecuperaDatiCartaDealerRequestDTO recuperaDatiCartaDealerRequest {get; set;}
        
        public Request() {
            serviceId = SERVICE_NAME;
            recuperaDatiCartaDealerRequest = new RecuperaDatiCartaDealerRequestDTO();
        }      
    }

    //********************
    // RESPONSE 
    //********************

    public class Response extends OCSResponse {
        @AuraEnabled
        public RecuperaDatiCartaDealerResponseDTO recuperaDatiCartaDealerResponse {get; set;}
            
        public override boolean isOK() {    
            return super.isOK() && 'Ok'.equalsIgnoreCase(resultMessage);
        }
                
        public override string getMessage() {
            return super.getMessage();
        }         
    }

    //********************
    // INVOKER
    //********************
    public static Response invoke(Request req) {        
        
        return (Response)ApiUtils.callApi(SERVICE_NAME,req, Response.class);       
    }

    public static Response invoke(String numPratica) {        
        OCSRecuperaDatiCartaDealerInvoker.RecuperaDatiCartaDealerRequestDTO dto = new OCSRecuperaDatiCartaDealerInvoker.RecuperaDatiCartaDealerRequestDTO();
        dto.numPratica = numPratica;
        OCSRecuperaDatiCartaDealerInvoker.Request req = new OCSRecuperaDatiCartaDealerInvoker.Request();
        req.recuperaDatiCartaDealerRequest = dto;
        return (Response)ApiUtils.callApi(SERVICE_NAME,req, Response.class);       
    }

}