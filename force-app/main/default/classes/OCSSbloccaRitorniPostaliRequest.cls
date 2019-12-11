public class OCSSbloccaRitorniPostaliRequest extends OCSRequest {
    
    public List<SbloccoRitornoPostaleDTO> ritorniPostali {get;set;}
    
    public OCSSbloccaRitorniPostaliRequest(List<OCSSbloccaRitorniPostaliRequest.SbloccoRitornoPostaleDTO> elenco) {
        serviceId = 'sbloccaRitorniPostali';
        this.ritorniPostali = elenco;
    }
    
    public class SbloccoRitornoPostaleDTO {
        
        public String codLettera {get;set;}
        public String dataEsito {get;set;}
        public String oraEsito {get;set;}
        public String flagContattato {get;set;}
        public String flagVerificato {get;set;}
        public String esitoContatto {get;set;}

    }

}