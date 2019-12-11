public class VerificaRequisitiDemDealerInvoker {

    public final static String SERVICE_NAME = 'verificaRequisitiDemDealer';
    private final static String SERVICE_ID = 'verificaRequisitiDematerializzazioneDealer';


    public class VerificaRequisitiDemDealerRequestDTO  {
        public String tipoIntermediario {get;set;}
        public String codIntermediario {get;set;}

        public VerificaRequisitiDemDealerRequestDTO(){}
        public VerificaRequisitiDemDealerRequestDTO(String tipoIntermediario, String codIntermediario){
            this.tipoIntermediario = tipoIntermediario;
            this.codIntermediario = codIntermediario;

        }
    }

    public class VerificaRequisitiDemDealerResponseDTO  {
        public String esito {get;set;}
        public String desErrore {get;set;}

        public VerificaRequisitiDemDealerResponseDTO(){}
    }


    //********************
    // REQUEST
    //********************
    public class Request extends OCSRequest {
        
        public VerificaRequisitiDemDealerRequestDTO verificaRequisitiDematerializzazioneDealerRequest {get; set;}
        
        public Request() {
            serviceId = SERVICE_ID;
            verificaRequisitiDematerializzazioneDealerRequest = new VerificaRequisitiDemDealerRequestDTO();
        }      
        
        public Request(String tipoIntermediario, String codIntermediario) {
            serviceId = SERVICE_ID;
            verificaRequisitiDematerializzazioneDealerRequest = new VerificaRequisitiDemDealerRequestDTO(tipoIntermediario,codIntermediario);
        }      
    }


    //********************
    // RESPONSE 
    //********************

    public class Response extends OCSResponse {
        @AuraEnabled
        public VerificaRequisitiDemDealerResponseDTO verificaRequisitiDematerializzazioneDealerResponse {get; set;}
            
        public override boolean isOK() {    
            return super.isOK() && 'ok'.equalsIgnoreCase(resultMessage) && verificaRequisitiDematerializzazioneDealerResponse!=null && 'ok'.equalsIgnoreCase(verificaRequisitiDematerializzazioneDealerResponse.esito);
        }
                
        public override string getMessage() {
            String mess = super.getMessage();
            if (!isOK() && verificaRequisitiDematerializzazioneDealerResponse!=null) {
                // se non OK metto eventuale descrizione di errore
                mess=verificaRequisitiDematerializzazioneDealerResponse.desErrore;
            } 
            return mess;

        }         
    }

    //********************
    // INVOKER
    //********************
    public static Response invoke(Request req) {        
        
        return (Response)ApiUtils.callApi(SERVICE_NAME,req, Response.class);       
    }


}