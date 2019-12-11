public class OCSRecuperaDelinquencyResponse extends OCSResponse{ 
    
    @AuraEnabled
    public recuperaDelinquencyResponse recuperaDelinquencyResponse{get;set;}

    public class recuperaDelinquencyResponse{
    @AuraEnabled
    public String currentDelinquencyCliente{get; set;}
    @AuraEnabled
    public String maxDelinquencyCliente{get; set;}
    @AuraEnabled
    public List<elencoPraticheClass> elencoPratiche{get;set;}
    }

    /*public OCSRecuperaDelinquencyResponse(){
        this.elencoPratiche= new List<elencoPraticheClass>();
    }*/

    public class elencoPraticheClass{
        @AuraEnabled
        public String tipoPratica{get;set;}
        @AuraEnabled
        public String numPratica{get;set;}
        @AuraEnabled
        public String currentDelinquency{get;set;}
        @AuraEnabled
        public String maxDelinquency{get;set;}
    }
}