public class OCSCensimDatiAggConvenzionatoResponse  extends OCSResponse{

    @AuraEnabled
    public CensimDatiAggConvenzionatoResponse censimentoDatiAggConvenzionatoResponse{get;set;}     
    
    public class CensimDatiAggConvenzionatoResponse{
        @AuraEnabled
        public List<Elenco> elenco {get; set;}
        
        public CensimDatiAggConvenzionatoResponse() {
            this.elenco=new List<Elenco>();
        }        
    }    
 
    
    public class Elenco {        
		public String partimestp {get;set;}
		public String intermediario {get;set;}
		public String gestionePv {get;set;}
		public String gestioneVe {get;set;}
		public String destinatario {get;set;}
		public String destinatarioRappel {get;set;}
		public String pagamentoProvv {get;set;}
		public String pagamentoTerzi {get;set;}
		public String terzoDaLiquidare {get;set;}
		public String obblDocumenti {get;set;}
		public String plafond {get;set;}
		public String volumeAffari {get;set;}
		public String segnala {get;set;}        
    }
    
}