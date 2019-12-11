public class OCSVariazioneOffertePromoInvoker {  
    public static OCSVariazioneOffertePromoResponse invoke (OCSVariazioneOffertePromoRequest req) {
        return (OCSVariazioneOffertePromoResponse)ApiUtils.callApi ('ocs.variazioneOffertePromozionali', req, OCSVariazioneOffertePromoResponse.class); 
    }
    
    public static OCSVariazioneOffertePromoResponse variazioneOffertePromo (String codCliente) {
        OCSVariazioneOffertePromoRequest req = new OCSVariazioneOffertePromoRequest();
        req.variazioneOffertePromozionaliRequest.codCliente = codCliente;
        req.variazioneOffertePromozionaliRequest.flagOffCommInterne = 'M';
        req.variazioneOffertePromozionaliRequest.flagOffCommIntAut = 'M';
        req.variazioneOffertePromozionaliRequest.flagOffCommEsterne = 'M';
        req.variazioneOffertePromozionaliRequest.flagOffCommEstAut = 'M';
        req.variazioneOffertePromozionaliRequest.flagServiziAltri = 'M';
        req.variazioneOffertePromozionaliRequest.flagDatiSensibili = 'M';
        req.variazioneOffertePromozionaliRequest.flagStampaLettera = 'S';
        req.variazioneOffertePromozionaliRequest.valOffCommInterne = 'N';
        req.variazioneOffertePromozionaliRequest.valOffCommIntAut = 'N';
        req.variazioneOffertePromozionaliRequest.valOffCommEsterne = 'N';
        req.variazioneOffertePromozionaliRequest.valOffCommEstAut = 'N';
        req.variazioneOffertePromozionaliRequest.valServiziAltri = 'N';
        req.variazioneOffertePromozionaliRequest.valDatiSensibili = 'N';
        req.variazioneOffertePromozionaliRequest.codLettera = 'CC29';      
        
        return invoke (req);
    }
}