public class OCSRecuperaPacchettiServiziResponse extends OCSResponse{
    
    public class RecuperaPacchettiServiziResponseDTO{
        @AuraEnabled 
        public List<PacchettoServizioDTO> elencoPacchettiServizi;
    }
    
    @AuraEnabled 
    public RecuperaPacchettiServiziResponseDTO recuperaPacchettiServiziResponse {get;set;}
    
    public OCSRecuperaPacchettiServiziResponse(){
        this.recuperaPacchettiServiziResponse=new RecuperaPacchettiServiziResponseDTO();
        this.recuperaPacchettiServiziResponse.elencoPacchettiServizi=new List<PacchettoServizioDTO>();
    }
    
    public class PacchettoServizioDTO{
        @AuraEnabled public String codServizio {get;set;}
        @AuraEnabled public String codPacchetto {get;set;}
        @AuraEnabled public String codFornitore {get;set;}
        @AuraEnabled public String dataInizioCopertura {get;set;}
        @AuraEnabled public String dataFineCopertura {get;set;}
        @AuraEnabled public String assicurazioneAttivaFinanziata {get;set;}
        @AuraEnabled public String durata {get;set;}
        @AuraEnabled public String desFornitore {get;set;}
    }
}