public class OCSSbloccaRitorniPostaliInvoker {
    
    public static OCSSbloccaRitorniPostaliResponse sbloccaRitorniPostali(List<OCSSbloccaRitorniPostaliRequest.SbloccoRitornoPostaleDTO> elencoRitorni) {
       
        OCSSbloccaRitorniPostaliRequest req = new OCSSbloccaRitorniPostaliRequest(elencoRitorni);
        OCSSbloccaRitorniPostaliResponse response = (OCSSbloccaRitorniPostaliResponse)ApiUtils.callApi('ocs.sbloccaRitorniPostali', req, OCSSbloccaRitorniPostaliResponse.class);
        return response;
        
    }

}