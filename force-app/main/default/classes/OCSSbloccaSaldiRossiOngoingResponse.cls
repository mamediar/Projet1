public class OCSSbloccaSaldiRossiOngoingResponse extends OCSResponse {
    
    public SbloccaSaldiRossiOngoingResponseDTO sbloccaSaldiRossiOngoingResponse;
    
    public OCSSbloccaSaldiRossiOngoingResponse() {
        sbloccaSaldiRossiOngoingResponse = new SbloccaSaldiRossiOngoingResponseDTO();
    }
    
    public class SbloccaSaldiRossiOngoingResponseDTO {
        
        public String ultimaPraticaElaborata {get;set;}
        public String ultimaDataRevocaCarta {get;set;}
        
    }

}