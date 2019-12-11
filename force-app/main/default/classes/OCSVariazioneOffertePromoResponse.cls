public class OCSVariazioneOffertePromoResponse extends OCSResponse{
    public variazioneOffertePromozionaliResponseDTO variazioneOffertePromozionaliResponse {get; set;}  
    
    public class variazioneOffertePromozionaliResponseDTO {
        public String esitoElaborazione {get; set;}
    }
    
    public override boolean isOK() {    
        return super.isOK() && variazioneOffertePromozionaliResponse.esitoElaborazione.equalsIgnoreCase('ok');
    }
    
    public override string getMessage() {
        return super.getMessage().equalsIgnoreCase('success') ? variazioneOffertePromozionaliResponse.esitoElaborazione : super.getMessage();
    }
}