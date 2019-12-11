public class OCSRicercaPresenzaLottoRequest extends OCSRequest {
    
    public String authorization {get; set;}
    public Ebagetadlv1Request ebagetadlv1Request {get; set;}
    
    public OCSRicercaPresenzaLottoRequest()
    	{
            serviceId = 'OCS_EBAGETADL_V1';
            ebagetadlv1Request = new Ebagetadlv1Request();
        }

    public class Ebagetadlv1Request{
        public String msfilogon_UTENTE {get; set;}
        public String mfbayadlo_IN_PRATICA {get; set;}
        public String mfbayadlo_IN_PROCEDURA {get; set;}
        public String msflogon_TMP_KEY {get; set;}
        public String msfilogon_SENDER_TIPO {get; set;}
        public Integer msfilogon_SENDER_CODICE {get; set;}
        public String msfilogon_CANALE_ACQUISIZ {get; set;}
    }   
}