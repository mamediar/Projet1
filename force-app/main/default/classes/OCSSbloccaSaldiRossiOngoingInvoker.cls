public class OCSSbloccaSaldiRossiOngoingInvoker {
    
    public static OCSSbloccaSaldiRossiOngoingResponse sbloccaSaldiRossiOngoing(String strServiceID, List<OCSSbloccaSaldiRossiOngoingRequest.SbloccoSaldoRossoOngoingDTO> elencoSaldiRossiOngoing) {
        
        final String SALDI_ROSSI_ONGOING = 'sbloccaSaldiRossiOngoing';
        final String SALDI_ROSSI_CARTE_ATTIVE = 'sbloccaSaldiRossiCarteAttive';
        OCSSbloccaSaldiRossiOngoingResponse response;
        OCSSbloccaSaldiRossiOngoingRequest req = new OCSSbloccaSaldiRossiOngoingRequest(strServiceID, elencoSaldiRossiOngoing);
        if (SALDI_ROSSI_ONGOING.equalsIgnoreCase(strServiceID)) {
            response = (OCSSbloccaSaldiRossiOngoingResponse)ApiUtils.callApi('ocs.'+ SALDI_ROSSI_ONGOING, req, OCSSbloccaSaldiRossiOngoingResponse.class);
        } else {
            response = (OCSSbloccaSaldiRossiOngoingResponse)ApiUtils.callApi('ocs.'+ SALDI_ROSSI_CARTE_ATTIVE, req, OCSSbloccaSaldiRossiOngoingResponse.class);
        }
        
        return response;        
    }
    
}