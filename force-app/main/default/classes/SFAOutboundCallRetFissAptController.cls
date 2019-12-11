public class SFAOutboundCallRetFissAptController {
    
    @AuraEnabled
    public static wrapInit doInit(String taskId){
        Task t = [Select Customer__c,WhatId from task where id = :taskId][0];
        case c = [Select Branch__c from case where id = :t.whatid][0];
        return new wrapInit(c,t);
    }
    
    @AuraEnabled
    public static void esitaTask(String taskId,Event app){
        Task tsk = [Select id,pratica__c from task where id=:taskId];
        tsk.Status = 'Completed';
        tsk.Disposition__c = XCS_DispositionUtils.findDispositionByExternalID(XCS_DispositionUtils.ACTIVITY_ITEM_APPUNTAMENTO_FISSATO).id;
        Event updateApp = new Event(Id=app.id,isRetention__c=true,pratica__c= tsk.pratica__c);
        update updateApp;
        update tsk;
    }
	
   
    public class wrapInit{
       	@AuraEnabled
        public Case caseOfTask{get;set;}
        @AuraEnabled
        public Task currentTask{get;set;}
        public wrapInit(case ca,task ta)
        {
            this.caseOfTask = ca;
            this.currentTask = ta;
        }
    }
    
}