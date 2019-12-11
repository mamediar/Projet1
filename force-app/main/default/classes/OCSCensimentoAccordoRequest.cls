public class OCSCensimentoAccordoRequest extends OCSRequest  {
    
    @AuraEnabled
    public OCSCensimentoAccordoRequestData censimentoAccordoRequest{get;set;}
    
    public OCSCensimentoAccordoRequest(){
        this.serviceId='censimentoAccordo';
        this.censimentoAccordoRequest=new OCSCensimentoAccordoRequestData();
    }
    
    public class OCSCensimentoAccordoRequestData{
        @AuraEnabled
        public List<Elenco> elenco {get; set;}
        
        public OCSCensimentoAccordoRequestData() {
            this.elenco=new List<Elenco>();
        }
    }


    
    public class Elenco {
        public String partimestp {get;set;}
		public String tipoIntermediario{ get{	if(tipoIntermediario == null) tipoIntermediario = ''; return tipoIntermediario;}  set;} 
		public String codIntermediario{ get{	if(codIntermediario == null) codIntermediario = ''; return codIntermediario;}  set;} 
		public String codAccordo{ get{	if(codAccordo == null) codAccordo = ''; return codAccordo;}  set;} 
		public String nomeFile {get;set;}
		public String segnala {get;set;}
       
    }    
}