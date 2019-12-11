public class OCSSbloccaSaldiRossiResponse extends OCSResponse {
    
    public SbloccaSaldiRossiResponseDTO sbloccaSaldiRossiResponse;
    
    public OCSSbloccaSaldiRossiResponse() {
        sbloccaSaldiRossiResponse = new SbloccaSaldiRossiResponseDTO();
    }
    
    public class SbloccaSaldiRossiResponseDTO {
        
        public String ultimaPraticaElaborata {get;set;}
        public String ultimaDataRevocaCarta {get;set;}
        
    }
    
}