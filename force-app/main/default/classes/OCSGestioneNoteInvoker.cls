public class OCSGestioneNoteInvoker {
    public static OCSGestioneNoteResponse gestioneNote(OCSGestioneNoteRequest req){
        return (OCSGestioneNoteResponse)ApiUtils.callApi
            ('ocs.gestioneNote',req,OCSGestioneNoteResponse.class);
    }
    
    public static OCSGestioneNoteResponse gestioneNote (String utente,string codCliente,string numPratica,string tipoPratica,string modalita, string tipoNote, string note)
    {        
        OCSGestioneNoteRequest req = new OCSGestioneNoteRequest();
        req.GestioneNoteRequest.utente = utente;
        req.GestioneNoteRequest.codCliente = codCliente ;
        req.GestioneNoteRequest.numPratica = numPratica ;
        req.GestioneNoteRequest.tipoPratica = tipoPratica;
        req.GestioneNoteRequest.modalita = modalita;
        req.GestioneNoteRequest.tipoNote = tipoNote;
        req.GestioneNoteRequest.note = note;
        
        return gestioneNote(req);
    }
    
    public static void filtraNote(String utente,string codCliente,string numPratica,string tipoPratica,string modalita, string tipoNote, string note){
        RecordType rt = [Select id from RecordType where DeveloperName = 'Note' and SobjectType = 'XCS_Messaggio__c' ];      
        XCS_Messaggio__c n = new XCS_Messaggio__c();
        n.CodCliente__c = codCliente;
        n.NumPratica__c = numPratica;
        n.TipoPratica__c = tipoPratica;
        n.TipoNote__c = tipoNote;
        n.Testo__c = note;
        n.Utente__c = utente;
        n.Modalita__c = modalita;
        n.CompanyType__c = 'COMPASS'; 
        n.RecordTypeId = rt.id;
        insert n;
        System.debug('DP XCS_Messaggio__c dopo inserimento ::::::::::::::::::::::::::> ' + n);
    }  
    
    public static XCS_Messaggio__c createOCSNote(RecordType rt, String utente,string codCliente,string numPratica,string tipoPratica,string modalita, string tipoNote, string note) {
        
       	XCS_Messaggio__c n = new XCS_Messaggio__c();
       	n.CodCliente__c = codCliente;
       	n.NumPratica__c = numPratica;
       	n.TipoPratica__c = tipoPratica;
       	n.TipoNote__c = tipoNote;
       	n.Testo__c = note;
       	n.Utente__c = utente;
       	n.Modalita__c = modalita;
       	n.CompanyType__c = 'COMPASS'; 
       	n.RecordTypeId = rt.id;
        return n;
    }
}