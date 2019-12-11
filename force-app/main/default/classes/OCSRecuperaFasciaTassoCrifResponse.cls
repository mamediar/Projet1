public class OCSRecuperaFasciaTassoCrifResponse extends OCSResponse{ 
    @AuraEnabled
    public recuperaFasciaTassoCrifResponse recuperaFasciaTassoCrifResponse{get;set;}
        
    public class recuperaFasciaTassoCrifResponse{
        @AuraEnabled
        public String codFasciaTasso{get;set;}
        @AuraEnabled
        public String as400Status{get;set;}
        @AuraEnabled
        public String as400Errore{get;set;}
    }
}