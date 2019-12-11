public class OCSVariazioneEmailRequest extends OCSRequest {
    public String authorization {get; set;}
    public DatiVariazioneMailClienteRequestDTO datiVariazioneMailClienteRequest {get; set;}
    
    public OCSVariazioneEmailRequest() {
        this.serviceId = 'variazioneMailCliente';
        this.datiVariazioneMailClienteRequest = new DatiVariazioneMailClienteRequestDTO();
    }
    
    public class DatiVariazioneMailClienteRequestDTO {
        public String codCliente {get; set;}
        public String email {get;set;} 
    }
}