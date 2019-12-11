public class OCSRecuperaSaldiRossiCarteRevocateRes extends OCSResponse {
    
   public RecuperaSaldiRossiResponseDTO recuperaSaldiRossiResponse;
    
    public OCSRecuperaSaldiRossiCarteRevocateRes() { 
       
        recuperaSaldiRossiResponse = new RecuperaSaldiRossiResponseDTO();
    }
    
    public class RecuperaSaldiRossiResponseDTO {
 
		public List<SaldoRossoDTO> elencoSaldiRossi {get;set;}
        public RecuperaSaldiRossiResponseDTO() {
            elencoSaldiRossi = new List<SaldoRossoDTO>();
        }
    }
    
    public class SaldoRossoDTO {
        
        public String importoSaldo {get;set;}
       	public String dataRevocaCarta {get;set;}
        public String codCliente {get;set;}
       	public String cognome {get;set;}
       	public String nome {get;set;}
        public String tipoPratica {get;set;}
        public String numPratica {get;set;}
        public String dataNascita {get;set;}
        public String luogoNascita {get;set;}
        public String provNascita {get;set;}
       	public String sesso {get;set;}
        public String tipoPagamento {get;set;}
        public String abi {get;set;}
        public String cab {get;set;}
       	public String numConto {get;set;}
       	public String iban {get;set;}
        public String filiale {get;set;}
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