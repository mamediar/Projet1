public class OCSRecuperaDatiFuturoResponse extends OCSResponse{
    public OCSRecuperaDatiPostvenditaResponse.PSVDatiClienteDTO[] cliente {get;set;}
    public DatiPraticaFuturoDTO[] pratiche {get;set;}
    
    public class DatiPraticaFuturoDTO{
        public String numPratica{get;set;}
		public String codCliente{get;set;}
        public String dataCaricamento{get;set;}
        public String tipoPratica{get;set;}
        public String codStatoPratica{get;set;}
        public String codAttributoPratica{get;set;}
        public String desStatoPratica{get;set;}
        public String desAttributoPratica{get;set;}
        public String dataContratto{get;set;}
        public String dataEstinzioneAnticipata{get;set;}
        public String flagRecupero{get;set;}
        public String classifRecupero{get;set;}
        public String codRecuperatore{get;set;}
        public String desRecuperatore{get;set;}
        public String aziendaCod{get;set;}
        public String aziendaRagSoc{get;set;}
        public String aziendaIndirizzo{get;set;}
        public String aziendaCap{get;set;}
        public String aziendaLocalita{get;set;}
        public String aziendaProv{get;set;}
        public String aziendaSedeCod{get;set;}
        public String aziendaSedeRagSoc{get;set;}
        public String aziendaSedeIndirizzo{get;set;}
        public String aziendaSedeCap{get;set;}
        public String aziendaSedeLocalita{get;set;}
        public String aziendaSedeProv{get;set;}
        public String agenteCod{get;set;}
        public String agenteRagSoc{get;set;}
        public String subAgenteCod{get;set;}
        public String subAgenteRagSoc{get;set;}
        public String bancaCod{get;set;}
        public String bancaRagSoc{get;set;}
        public String filBancaCod{get;set;}
        public String filBancaRagSoc{get;set;}
        public String assicVitaCod{get;set;}
        public String assicVitaRagSoc{get;set;}
        public String assicImpiegoCod{get;set;}
        public String assicImpiegoRagSoc{get;set;}
        
        public Map<String,String> getMap(){
            Map<String,String> res=new Map<String,String>();
            res.put('numPratica',numPratica);
            res.put('codCliente',codCliente);
            res.put('dataCaricamento',dataCaricamento);
            res.put('tipoPratica',tipoPratica);
            res.put('codStatoPratica',codStatoPratica);
            res.put('codAttributoPratica',codAttributoPratica);
            res.put('desStatoPratica',desStatoPratica);
            res.put('desAttributoPratica',desAttributoPratica);
            res.put('dataContratto',dataContratto);
            res.put('dataEstinzioneAnticipata',dataEstinzioneAnticipata);
            res.put('flagRecupero',flagRecupero);
            res.put('tipoPraclassifRecuperotica',classifRecupero);
            res.put('codRecuperatore',codRecuperatore);
            res.put('desRecuperatore',desRecuperatore);
            res.put('aziendaCod',aziendaCod);
            res.put('aziendaRagSoc',aziendaRagSoc);
            res.put('aziendaIndirizzo',aziendaIndirizzo);
            res.put('aziendaCap',aziendaCap);
            res.put('aziendaLocalita',aziendaLocalita);
            res.put('aziendaProv',aziendaProv);
            res.put('aziendaSedeCod',aziendaSedeCod);
            res.put('aziendaSedeRagSoc',aziendaSedeRagSoc);
            res.put('aziendaSedeIndirizzo',aziendaSedeIndirizzo);
            res.put('aziendaSedeCap',aziendaSedeCap);
            res.put('aziendaSedeLocalita',aziendaSedeLocalita);
            res.put('aziendaSedeProv',aziendaSedeProv);
            res.put('agenteCod',agenteCod);
            res.put('agenteRagSoc',agenteRagSoc);
            res.put('subAgenteCod',subAgenteCod);
            res.put('subAgenteRagSoc',subAgenteRagSoc);
            res.put('bancaCod',bancaCod);
            res.put('bancaRagSoc',bancaRagSoc);
            res.put('filBancaCod',filBancaCod);
            res.put('filBancaRagSoc',filBancaRagSoc);
            res.put('assicVitaCod',assicVitaCod);
            res.put('assicVitaRagSoc',assicVitaRagSoc);
            res.put('assicImpiegoCod',assicImpiegoCod);
            res.put('assicImpiegoRagSoc',assicImpiegoRagSoc);
            return res;
        }
    }
}