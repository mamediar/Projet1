public class OCSCensimDatiAggConvenzionatoRequest extends OCSRequest {
	@AuraEnabled
    public OCSCensimDatiAggConvenzionatoRequestData censimentoDatiAggConvenzionatoRequest{get;set;}
    
    public OCSCensimDatiAggConvenzionatoRequest(){
        this.serviceId='censimentoDatiAggConvenzionato';
        this.censimentoDatiAggConvenzionatoRequest=new OCSCensimDatiAggConvenzionatoRequestData();
    }
    
    public class OCSCensimDatiAggConvenzionatoRequestData{
        @AuraEnabled
        public List<Elenco> elenco {get; set;}
        
        public OCSCensimDatiAggConvenzionatoRequestData() {
            this.elenco=new List<Elenco>();
        }
    }

    public class Elenco {        
		public String partimestp {get { if (partimestp == null ) partimestp = ''; return partimestp; } set;}
		public String intermediario {get { if (intermediario == null ) intermediario = ''; return intermediario; } set;}
		public String gestionePv {get { if (gestionePv == null ) gestionePv = ''; return gestionePv; } set;}
		public String gestioneVe {get { if (gestioneVe == null ) gestioneVe = ''; return gestioneVe; } set;}
		public String destinatario {get { if (destinatario == null ) destinatario = ''; return destinatario; } set;}
		public String destinatarioRappel {get { if (destinatarioRappel == null ) destinatarioRappel = ''; return destinatarioRappel; } set;}
		public String pagamentoProvv {get { if (pagamentoProvv == null ) pagamentoProvv = ''; return pagamentoProvv; } set;}
		public String pagamentoTerzi {get { if (pagamentoTerzi == null ) pagamentoTerzi = ''; return pagamentoTerzi; } set;}
		public String terzoDaLiquidare {get { if (terzoDaLiquidare == null ) terzoDaLiquidare = ''; return terzoDaLiquidare; } set;}
		public String obblDocumenti {get { if (obblDocumenti == null ) obblDocumenti = ''; return obblDocumenti; } set;}
		public String plafond {get { if (plafond == null ) plafond = ''; return plafond; } set;}
		public String volumeAffari {get { if (volumeAffari == null ) volumeAffari = ''; return volumeAffari; } set;}
		public String segnala {get { if (segnala == null ) segnala = ''; return segnala; } set;}        
    }
    

}