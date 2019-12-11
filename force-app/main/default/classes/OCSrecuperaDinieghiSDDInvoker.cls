public class OCSrecuperaDinieghiSDDInvoker {
    public static OCSRecuperaDinieghiSDDResponse callRecuperaDinieghiSDD(OCSRecuperaDinieghiSDDRequest request){
        return (OCSRecuperaDinieghiSDDResponse)ApiUtils.callApi('ocs.recuperaDinieghiSDD',request,OCSRecuperaDinieghiSDDResponse.class);
    }
    
    public static OCSRecuperaDinieghiSDDResponse callRecuperaDinieghiSDD(){ 
        OCSRecuperaDinieghiSDDRequest request=new OCSRecuperaDinieghiSDDRequest();
        OCSRecuperaDinieghiSDDResponse res= callRecuperaDinieghiSDD(request);
        return res;
    }
}