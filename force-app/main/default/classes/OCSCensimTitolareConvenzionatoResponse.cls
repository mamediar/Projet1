public class OCSCensimTitolareConvenzionatoResponse  extends OCSResponse{

    @AuraEnabled
    public CensimTitolareConvenzionatoResponse censimentoTitolareConvenzionatoResponse {get;set;}     
    
    public class CensimTitolareConvenzionatoResponse{
        @AuraEnabled
        public List<Elenco> elenco {get; set;}
        
        public CensimTitolareConvenzionatoResponse() {
            this.elenco=new List<Elenco>();
        }        
    }    
 
            
	public class Elenco {
		public String partimestp {get;set;}
		public String primaria {get;set;}
		public String secondaria {get;set;}
		public String tipoSecondaria {get;set;}
		public String tipoLegame {get;set;}
		public String assenzaLegame {get;set;}
		public String dataInserimento {get;set;}
		public String dataChiusura {get;set;}
		public String dataAnnullo {get;set;}
		public String cert {get;set;}
		public String dataFineCert {get;set;}
		public String notaCert {get;set;}
		public String segnala {get;set;}
	}        
        

    
}