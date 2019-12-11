/**
 * @File Name          : OCSCartaDatiFinanziariInvoker.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 30/10/2019, 09:38:36
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    30/10/2019   Federico Negro     Initial Version
**/
public class OCSCartaDatiFinanziariInvoker {
 	
    @auraEnabled public static OCSCartaDatiFinanziariResponse cartaDatiFinanziari(String numeroPrat) {        
        OCSCartaDatiFinanziariRequest req = new OCSCartaDatiFinanziariRequest();
        req.datiCartaDatiFinanziariRequest.numeroPratica = numeroPrat;   		     
        OCSCartaDatiFinanziariResponse response = (OCSCartaDatiFinanziariResponse)ApiUtils.callApi('ocs.cartaDatiFinanziari', req, OCSCartaDatiFinanziariResponse.class);
        //String apiResult = ApiUtils.callApi('ocs.cartaDatiFinanziari', req);        
        //OCSCartaDatiFinanziariResponse response = (OCSCartaDatiFinanziariResponse)JSON.deserialize(apiResult, OCSCartaDatiFinanziariResponse.class);
        System.debug('***Response Carta Dati Finanaziari : ' + response);
        return response;
    }
}