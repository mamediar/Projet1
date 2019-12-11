public class OCSRicercaPresenzaLottoInvoker 
{
    public static OCSRicercaPresenzaLottoResponse ricercaPresenzaLotto (String numPratica,String Procedura)
    {        
        OCSRicercaPresenzaLottoRequest req = new OCSRicercaPresenzaLottoRequest();
        req.serviceId = 'OCS_EBAGETADL_V1';
        req.ebagetadlv1Request.msfilogon_UTENTE =  'WB';
        req.ebagetadlv1Request.mfbayadlo_IN_PRATICA = numPratica;
        req.ebagetadlv1Request.mfbayadlo_IN_PROCEDURA = Procedura;
       	if(!Test.isRunningTest()) req.ebagetadlv1Request.msflogon_TMP_KEY = 'TMPCRM_' + System.currentTimeMillis();
        else req.ebagetadlv1Request.msflogon_TMP_KEY ='';
        req.ebagetadlv1Request.msfilogon_SENDER_TIPO = 'AG';
        req.ebagetadlv1Request.msfilogon_SENDER_CODICE = 12; 
        req.ebagetadlv1Request.msfilogon_CANALE_ACQUISIZ = 'EW1';
        String apiResult = ApiUtils.callApi('ricerca.ocs.ricercaPresenzaLotto', req);
        system.debug(apiresult);
        OCSRicercaPresenzaLottoResponse pratica = (OCSRicercaPresenzaLottoResponse)JSON.deserialize(apiResult, OCSRicercaPresenzaLottoResponse.class);     
        return pratica;
    }
}