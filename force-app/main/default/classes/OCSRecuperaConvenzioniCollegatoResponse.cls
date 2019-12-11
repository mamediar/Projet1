public class OCSRecuperaConvenzioniCollegatoResponse extends OCSResponse{
	@AuraEnabled
    public OCSRecuperaConvenzioniCollegatoResponseData recuperaConvenzioniCollegatoResponse{get;set;}
    
    public OCSRecuperaConvenzioniCollegatoResponse(){
        this.recuperaConvenzioniCollegatoResponse=new OCSRecuperaConvenzioniCollegatoResponseData();
    }
    
    public class OCSRecuperaConvenzioniCollegatoResponseData{
        @AuraEnabled
        public ConvenzioniCollegatoDTO[] elenco =  new List<ConvenzioniCollegatoDTO>   ();
        
        public ConvenzioniCollegatoDTO[] getElenco()
        {
            return this.elenco;
        }
    }
    
    public class ConvenzioniCollegatoDTO{
        @AuraEnabled
        public String codConvenzione{get;set;}
        @AuraEnabled
        public String ragioneSociale{get;set;}
        @AuraEnabled
        public String flagFirmatario{get;set;}
        @AuraEnabled
        public String flagRappresentante{get;set;}
        @AuraEnabled
        public String flagReferente{get;set;}
        @AuraEnabled
        public String flagSocio{get;set;}
        @AuraEnabled
        public String flagTitolare{get;set;}
        @AuraEnabled
        public String flagResponsabileIvass{get;set;}
        @AuraEnabled
        public String codIscrizioneIvass{get;set;}
        @AuraEnabled
        public String dataIscrizioneIvass{get;set;}
        @AuraEnabled
        public String dataScadenzaIscrizioneIvass{get;set;}
        @AuraEnabled
        public String dataApertura{get;set;} //AAAAMMGG oppure 0
        @AuraEnabled
        public String dataChiusura{get;set;} //AAAAMMGG oppure 0
        @AuraEnabled
        public String flagPresenzaAnagrafica{get;set;}
        @AuraEnabled
        public String flagPresenzaProtesti{get;set;}
        @AuraEnabled
        public String flagPresenzaEsponentiBanca{get;set;}
        @AuraEnabled
        public String tipoFirma{get;set;}
        @AuraEnabled
        public String note1{get;set;}
        @AuraEnabled
        public String note2{get;set;}
    }
}