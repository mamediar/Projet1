public class OCSDatiAggiuntiviReclamiResponse extends OCSResponse{
    
    public DatiAggiuntiviReclamiResponseDTO datiAggiuntiviReclamiResponse{get;set;}
    
    public OCSDatiAggiuntiviReclamiResponse(){
        datiAggiuntiviReclamiResponse = new DatiAggiuntiviReclamiResponseDTO(); 
    }
    
    public class DatiAggiuntiviReclamiResponseDTO{
        public String abi {get;set;}
        public String cab {get;set;}
        public String cc {get;set;}
        public String importo {get;set;}
        public String nomeBanca {get;set;}
        public String dataRevoca {get;set;}
        public String dataDepennamento {get;set;}
        public String tabellaFinanziaria {get;set;}
        public String codAttributoPM {get;set;}
        public String desAttributoPM {get;set;}
    }        
}