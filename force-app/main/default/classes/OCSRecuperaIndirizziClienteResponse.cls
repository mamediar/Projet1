public class OCSRecuperaIndirizziClienteResponse extends OCSResponse{
    public class RecuperaIndirizziClienteResponseDTO{
        @AuraEnabled 
        public List<IndirizzoDTO> elencoIndirizzi;
    }
    
    @AuraEnabled 
    public RecuperaIndirizziClienteResponseDTO recuperaIndirizziClienteResponse {get;set;}
    
    public OCSRecuperaIndirizziClienteResponse(){
        this.recuperaIndirizziClienteResponse=new RecuperaIndirizziClienteResponseDTO();
        this.recuperaIndirizziClienteResponse.elencoIndirizzi=new List<IndirizzoDTO>();
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