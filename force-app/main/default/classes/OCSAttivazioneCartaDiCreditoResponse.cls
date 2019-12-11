public class OCSAttivazioneCartaDiCreditoResponse extends OCSResponse {
    public DatiAttivazioneCartaDiCreditoResponseDTO datiAttivazioneCartaDiCreditoResponse {get;set;}
    
    public class DatiAttivazioneCartaDiCreditoResponseDTO {
        public String statoCarta {get;set;}
        public String as400Status {get;set;}
        public String as400Errore {get;set;}
    }
    
    public override boolean isOK() {
        return super.isOK() && datiAttivazioneCartaDiCreditoResponse.as400Status.equalsIgnoreCase('ok');
        //return super.isOK() && 'OK'.equalsIgnoreCase(datiAttivazioneCartaDiCreditoResponse.as400Status);
    }
     
    public override String getMessage() {  
/*        String res = super.getMessage();
        if (res.equalsIgnoreCase('Success')){
            if(!this.isOK()) {
                res = 'Status: '+ datiAttivazioneCartaDiCreditoResponse.as400Status + '\nMessaggio: ' + datiAttivazioneCartaDiCreditoResponse.as400Errore;
            }
        }
        return res;     
*/
        return super.getMessage().equalsIgnoreCase('success') ? datiAttivazioneCartaDiCreditoResponse.as400Errore : super.getMessage();
    }
    
    
    
    
}