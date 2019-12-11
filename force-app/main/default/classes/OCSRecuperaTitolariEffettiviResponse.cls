public class OCSRecuperaTitolariEffettiviResponse  extends OCSResponse{

    @AuraEnabled
    public RecuperaTitolariEffettiviResponse recuperaTitolariEffettiviResponse{get;set;}     
    
    public class RecuperaTitolariEffettiviResponse{
        @AuraEnabled
        public List<ElencoTitolari> ElencoTitolari {get; set;}
        
        public RecuperaTitolariEffettiviResponse() {
            this.elencoTitolari=new List<ElencoTitolari>();
        }        
    }    


	public class ElencoTitolari {
		public String codAnaSecondaria {get;set;}
		public String tipoAnaSecondaria {get;set;}
		public String tipoLegame {get;set;}
		public String assenzaLegame {get;set;}
		public String dataInserimento {get;set;}
		public String dataChiusura {get;set;}
		public String dataAnnullo {get;set;}
		public String cert {get;set;}
		public String certDataFine {get;set;}
		public String certNote {get;set;}
	}    
    
    

    
    
}