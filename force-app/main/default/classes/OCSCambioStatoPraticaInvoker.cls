public class OCSCambioStatoPraticaInvoker 
{
     public static ContractResult invoke(Contract contratto, String nuovoStato)
    {    
        ContractResult res = new ContractResult();
        OCSCambioStatoPraticaRequest req = new OCSCambioStatoPraticaRequest();
        system.debug('dentro invoker---- prima caricamento' + req);
        system.debug('contratto prima caricamento' + contratto + ' stato :' + nuovoStato);

        req.ebavaradpv1Request.msfilogon_UTENTE =  'WB';
        req.ebavaradpv1Request.mfbayadpv_PRATICA = contratto.ContractNumber__c;
        req.ebavaradpv1Request.mfbayadpv_PROCEDURA = contratto.Procedure__c;    
        req.ebavaradpv1Request.mfbayadpv_SITUAZIONE_PRATICA =  nuovoStato;
        if(!Test.isRunningTest()) req.ebavaradpv1Request.msflogon_TMP_KEY = 'TMPCRM_' + System.currentTimeMillis();
        else req.ebavaradpv1Request.msflogon_TMP_KEY ='';
        req.ebavaradpv1Request.msfilogon_SENDER_TIPO = 'AG';
        req.ebavaradpv1Request.msfilogon_SENDER_CODICE = 12; 
        req.ebavaradpv1Request.msfilogon_CANALE_ACQUISIZ = 'EW1';
        req.ebavaradpv1Request.msfilogon_TIPO_CARICAMENTO = 'ES';
        system.debug('dentro invoker---- dopo caricamento' + req);
        OCSCambioStatoPraticaResponse pratica;
        try
        {
           	String apiResult = ApiUtils.callApi('ricerca.ocs.cambioStatoPratica', req);
        	pratica = (OCSCambioStatoPraticaResponse)JSON.deserialize(apiResult, OCSCambioStatoPraticaResponse.class) ; 
        }
        catch(exception e)
        {
            pratica = new OCSCambioStatoPraticaResponse();
            OCSCambioStatoPraticaResponse.Ebavaradpv1RequestInfo r = new OCSCambioStatoPraticaResponse.Ebavaradpv1RequestInfo(); 
            pratica.ebavaradpv1Response = new OCSCambioStatoPraticaResponse.ebavaradpv1();
            pratica.ebavaradpv1Response.msfres_STATUS = XCSCompassConstants.STATUSERRORECONNESSIONE;
            r.msferr_CODICE = XCSCompassConstants.CODICEERRORECONNESSIONE;
            r.msferr_DESCRIZIONE = XCSCompassConstants.MESSAGGIOERRORECONNESSIONE;
            pratica.Ebavaradpv1RequestInfoResponse.add(r);
        }
        res.contract = contratto;
        res.response = pratica;
        system.debug('Dentro invoker------' + res);
        return res;
    }
	public static OCSCambioStatoFilterList multiInvoke(list<Contract> contratti,String nuovoStato)
    {
       OCSCambioStatoFilterList res = new OCSCambioStatoFilterList();
       ContractResult cr;
        System.debug('listacontrattiinkover' + contratti);
        for(contract c: contratti)
        {
            system.debug('Dentro multiinvoker------ prima chiamata');
            cr = invoke(c,nuovoStato);
            if(cr.response.isOK())
            {
                res.listaOK.add(cr);
            }
            else
            {    
                res.listaKO.add(cr);
            }    
        }
        System.debug('Fine multi invoker' + res);
        return res;
    }
}