public class OCSAttivazioneCartaDiCreditoInvoker {
    
    
    public static OCSAttivazioneCartaDiCreditoResponse attivaCarta (OCSAttivazioneCartaDiCreditoRequest request) {
        return (OCSAttivazioneCartaDiCreditoResponse)ApiUtils.callApi('ocs.attivazioneCartaDiCredito', request, OCSAttivazioneCartaDiCreditoResponse.class); 
        
    } 
     
        
    public static OCSAttivazioneCartaDiCreditoResponse  attivaCarta (ValoriRichiesti obj) {
        OCSAttivazioneCartaDiCreditoRequest cartaReq = new OCSAttivazioneCartaDiCreditoRequest();
        cartaReq.numeroCarta = obj.numeroCarta;
        cartaReq.scadenzaCarta = obj.scadenzaCarta;
        cartaReq.utente = obj.utente;
        return   attivaCarta(cartaReq); 
    }
/*    
    public static List<OCSAttivazioneCartaDiCreditoResponse>  attivaCarta (List<ValoriRichiesti> objList) {
        List<OCSAttivazioneCartaDiCreditoResponse> listaResponse = new List<OCSAttivazioneCartaDiCreditoResponse>();
        for (ValoriRichiesti i : objList) {
            listaResponse.add(attivaCarta(i));
        } 
        return listaResponse;
    }
*/    
    public class ValoriRichiesti {
        public String numeroCarta {get;set;}
        public String scadenzaCarta {get;set;} 
        public String utente {get;set;}
    }
    
}