public class OCS_OCS_COPSVDTA_V1Response extends OCSResponse  {
    
    @AuraEnabled
    public Copsvdtaresponse copsvdtaresponse {get;set;}

    public OCS_OCS_COPSVDTA_V1Response() {
        this.copsvdtaresponse = new Copsvdtaresponse();
    }
    
    public class Copsvdtaresponse {
        public String mftpsres_STATUS {get;set;}
        public String  mftpsres_PROCEDURA  {get;set;}
        public Integer mftpsres_NUM_PRATICA {get;set;}
        public String mftpsres_STATO {get;set;}
        public String mftpsres_ATTRIBUTO {get;set;}
        public Integer mftpsres_PROGRESSIVO {get;set;}
        public String mftpsres_CODICE_RIF_EXT_2 {get;set;}
        public String msfologon_ERRORE {get;set;}
        public String msfologon_ERRORE_DES {get;set;}
        public String msfologon_STATUS {get;set;}
        public String msfologon_SESSION_ID {get;set;}
        @AuraEnabled
        public Mfterr_OMSFERR_OCCURS[] mfterr_OMSFERR_OCCURS {get;set;}

        public Copsvdtaresponse() {
            this.mfterr_OMSFERR_OCCURS = new List<Mfterr_OMSFERR_OCCURS>();
        }        
    }
    
    public class Mfterr_OMSFERR_OCCURS { 
		public Integer msferr_N_RECORD {get;set;}
		public String msferr_TIPO {get;set;}
		public String msferr_CODICE {get;set;}
		public String msferr_DESCRIZIONE {get;set;}
		public Integer msferr_N_CAMPO {get;set;}
		public String msferr_COD_MSG {get;set;}				
	}

}