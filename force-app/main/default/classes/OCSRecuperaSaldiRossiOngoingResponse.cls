public class OCSRecuperaSaldiRossiOngoingResponse extends OCSResponse {
    
    public RecuperaSaldiRossiOngoingResponseDTO recuperaSaldiRossiOngoingResponse;
    
    public OCSRecuperaSaldiRossiOngoingResponse() { 
       
        recuperaSaldiRossiOngoingResponse = new RecuperaSaldiRossiOngoingResponseDTO();
    }
    
    public class RecuperaSaldiRossiOngoingResponseDTO {
 
		public List<SaldoRossoOngoingDTO> elencoSaldiRossi {get;set;}
        public RecuperaSaldiRossiOngoingResponseDTO() {
            elencoSaldiRossi = new List<SaldoRossoOngoingDTO>();
        }
    }
    
    public class SaldoRossoOngoingDTO {
        
        public String periodo {get;set;}
       	public String tipoRecord {get;set;}
       	public String tipoPraticaTe {get;set;}
        public String numPraticaTe {get;set;}
        public String primaEstrazioneTe {get;set;}
        public String statoPraticaTe {get;set;}
       	public String bloccoPraticaTe {get;set;}
       	public String saldoTe {get;set;}
        public String compensabileTe {get;set;}
        public String progressivoDe {get;set;}
        public String tipoPraticaDe {get;set;}
       	public String numPraticaDe {get;set;}
       	public String statoPraticaDe {get;set;}
        public String bloccoPraticaDe {get;set;}
        public String tipoCompensazioneDe {get;set;}
        public String anzianitaInsolutoDe {get;set;}
       	public String totaleSpesaDe {get;set;}
       	public String compensazionePropostaDe {get;set;}
        public String dataEstrazione {get;set;}
        public String abi {get;set;}
        public String cab {get;set;}
       	public String numConto {get;set;}
       	public String iban {get;set;}
        public String tipoPagamento {get;set;}
        public String filiale {get;set;}
        public String codCliente {get;set;}
       	public String cognome {get;set;}
       	public String nome {get;set;}
        public String dataNascita {get;set;}
        public String luogoNascita {get;set;}
        public String provNascita {get;set;}
       	public String sesso {get;set;}
       	public String codFiscale {get;set;}
        public String indirizzo {get;set;}
        public String cap {get;set;}
        public String localita {get;set;}
       	public String provincia {get;set;}
       	public String email {get;set;}
        public String denominazioneAzienda {get;set;}
        public String telefonoCasa {get;set;}
        public String telCellulare {get;set;}
        
    }

}