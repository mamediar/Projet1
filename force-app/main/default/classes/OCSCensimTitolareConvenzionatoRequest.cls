public class OCSCensimTitolareConvenzionatoRequest extends OCSRequest {
	@AuraEnabled
    public OCSCensimTitolareConvenzionatoRequestData censimentoTitolareConvenzionatoRequest{get;set;}
    
    public OCSCensimTitolareConvenzionatoRequest(){
        this.serviceId='censimentoTitolareConvenzionato';
        this.censimentoTitolareConvenzionatoRequest=new OCSCensimTitolareConvenzionatoRequestData();
    }
    
    public class OCSCensimTitolareConvenzionatoRequestData{
        @AuraEnabled
        public List<Elenco> elenco {get; set;}
        
        public OCSCensimTitolareConvenzionatoRequestData() {
            this.elenco=new List<Elenco>();
        }
    }

        
	public class Elenco {
		public String partimestp {get { if (partimestp == null ) partimestp = ''; return partimestp; } set;} 
		public String primaria {get { if (primaria == null ) primaria = ''; return primaria; } set;} 
		public String secondaria {get { if (secondaria == null ) secondaria = ''; return secondaria; } set;} 
		public String tipoSecondaria {get { if (tipoSecondaria == null ) tipoSecondaria = ''; return tipoSecondaria; } set;} 
		public String tipoLegame {get { if (tipoLegame == null ) tipoLegame = ''; return tipoLegame; } set;} 
		public String assenzaLegame {get { if (assenzaLegame == null ) assenzaLegame = ''; return assenzaLegame; } set;} 
		public String dataInserimento {get { if (dataInserimento == null ) dataInserimento = '0'; return dataInserimento; } set;} 
		public String dataChiusura {get { if (dataChiusura == null ) dataChiusura = '0'; return dataChiusura; } set;} 
		public String dataAnnullo {get { if (dataAnnullo == null ) dataAnnullo = '0'; return dataAnnullo; } set;} 
		public String cert {get { if (cert == null ) cert = ''; return cert; } set;} 
		public String dataFineCert {get { if (dataFineCert == null ) dataFineCert = ''; return dataFineCert; } set;} 
		public String notaCert {get { if (notaCert == null ) notaCert = ''; return notaCert; } set;} 
		public String segnala {get { if (segnala == null ) segnala = ''; return segnala; } set;} 
	}        

}