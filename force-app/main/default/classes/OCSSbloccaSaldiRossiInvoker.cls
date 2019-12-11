public class OCSSbloccaSaldiRossiInvoker {
    
    public static OCSSbloccaSaldiRossiResponse sbloccaSaldiRossi(List<OCSSbloccaSaldiRossiRequest.SbloccoSaldoRossoDTO> elencoSaldiRossi) {
    
        OCSSbloccaSaldiRossiResponse response;
        OCSSbloccaSaldiRossiRequest req = new OCSSbloccaSaldiRossiRequest(elencoSaldiRossi);
       	response = (OCSSbloccaSaldiRossiResponse)ApiUtils.callApi('ocs.sbloccaSaldiRossi', req, OCSSbloccaSaldiRossiResponse.class);
        return response;        
    }

}