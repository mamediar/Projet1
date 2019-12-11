public class OCSrecuperaDatiUtenteZucchettiResponse extends OCSResponse{
    @AuraEnabled
    public recuperaDatiUtenteZucchettiResponse recuperaDatiUtenteZucchettiResponse{get;set;}

    public class recuperaDatiUtenteZucchettiResponse{
        @AuraEnabled
        public String codFiscale{get;set;}
        @AuraEnabled
        public String idCompany{get;set;}
        @AuraEnabled
        public String idEmploy{get;set;}
        @AuraEnabled
        public String modelloAuto{get;set;}
        @AuraEnabled
        public String tipoAuto{get;set;}
        @AuraEnabled
        public String username{get;set;}
    }
}