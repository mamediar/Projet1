public class RecuperaUtenzeIntermediarioInvoker {
    
    //********************
    // REQUEST
    //********************
    public class Request extends OCSRequest {
        
        public RecuperaUtenzeIntermediarioRequestDTO recuperaUtenzeIntermediarioRequest {get; set;}
        
        public Request() {
            serviceId = 'recuperaUtenzeIntermediario';
            recuperaUtenzeIntermediarioRequest = new RecuperaUtenzeIntermediarioRequestDTO();
        }
        
        public Request(RecuperaUtenzeIntermediarioRequestDTO objectIn) {        
            serviceId = 'recuperaUtenzeIntermediario';
            recuperaUtenzeIntermediarioRequest = objectIn;
        }
        
    }
    
    public class RecuperaUtenzeIntermediarioRequestDTO {      				
        public String codiceIntermediario {get; set;}
        public String codiceUtenza {get; set;}
    }
    
    //********************
    // RESPONSE DTO
    //********************
    
    public class Response extends OCSResponse {
        @AuraEnabled
        public RecuperaStatoRichiestePSVResponseDTO recuperaUtenzeIntermediarioResponse {get; set;}
            
        public override boolean isOK() {    
            return super.isOK() && recuperaUtenzeIntermediarioResponse.AS400Status.equalsIgnoreCase('ok');
        }
                
        public override string getMessage() {
            return super.getMessage().equalsIgnoreCase('success') && isOK() ? super.getMessage() : recuperaUtenzeIntermediarioResponse.AS400Errore;
        }         
    }
    
    public class RecuperaStatoRichiestePSVResponseDTO{
        
        @AuraEnabled public String AS400Status{get;set;}
        @AuraEnabled public String AS400Errore{get;set;}
        @AuraEnabled public UtenzaIntermediarioDTO[] utenze{get;set;}    
        
    }
    
    public class UtenzaIntermediarioDTO{
        
        @AuraEnabled public String codiceIntermediario{get;set;}
        @AuraEnabled public String ragSocIntermediario{get;set;}
        @AuraEnabled public String utenza{get;set;}
        @AuraEnabled public String flagDisabilitato{get;set;}
        @AuraEnabled public String dataScadenzaAccount{get;set;}
        @AuraEnabled public String canale{get;set;}
        @AuraEnabled public String nome{get;set;}
        @AuraEnabled public String cognome{get;set;}
        @AuraEnabled public String email{get;set;}
        @AuraEnabled public String codAnagrafica{get;set;}
        @AuraEnabled public String flagAuth{get;set;}
        @AuraEnabled public String dataNascita{get;set;}
        @AuraEnabled public String localitaNascita{get;set;}
        @AuraEnabled public String provinciaNascita{get;set;}
        @AuraEnabled public String codiceFiscale{get;set;}
        @AuraEnabled public String profiloAri{get;set;}
        @AuraEnabled public String filiale{get;set;}
        @AuraEnabled public String partitaIva{get;set;}
        @AuraEnabled public String tipo{get;set;}
        @AuraEnabled public String statoDealer{get;set;}     
    }
    
    //********************
    // INVOKER
    //********************
    public static Response invoke (RecuperaUtenzeIntermediarioRequestDTO objectIn ) {    
        System.debug('############################ running invoke ')  ;
        
        Request req = new Request();       
        req.recuperaUtenzeIntermediarioRequest = objectIn;
        
        return (Response)ApiUtils.callApi ('recuperaUtenzeIntermediario',req, Response.class);       
    }

    public static Boolean validateResponse(Response response){
        Boolean validate = false;
        if(response.resultCode != 0 || response.recuperaUtenzeIntermediarioResponse.utenze.size() == 0){
            validate = true;
        }
        return !validate;
    }
    
}