public class InserimentoRichiestaDemDealerInvoker {

    public final static String SERVICE_NAME = 'inserimentoRichiestaDemDealer';
    private final static String SERVICE_ID = 'inserimentoRichiestaDematerializzazioneDealer';


    public class InserimentoRichiestaDemDealerRequestDTO  {
        public String tipoIntermediario {get;set;}
        public String codIntermediario {get;set;}
        public String utenteRichiedente {get;set;}

        public InserimentoRichiestaDemDealerRequestDTO(){}
        public InserimentoRichiestaDemDealerRequestDTO(String tipoIntermediario, String codIntermediario,String utenteRichiedente){
            this.tipoIntermediario = tipoIntermediario;
            this.codIntermediario = codIntermediario;
            this.utenteRichiedente = utenteRichiedente;
        }
    }

    public class InserimentoRichiestaDemDealerResponseDTO  {
        public String esito {get;set;}
        public String desErrore {get;set;}

        public InserimentoRichiestaDemDealerResponseDTO(){}
    }


    //********************
    // REQUEST
    //********************
    public class Request extends OCSRequest {
        
        public InserimentoRichiestaDemDealerRequestDTO inserimentoRichiestaDematerializzazioneDealerRequest {get; set;}
        
        public Request() {
            serviceId = SERVICE_ID;
            inserimentoRichiestaDematerializzazioneDealerRequest = new InserimentoRichiestaDemDealerRequestDTO();
        }      
        
        public Request(String tipoIntermediario, String codIntermediario,String utenteRichiedente) {
            serviceId = SERVICE_ID;
            inserimentoRichiestaDematerializzazioneDealerRequest = new InserimentoRichiestaDemDealerRequestDTO(tipoIntermediario,codIntermediario,utenteRichiedente);
        }      
    }


    //********************
    // RESPONSE 
    //********************

    public class Response extends OCSResponse {
        @AuraEnabled
        public InserimentoRichiestaDemDealerResponseDTO inserimentoRichiestaDematerializzazioneDealerResponse {get; set;}
            
        public override boolean isOK() {    
            return super.isOK() && 'ok'.equalsIgnoreCase(resultMessage) && inserimentoRichiestaDematerializzazioneDealerResponse!=null && 'ok'.equalsIgnoreCase(inserimentoRichiestaDematerializzazioneDealerResponse.esito);
        }
                
        public override string getMessage() {
            String mess = super.getMessage();
            if (!isOK() && inserimentoRichiestaDematerializzazioneDealerResponse!=null) {
                System.debug('Messaggio chiamata :'+ super.getMessage());
                // se non OK, metto eventuale descrizione di errore
                mess=inserimentoRichiestaDematerializzazioneDealerResponse.desErrore;
                System.debug('Messaggio Errore :'+ mess);
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