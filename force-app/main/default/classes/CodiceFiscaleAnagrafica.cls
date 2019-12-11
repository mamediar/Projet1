public class CodiceFiscaleAnagrafica {

    
    public Anagrafica anagrafica{get;set;}     
    
    public CodiceFiscaleAnagrafica(){
        this.anagrafica= new Anagrafica();
    }
    
    
    public class Anagrafica{        
        public String cognome{get; set;}
        public String nome{get; set;}
        public String sesso{get; set;}    //M o F
        public Date dataNascita{get; set;}
        public String codiceComune{get; set;}   //potrebbe essere ad esempio "002"
    }

    
}