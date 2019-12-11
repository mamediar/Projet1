public class OCSDinieghiSDDFlagLetturaInvoker {


    public static OCSDinieghiSDDFlagLetturaResponse callFlagLetturaSDD(OCSDinieghiSDDFlagLetturaRequest request){
        return (OCSDinieghiSDDFlagLetturaResponse)ApiUtils.callApi('ocs.dinieghiSDDFlagLettura',request,OCSDinieghiSDDFlagLetturaResponse.class);
    }
    
    public static OCSDinieghiSDDFlagLetturaResponse callFlagLetturaSDD(List<OCSDinieghiSDDFlagLetturaRequest.DiniegoSDDFlagLetturaDTO> lista){ 

        
        OCSDinieghiSDDFlagLetturaRequest request=new OCSDinieghiSDDFlagLetturaRequest(lista);
        OCSDinieghiSDDFlagLetturaResponse res= callFlagLetturaSDD(request);
        return res;
    }

}