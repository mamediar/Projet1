@isTest
public class OCSRicercaPresenzaLottoResponseTest 
{
	@isTest
    public static void test()
    {
		OCSRicercaPresenzaLottoResponse.Ebavaradpv1RequestInfo ogg2 = new OCSRicercaPresenzaLottoResponse.Ebavaradpv1RequestInfo();
        ogg2.msferr_COD_MSG = '';
        ogg2.msferr_CODICE = '';
        ogg2.msferr_DESCRIZIONE = '';
        ogg2.msferr_N_CAMPO = 0;
        ogg2.msferr_N_RECORD = 0;
        ogg2.msferr_TIPO = '';    
        List<OCSRicercaPresenzaLottoResponse.Ebavaradpv1RequestInfo> listogg = new List<OCSRicercaPresenzaLottoResponse.Ebavaradpv1RequestInfo>();
        listogg.add(ogg2);
        OCSRicercaPresenzaLottoResponse ogg = new OCSRicercaPresenzaLottoResponse();
        ogg.ebagetadlv1Response = new OCSRicercaPresenzaLottoResponse.ebavaradpv1();
        
        ogg.ebagetadlv1Response.mfbayadlo_OU_LOTTO = 0;
        ogg.ebagetadlv1Response.msfologon_STATUS = '';
        ogg.ebagetadlv1Response.msfologon_ERRORE = '';
        ogg.ebagetadlv1Response.msfologon_ERRORE_DES = '';
        ogg.ebagetadlv1Response.msfologon_SESSION_ID = '';
        ogg.ebagetadlv1Response.mfterr_OMSFERR_OCCURS = listogg;   
    }
}