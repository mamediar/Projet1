public class OCSCensimentoAnagIntegrativaRequest extends OCSRequest {

	@AuraEnabled
    public OCSCensimentoAnagIntegrativaRequestData censimentoAnagraficaIntegrativaRequest{get;set;}
    
    public OCSCensimentoAnagIntegrativaRequest(){
        this.serviceId='censimentoAnagraficaIntegrativa';
        this.censimentoAnagraficaIntegrativaRequest=new OCSCensimentoAnagIntegrativaRequestData();
    }
    
    public class OCSCensimentoAnagIntegrativaRequestData{
        @AuraEnabled
        public List<Elenco> elenco {get; set;}
        
        public OCSCensimentoAnagIntegrativaRequestData() {
            this.elenco=new List<Elenco>();
        }
    }    

    public class Elenco {
        
		public String partimestp{get { if (partimestp == null ) partimestp = ''; return partimestp; } set;}
		public String nomefile{get { if (nomefile == null ) nomefile = ''; return nomefile; } set;}
		public String intCodice{get { if (intCodice == null ) intCodice = ''; return intCodice; } set;}
		public String intStato{get { if (intStato == null ) intStato = ''; return intStato; } set;}
		public String intFiliale{get { if (intFiliale == null ) intFiliale = ''; return intFiliale; } set;}
		public String intFattRic{get { if (intFattRic == null ) intFattRic = ''; return intFattRic; } set;}
		public String intAttributo{get { if (intAttributo == null ) intAttributo = ''; return intAttributo; } set;}
		public String intTipologia{get { if (intTipologia == null ) intTipologia = ''; return intTipologia; } set;}
		public String intStampaProf{get { if (intStampaProf == null ) intStampaProf = ''; return intStampaProf; } set;}
		public String intRsStampaProf{get { if (intRsStampaProf == null ) intRsStampaProf = ''; return intRsStampaProf; } set;}
		public String intStampaAllProf{get { if (intStampaAllProf == null ) intStampaAllProf = ''; return intStampaAllProf; } set;}
		public String intRsStampaAllProf{get { if (intRsStampaAllProf == null ) intRsStampaAllProf = ''; return intRsStampaAllProf; } set;}
		public String intMacroarea{get { if (intMacroarea == null ) intMacroarea = ''; return intMacroarea; } set;}
		public String intProdottoDom{get { if (intProdottoDom == null ) intProdottoDom = ''; return intProdottoDom; } set;}
		public String intAccrAutomFatt{get { if (intAccrAutomFatt == null ) intAccrAutomFatt = ''; return intAccrAutomFatt; } set;}
		public String intAbilIsvap{get { if (intAbilIsvap == null ) intAbilIsvap = ''; return intAbilIsvap; } set;}
		public String intMediatore{get { if (intMediatore == null ) intMediatore = ''; return intMediatore; } set;}
		public String tipoint{get { if (tipoint == null ) tipoint = ''; return tipoint; } set;}
		public String respons{get { if (respons == null ) respons = ''; return respons; } set;}
		public String destprof{get { if (destprof == null ) destprof = ''; return destprof; } set;}
		public String codcomp{get { if (codcomp == null ) codcomp = ''; return codcomp; } set;}
		public String pagprovv{get { if (pagprovv == null ) pagprovv = ''; return pagprovv; } set;}
		public String dtconv{get { if (dtconv == null ) dtconv = ''; return dtconv; } set;}
		public String codagente{get { if (codagente == null ) codagente = ''; return codagente; } set;}
		public String icvPuntiVendita{get { if (icvPuntiVendita == null ) icvPuntiVendita = ''; return icvPuntiVendita; } set;}
		public String fvenditori{get { if (fvenditori == null ) fvenditori = ''; return fvenditori; } set;}
		public String codconv{get { if (codconv == null ) codconv = ''; return codconv; } set;}
		public String vendagg{get { if (vendagg == null ) vendagg = ''; return vendagg; } set;}
		public String annprov{get { if (annprov == null ) annprov = ''; return annprov; } set;}
		public String prvcatCategoria{get { if (prvcatCategoria == null ) prvcatCategoria = ''; return prvcatCategoria; } set;}
		public String segnala{get { if (segnala == null ) segnala = ''; return segnala; } set;}        

    }
  
    
    
}