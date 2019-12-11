public class OCSDcCreaDocumentoRequest  extends OCSRequest {

    public OCSDcCreaDocumentoRequestData dcCreaDocumentoRequest{get;set;}
    public String authorization{get;set;}
    
    public OCSDcCreaDocumentoRequest(){
        this.serviceId='dcCreaDocumento';
        this.authorization=null;
        this.dcCreaDocumentoRequest=new OCSDcCreaDocumentoRequestData();
    }
    
    public class OCSDcCreaDocumentoRequestData{

        public Pratica pratica {get; set;}
        
        public OCSDcCreaDocumentoRequestData() { 
            this.pratica=new Pratica();
        }
    }

    public class Pratica {
		public String societa {get { if (societa == null ) societa ='COMPASS'; return societa; } set;}
		public String tipoFirma {get { if (tipoFirma == null ) tipoFirma ='C'; return tipoFirma; } set;}
		public Boolean splitDocumenti {get { if (splitDocumenti == null ) splitDocumenti =false; return splitDocumenti; } set;}
        public String dataValiditaContratto {get {if (dataValiditaContratto == null ) dataValiditaContratto ='1561019772471'; return dataValiditaContratto;} set;}
        public List<String> tipiDocumento {get{ if (tipiDocumento == null ) tipiDocumento = new List<String>{'VARIE'}; return tipiDocumento;} set;}
		public String accordo {get; set;}
		public String bene {get; set;}
		public String dolceCasa {get; set;}
		public String emettitore {get; set;}
		public String idPratica {get; set;}
		public String procedura {get { if (procedura == null ) procedura ='VA'; return procedura; } set;}
		public String prodotto {get; set;}
		public String tipoProdotto {get; set;}
		public String canaleAcquisizione {get; set;}
		public String tipoCaricamento {get; set;}
		public String agente {get; set;}
		public String subagente {get; set;}
		public String convenzionato {get; set;}
		public String venditore {get; set;}
		public String soggetto {get; set;}
		public String risposteQuestionario {get; set;}
		public String assicurazione {get; set;}
		public String arrayLabelProperty {get; set;}
		public List<LabelProperty> labelProperty {get; set;}
		public List<String> listaModuloVarie {get; set;}
        
        public Pratica() {  
            this.labelProperty=new List<LabelProperty>();
            this.listaModuloVarie=new list<String>();
            //this.tipiDocumento=new list<String>();
        }      
	}
    
	public class LabelProperty {
		public String valore;
		public String variabile;
	}

}