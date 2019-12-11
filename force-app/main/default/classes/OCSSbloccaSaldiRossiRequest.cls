public class OCSSbloccaSaldiRossiRequest extends OCSRequest {
    
    public SbloccaSaldiRossiRequestDTO sbloccaSaldiRossiRequest {get;set;}
    
    public OCSSbloccaSaldiRossiRequest(List<OCSSbloccaSaldiRossiRequest.SbloccoSaldoRossoDTO> elenco) {
        
        serviceId = 'sbloccaSaldiRossi';
        sbloccaSaldiRossiRequest = new SbloccaSaldiRossiRequestDTO(elenco);
        
    }
    
    public class SbloccaSaldiRossiRequestDTO {
        
        public List<SbloccoSaldoRossoDTO> elencoSaldiDaSbloccare {get;set;}
        public SbloccaSaldiRossiRequestDTO(List<OCSSbloccaSaldiRossiRequest.SbloccoSaldoRossoDTO> elenco) {
            
            this.elencoSaldiDaSbloccare = elenco;
            
        }
        
    } 
    
    public class SbloccoSaldoRossoDTO {
        public String numPratica {get;set;}
        public String dataRevocaCarta {get;set;}
    }

}