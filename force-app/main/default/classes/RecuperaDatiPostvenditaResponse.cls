public  class RecuperaDatiPostvenditaResponse extends OCSAPIResponse {
    public  List<PSVDatiPraticaDTO> pratiche {get;set;}
    public   List<PSVDatiClienteDTO> cliente {get;set;}
    public RecuperaDatiPostvenditaResponse() {
    this.pratiche = new List<PSVDatiPraticaDTO>();
    this.cliente = new  List<PSVDatiClienteDTO>();
    }

    public class PSVDatiPraticaDTO {
     public String numPratica {get;set;}
     public String codCliente {get;set;}
     public String abi {get;set;}
     public String cab {get;set;}
     public String numConto {get;set;}
     public String Iban {get;set;}
     public String statoPratica {get;set;}
     public String tipoPagamento {get;set;}
     public String convenzionato {get;set;}
     public String puntoVendita {get;set;}
     public String venditore {get;set;}
     public String agente {get;set;}
     public String subAgente {get;set;}
     public String flagRecupero {get;set;}
     public String classifRecupero {get;set;}
     public String societa {get;set;}
     public String elencoCoobbligati {get;set;}
     public String codStatoPratica {get;set;}
     public String codAttributoPratica {get;set;}
     public String desStatoPratica {get;set;}
     public String desAttributoPratica {get;set;}
     public String codRecuperatore {get;set;}
     public String desRecuperatore {get;set;}
     public String Prodotto {get;set;}
     public String Filiale {get;set;}
     public String dataEstinzione {get;set;}
     public String canale {get;set;}
     public String tipoPratica {get;set;}
     public String dataCaricamento {get;set;}
     public String Pan {get;set;}
    }

    public class PSVDatiClienteDTO {
        public String cognome {get;set;}
        public String codCliente {get;set;}
        public String nome {get;set;}
        public String dataNascita {get;set;}
        public String luogoNascita {get;set;}
        public String provNascita {get;set;}
        public String sesso {get;set;}
        public String codFiscale {get;set;}
        public String piva {get;set;}
        public String indirizzo {get;set;}
        public String cap {get;set;}
        public String localita {get;set;}
        public String provincia {get;set;}

        public String paeseEstero {get;set;}
        public String email {get;set;}
        public String tipoDocumento {get;set;}
        public String numDocumento {get;set;}
        public String ufficioRilascio {get;set;}

        public String luogoRilascio {get;set;}
        public String provRilascio {get;set;}
        public String dataRilascio {get;set;}
        public String denominazioneAzienda {get;set;}
        public String formaGiuridica {get;set;}

        public String tipoAnagrafica {get;set;}
        public String dataScadenza {get;set;}
        public String telefonoCasa {get;set;}
        public String telCellulare {get;set;}
        public String tipoRapporto {get;set;}
        public String dataDepennamento {get;set;}
        public String ndg {get;set;}

    }
}