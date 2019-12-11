public class OCSNormalizzaIndirizzoResponse extends OCSResponse{
    public class NormalizzaIndirizzoResponseDTO{
        @AuraEnabled 
        public List<IndirizzoDTO> elencoIndirizzi;
        public String esito;
        public String codErrore;
        public String desErrore;
    }
    
    @AuraEnabled 
    public NormalizzaIndirizzoResponseDTO normalizzaIndirizzoResponse {get;set;}
    
    public OCSNormalizzaIndirizzoResponse(){
        this.normalizzaIndirizzoResponse=new NormalizzaIndirizzoResponseDTO();
        this.normalizzaIndirizzoResponse.elencoIndirizzi=new List<IndirizzoDTO>();
    }
    
    public class IndirizzoDTO{
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