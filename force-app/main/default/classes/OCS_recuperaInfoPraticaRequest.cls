public class OCS_recuperaInfoPraticaRequest extends OCSRequest {
    
    @AuraEnabled 
    public String authorization{get;set;}
    @AuraEnabled
    public RecuperaInfoPraticaRequest recuperaInfoPraticaRequest{get;set;}

    public OCS_recuperaInfoPraticaRequest() {
        this.serviceId = 'recuperaInfoPratica';
        this.authorization = null;
        this.recuperaInfoPraticaRequest = new RecuperaInfoPraticaRequest();
    }
    
    public class RecuperaInfoPraticaRequest {
        public String numPratica {get;set;}                
    }    

}