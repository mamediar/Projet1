public class OCSCensimTitolareConvenzionatoInvoker {
    
    public static OCSCensimTitolareConvenzionatoResponse callCensimentoTitolareConvenzionato (String dealerId, String titolareId) {
		List<OCSCensimTitolareConvenzionatoRequest.ELenco> elenco=processaDati(dealerId,titolareId);        
        OCSCensimTitolareConvenzionatoRequest req = new OCSCensimTitolareConvenzionatoRequest();
        req.censimentoTitolareConvenzionatoRequest.elenco = elenco;  
        OCSCensimTitolareConvenzionatoResponse response = (OCSCensimTitolareConvenzionatoResponse) ApiUtils.callApi('ocs.censimentoTitolareConvenzionato', req, OCSCensimTitolareConvenzionatoResponse.class);
        system.debug('Response: ' + response);
        return response;
    }
    
    
    public static List<OCSCensimTitolareConvenzionatoRequest.ELenco> processaDati (String dealerId, String titolareId) {
		String dealerOCSId=[SELECT id, OCS_External_Id__c FROM Account WHERE id=:dealerId][0].OCS_External_Id__c;
        String titolareOCSId=[SELECT id, OCS_External_Id__c FROM Contact WHERE id=:titolareId][0].OCS_External_Id__c;
        System.debug('***************dealerOCSId:: '+dealerOCSId);
        System.debug('***************titolareOCSId:: '+titolareOCSId);
        List<OCSCensimTitolareConvenzionatoRequest.ELenco> elenco = new List<OCSCensimTitolareConvenzionatoRequest.ELenco>();
        OCSCensimTitolareConvenzionatoRequest.ELenco elencoItem = new OCSCensimTitolareConvenzionatoRequest.ELenco();
        Date today = Date.Today();
		elencoItem.primaria=dealerOCSId.Substring(1);  
        elencoItem.secondaria=titolareOCSId;  
        elencoItem.tipoSecondaria='T'; 
        elencoItem.dataInserimento=DateUtils.formatDateYYYYMMDD(today);                 
        elenco.add(elencoItem); 
                
        return elenco;
    }    
    
    
}