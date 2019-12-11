public class SFAPraticheIrregolariNoteGDVController {

    @AuraEnabled
    public static Boolean getIfFlagVisible(Id praticaId)
        {   
    		Boolean isFlagVisible=false;
            SFA_PraticaIrregolare__c pratica=[SELECT Id,Status__c FROM SFA_PraticaIrregolare__c WHERE Id = :praticaId];
            if (pratica.Status__c=='Pratica - Gestita filiale'){  
                isFlagVisible=true;
            }
            return isFlagVisible;
        }
    

    
    @AuraEnabled
    public static List<ContentDocument> getAllNotes(String praticaId)
        { 
        List<ContentDocument> notes= new List<ContentDocument>();
		notes=XCSNoteUtils.getAllNotesByContentDocument(praticaId);
        return notes;            
        }
    

    
    @AuraEnabled
    public static List<ContentDocument> insertNote(String body, String praticaId, Boolean flagRimandaAllaFiliale) {
 
	    //recupera dati dell'user che sta inserendo la nota
        String title;
        /*User u = [select firstname, lastname, DefaultQueueId__c from user where id=:userinfo.getuserid()][0]; 
        List<Account> GDVUser = [SELECT Name, OCS_External_Id__c, RecordType.Name 
                                   FROM Account WHERE RecordType.Name = 'GDV' AND OCS_External_Id__c = :u.DefaultQueueId__c]; 
        if (GDVUser.size() < 1) {
           title ='GDV';
        } else {
           title =GDVUser[0].Name;
        } */
        title ='GDV';

        XCSNoteUtils.postaNoteInContentDocument(praticaId,title,body);        		
        
        if (flagRimandaAllaFiliale){
            SFA_PraticaIrregolare__c pratica=[SELECT Id,Status__c FROM SFA_PraticaIrregolare__c WHERE Id = :praticaId];
            pratica.Status__c='Pratica - Richiesta Maggiori Informazioni';
            try{
                update pratica;               
            }
            catch (Exception ex) {
                system.debug('Exception has occurred! ' +ex.getMessage());         
            }            
                        
        }  
        
		//recupera tutte le note allegate alla pratica:
		List<ContentDocument> notes= new List<ContentDocument>(); 
		notes=XCSNoteUtils.getAllNotesByContentDocument(praticaId);
        return notes;      


    }    
    
    
    
    
    
    

}