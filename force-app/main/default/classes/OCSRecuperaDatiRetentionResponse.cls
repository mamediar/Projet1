public class OCSRecuperaDatiRetentionResponse extends OCSResponse 
{
    @AuraEnabled
    public RecuperaDatiRetentionResponse recuperaDatiRetentionResponse{get; set;}
    
    public OCSRecuperaDatiRetentionResponse()
    {
        recuperaDatiRetentionResponse = new RecuperaDatiRetentionResponse();
        recuperaDatiRetentionResponse.elencoPratiche = new List<PraticheResponse>();
    }
    
    public class RecuperaDatiRetentionResponse
    {
        @AuraEnabled
        public List<PraticheResponse> elencoPratiche{get; set;}
    }
    public class PraticheResponse
    {
        @AuraEnabled
        public String tipoPratica {get; set;}
        @AuraEnabled
        public String numPratica {get; set;}
        @AuraEnabled
        public String statoPratica {get; set;}
        @AuraEnabled
        public String attributoPratica {get; set;}
        @AuraEnabled
        public String dataPrimaScadenza {get; set;}
        @AuraEnabled
        public String dataUltimaScadenza {get; set;}
        @AuraEnabled
        public String codProdotto {get; set;}
        @AuraEnabled
        public String desProdotto {get; set;}
        @AuraEnabled
        public String modalitaPagamento {get; set;}
        @AuraEnabled
        public String importoFinanziato {get; set;}
        @AuraEnabled
        public String montante {get; set;}
        @AuraEnabled
        public String saldoPratica {get; set;}
        @AuraEnabled
        public String dataEstinzione {get; set;}
        @AuraEnabled
        public String dataLiquidazione {get; set;}
        @AuraEnabled
        public String codCliente {get; set;}
        @AuraEnabled
        public String agente {get; set;}
    }
}