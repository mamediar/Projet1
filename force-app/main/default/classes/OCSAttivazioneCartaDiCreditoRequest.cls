public class OCSAttivazioneCartaDiCreditoRequest extends OCSRequest {
    @AuraEnabled
    public String scadenzaCarta {get;set;}
    @AuraEnabled
    public String utente {get;set;}
    @AuraEnabled
    public String numeroCarta {get;set;} 
    
    public OCSAttivazioneCartaDiCreditoRequest() {
        this.serviceId='attivazioneCartaDiCredito';
    }
    
}