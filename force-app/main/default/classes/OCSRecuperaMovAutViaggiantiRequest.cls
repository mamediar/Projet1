public class OCSRecuperaMovAutViaggiantiRequest extends OCSRequest {

    public RecuperaMovAutViaggiantiRequestDTO recuperaMovimentiAutorizzazioniViaggiantiRequest {get; set;}
    
    public OCSRecuperaMovAutViaggiantiRequest() {
        
        serviceId = 'recuperaMovAutViaggianti';
        recuperaMovimentiAutorizzazioniViaggiantiRequest = new RecuperaMovAutViaggiantiRequestDTO();
       
    }
    
    
    public class RecuperaMovAutViaggiantiRequestDTO {
        
        public String provenienza {get; set;}
        public String tipoIntermediario {get; set;}
		public String intermediario {get; set;}
        public String emettitore {get; set;}
        public String numPratica {get; set;}
        public String pan {get; set;}
		public String dataRegistrazione {get; set;}
        public String tipoRecord {get; set;}
        public String progressivo {get; set;}
        public String protocollo {get; set;}
        public String riga {get; set;}
		public String tipoChiave {get; set;}
        public String statoAutorizzazione {get; set;}
        public String esitoAutorizzazione {get; set;}
        public String dataAutorizzazione {get; set;}
		public String numElementi {get; set;}
        public String flagMovimenti {get; set;}
        public String flagAutorizzazioni {get; set;}
        public String utente {get; set;}
    }
    
    
}