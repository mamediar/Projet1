public class OCSVariazioneDocIdentitaResponse extends OCSResponse {
    
    @AuraEnabled
    public DatiVariazioneDocIdentitaResponse datiVariazioneDocIdentitaResponse {get;set;}

    public OCSVariazioneDocIdentitaResponse() {
        this.datiVariazioneDocIdentitaResponse = new DatiVariazioneDocIdentitaResponse();
    }
    
    public class DatiVariazioneDocIdentitaResponse {
        public String as400Errore;
        public String as400Status;
    }
        
    
}