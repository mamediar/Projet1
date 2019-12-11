@isTest
public class OCSCambioStatoPraticaResponseTest 
{
	@isTest
    public static void test()
    {
        String response = '{"resultCode":0,"resultMessage":"Ok","ebavaradpv1Response":{"msfres_STATUS":"OK","msfologon_STATUS":"a","msfologon_ERRORE":"a","mfterr_OMSFERR_OCCURS":[{  "msferr_CODICE":"4044","msferr_N_RECORD":1,"msferr_TIPO":"E","msferr_DESCRIZIONE":"4044 Nessun lotto abbinato","msferr_N_CAMPO":2,"msferr_COD_MSG":"&ADPV"}],"msfologon_ERRORE_DES":"a","msfologon_SESSION_ID":"788ec2e42093697fc3bcfaf45050f174"}}';     
        OCSCambioStatoPraticaResponse.Ebavaradpv1RequestInfo pratica2 = new OCSCambioStatoPraticaResponse.Ebavaradpv1RequestInfo();
        pratica2.msferr_CODICE = 'ko';
    	pratica2.msferr_N_RECORD  = 0;
        pratica2.msferr_TIPO  ='E';
        pratica2.msferr_DESCRIZIONE = 'error';  
        pratica2.msferr_N_CAMPO  = 2;
        pratica2.msferr_COD_MSG  = 'error';
        OCSCambioStatoPraticaResponse pratica = (OCSCambioStatoPraticaResponse)JSON.deserialize(response, OCSCambioStatoPraticaResponse.class) ;
    	pratica.resultCode = 0;
        pratica.resultMessage = 'ok';
        pratica.ebavaradpv1Response.msfres_status = 'ok';
        pratica.ebavaradpv1Response.msfologon_status = 'ok';
        pratica.ebavaradpv1Response.msfologon_errore = 'ok';
        pratica.ebavaradpv1Response.mfterr_OMSFERR_OCCURS.add(pratica2);
        pratica.ebavaradpv1Response.msfologon_ERRORE_DES = 'ok';
        pratica.ebavaradpv1Response.msfologon_SESSION_ID = 'ko';
      	boolean test = pratica.isOK();
     }
     @isTest
    public static void testisnull()
    {
        String response = '{"resultCode":0,"resultMessage":"Ok","ebavaradpv1Response":{"msfres_STATUS":"OK","msfologon_STATUS":"a","msfologon_ERRORE":"a","mfterr_OMSFERR_OCCURS":[{  "msferr_CODICE":"4044","msferr_N_RECORD":1,"msferr_TIPO":"E","msferr_DESCRIZIONE":"4044 Nessun lotto abbinato","msferr_N_CAMPO":2,"msferr_COD_MSG":"&ADPV"}],"msfologon_ERRORE_DES":"a","msfologon_SESSION_ID":"788ec2e42093697fc3bcfaf45050f174"}}';     
        OCSCambioStatoPraticaResponse.Ebavaradpv1RequestInfo pratica2 = new OCSCambioStatoPraticaResponse.Ebavaradpv1RequestInfo();
        OCSCambioStatoPraticaResponse pratica = (OCSCambioStatoPraticaResponse)JSON.deserialize(response, OCSCambioStatoPraticaResponse.class) ;
    	pratica.resultCode = 0;
        pratica.resultMessage = 'ok';
        pratica.ebavaradpv1Response.msfres_status = 'ok';
        pratica.ebavaradpv1Response.msfologon_status = 'ok';
        pratica.ebavaradpv1Response.msfologon_errore = 'ok';
        pratica.ebavaradpv1Response.mfterr_OMSFERR_OCCURS = null;
        pratica.ebavaradpv1Response.msfologon_ERRORE_DES = 'ok';
        pratica.ebavaradpv1Response.msfologon_SESSION_ID = 'ko';
      	boolean test = pratica.isOK();
     }
}