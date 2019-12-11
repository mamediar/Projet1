public  class OCSVariazioneTelefonoBancaInvoker {
    public static OCSVariazioneTelefonoBancaResponse callVariazioneTelefonoBancaSDD(OCSVariazioneTelefonoBancaRequest request){
        return (OCSVariazioneTelefonoBancaResponse)ApiUtils.callApi('ocs.variazioneTelefonoBanca',request,OCSVariazioneTelefonoBancaResponse.class);
    }
    
    public static OCSVariazioneTelefonoBancaResponse callVariazioneTelefonoBancaSDD(String abi, String cab, String telefono){ 
        OCSVariazioneTelefonoBancaRequest request=new OCSVariazioneTelefonoBancaRequest();
        request.variazioneTelefonoBancaRequest.cab=cab;
        request.variazioneTelefonoBancaRequest.abi=abi;
        request.variazioneTelefonoBancaRequest.telefono=telefono;
        OCSVariazioneTelefonoBancaResponse res= callVariazioneTelefonoBancaSDD(request);
        return res;
    }
}