public class OCSVariazioneEmailInvoker {
    
    public static OCSVariazioneEmailResponse invoke (OCSVariazioneEmailRequest req) {
        return (OCSVariazioneEmailResponse)ApiUtils.callApi ('ocs.variazioneMailCliente', req, OCSVariazioneEmailResponse.class);
    }
    
    public static OCSVariazioneEmailResponse variazioneMail (String codCliente, String email) {
        OCSVariazioneEmailRequest req = new OCSVariazioneEmailRequest();
        req.datiVariazioneMailClienteRequest.codCliente = codCliente;
        req.datiVariazioneMailClienteRequest.email = email;
        
        system.debug('Response: ' + codCliente + ' mail ' + email);
        
        return invoke (req);
    }
}