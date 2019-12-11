public class OCSRecuperaStatoRichiestePSVResponse extends OCSResponse
{
    @AuraEnabled
    public recuperaStatoRichiestePSVResponseClass recuperaStatoRichiestePSVResponse{get;set;}
    
    public OCSRecuperaStatoRichiestePSVResponse(){ 
        recuperaStatoRichiestePSVResponse = new recuperaStatoRichiestePSVResponseClass();
    }
    
    public class recuperaStatoRichiestePSVResponseClass{
        @AuraEnabled
        public List<ResponseClass> elencoStatiRichieste;
    }
    
    public class ResponseClass{
        @AuraEnabled
        public String progressivo{get;set;}
        @AuraEnabled
        public String stato{get;set;}
        @AuraEnabled
        public String blocco{get;set;}
        @AuraEnabled
        public String dataAzione{get;set;}
        @AuraEnabled
        public String codAzione{get;set;}
    }
}