public class OCSRecuperaConvenzioniCollegatoRequest extends OCSRequest{
	@AuraEnabled
    public OCSRecuperaConvenzioniCollegatoRequestData recuperaConvenzioniCollegatoRequest{get;set;}
    
    public OCSRecuperaConvenzioniCollegatoRequest(){
        this.serviceId='recuperaConvenzioniCollegato';
        this.recuperaConvenzioniCollegatoRequest=new OCSRecuperaConvenzioniCollegatoRequestData();
    }
    
    public class OCSRecuperaConvenzioniCollegatoRequestData{
        @AuraEnabled
        public String codCollegato{get;set;}
    }
}