/**
 * @author Domenico Fava   
 * La classe si occupa di estendere l'appuntamento della filiale con
 * tutti gli utenti o risorse della filiale
 */
public without sharing class ShareBranchCalendar {
    /**
     * Il metodo condivide l'evento della filiale con tutti i suoi dipendenti
     * @param  mapBranchEvent <BranchId,EventId> --> evento da condividere agli user del branch
     */
    @future
    public static void future_shareUser (Map<String,String> mapBranchEvent){
        List<EventRelation> eventToInsert = new List<EventRelation>();
        Map<String,String> mapRolePerBranches = new Map<String,String>();
        try{
            //ricerca Account branch per recuperare il ruolo delle filiali
            List<Account> branches = [SELECT ID,name,NameRoleReference__c FROM Account
                            WHERE id in :mapBranchEvent.keySet()];
            //organizzazione mappa <ruoloFiliale,branchId>
            for(Account branch : branches){
                mapRolePerBranches.put(branch.NameRoleReference__c.toLowerCase(),branch.ID);
            }
            System.debug('mapRolePerBranches-->'+mapRolePerBranches);
            //ricerca User che utilizzano il ruolo della filiale
            List<User> userInBranch = [SELECT ID, Name, UserRole.DeveloperName FROM USER WHERE UserRole.DeveloperName in :mapRolePerBranches.keySet() AND IsActive = true];
            for(User us : userInBranch){
                String branchId = mapRolePerBranches.get(us.UserRole.DeveloperName.toLowerCase());
                String eventId = mapBranchEvent.get(branchId);
                //Attendee tra evento e utente della filiale
                EventRelation ev = new EventRelation(EventId=eventId,RelationId=us.Id,Status='Accepted');
                System.debug('EventRelation:'+us.Name + '-->'+eventId);
                eventToInsert.add(ev);
                
            }
            //inserimento massivo di condivisione evento agli utenti della filiale
            Database.SaveResult[] lsr = Database.insert(eventToInsert,false);
            System.debug('risultato salvataggio-->'+lsr);
        } catch(Exception e){
            System.debug('Exception'+e);
            System.debug(e.getMessage());
        }
        
    }

    /**
      * capire se uno user è occupato:
      * SELECT id,Branch__r.name, User__r.name, XCS_Zone__r.name, Time__c FROM SFA_Slot__c
      */ 

    /**
     * <Fxx-Deskx,Event>
     */
     public static void shareResources (Map<String,Event> mapResourceEvent){
         List<Event> eventInError = new List<Event>();
         List<EventRelation> eventToInsert = new List<EventRelation>();
         Map<String,Calendar> mapCalendar = new Map<String,Calendar>();
         //Risorse di tutti gli eventi
         List<Calendar> resources = [select id,Type, name from Calendar where NAME IN :mapResourceEvent.keySet() AND Type = 'Resource' AND IsActive = true];
         for(Calendar resource : resources){
             mapCalendar.put(resource.Name, resource);
         }


         for(String nameResorce : mapResourceEvent.keySet()){
             Calendar calendar = mapCalendar.get(nameResorce);
             Event ev = mapResourceEvent.get(nameResorce);
             //se esiste valore, vuol dire che esiste la risorsa associata
             if(calendar != null){
                 System.debug('Risorsa ***'+nameResorce+'***trovata');
                 //Attendee tra evento e risorsa
                EventRelation evRel = new EventRelation(EventId=ev.Id,RelationId=calendar.Id,Status='Accepted');
                eventToInsert.add(evRel);
             } else{
                 System.debug('Risorsa ***'+nameResorce+'*** NON trovata');
                 eventInError.add(ev);
             }
         }

         if(eventToInsert.size()>0){
             System.debug('inserisco Attendee');
             insert eventToInsert;
         }

         if(eventInError.size()>0){
             for(Event ev : eventInError){
                 ev.addError('RISORSA NON DISPONIBILE PER L\'APPUNTAMENTO');
             }
         }
     }
}