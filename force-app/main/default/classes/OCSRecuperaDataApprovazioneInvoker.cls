public  class OCSRecuperaDataApprovazioneInvoker {
   
    public static OCSRecuperaDataApprovazioneResponse invoke(String tipoPratica,String numPratica)
    {
        OCSRecuperaDataApprovazioneRequest req = new OCSRecuperaDataApprovazioneRequest();        
        req.recuperaDataApprovazioneRequest.tipoPratica = tipoPratica;
        req.recuperaDataApprovazioneRequest.numPratica = numPratica;
        return (OCSRecuperaDataApprovazioneResponse)apiutils.callApi('ocs.recuperaDataApprovazione', req, OCSRecuperaDataApprovazioneResponse.class);
    }    
    
    
}