public class OCSSbloccaSaldiRossiOngoingRequest extends OCSRequest {
    
    public SbloccaSaldiRossiOngoingRequestDTO sbloccaSaldiRossiOngoingRequest {get;set;}
    
    public OCSSbloccaSaldiRossiOngoingRequest(String strServiceID, List<OCSSbloccaSaldiRossiOngoingRequest.SbloccoSaldoRossoOngoingDTO> elenco) {
        
        serviceId = strServiceID;
        sbloccaSaldiRossiOngoingRequest = new SbloccaSaldiRossiOngoingRequestDTO(elenco);
        
    }
    
    public class SbloccaSaldiRossiOngoingRequestDTO {
        
        public List<SbloccoSaldoRossoOngoingDTO> elencoSaldiDaSbloccare {get;set;}
        public SbloccaSaldiRossiOngoingRequestDTO(List<OCSSbloccaSaldiRossiOngoingRequest.SbloccoSaldoRossoOngoingDTO> elenco) {
            
            this.elencoSaldiDaSbloccare = elenco;
            
        }
        
    } 
    
    public class SbloccoSaldoRossoOngoingDTO {
        public String numPratica {get;set;}
        public String periodo {get;set;}
    }
}