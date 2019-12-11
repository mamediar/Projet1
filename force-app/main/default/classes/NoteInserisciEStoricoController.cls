public class NoteInserisciEStoricoController {

    //Filtra le note 
    @AuraEnabled
    public static List<ContentNote> getAllNotes(String recordId, Boolean filterOnTitle, Boolean filterOnDate, Boolean noFilter, String titleFilter, Datetime startDateFilter, Datetime endDateFilter){    
        List<ContentNote> notes=new List<ContentNote>();
        if(filterOnTitle){
            return XCSNoteUtils.getAllNotes(recordId,titleFilter);
        } else if(filterOnDate){
               if(startDateFilter!=null && endDateFilter!=null){
                    return XCSNoteUtils.getAllNotes(recordId,startDateFilter,endDateFilter);
            	} else if(startDateFilter!=null){
                    return XCSNoteUtils.getAllNotes(recordId,startDateFilter);
                } else {
                    return notes;  
                }   
        } else if(noFilter){
            return XCSNoteUtils.getAllNotes(recordId);
        }  else {
            return notes;
        }  
    }
    
    
    @AuraEnabled
    public static List<ContentNote> insertNote(String body, String recordId, String title) {
        if(String.isEmpty(title)){  //se il title passato è vuoto allora viene imposto come title l'utente connesso oppure il nome della coda a cui appartiene
            //recupera dati dell'user che sta inserendo la nota
            User u = [select firstname, lastname, DefaultQueueId__c from user where id=:userinfo.getuserid()][0];              
            if (string.isEmpty(u.DefaultQueueId__c)){
                title =u.firstname+' '+u.lastname;
            } else {
                List<Group> lstGroup=[SELECT Id, Name, DeveloperName FROM Group WHERE developername=:u.DefaultQueueId__c];
                if(lstGroup.size()>0 ){
                    if(!String.isEmpty(lstGroup[0].Name)){
                        title =lstGroup[0].Name;
                    } else {
                        title =lstGroup[0].DeveloperName;
                    }
                } else {
                    title =u.firstname+' '+u.lastname;
                }           
            } 
        }
        XCSNoteUtils.postANote(recordId,title,body);        		
        return XCSNoteUtils.getAllNotes(recordId);
    }    

}