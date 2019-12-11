public class OCSRecuperaSegnalazioniClienteResponse extends OCSResponse{
	@AuraEnabled
    public OCSRecuperaSegnalazioniClienteResponseData recuperaSegnalazioniClienteResponse{get;set;}
    
    public OCSRecuperaSegnalazioniClienteResponse(){
        this.recuperaSegnalazioniClienteResponse=new OCSRecuperaSegnalazioniClienteResponseData();
    }
    
    public class OCSRecuperaSegnalazioniClienteResponseData{
        @AuraEnabled
        public String causaleAnnullo{get;set;}
       	@AuraEnabled
        public String dataAnnullo{get;set;} //AAAAMMGG oppure 0 se vuota
        @AuraEnabled
        public SegnalazioneClienteDTO[] elencoSegnalazioni{get;set;}
        
        public OCSRecuperaSegnalazioniClienteResponseData(){
            this.elencoSegnalazioni=new List<SegnalazioneClienteDTO>();
        }
    }
    
    public class SegnalazioneClienteDTO{
            @AuraEnabled
            public String tipoSegnalazione{get;set;}
        }
    
	public Boolean isCointestata(){
        Boolean res=false;
        List<OCSRecuperaSegnalazioniClienteResponse.SegnalazioneClienteDTO> segnalazioni=this.recuperaSegnalazioniClienteResponse.elencoSegnalazioni;
        for(OCSRecuperaSegnalazioniClienteResponse.SegnalazioneClienteDTO s:segnalazioni){
            if('COI'.equalsIgnoreCase(s.tipoSegnalazione)){
                res=true;
                break;
            }
        }
        return res;
    }    
}