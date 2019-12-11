public class OCSCambioStatoPraticaResponse extends OCSResponse {

    public ebavaradpv1 ebavaradpv1Response {get; set;}
    public List<Ebavaradpv1RequestInfo> Ebavaradpv1RequestInfoResponse = new List<Ebavaradpv1RequestInfo>();
    
    public class ebavaradpv1{
        public String msfres_STATUS {get; set;}
        public String msfologon_STATUS {get; set;}
        public String msfologon_ERRORE {get; set;}
        public List<Ebavaradpv1RequestInfo> mfterr_OMSFERR_OCCURS {get; set;}
        public String msfologon_ERRORE_DES {get; set;}
        public String msfologon_SESSION_ID {get; set;}
    }
    public class Ebavaradpv1RequestInfo{
       public String msferr_CODICE {get; set;}
       public Integer msferr_N_RECORD {get; set;}
       public String msferr_TIPO {get; set;}
       public String msferr_DESCRIZIONE {get; set;}
       public Integer msferr_N_CAMPO {get; set;}
       public String msferr_COD_MSG {get; set;}
    }
     public override boolean isOK()
    {
        return null == ebavaradpv1Response.mfterr_OMSFERR_OCCURS ? 
            ebavaradpv1Response.msfres_STATUS.equals('OK') : 
        ebavaradpv1Response.mfterr_OMSFERR_OCCURS[0].msferr_CODICE.equals('0') && ebavaradpv1Response.msfres_STATUS.equals('OK');
    }
}