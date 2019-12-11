public without sharing class XCS_GestioneIndisponibilitaClass {
    
    @AuraEnabled
    public static InitWrapper initApex(){
        

        InitWrapper iW = new InitWrapper(); 
        
        setAllBranchListPerAreaMap(iW);
        return iW; 
    }

    @AuraEnabled
    public static AppointmentWrapper getAppointmentWrapper(Account filialeSelected,Date targetDate){
        targetDate = targetDate == null ? Date.today() : targetDate;
        Datetime dtStart = Datetime.newInstance(targetDate.year(), targetDate.month(),targetDate.day());
        Datetime dtEnd = dtStart.addDays(1);

        DeskObject deskToPush;
        AppointmentObject appToPush;

        AppointmentWrapper appWrapper = new AppointmentWrapper();
        List<DeskObject> deskListAppointment = new List<DeskObject>();
        List<AppointmentObject> appuntamentiAllDeskList = new List<AppointmentObject>();

        List<XCS_Appointment__c> appForpAllDesk =  [SELECT Id,XCS_Desk__c,StartTime__c,StartDateTime__c,EndDateTime__c,EndTime__c,Type__c FROM XCS_Appointment__c WHERE (Branch__c =: filialeSelected.Id OR Branch__c = null) AND XCS_Desk__c = null AND Date__c =: targetDate AND Type__c != 'App'];
        List<XCS_Desk__c> deskListFromDesk = [SELECT Id,isActive__c,DeskName__c,(SELECT Id,StartDateTime__c,StartTime__c,EndDateTime__c,EndTime__c,Type__c,XCS_Desk__c FROM Appuntamenti__r WHERE Date__c =: targetDate),(SELECT Id,Desk__c,StartDateTime,EndDateTime,ActivityType  FROM Activities__r WHERE StartDateTime >=: dtStart AND EndDateTime <:dtEnd order by StartDateTime ASC) FROM XCS_Desk__c WHERE Branch__c =: filialeSelected.Id AND isActive__c = true ORDER BY DeskName__c]; 

        for(XCS_Appointment__c app : appForpAllDesk){

            appToPush = new AppointmentObject();
            appToPush.Id = app.Id;
            appToPush.XCS_Desk = app.XCS_Desk__c;
            appToPush.StartDateTime = app.StartDateTime__c;
            appToPush.EndDateTime = app.EndDateTime__c;
            appToPush.StartTime = app.StartTime__c;
            appToPush.EndTime = app.EndTime__c;
            appToPush.Type = app.Type__c;

            appuntamentiAllDeskList.add(appToPush); 
        }

        if(!deskListFromDesk.isEmpty()){
            for(XCS_Desk__c desk : deskListFromDesk){

                deskToPush = new DeskObject();
                deskToPush.Id = desk.Id;
                deskToPush.DeskName = desk.DeskName__c;
                deskToPush.isActive = desk.isActive__c;
                deskToPush.Appuntamenti = new List<AppointmentObject>();
                
                if(!desk.Appuntamenti__r.isEmpty()){
                    for(XCS_Appointment__c app : desk.Appuntamenti__r){
                        appToPush = new AppointmentObject();
                        appToPush.Id = app.Id;
                        appToPush.XCS_Desk = app.XCS_Desk__c;
                        appToPush.StartDateTime = app.StartDateTime__c;
                        appToPush.EndDateTime = app.EndDateTime__c;
                        appToPush.StartTime = app.StartTime__c;
                        appToPush.EndTime = app.EndTime__c;
                        appToPush.Type = app.Type__c;
                        
                        deskToPush.Appuntamenti.add(appToPush);
                    }
                }

                if(!desk.Activities__r.isEmpty()){
                    Datetime lastStartDateTime = null;
                    Datetime lastEndDateTime = null;
                    for(Integer i=0; i<desk.Activities__r.size(); i++){
                        if(desk.Activities__r[i].ActivityType  == 'Indisponibilità') continue;
                        System.debug('-----------');
                        System.debug('lastStartDateTime-->'+lastStartDateTime);
                        System.debug('desk.Activities__r[i].StartDateTime-->'+desk.Activities__r[i].StartDateTime);
                        System.debug('lastEndDateTime-->'+lastEndDateTime);
                        System.debug('desk.Activities__r[i].EndDateTime-->'+desk.Activities__r[i].EndDateTime);
                        System.debug('-----------');
                        if(lastStartDateTime == desk.Activities__r[i].StartDateTime && lastEndDateTime == desk.Activities__r[i].EndDateTime) {
                            System.debug('----SALTO APPUNTAMENTO----- ATTENDEE');
                            continue;
                        }
                        lastStartDateTime = desk.Activities__r[i].StartDateTime;
                        lastEndDateTime   = desk.Activities__r[i].EndDateTime;
                        appToPush = new AppointmentObject();
                        appToPush.Id = desk.Activities__r[i].Id;
                        appToPush.XCS_Desk = desk.Activities__r[i].Desk__c;
                        appToPush.StartDateTime = desk.Activities__r[i].StartDateTime;
                        appToPush.EndDateTime = desk.Activities__r[i].EndDateTime;
                        appToPush.StartTime = desk.Activities__r[i].StartDateTime.Time();
                        appToPush.EndTime = desk.Activities__r[i].EndDateTime.Time();
                        appToPush.Type = 'App';
                        
                        deskToPush.Appuntamenti.add(appToPush);
                    }
                }
                
                deskListAppointment.add(deskToPush);
            }
        }
            

        appWrapper.deskList = deskListAppointment;
        appWrapper.appuntamentiAllDeskList = appuntamentiAllDeskList;
        return appWrapper;
    }

    @AuraEnabled
    public static void insertIndisponibilitaApex(XCS_Appointment__c theAppointment){
        
        if(theAppointment != null){
            insert theAppointment;
        }

    }

    @AuraEnabled
    public static void deleteIndisponibilitaApex(XCS_Appointment__c theAppointmentToDelete){
        
        if(theAppointmentToDelete != null){
            delete theAppointmentToDelete;
        }

    }

    @AuraEnabled
    public static void updateAppointmentListApex(List<XCS_Appointment__c> theAppointmentListToUpdate){
        
        if(theAppointmentListToUpdate != null){
            update theAppointmentListToUpdate;
        }

    }

    private static void setAllBranchListPerAreaMap(InitWrapper initWrapper){

        String userType = typeUser();
        User u= [SELECT Id,Name,DefaultQueueId__c,Area__c,UserRole.Name FROM User WHERE Id =: UserInfo.getUserId()];
        String OCSExternalId = u.DefaultQueueId__c == null ? '' : u.DefaultQueueId__c;
        String Area = u.Area__c == null ? '' : u.Area__c;
        String Role = u.UserRole.Name == null ? '' : u.UserRole.Name;
        System.debug('DP Ruolo: '+Role);
        System.debug('DP typeUser: '+userType);
        String QueryBranch = 'SELECT Id,Name,toLabel(Type) TypeLabel,OCS_External_Id__c,OCSAreaId__c,Region_Name__c,'+
                               +' (SELECT DeskName__c,isActive__c,Product__c, Branch__c FROM XCS_Desk__r ORDER BY DeskName__c)'+
                               +' FROM Account'+
                               +' WHERE OCS_External_Id__c != null AND OCSAreaId__c != null AND Region_Name__c != null'+
                               +' AND Type = \'FIL\' AND RecordType.DeveloperName = \'Branch\'';
        

        //Setto la visibilità delle filiali in base al profilo che andranno a prendermi la Coda/Area/Regione dell'utente.
        if(userType=='Area Manager' && Role.contains('REGIONE')){
           QueryBranch +=' AND toLabel(Region_Name__c) =: Role'; 
           System.debug('DP sono un region manager');
        }
        if(userType=='Area Manager' && !Role.contains('REGIONE')){
            QueryBranch +=' AND OCSAreaIdText__c=: Area';
            System.debug('DP sono un Area manager');
        }                                     
        If(userType=='Branch Manager' || userType=='Branch Employee'){
            QueryBranch += ' AND OCS_External_Id__c=: OCSExternalId';
            System.debug('DP sono un utente di filiale');
        }
        
        
        System.debug('DP QueryBranch: '+QueryBranch);
        List<Account> allBranchList = Database.query(QueryBranch);
        /*List<Account> allBranchList = [SELECT Id,Name,toLabel(Type) TypeLabel,OCS_External_Id__c,OCSAreaId__c,Region_Name__c, 
                                      (SELECT DeskName__c,isActive__c,Product__c, Branch__c FROM XCS_Desk__r ORDER BY DeskName__c) 
                                       FROM Account 
                                       WHERE OCS_External_Id__c != null 
                                       AND OCSAreaId__c != null 
                                       AND Region_Name__c != null 
                                       AND Type = 'FIL' 
                                       AND RecordType.DeveloperName = 'Branch'];*/
        System.debug('DP allBranchList: '+allBranchList);
        Map<String,List<String>> areaListPerRegion = new Map<String,List<String>>();
        Map<String,List<Account>> branchListPerArea = new Map<String,List<Account>>();

        for (Account branch : allBranchList){

            if(areaListPerRegion.containsKey(branch.Region_Name__c)){
                if(!areaListPerRegion.get(branch.Region_Name__c).contains(String.valueOf(branch.OCSAreaId__c)))
                    areaListPerRegion.get(branch.Region_Name__c).add(String.valueOf(branch.OCSAreaId__c));
            }else{
                areaListPerRegion.put(branch.Region_Name__c,new List<String>{String.valueOf(branch.OCSAreaId__c)});
            }

            if(branchListPerArea.containsKey(String.valueOf(branch.OCSAreaId__c))){
                branchListPerArea.get(String.valueOf(branch.OCSAreaId__c)).add(branch);
            }else{
                branchListPerArea.put(String.valueOf(branch.OCSAreaId__c),new List<Account>{branch});
            }
        }
        initWrapper.areaListPerRegion = areaListPerRegion;
        initWrapper.branchListPerArea = branchListPerArea;
    }

    public static String typeUser() {
        String userType = [SELECT Name FROM Profile WHERE id=:userinfo.getProfileId() LIMIT 1].name;       
        return userType == null ? '' : userType;      
    }
    
    public class InitWrapper {
        
        @AuraEnabled
        public Map<String,List<String>> areaListPerRegion;
        @AuraEnabled
        public Map<String,List<Account>> branchListPerArea;
        @AuraEnabled
        public Date today = Date.today();

    }

    public class AppointmentWrapper{

        @AuraEnabled
        public List<DeskObject> deskList;
        @AuraEnabled
        public List<AppointmentObject> appuntamentiAllDeskList;
    }

    public class DeskObject{ 

        @AuraEnabled
        public Id Id;
        @AuraEnabled
        public String DeskName;
        @AuraEnabled
        public Boolean isActive;
        @AuraEnabled
        public List<AppointmentObject> Appuntamenti;
    }

    public class AppointmentObject{

        @AuraEnabled
        public Id Id;
        @AuraEnabled
        public String XCS_Desk;
        @AuraEnabled
        public DateTime StartDateTime;
        @AuraEnabled
        public DateTime EndDateTime;
        @AuraEnabled
        public Time StartTime;
        @AuraEnabled
        public Time EndTime;
        @AuraEnabled
        public String Type;
    }
}