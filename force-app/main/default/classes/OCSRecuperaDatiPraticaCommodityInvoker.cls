public with sharing class OCSRecuperaDatiPraticaCommodityInvoker {

  public final static String SERVICE_NAME = 'recuperaDatiPraticaCommodity';
   
     public class DatiPraticaCommodityDTO{
         public String numeroPratica {get;set;}  
         public String codCliente {get;set;} 
         public String cognome {get;set;} 
         public String nome {get;set;}     
         public String ragioneSociale {get;set;}   
         public String telefonoCasa {get;set;}
         public String codDealer {get;set;}   
         public String statoDealer {get;set;}  
         public String telCellulare {get;set;}  
         public String telDatore {get;set;}  
         public String codClienteCoob {get;set;}
         public String cognomeCoob {get;set;}
         public String nomeCoob {get;set;}
         public String ragioneSocialeCoob {get;set;}
         public String telefonoCasaCoob {get;set;}
         public String telCellulareCoob {get;set;}
         public String telDatoreCoob {get;set;}
         public String dataLiquidazione {get;set;}
         public String descrizioneBene {get;set;}
         public String codDestFinanziamento {get;set;}
         public String descDestFinanziamento {get;set;}
         public String tipoProdotto {get;set;}
         public String numRata {get;set;}
         public String importoRata {get;set;}
         public String finanziato {get;set;}
         public String ragioneSocialeDealer {get;set;}
         public String canale {get;set;}
         public  DatiPraticaCommodityDTO(){}
     }

     public class RecuperaDatiPraticaCommodityRequest{
         public String numPratica {get;set;} 
         public RecuperaDatiPraticaCommodityRequest(){}
     }

    public class RecuperaDatiPraticaCommodityResponse{
        public DatiPraticaCommodityDTO datiPraticaCommodityDTO {get;set;}
        public RecuperaDatiPraticaCommodityResponse(){}
    }

    //********************
    // REQUEST
    //********************
    public class Request extends OCSRequest {
        
        public RecuperaDatiPraticaCommodityRequest recuperaDatiPraticaCommodityRequest {get; set;}
        
        public Request() {
            serviceId = SERVICE_NAME;
            recuperaDatiPraticaCommodityRequest = new RecuperaDatiPraticaCommodityRequest();
        }      
    }

    //********************
    // RESPONSE 
    //********************

    public class Response extends OCSResponse {
        @AuraEnabled
        public RecuperaDatiPraticaCommodityResponse recuperaDatiPraticaCommodityResponse {get; set;}
            
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
        OCSRecuperaDatiPraticaCommodityInvoker.RecuperaDatiPraticaCommodityRequest dto = new OCSRecuperaDatiPraticaCommodityInvoker.RecuperaDatiPraticaCommodityRequest();
        dto.numPratica = numPratica;
        OCSRecuperaDatiPraticaCommodityInvoker.Request req = new OCSRecuperaDatiPraticaCommodityInvoker.Request();
        req.recuperaDatiPraticaCommodityRequest = dto;
        return (Response)ApiUtils.callApi(SERVICE_NAME,req, Response.class);       
    }

}