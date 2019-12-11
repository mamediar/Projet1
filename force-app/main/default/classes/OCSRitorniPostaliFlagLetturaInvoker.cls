public class OCSRitorniPostaliFlagLetturaInvoker {
    
    public static OCSRitorniPostaliFlagLetturaResponse ritorniPostaliFlagLettura(List<String> elencoLetterId) {
       
        OCSRitorniPostaliFlagLetturaRequest req = new OCSRitorniPostaliFlagLetturaRequest(elencoLetterId);
        OCSRitorniPostaliFlagLetturaResponse response = (OCSRitorniPostaliFlagLetturaResponse)ApiUtils.callApi('ocs.ritorniPostaliFlagLettura', req, OCSRitorniPostaliFlagLetturaResponse.class);
        return response;
        
    }

}