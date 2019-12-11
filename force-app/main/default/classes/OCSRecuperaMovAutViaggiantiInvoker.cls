public class OCSRecuperaMovAutViaggiantiInvoker {
    
    public static OCSRecuperaMovAutViaggiantiResponse recuperaMovAutViaggianti (String numPratica) {        
        OCSRecuperaMovAutViaggiantiRequest req = new OCSRecuperaMovAutViaggiantiRequest();
        req.recuperaMovimentiAutorizzazioniViaggiantiRequest.numPratica = numPratica;
        
        req.recuperaMovimentiAutorizzazioniViaggiantiRequest.flagMovimenti = 'S';
        req.recuperaMovimentiAutorizzazioniViaggiantiRequest.flagAutorizzazioni = 'S';

        
        
        OCSRecuperaMovAutViaggiantiResponse response = (OCSRecuperaMovAutViaggiantiResponse)ApiUtils.callApi('ocs.recuperaMovAutViaggianti', req, OCSRecuperaMovAutViaggiantiResponse.class);
        System.debug('RESPONSE MOVAUTO' + response);
        return response;
    }
        
    public static OCSRecuperaMovAutViaggiantiResponse recuperaMovAutViaggianti (String numPratica, Boolean flagAut, Boolean flagMov) {        
        OCSRecuperaMovAutViaggiantiRequest req = new OCSRecuperaMovAutViaggiantiRequest();
        req.recuperaMovimentiAutorizzazioniViaggiantiRequest.numPratica = numPratica;       
        
        req.recuperaMovimentiAutorizzazioniViaggiantiRequest.flagMovimenti = flagMov ? 'S' : 'N';
        req.recuperaMovimentiAutorizzazioniViaggiantiRequest.flagAutorizzazioni = flagAut ? 'S' : 'N';
  
        OCSRecuperaMovAutViaggiantiResponse response = (OCSRecuperaMovAutViaggiantiResponse)ApiUtils.callApi('ocs.recuperaMovAutViaggianti', req, OCSRecuperaMovAutViaggiantiResponse.class);
        System.debug('RESPONSE MOVAUTO' + response);
        return response;
    }
    
    
    
}