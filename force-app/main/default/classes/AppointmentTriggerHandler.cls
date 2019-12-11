public with sharing class AppointmentTriggerHandler  extends TriggerHandler {
    static Map<String,String> mapEventType=new Map<String,String> {'Fest'=>'Festività', 'Ind'=>'Indisponibilità', 'App'=>'Appuntamento'};
    
    
    public override void  afterInsert(){
        
        List<XCS_Appointment__c> lstAppointment=(List<XCS_Appointment__c>) Trigger.new;
        List<Event> lstEvent=new List<Event>();
        //List<Account> lstBranch=[select id from account where RecordType.DeveloperName='Branch'];
        
        //recupero le branch selezionate
        Set<Id> setBranchId=new Set<Id>();
        for(XCS_Appointment__c app : lstAppointment)   setBranchId.add(app.Branch__c);
        
        List<XCS_Desk__c> lstBranchDesk=[select id,Branch__c from XCS_Desk__c where isActive__c=true and branch__c in :setBranchId]; 
        List<XCS_Desk__c> lstAllDesk=[select id,Branch__c from XCS_Desk__c where isActive__c=true ]; 

        for(XCS_Appointment__c app : lstAppointment){
            DateTime dtStartDateTime=DateTime.newInstance(app.Date__c,app.StartTime__c); //costruisco data ora x appuntamento
            DateTime dtEndDateTime=DateTime.newInstance(app.Date__c,app.EndTime__c); //costruisco data ora x appuntamento           

            //String dtStartDateTime=dtStartDateTimeGMT.format();
            //String dtEndDateTime=dtEndDateTimeGMT.format();

            /**
            Integer offsetStart = UserInfo.getTimezone().getOffset(dtStartDateTimeGMT);
            Integer offsetEnd = UserInfo.getTimezone().getOffset(dtEndDateTimeGMT);
            DateTime dtStartDateTime=dtStartDateTimeGMT.addSeconds(offsetStart);
            DateTime dtEndDateTime=dtEndDateTimeGMT.addSeconds(offsetEnd);
             */

             
            if(app.Branch__c==null)  {
                          
                //occorre creare un evento a calendario x ogni filiale e per ogni desk => per ogni desk
                for(XCS_Desk__c dsk : lstAllDesk) {
                    
                    lstEvent.add(
                        new Event(
                        Type=mapEventType.get(app.Type__c), 
                        ActivityDateTime=dtStartDateTime,
                        ActivityDate = dtStartDateTime.date(),
                        StartDatetime=dtStartDateTime, 
                        EndDatetime=dtEndDateTime, 
                        WhatId=dsk.Branch__c,
                        Subject=mapEventType.get(app.Type__c),
                        Desk__c=dsk.id,
                        Appuntamento__c=app.id
                        )  
                    );
                }
            }
            else if(app.XCS_Desk__c==null){
                
                // imposto tutti i desk
                //List<XCS_Desk__c> lstDesk=[select id,Branch__c from XCS_Desk__c where isActive__c=true and Branch__c in :setBranchId ];            
                for(XCS_Desk__c dsk : lstBranchDesk) 
                    lstEvent.add(
                            new Event(
                            Type=mapEventType.get(app.Type__c), 
                            ActivityDateTime=dtStartDateTime,
                            StartDatetime=dtStartDateTime, 
                            EndDatetime=dtEndDateTime, 
                            WhatId=dsk.Branch__c,
                            Subject=mapEventType.get(app.Type__c),
                            Desk__c=dsk.id,
                            Appuntamento__c=app.id
                            )  
                        );
            }
            else
                lstEvent.add(
                        new Event(
                        Type=mapEventType.get(app.Type__c), 
                        ActivityDateTime=dtStartDateTime,
                        StartDatetime=dtStartDateTime, 
                        EndDatetime=dtEndDateTime, 
                        WhatId=app.Branch__c,
                        Subject=mapEventType.get(app.Type__c),
                        Desk__c=app.XCS_Desk__c,
                        Appuntamento__c=app.id
                        )  
             );
               
        }
        system.debug('DP lstAppointment: '+lstAppointment);
        system.debug('DP lstEvent: '+lstEvent);
        processInsert(JSON.serialize(lstEvent));
        
     }
    @future 
    private static void processInsert(String j){
        List<SObject> lst=(List<SObject>) JSON.deserialize(j, List<SObject>.class);
        insert lst;
    }

    @future 
    private static void processDelete(String j){
        List<SObject> lst=(List<SObject>) JSON.deserialize(j, List<SObject>.class);
        delete lst;
    }
    @future 
    private static void processUpdate(String j){
        List<SObject> lst=(List<SObject>) JSON.deserialize(j, List<SObject>.class);
        AppointmentTriggerHandler.setSkipValidation();
        System.assert(BypassRules__c.getInstance().BypassValidationRule__c,'CUSTOM SETTING NOT BYPASS RULE');
        if(lst.size()>0) update lst;
        AppointmentTriggerHandler.unsetSkipValidation();
    }
     public override void  afterUpdate(){
        Map<Id,XCS_Appointment__c> mapAppointment = (Map<Id,XCS_Appointment__c>) Trigger.newMap;
        List<XCS_Appointment__c> lstAppointment=(List<XCS_Appointment__c>) Trigger.new;
        List<Event> lstEvent=[select id,Type,ActivityDateTime,StartDatetime,EndDateTime,WhatId,Subject,Desk__c,Appuntamento__c from event where appuntamento__c=:lstAppointment];
        System.assert(lstEvent.size()>0,'NO EVENT TO UPDATE');
        for(Event evt : lstEvent){
            XCS_Appointment__c app=mapAppointment.get(evt.Appuntamento__c) ;
            DateTime dtStartDateTime=DateTime.newInstance(app.Date__c,app.StartTime__c); //costruisco data ora x appuntamento
            DateTime dtEndDateTime=DateTime.newInstance(app.Date__c,app.EndTime__c); //costruisco data ora x appuntamento                       
            
           // evt.Type=mapEventType.get(app.Type__c); 
            evt.ActivityDateTime=dtStartDateTime;
            evt.StartDatetime=dtStartDateTime; 
            evt.EndDatetime=dtEndDateTime;                 
           // evt.Subject=mapEventType.get(app.Type__c);                   
        }
        
        processUpdate(JSON.serialize(lstEvent));        
     }
     /***VALIDATION RULE BYPASS FROM CUSTOM SETTING */
     private static void setSkipValidation(){
        BypassRules__c tempSkipValidation =  BypassRules__c.getInstance();

        if(tempSkipValidation == null) {
            tempSkipValidation = new BypassRules__c();
        }
        
        tempSkipValidation.BypassValidationRule__c = true;
        upsert tempSkipValidation;
        
     }
     private static void unsetSkipValidation(){         
        BypassRules__c tempSkipValidation =  BypassRules__c.getInstance();
        tempSkipValidation.BypassValidationRule__c = false;
        update tempSkipValidation;
     }
     public override void  afterDelete(){

     }

     public override void  beforeDelete(){
         List<XCS_Appointment__c> lstAppointment=(List<XCS_Appointment__c>) Trigger.old;
         List<Event> lstEvent=[select id from Event where Appuntamento__c=:lstAppointment];
         if(lstEvent.size()>0)  processDelete(JSON.serialize(lstEvent));
             
         
     }

     public override void  afterUndelete(){

     }
}