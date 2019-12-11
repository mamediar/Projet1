public class OCSRecuperaPacchettiServiziRequest extends OCSRequest{
    @AuraEnabled public RecuperaPacchettiServiziRequestDTO recuperaPacchettiServiziRequest {get;set;}
    
    public OCSRecuperaPacchettiServiziRequest(){
        this.serviceId='recuperaPacchettiServizi';
        this.recuperaPacchettiServiziRequest=new RecuperaPacchettiServiziRequestDTO();
    }
    
    public class RecuperaPacchettiServiziRequestDTO{
        @AuraEnabled public String tipoPratica {get;set;}
        @AuraEnabled public String numPratica {get;set;}
    }
}