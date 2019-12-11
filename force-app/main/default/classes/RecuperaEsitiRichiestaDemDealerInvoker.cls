public  class RecuperaEsitiRichiestaDemDealerInvoker {

    public final static String SERVICE_NAME = 'recuperaEsitiRichiestaDemDealer';
    private final static String SERVICE_ID = 'recuperaEsitiRichiestaDematerializzazioneDealer';

    public class RecuperaEsitiRichiestaDemDealerRequest  {
        public RecuperaEsitiRichiestaDemDealerRequest(){}
    }


    public class EsitoRichiestaDemDealerDTO {
        public String tipoIntermediario {get;set;}
        public String codIntermediario {get;set;}
        public String dataInserimento {get;set;}
        public String utenteRichiedente {get;set;}
        public String flagDematerializzazione {get;set;}
        public String esitoDematerializzazione {get;set;}
        public String dataElaborazioneOCS {get;set;}

        public EsitoRichiestaDemDealerDTO(){}
    }


    public class EsitoRichiestaDemDealerResponse {
          public EsitoRichiestaDemDealerDTO[] elenco {get;set;} 
       
          public EsitoRichiestaDemDealerResponse(){}

    }

    //********************
    // REQUEST
    //********************
    public class Request extends OCSRequest {
        
        public RecuperaEsitiRichiestaDemDealerRequest recuperaEsitiRichiestaDematerializzazioneDealerRequest {get; set;}
        
        public Request() {
            serviceId = SERVICE_ID;
            recuperaEsitiRichiestaDematerializzazioneDealerRequest = new RecuperaEsitiRichiestaDemDealerRequest();
        }      
        
    }


    //********************
    // RESPONSE 
    //********************

    public class Response extends OCSResponse {
        @AuraEnabled
        public EsitoRichiestaDemDealerResponse recuperaEsitiRichiestaDematerializzazioneDealerResponse {get; set;}
            
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


}