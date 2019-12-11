public class OCSSchedaClienteResponse extends OCSResponse{
    @AuraEnabled
    public PSVDatiPraticaDTO[] pratiche{get;set;}
    @AuraEnabled
    public PSVDatiClienteDTO[] cliente{get;set;}
    
    public OCSSchedaClienteResponse(){
        this.pratiche=new List<PSVDatiPraticaDTO>();
        this.cliente=new List<PSVDatiClienteDTO>();
    }
    
    public class PSVDatiPraticaDTO{
        @AuraEnabled
		public String numPratica{get;set;}
        @AuraEnabled
        public String codCliente{get;set;}
        @AuraEnabled
        public String abi{get;set;}
        @AuraEnabled
        public String cab{get;set;}
        @AuraEnabled
        public String numConto{get;set;}
        @AuraEnabled
        public String iban{get;set;}
        @AuraEnabled
        public String statoPratica{get;set;}
        @AuraEnabled
        public String tipoPagamento{get;set;}
        @AuraEnabled
        public String prodotto{get;set;}
        @AuraEnabled
        public String filiale{get;set;}
        @AuraEnabled
        public String dataEstinzione{get;set;}
        @AuraEnabled
        public String tipoPratica{get;set;}
        @AuraEnabled
        public String dataCaricamento{get;set;}
        @AuraEnabled
        public String pan{get;set;}
        @AuraEnabled
        public String convenzionato{get;set;}
        @AuraEnabled
        public String puntoVendita{get;set;}
        @AuraEnabled
        public String venditore{get;set;}
        @AuraEnabled
        public String agente{get;set;}
        @AuraEnabled
        public String subAgente{get;set;}
        @AuraEnabled
        public String flagRecupero{get;set;}
        @AuraEnabled
        public String classifRecupero{get;set;}
        @AuraEnabled
        public String societa{get;set;}
        @AuraEnabled
        public PSVDatiClienteDTO[] elencoCoobbligati{get;set;} //Da verificare, in realtà è una lista!
        @AuraEnabled
        public String codStatoPratica{get;set;}
        @AuraEnabled
        public String codAttributoPratica{get;set;}
        @AuraEnabled
        public String desStatoPratica{get;set;}
        @AuraEnabled
        public String desAttributoPratica{get;set;}
        @AuraEnabled
        public String codRecuperatore{get;set;}
        @AuraEnabled
        public String desRecuperatore{get;set;}
        @AuraEnabled
        public String canale{get;set;}
        
        
        public PSVDatiPraticaDTO(){
            elencoCoobbligati=new List<PSVDatiClienteDTO>();
        }
    }

    public class PSVDatiClienteDTO{
        @AuraEnabled
        public String cognome{get;set;}
        @AuraEnabled
        public String codCliente{get;set;}
        @AuraEnabled
        public String nome{get;set;}
        @AuraEnabled
        public String dataNascita{get;set;}
        @AuraEnabled
        public String luogoNascita{get;set;}
        @AuraEnabled
        public String provNascita{get;set;}
        @AuraEnabled
        public String sesso{get;set;}
        @AuraEnabled
        public String codFiscale{get;set;}
        @AuraEnabled
        public String piva{get;set;}
        @AuraEnabled
        public String indirizzo{get;set;}
        @AuraEnabled
        public String cap{get;set;}
        @AuraEnabled
        public String localita{get;set;}
        @AuraEnabled
        public String provincia{get;set;}
        @AuraEnabled
        public String paeseEstero{get;set;}
        @AuraEnabled
        public String email{get;set;}
        @AuraEnabled
        public String tipoDocumento{get;set;}
        @AuraEnabled
        public String numDocumento{get;set;}
        @AuraEnabled
        public String ufficioRilascio{get;set;}
        @AuraEnabled
        public String luogoRilascio{get;set;}
        @AuraEnabled
        public String provRilascio{get;set;}
        @AuraEnabled
        public String dataRilascio{get;set;}
        @AuraEnabled
        public String denominazioneAzienda{get;set;}
        @AuraEnabled
        public String formaGiuridica{get;set;}
        @AuraEnabled
        public String tipoAnagrafica{get;set;}
        @AuraEnabled
        public String dataScadenza{get;set;}
        @AuraEnabled
        public String telefonoCasa{get;set;}
        @AuraEnabled
        public String telCellulare{get;set;}
        @AuraEnabled
        public String telAlternativo{get;set;}
        @AuraEnabled
        public String telFax{get;set;}
        @AuraEnabled
        public String tipoRapporto{get;set;}
        @AuraEnabled
        public String dataDepennamento{get;set;}
        @AuraEnabled
        public String indirizzoDomicilio{get;set;}
        @AuraEnabled
        public String capDomicilio{get;set;}
        @AuraEnabled
        public String localitaDomicilio{get;set;}
        @AuraEnabled
        public String provinciaDomicilio{get;set;}
        @AuraEnabled
        public String flagIstruttoriPratiche{get;set;}
        @AuraEnabled
        public String flagRilevaQualit{get;set;}
        @AuraEnabled
        public String flagOffCommInt{get;set;}
        @AuraEnabled
        public String flagOffCommIntAut{get;set;}
        @AuraEnabled
        public String flagOffCommEst{get;set;}
        @AuraEnabled
        public String flagOffCommEstAut{get;set;}
        @AuraEnabled
        public String flagAcServiziAltri{get;set;}
        @AuraEnabled
        public String flagDatiSensibili{get;set;}
        @AuraEnabled
        public String flagInformativaSic{get;set;}
        //public String ndg{get;set;}
    }
}