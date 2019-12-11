public class OCSNormalizzaIndirizzoRequest extends OCSRequest{

    @AuraEnabled
    public OCSNormalizzaIndirizzoRequestData normalizzaIndirizzoRequest{get;set;}
    
    public OCSNormalizzaIndirizzoRequest(){
        this.serviceId='normalizzaIndirizzo';
        this.normalizzaIndirizzoRequest=new OCSNormalizzaIndirizzoRequestData();
    }
   

    public class OCSNormalizzaIndirizzoRequestData{
        @AuraEnabled
        public Indirizzo indirizzo {get; set;}
        
        public OCSNormalizzaIndirizzoRequestData() {
            this.indirizzo=new Indirizzo();
        }
    }

    public class Indirizzo{
        @AuraEnabled public String tipoIndirizzo {get;set;}
        @AuraEnabled public String indirizzo {get;set;}
        @AuraEnabled public String civico {get;set;}
        @AuraEnabled public String cap {get;set;}
        @AuraEnabled public String localita {get;set;}
        @AuraEnabled public String provincia {get;set;}
        @AuraEnabled public String nazione {get;set;}
        @AuraEnabled public String capRischio {get;set;}
    }    
    
}