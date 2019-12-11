public class OCSCensimentoAccordoInvoker {
    
    public static OCSCensimentoAccordoResponse callCensimentoAccordo (String dealerId) {
		List<OCSCensimentoAccordoRequest.ELenco> elenco=processaDati(dealerId);        
        OCSCensimentoAccordoRequest req = new OCSCensimentoAccordoRequest();
        req.censimentoAccordoRequest.elenco = elenco;  
        OCSCensimentoAccordoResponse response = (OCSCensimentoAccordoResponse) ApiUtils.callApi('ocs.censimentoAccordo', req, OCSCensimentoAccordoResponse.class);
        system.debug('ResponseQUARTOSERVIZIO: ' + response);
        return response;
    } 
     

    public static List<OCSCensimentoAccordoRequest.ELenco> processaDati (String dealerId) {
        
        Account dealer=[SELECT id, Dealership_Code__c, OCS_External_Id__c, Tipo_Intermediario__c 
                        FROM Account WHERE id=:dealerId][0];         
		List<OCSCensimentoAccordoRequest.ELenco> elenco = new List<OCSCensimentoAccordoRequest.ELenco>();
        OCSCensimentoAccordoRequest.ELenco elencoDealer = new OCSCensimentoAccordoRequest.ELenco();    
        elencoDealer.codAccordo='000000';
        elencoDealer.codIntermediario=dealer.OCS_External_Id__c.Substring(1); 
        elencoDealer.tipoIntermediario=dealer.Tipo_Intermediario__c ;
        elenco.add(elencoDealer);
        
        if (dealer.Dealership_Code__c!=0){
            OCSCensimentoAccordoRequest.ELenco elencoDealer2 = new OCSCensimentoAccordoRequest.ELenco();  
            elencoDealer2.codAccordo=String.valueof(dealer.Dealership_Code__c);
            elencoDealer2.codIntermediario=dealer.OCS_External_Id__c.Substring(1);
            elencoDealer2.tipoIntermediario=dealer.Tipo_Intermediario__c;
            elenco.add(elencoDealer2);
        }        

		return elenco;
   
    }   

    
}