public class OCSRicercaPresenzaLottoResponse extends OCSResponse {

    public ebavaradpv1 ebagetadlv1Response {get; set;}
    
    public class ebavaradpv1{
        public Integer mfbayadlo_OU_LOTTO {get; set;}
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
        return resultCode == 0 ;
    }
    public boolean isFound()
    {
        return  ebagetadlv1Response.mfbayadlo_OU_LOTTO != 0 ;
    }

}