public class OCSRecuperaPraticheAssicurateInvoker {
    
    public static OCSRecuperaPraticheAssicurateResponse callRecuperaPraticheAssicurate(OCSRecuperaPraticheAssicurateRequest request){
        return (OCSRecuperaPraticheAssicurateResponse)ApiUtils.callApi('ocs.recuperaPraticheAssicurate',request,OCSRecuperaPraticheAssicurateResponse.class);
    }
    
    public static OCSRecuperaPraticheAssicurateResponse callRecuperaPraticheAssicurate(String numPratica, String codCliente,
                                                                                       String cognomeCliente,  String nomeCliente, String codFiscale, String dataNascitaCliente,
                                                                                       String ragioneSociale, String pan)
    { 
        
        OCSRecuperaPraticheAssicurateRequest request=new OCSRecuperaPraticheAssicurateRequest(numPratica, codCliente,
                                                                                              cognomeCliente, nomeCliente, codFiscale, dataNascitaCliente,
                                                                                              ragioneSociale, pan);
        OCSRecuperaPraticheAssicurateResponse res= callRecuperaPraticheAssicurate(request);
        return res;
    }
}