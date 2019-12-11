public class OCSRecuperaConvenzioniCollegatoInvoker {
    public static OCSRecuperaConvenzioniCollegatoResponse callRecConvColl(OCSRecuperaConvenzioniCollegatoRequest request){
        return (OCSRecuperaConvenzioniCollegatoResponse)ApiUtils.callApi('ocs.recuperaConvenzioniCollegato',request,OCSRecuperaConvenzioniCollegatoResponse.class);
    }
    
    public static OCSRecuperaConvenzioniCollegatoResponse callRecConvColl(String codCollegato){
        OCSRecuperaConvenzioniCollegatoRequest request=new OCSRecuperaConvenzioniCollegatoRequest();
        request.recuperaConvenzioniCollegatoRequest.codCollegato=codCollegato;
        return(callRecConvColl(request)); 
    }
}