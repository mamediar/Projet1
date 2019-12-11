public class OCSRecuperaDatiPostvenditaResponse extends OCSResponse{
    public PSVDatiPraticaDTO[] pratiche{get;set;}
    public PSVDatiClienteDTO[] cliente{get;set;}
    
    public OCSRecuperaDatiPostvenditaResponse(){
        this.pratiche=new List<PSVDatiPraticaDTO>();
        this.cliente=new List<PSVDatiClienteDTO>();
    }
    
    public class PSVDatiPraticaDTO{
        public String numPratica{get;set;}
        public String codCliente{get;set;}
        public String abi{get;set;}
        public String cab{get;set;}
        public String numConto{get;set;}
        public String iban{get;set;}
        public String statoPratica{get;set;}
        public String tipoPagamento{get;set;}
        public String prodotto{get;set;}
        public String filiale{get;set;}
        public String dataEstinzione{get;set;}
        public String tipoPratica{get;set;}
        public String dataCaricamento{get;set;}
        public String pan{get;set;}
        public String convenzionato{get;set;}
        public String puntoVendita{get;set;}
        public String venditore{get;set;}
        public String agente{get;set;}
        public String subAgente{get;set;}
        public String flagRecupero{get;set;}
        public String classifRecupero{get;set;}
        public String societa{get;set;}
        public PSVDatiClienteDTO[] elencoCoobbligati{get;set;} //Da verificare, in realtà è una lista!
        public String codStatoPratica{get;set;}
        public String codAttributoPratica{get;set;}
        public String desStatoPratica{get;set;}
        public String desAttributoPratica{get;set;}
        public String codRecuperatore{get;set;}
        public String desRecuperatore{get;set;}
        public String canale{get;set;}
        
        public PSVDatiPraticaDTO(){
            elencoCoobbligati=new List<PSVDatiClienteDTO>();
        }
        
        public Map<String,String> getMap(){
            Map<String,String> res=new Map<String,String>();
            res.put('numPratica',numPratica);
            res.put('codCliente',codCliente);
            res.put('abi',abi);
            res.put('cab',cab);
            res.put('numConto',numConto);
            res.put('iban',iban);
            res.put('statoPratica',statoPratica);
            res.put('tipoPagamento',tipoPagamento);
            res.put('prodotto',prodotto);
            res.put('filiale',filiale);
            res.put('dataEstinzione',dataEstinzione);
            res.put('tipoPratica',tipoPratica);
            res.put('dataCaricamento',dataCaricamento);
            res.put('pan',pan);
            res.put('convenzionato',convenzionato);
            res.put('puntoVendita',puntoVendita);
            res.put('venditore',venditore);
            res.put('agente',agente);
            res.put('subAgente',subAgente);
            res.put('flagRecupero',flagRecupero);
            res.put('classifRecupero',classifRecupero);
            res.put('societa',societa);
            res.put('elencoCoobbligati',JSON.serialize(elencoCoobbligati));
            res.put('codStatoPratica',codStatoPratica);
            res.put('codAttributoPratica',codAttributoPratica);
            res.put('desStatoPratica',desStatoPratica);
            res.put('desAttributoPratica',desAttributoPratica);
            res.put('codRecuperatore',codRecuperatore);
            res.put('desRecuperatore',desRecuperatore);
            res.put('canale',canale);
            return res;
        }
    }
    
    public class PSVDatiClienteDTO{
        public String cognome{get;set;}
        public String codCliente{get;set;}
        public String nome{get;set;}
        public String dataNascita{get;set;}
        public String luogoNascita{get;set;}
        public String provNascita{get;set;}
        public String sesso{get;set;}
        public String codFiscale{get;set;}
        public String piva{get;set;}
        public String indirizzo{get;set;}
        public String cap{get;set;}
        public String localita{get;set;}
        public String provincia{get;set;}
        public String paeseEstero{get;set;}
        public String email{get;set;}
        public String tipoDocumento{get;set;}
        public String numDocumento{get;set;}
        public String ufficioRilascio{get;set;}
        public String luogoRilascio{get;set;}
        public String provRilascio{get;set;}
        public String dataRilascio{get;set;}
        public String denominazioneAzienda{get;set;}
        public String formaGiuridica{get;set;}
        public String tipoAnagrafica{get;set;}
        public String dataScadenza{get;set;}
        public String telefonoCasa{get;set;}
        public String telCellulare{get;set;}
        public String tipoRapporto{get;set;}
        public String dataDepennamento{get;set;}
        public String ndg{get;set;}
        
        public Map<String,String> getMap(){
            Map<String,String> res=new Map<String,String>();
            res.put('cognome',cognome);
            res.put('codCliente',codCliente);
            res.put('nome',nome);
            res.put('dataNascita',dataNascita);
            res.put('luogoNascita',luogoNascita);
            res.put('provNascita',provNascita);
            res.put('sesso',sesso);
            res.put('codFiscale',codFiscale);
            res.put('piva',piva);
            res.put('indirizzo',indirizzo);
            res.put('cap',cap);
            res.put('localita',localita);
            res.put('provincia',provincia);
            res.put('paeseEstero',paeseEstero);
            res.put('email',email);
            res.put('tipoDocumento',tipoDocumento);
            res.put('numDocumento',numDocumento);
            res.put('ufficioRilascio',ufficioRilascio);
            res.put('luogoRilascio',luogoRilascio);
            res.put('provRilascio',provRilascio);
            res.put('dataRilascio',dataRilascio);
            res.put('denominazioneAzienda',denominazioneAzienda);
            res.put('formaGiuridica',formaGiuridica);
            res.put('tipoAnagrafica',tipoAnagrafica);
            res.put('dataScadenza',dataScadenza);
            res.put('telefonoCasa',telefonoCasa);
            res.put('telCellulare',telCellulare);
            res.put('tipoRapporto',tipoRapporto);
            res.put('dataDepennamento',dataDepennamento);
            res.put('ndg',ndg);
            return res;
        }
    }
}