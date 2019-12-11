public class OCSRecuperaLettereFaxHostInvoker {
	
    public static OCSRecuperaLettereFaxHostResponse recuperaLettereFaxHost(String numPratica, String tipoPratica, String codCliente, Datetime dataDa){
        OCSRecuperaLettereFaxHostRequest request = new OCSRecuperaLettereFaxHostRequest();
        
        request.recuperaLettereFaxHostRequestDTO.numPratica = numPratica;
        request.recuperaLettereFaxHostRequestDTO.tipoPratica = tipoPratica;
        request.recuperaLettereFaxHostRequestDTO.codCliente = codCliente;  
		request.setDataDa(dataDa);
        
        return (OCSRecuperaLettereFaxHostResponse)ApiUtils.callApi('ocs.recuperaLettereFaxHost', request, OCSRecuperaLettereFaxHostResponse.class);
    }
    
    public static OCSRecuperaLettereFaxHostResponse recuperaLettereFaxHost(String numPratica, String tipoPratica, String codCliente){
        OCSRecuperaLettereFaxHostRequest request = new OCSRecuperaLettereFaxHostRequest();
        
        request.recuperaLettereFaxHostRequestDTO.numPratica = numPratica;
        request.recuperaLettereFaxHostRequestDTO.tipoPratica = tipoPratica;
        request.recuperaLettereFaxHostRequestDTO.codCliente = codCliente;          
        request.setDataDa(Date.today());
        
        return (OCSRecuperaLettereFaxHostResponse)ApiUtils.callApi('ocs.recuperaLettereFaxHost', request, OCSRecuperaLettereFaxHostResponse.class);
    }    
}