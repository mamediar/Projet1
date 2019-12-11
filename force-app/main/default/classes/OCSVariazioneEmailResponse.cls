public class OCSVariazioneEmailResponse extends OCSResponse {
    public DatiVariazioneMailClienteResponseDTO datiVariazioneMailClienteResponse {get; set;}  
    
    public class DatiVariazioneMailClienteResponseDTO {
        public String as400Status {get; set;}
        public String as400Errore {get; set;}
    }
    
    public override boolean isOK() {    
        return super.isOK() && datiVariazioneMailClienteResponse.as400Status.equalsIgnoreCase('ok');
    }
    
    public override string getMessage() {
        return super.getMessage().equalsIgnoreCase('success') ? datiVariazioneMailClienteResponse.as400Errore : super.getMessage();
    }
}