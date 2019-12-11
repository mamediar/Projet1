public class XCS_Gestione_Desk_festivita_Apex {
    
    @AuraEnabled
    public static InitWrapper initApex(){
        List<XCS_Appointment__c> festivities= [SELECT Id,Date__c, Branch__c, Branch__r.Name, Branch__r.OCS_External_Id__c, EndTime__c, StartTime__c, StartDateTime__c, EndDateTime__c FROM XCS_Appointment__c WHERE Type__c='Fest'];
        List<XCS_Appointment__c> unavailabilities= [SELECT Id,Date__c, Branch__c, Branch__r.Name, Branch__r.OCS_External_Id__c, EndTime__c, StartTime__c, StartDateTime__c, EndDateTime__c FROM XCS_Appointment__c WHERE Type__c='Ind'];
        List<Event> eventList=[SELECT ActivityDate, EndDateTime, StartDateTime, Owner.Name FROM Event WHERE Owner.Alias =null];
        List<AppointmentWrapper> appointments=formatEvents(eventList);
        return new InitWrapper(XCS_GestioneDeskClass.initApex(), Date.today(), festivities, unavailabilities, appointments);
    }
    @AuraEnabled
    public static List<XCS_Appointment__c> insertNewfestivities(List<String> branchList,
    XCS_Appointment__c appuntamentoBase, boolean allFiliali){
        List<XCS_Appointment__c> appuntamenti= new List<XCS_Appointment__c>();
        for(String branch: branchList){
            XCS_Appointment__c appuntamento=createBasicAppointment(appuntamentoBase.Date__c, 
                                                                        appuntamentoBase.EndTime__c, 
                                                                        appuntamentoBase.StartTime__c);
            appuntamento.Branch__r=new Account(OCS_External_Id__c= branch);
            appuntamenti.add(appuntamento);
        }
        if(allFiliali){
            XCS_Appointment__c appuntamento= createBasicAppointment(appuntamentoBase.Date__c, 
                                                                    appuntamentoBase.EndTime__c, 
                                                                    appuntamentoBase.StartTime__c);
            appuntamenti.add(appuntamento);
        }
        try {
            insert appuntamenti;
        } catch (Exception ex) {
            AuraHandledException e= new AuraHandledException('Inserimento fallito');
            e.setMessage('Inserimento fallito');
            throw e;
        }
        return appuntamenti;
    }

    private static XCS_Appointment__c createBasicAppointment(Date myDate, Time myEndTime, Time myStartTime){
        return new XCS_Appointment__c(
                Date__c= myDate,
                EndTime__c= myEndTime,
                StartTime__c= myStartTime,
                Type__c= 'Fest'
            );
    }

    @AuraEnabled
    public static void updateFestivities(List<XCS_Appointment__c> festivityData){
        try {
            update festivityData;
        } catch (Exception ex) {
            AuraHandledException e= new AuraHandledException('Aggiornamento fallito');
            e.setMessage('Aggiornamento fallito');
            throw e;
        }
    }

    @AuraEnabled
    public static void deleteFestivities(List<XCS_Appointment__c> toDeleteData){
        try {
            delete toDeleteData;
        } catch (Exception ex) {
            AuraHandledException e= new AuraHandledException('Rimozione fallita');
            e.setMessage('Rimozione fallita');
            throw e;
        }
    }

    private static List<AppointmentWrapper> formatEvents(List<Event> eventList){
        List<AppointmentWrapper> appointments=new List<AppointmentWrapper>();
        for(Event event:eventList){
            appointments.add(new AppointmentWrapper(event));
        }
        return appointments;
    }

    public class InitWrapper{
        @AuraEnabled
        public XCS_GestioneDeskClass.InitWrapper gestioneDeskWrapper;
        @AuraEnabled
        public Date today;
        @AuraEnabled
        public List<XCS_Appointment__c> allFestivities;
        @AuraEnabled
        public List<XCS_Appointment__c> unavailabilities;
        @AuraEnabled
        public List<AppointmentWrapper> eventList;

        public InitWrapper(XCS_GestioneDeskClass.InitWrapper Wrapper, Date today, List<XCS_Appointment__c> festivities, List<XCS_Appointment__c> unavailabilities, List<AppointmentWrapper> appointments){
            this.gestioneDeskWrapper=Wrapper;
            this.today=today;
            this.allFestivities=festivities;
            this.unavailabilities=unavailabilities;
            this.eventList=appointments;
        }
    }

    public class AppointmentWrapper{
        @AuraEnabled
        public Date Date_c;
        @AuraEnabled
        public String BranchOcsCode;
        @AuraEnabled
        public Time StartTime_c;
        @AuraEnabled
        public Time EndTime_c;

        public AppointmentWrapper(Event event){
            this.Date_c=event.StartDateTime.date();
            this.BranchOcsCode=event.Owner.Name;
            this.StartTime_c=event.StartDateTime.time();
            this.EndTime_c=event.EndDateTime.time();
        }
            
        
    }
}