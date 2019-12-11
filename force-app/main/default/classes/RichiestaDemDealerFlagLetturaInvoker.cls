public  class RichiestaDemDealerFlagLetturaInvoker {

    public final static String SERVICE_NAME = 'richiestaDemDealerFlagLettura';
    private final static String SERVICE_ID = 'richiestaDematerializzazioneDealerFlagLettura';


   public class RichiestaDemDealerFlagLetturaRequest  {
        public String tipoIntermediario {get;set;}
        public String codIntermediario {get;set;}
        public String dataInserimento {get;set;}

        public RichiestaDemDealerFlagLetturaRequest(){}
        public RichiestaDemDealerFlagLetturaRequest(String tipoIntermediario, String codIntermediario,String dataInserimento){
            this.tipoIntermediario = tipoIntermediario;
            this.codIntermediario = codIntermediario;
            this.dataInserimento = dataInserimento;
        }
    }


   public class RichiestaDemDealerFlagLetturaResponse  {
        public String esito {get;set;}
        public RichiestaDemDealerFlagLetturaResponse(){}
    }


    //********************
    // REQUEST
    //********************
    public class Request extends OCSRequest {
        
        public RichiestaDemDealerFlagLetturaRequest richiestaDematerializzazioneDealerFlagLetturaRequest {get; set;}
        
        public Request() {
            serviceId = SERVICE_ID;
            richiestaDematerializzazioneDealerFlagLetturaRequest = new RichiestaDemDealerFlagLetturaRequest();
        }      
        
        public Request(String tipoIntermediario, String codIntermediario,String dataInserimento) {
            serviceId = SERVICE_ID;
            richiestaDematerializzazioneDealerFlagLetturaRequest = new RichiestaDemDealerFlagLetturaRequest(tipoIntermediario,codIntermediario,dataInserimento);
        }      
    }
    
   //********************
    // RESPONSE 
    //********************

    public class Response extends OCSResponse {
        @AuraEnabled
        public RichiestaDemDealerFlagLetturaResponse richiestaDematerializzazioneDealerFlagLetturaResponse {get; set;}
            
        public override boolean isOK() {    
            return super.isOK() && 'ok'.equalsIgnoreCase(resultMessage) && richiestaDematerializzazioneDealerFlagLetturaResponse!=null && 'ok'.equalsIgnoreCase(richiestaDematerializzazioneDealerFlagLetturaResponse.esito);
        }
                
        public override string getMessage() {
            String mess = super.getMessage();
            if (!isOK() && richiestaDematerializzazioneDealerFlagLetturaResponse!=null) {
                // se non OK, concateno anche eventuale esito
                mess+=' esito: '+richiestaDematerializzazioneDealerFlagLetturaResponse.esito;
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