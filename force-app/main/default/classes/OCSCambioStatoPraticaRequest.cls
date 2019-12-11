public class OCSCambioStatoPraticaRequest extends OCSRequest{
    
    //public String authorization {get; set;}
    public Ebavaradpv1Request ebavaradpv1Request {get; set;}
    
    public OCSCambioStatoPraticaRequest()
    	{
            serviceId = 'OCS_EBAVARADP_V1';
            ebavaradpv1Request = new Ebavaradpv1Request();
        }
    
    
    public class Ebavaradpv1Request{
        public String msfilogon_UTENTE {get; set;}
        public String mfbayadpv_PRATICA {get; set;}
        public String mfbayadpv_PROCEDURA {get; set;}
        public String mfbayadpv_SITUAZIONE_PRATICA {get; set;}
        public String msflogon_TMP_KEY {get; set;}
        public String msfilogon_SENDER_TIPO {get; set;}
        public Integer msfilogon_SENDER_CODICE {get; set;}
        public String msfilogon_CANALE_ACQUISIZ {get; set;}
        public String msfilogon_TIPO_CARICAMENTO {get; set;}
    }   
}