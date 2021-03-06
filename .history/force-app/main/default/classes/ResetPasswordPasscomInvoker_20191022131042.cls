public class ResetPasswordPasscomInvoker {
    //********************
    // REQUEST
    //********************
    public class Request extends OCSRequest {
        public String utente {get;set;}
        public CompanyType companyType;
        public Request() {
            serviceId = 'resetPasswordPasscom';
            utente=utente;
            companyType.value='COMPASS';
        }
        
        public Request(String utenza) {        
            serviceId = 'resetPasswordPasscom';
            utente = utenza;
            companyType.value='COMPASS';
        }
    }

    public class CompanyType {
        @AuraEnabled public String value{get;set;}
    }


    //********************
    // RESPONSE DTO
    //********************
    public class Response extends OCSResponse {
        @AuraEnabled
        public ResetPasswordPasscomResponseDTO resetPasswordPasscomResponse {get; set;}
            
        public override boolean isOK() {    
            return super.isOK() && resetPasswordPasscomResponse.resultMessage.equalsIgnoreCase('ok');
        }
                
        public override string getMessage() {
            return super.getMessage().equalsIgnoreCase('success') && isOK() ? super.getMessage() : resetPasswordPasscomResponse.resultCode;
        }  
    }

    public class ResetPasswordPasscomResponseDTO{
        
        @AuraEnabled public String resultCode{get;set;}
        @AuraEnabled public String resultMessage{get;set;}
        @AuraEnabled public ResetPasswordPasscomResponse resetPasswordPasscomResponseDTO{get;set;}    
        
    }

    public class ResetPasswordPasscomResponse{
        @AuraEnabled public String esito{get;set;}
        @AuraEnabled public String codErrore{get;set;}
        @AuraEnabled public String desErrore{get;set;}
    }

    //********************
    // INVOKER
    //********************

    public Response invoke(String utenza) {        
        
        Request req = new Request();       
        req.utente = utenza;
        
        return (Response)ApiUtils.callApi ('resetPasswordPasscom',req, Response.class);       
    }
}