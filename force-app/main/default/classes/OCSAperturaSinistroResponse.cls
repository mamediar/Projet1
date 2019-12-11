public class OCSAperturaSinistroResponse extends OCSResponse  {
    
    public ApertutaSinistroResponseDTO datiAperturaSinistroResponse{get;set;}
   
    
    
    public OCSAperturaSinistroResponse(){
   
        datiAperturaSinistroResponse = new ApertutaSinistroResponseDTO();
    }
    
    
    
    
    public class ApertutaSinistroResponseDTO{
        public String compagnia{get;set;}
        public String opzionePagamento{get;set;}
        public String tipoPratica{get;set;}
        public String luogoElab{get;set;}
        public String dataElab{get;set;}
        public String numPratica{get;set;}
        public String polizza{get;set;}
        public String dataErogazione{get;set;}
        public String nominativoAssicurato{get;set;}
        public String tipoSinistro{get;set;}
        public String dataSinistro{get;set;}
        public String saldoResiduo{get;set;}
         public String rata{get;set;}
        public String dataPrimoUtilizzo{get;set;}
        public String contraente{get;set;}
        public String dataNascita{get;set;}
        public String codFiscale{get;set;}
        public String codCliente{get;set;}
        public String professione{get;set;}
        public String Pan{get;set;}
        public String dataSottoscrizione{get;set;}
        public String durata{get;set;}
        public String dataScadenza{get;set;}
        public String finanziato{get;set;}
        public String dataResiduoAl{get;set;}
        public String ggScadenzaRata{get;set;}
        public String tan{get;set;}
        public String taeg{get;set;}
        public String dataRichiesta{get;set;}
        public String dataValidita{get;set;}
        public String fido{get;set;}
        public String pianoAmmortamento{get;set;}
        public List<AperturaSinistroScarto> scarti{get;set;}
       
        public ApertutaSinistroResponseDTO(){
             this.scarti = new List<AperturaSinistroScarto>();
        }
        
    }
    
    
    public class AperturaSinistroScarto{
        public String numPratica{get;set;}
        public String dataSinistro{get;set;}
        public String tipoSinistro{get;set;}
        public String cognome{get;set;}
        public String nome{get;set;}
        public String desScarto{get;set;}
        
    }
    
}