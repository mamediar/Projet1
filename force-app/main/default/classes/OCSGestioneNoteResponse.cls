public class OCSGestioneNoteResponse extends OCSResponse {
    
    public InfoNota gestioneNoteResponse {get; set;} 
    
    public class InfoNota {
        public String as400Status {get; set;}
        public String as400Errore {get; set;}
    }
    
    public override boolean isOK()
    {            
 //       gestioneNoteResponse = new InfoNota();
        return super.isOk() && 'OK'.equalsIgnoreCase(gestioneNoteResponse.as400Status);
    }
    
}