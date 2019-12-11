public class OCSGestioneNoteRequest  extends OCSRequest  {
    
      public Note gestioneNoteRequest {get; set;}
    
    public  OCSGestioneNoteRequest()
    {
        serviceId = 'gestioneNote';
        gestioneNoteRequest = New Note();
    }   
    
    public class Note {
    public String utente {get; set;}
    public String codCliente {get; set;}
    public String numPratica {get; set;}
    public String tipoPratica {get; set;}
    public String modalita {get; set;}
    public String tipoNote {get; set;}
    public String note {get; set;}// concatena al posto ticket metti case number del case sotto 7777 service interno masino...a sinistra metto profilo utente
    }

}