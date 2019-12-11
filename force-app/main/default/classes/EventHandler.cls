public without sharing class  EventHandler extends TriggerHandler{

public override void afterInsert() {   
        System.debug('_______EventHandler.afterInsert____START');       
                
        Map<String,String> mapBranchEvent = new Map<String,String> (); 
        Map<String,Event> mapResourceEvent = new Map<String,Event> (); 
        Set<Id> desks = new Set<Id>();
        for(Event ev : (List<Event>)Trigger.new){
            if('Appuntamento'.equals(ev.Type)){
                desks.add(ev.Desk__c);
            }
        }

        if(desks.size()>0){
            //recupera i desk degli appuntamenti
            Map<String,XCS_Desk__c> deskMap = new Map<String,XCS_Desk__c>([SELECT ID,Branch__c,Branch__r.OCS_External_Id__c,DeskName__c FROM XCS_Desk__c WHERE ID IN :desks AND Branch__c != NULL]);
            if(deskMap.size()> 0){
                
                for(Event ev : (List<Event>)Trigger.new){
                    if('Appuntamento'.equals(ev.Type) && deskMap.containsKey(ev.Desk__c)){
                            mapBranchEvent.put(deskMap.get(ev.Desk__c).Branch__c,ev.Id);
                            XCS_Desk__c desk = deskMap.get(ev.Desk__c);
                            mapResourceEvent.put(desk.Branch__r.OCS_External_Id__c+'-'+desk.DeskName__c,ev);
                    }
                }
            }
        }
       
                       
        
        if(mapResourceEvent.size()>0){
            ShareBranchCalendar.shareResources(mapResourceEvent);
        }

        if(mapBranchEvent.size()>0){
            ShareBranchCalendar.future_shareUser(mapBranchEvent);
        }

        System.debug('_______EventHandler.afterInsert____DONE');  
    }

    public override void beforeInsert() {
        System.debug('_______EventHandler.beforeInsert____START');
        
        

        System.debug('_______EventHandler.beforeInsert____DONE');  
    }

    public override void beforeUpdate() {
        System.debug('_______EventHandler.beforeUpdate____START');       
        
        
        System.debug('_______EventHandler.beforeUpdate____DONE'); 
    }

    public override void afterUpdate() {
        System.debug('_______EventHandler.afterUpdate____START');       
        // --START-- elimina tutti gli elementi correlati all'appuntamento annullato 
        Set<Id> eventToDeleteSons = new Set<Id>();
        System.debug('nuovo stato azione-->'+((Event)Trigger.new[0]).Stato_Azione__c);
        System.debug('vecchio stato azione-->'+((Event)Trigger.old[0]).Stato_Azione__c);
        Integer cont = 0;
        for(Event ev : (List<Event>)Trigger.new){
            if('Appuntamento'.equals(ev.Type)  
                && ((Event)Trigger.new[cont]).Stato_Azione__c!=((Event)Trigger.old[0]).Stato_Azione__c 
                && 'Non presentato/Annullato'.equals(((Event)Trigger.new[cont]).Stato_Azione__c)){
                eventToDeleteSons.add(ev.Id);
            }
            cont ++;
        }

        if(eventToDeleteSons != null && eventToDeleteSons.size()>0){
            //elimina gli eventi correlati all'appuntamento annullato
            List<EventRelation> eventSons = [select id,EventId 
                                                FROM EventRelation where EventId in :eventToDeleteSons 
                                                    AND IsInvitee = true];
            if(eventSons!=null && eventSons.size()>0)
                delete eventSons;
        }

        // --END-- elimina tutti gli elementi correlati all'appuntamento annullato 

        System.debug('_______EventHandler.afterUpdate____DONE'); 
    }

    public override void beforeDelete() {
        System.debug('_______EventHandler.beforeDelete____START');       
                
        
        System.debug('_______EventHandler.beforeDelete____DONE'); 
    }
}