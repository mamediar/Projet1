public class OCSVariazioneOffertePromoRequest extends OCSRequest{
    public String authorization {get; set;}
    public variazioneOffertePromozionaliRequestDTO variazioneOffertePromozionaliRequest {get; set;}
    
    public OCSVariazioneOffertePromoRequest() {
        this.serviceId = 'variazioneOffertePromozionali';
        this.variazioneOffertePromozionaliRequest = new variazioneOffertePromozionaliRequestDTO();
    }
    
    public class variazioneOffertePromozionaliRequestDTO {
        public String codCliente {get; set;}
        public String flagOffCommInterne {get; set;}
        public String flagOffCommIntAut {get; set;}
        public String flagOffCommEsterne {get; set;}
        public String flagOffCommEstAut {get; set;}
        public String flagServiziAltri {get; set;}
        public String flagDatiSensibili {get; set;}
        public String flagStampaLettera {get; set;}
        public String valOffCommInterne {get; set;}
        public String valOffCommIntAut {get; set;}
        public String valOffCommEsterne {get; set;}
        public String valOffCommEstAut {get; set;}
        public String valServiziAltri {get; set;}
        public String valDatiSensibili {get; set;}
        public String codLettera {get; set;}
    }

}