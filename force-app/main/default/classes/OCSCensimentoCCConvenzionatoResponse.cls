public class OCSCensimentoCCConvenzionatoResponse  extends OCSResponse{

    @AuraEnabled
    public CensimentoCCConvenzionatoResponse censimentoCCConvenzionatoResponse{get;set;}     
    
    public class CensimentoCCConvenzionatoResponse{
        @AuraEnabled
        public List<Elenco> elenco {get; set;}
        
        public CensimentoCCConvenzionatoResponse() {
            this.elenco=new List<Elenco>();
        }        
    }    
 
    
    public class Elenco {
		public String partimestp {get;set;}
		public String iban {get;set;}
		public String intermediario {get;set;}
		public String progressivo {get;set;}
		public String abi {get;set;}
		public String cab {get;set;}
		public String bankCode {get;set;}
		public String subNumber {get;set;}
		public String conto {get;set;}
		public String cin {get;set;}
		public String descrizione {get;set;}
		public String liquidazione {get;set;}
		public String provvigioni {get;set;}
		public String erRvd {get;set;}
		public String iva {get;set;}
		public String agente {get;set;}
		public String segnala {get;set;}        
    }
    
}