public class CRM_GestioneEmailChiusuraController {
    
    @AuraEnabled
    public static void handleCase(String esito,String recordId,String note){
        System.debug('id = ' + recordId);
        CaseUtils.esitaCase(recordId,esito,note);        
        if(note!=null && !note.equals('')){
            XCSNoteUtils.postANote(recordId,'Nota - '+esito,note);
        }
        if(esito.equalsIgnoreCase('Gestita')){
            CaseUtils.closeCase(recordId);
        }
        else if(esito.equalsIgnoreCase('Annullata'))
			CaseUtils.changeStatus(recordId,'New');            
        
    }
}