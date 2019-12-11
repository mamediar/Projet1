public class OCSRecuperaSaldoClienteResponse extends OCSResponse{ 
    @AuraEnabled
    public recuperaSaldoClienteResponse recuperaSaldoClienteResponse;
    
    public class recuperaSaldoClienteResponse{ 
        @AuraEnabled
        public List<PraticheClass> elencoPratiche;
    }

    public class PraticheClass{
        @AuraEnabled
        public String numPratica{get;set;}
        @AuraEnabled
        public String tipoPratica{get;set;}
        @AuraEnabled
        public String saldo{get;set;}
        @AuraEnabled
        public String tipoProdotto{get;set;}
        @AuraEnabled
        public String dataEsame{get;set;}
        @AuraEnabled
        public String stato{get;set;}
        @AuraEnabled
        public String attributo{get;set;}
        @AuraEnabled
        public String tipoRapporto{get;set;}
        @AuraEnabled
        public String prodotto{get;set;}
        @AuraEnabled
        public String scaduto{get;set;}
        @AuraEnabled
        public String finanziato{get;set;}
        @AuraEnabled
        public String dataPrimoUtilizzo{get;set;}
        @AuraEnabled
        public String dataPrimaAttivazione{get;set;}
        @AuraEnabled
        public String dataCompetenzaPrimoEC{get;set;}
    }
}