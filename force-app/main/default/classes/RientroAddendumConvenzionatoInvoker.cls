public class RientroAddendumConvenzionatoInvoker {


    public final static String SERVICE_NAME = 'rientroAddendumConvenzionato';
   
     public class RientroAddendumConvenzionatoDTO{
         public String partimestp {get;set;}  
         public String codice {get;set;}  
         public String stato {get;set;}  
         public String tipint {get;set;}  
         public String datainv {get;set;}  
         public String nota {get;set;}  
         public String segnala {get;set;}  

         public RientroAddendumConvenzionatoDTO(){}
     }


     public class RientroAddendumConvenzionatoRequestDTO{
         public RientroAddendumConvenzionatoDTO[] elenco {get;set;} 
         public RientroAddendumConvenzionatoRequestDTO(){}
     }


     public class RientroAddendumConvenzionatoResponseDTO{
         public RientroAddendumConvenzionatoDTO[] elenco {get;set;} 
         public RientroAddendumConvenzionatoResponseDTO(){}
     }

    //********************
    // REQUEST
    //********************
    public class Request extends OCSRequest {
        
        public RientroAddendumConvenzionatoRequestDTO rientroAddendumConvenzionatoRequest {get; set;}
        
        public Request() {
            serviceId = SERVICE_NAME;
            rientroAddendumConvenzionatoRequest = new RientroAddendumConvenzionatoRequestDTO();
        }      
    }

    //********************
    // RESPONSE 
    //********************

    public class Response extends OCSResponse {
        @AuraEnabled
        public RientroAddendumConvenzionatoResponseDTO rientroAddendumConvenzionatoResponse {get; set;}
            
        public override boolean isOK() {    
            return super.isOK() && 'ok'.equalsIgnoreCase(resultMessage);
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



    public static Response invoke(String codiceDelear,Integer tipoInt) {        
        RientroAddendumConvenzionatoInvoker.RientroAddendumConvenzionatoDTO dto1 = new RientroAddendumConvenzionatoInvoker.RientroAddendumConvenzionatoDTO();
        dto1.codice = codiceDelear;
        dto1.stato = '003'; // default;
        dto1.tipint = String.valueOf(tipoInt);
        dto1.nota = '';
        String dateFormatted = (DateTime.now()).format('yyyyMMdd');
        dto1.datainv = dateFormatted; //required
        dto1.segnala = '';
        dto1.partimestp = '';
        RientroAddendumConvenzionatoInvoker.RientroAddendumConvenzionatoDTO[] lista = new RientroAddendumConvenzionatoInvoker.RientroAddendumConvenzionatoDTO[]{dto1};
        RientroAddendumConvenzionatoInvoker.RientroAddendumConvenzionatoRequestDTO rientro = new RientroAddendumConvenzionatoInvoker.RientroAddendumConvenzionatoRequestDTO();
        rientro.elenco = lista;
        RientroAddendumConvenzionatoInvoker.Request req = new RientroAddendumConvenzionatoInvoker.Request();
        req.rientroAddendumConvenzionatoRequest = rientro;
        return (Response)ApiUtils.callApi(SERVICE_NAME,req, Response.class);       
    }


}