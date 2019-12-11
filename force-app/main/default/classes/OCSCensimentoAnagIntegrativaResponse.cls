public class OCSCensimentoAnagIntegrativaResponse  extends OCSResponse{

    @AuraEnabled
    public CensimentoAnagIntegrativaResponse censimentoAnagraficaIntegrativaResponse{get;set;}     
    
    public class CensimentoAnagIntegrativaResponse{
        @AuraEnabled
        public List<Elenco> elenco {get; set;}
        
        public CensimentoAnagIntegrativaResponse() {
            this.elenco=new List<Elenco>();
        }        
    }    
 
    
    public class Elenco {

		public String partimestp{get;set;}
		public String nomefile{get;set;}
		public String intCodice{get;set;}
		public String intStato{get;set;}
		public String intFiliale{get;set;}
		public String intFattRic{get;set;}
		public String intAttributo{get;set;}
		public String intTipologia{get;set;}
		public String intStampaProf{get;set;}
		public String intRsStampaProf{get;set;}
		public String intStampaAllProf{get;set;}
		public String intRsStampaAllProf{get;set;}
		public String intMacroarea{get;set;}
		public String intProdottoDom{get;set;}
		public String intAccrAutomFatt{get;set;}
		public String intAbilIsvap{get;set;}
		public String intMediatore{get;set;}
		public String tipoint{get;set;}
		public String respons{get;set;}
		public String destprof{get;set;}
		public String codcomp{get;set;}
		public String pagprovv{get;set;}
		public String dtconv{get;set;}
		public String codagente{get;set;}
		public String icvPuntiVendita{get;set;}
		public String fvenditori{get;set;}
		public String codconv{get;set;}
		public String vendagg{get;set;}
		public String annprov{get;set;}
		public String prvcatCategoria{get;set;}
		public String segnala{get;set;}
	}         
  
}