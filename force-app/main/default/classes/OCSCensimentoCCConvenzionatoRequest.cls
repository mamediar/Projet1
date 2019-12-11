public class OCSCensimentoCCConvenzionatoRequest extends OCSRequest {
	@AuraEnabled
    public OCSCensimentoCCConvenzionatoRequestData censimentoCCConvenzionatoRequest{get;set;}
    
    public OCSCensimentoCCConvenzionatoRequest(){
        this.serviceId='censimentoCCConvenzionato';
        this.censimentoCCConvenzionatoRequest=new OCSCensimentoCCConvenzionatoRequestData();
    }
    
    public class OCSCensimentoCCConvenzionatoRequestData{
        @AuraEnabled
        public List<Elenco> elenco {get; set;}
        
        public OCSCensimentoCCConvenzionatoRequestData() {
            this.elenco=new List<Elenco>();
        }
    }

    public class Elenco {
		public String partimestp {get { if (partimestp == null ) partimestp = ''; return partimestp; } set;}
		public String iban {get { if (iban == null ) iban = ''; return iban; } set;}
		public String intermediario {get { if (intermediario == null ) intermediario = ''; return intermediario; } set;}
		public String progressivo {get { if (progressivo == null ) progressivo = ''; return progressivo; } set;}
		public String abi {get { if (abi == null ) abi = ''; return abi; } set;}
		public String cab {get { if (cab == null ) cab = ''; return cab; } set;}
		public String bankCode {get { if (bankCode == null ) bankCode = ''; return bankCode; } set;}
		public String subNumber {get { if (subNumber == null ) subNumber = ''; return subNumber; } set;}
		public String conto {get { if (conto == null ) conto = ''; return conto; } set;}
		public String cin {get { if (cin == null ) cin = ''; return cin; } set;}
		public String descrizione {get { if (descrizione == null ) descrizione = ''; return descrizione; } set;}
		public String liquidazione {get { if (liquidazione == null ) liquidazione = ''; return liquidazione; } set;}
		public String provvigioni {get { if (provvigioni == null ) provvigioni = ''; return provvigioni; } set;}
		public String erRvd {get { if (erRvd == null ) erRvd = ''; return erRvd; } set;}
		public String iva {get { if (iva == null ) iva = ''; return iva; } set;}
		public String agente {get { if (agente == null ) agente = ''; return agente; } set;}
		public String segnala {get { if (segnala == null ) segnala = ''; return segnala; } set;}        
    }
    

}