public class OCSRecuperaDelinquencyInvoker {
    public static OCSRecuperaDelinquencyResponse callGetDelinquency(OCSRecuperaDelinquencyRequest request){
        return (OCSRecuperaDelinquencyResponse)ApiUtils.callApi('ocs.recuperaDelinquency',request,OCSRecuperaDelinquencyResponse.class);
    }
    
    public static OCSRecuperaDelinquencyResponse callGetDelinquency(String codCliente){
        OCSRecuperaDelinquencyRequest request=new OCSRecuperaDelinquencyRequest();
        request.recuperaDelinquencyRequest.codCliente=codCliente;
        OCSRecuperaDelinquencyResponse res= callGetDelinquency(request);
        return res;
    }

    public static OCSRecuperaDelinquencyResponse callGetDelinquency(String codCliente, String tipoPratica, String numPratica){
        OCSRecuperaDelinquencyRequest request=new OCSRecuperaDelinquencyRequest();
        request.recuperaDelinquencyRequest.codCliente=codCliente;
        request.recuperaDelinquencyRequest.tipoPratica=tipoPratica;
        request.recuperaDelinquencyRequest.numPratica=numPratica;
        OCSRecuperaDelinquencyResponse res= callGetDelinquency(request);
        return res;
    }
}