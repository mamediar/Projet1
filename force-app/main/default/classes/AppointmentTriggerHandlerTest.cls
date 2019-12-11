@isTest
public with sharing class AppointmentTriggerHandlerTest {
    
    @TestSetup
    static void makeData(){
         FObject.setGlobalVerbose('none');
        /**
        FObject objAccount = new FObject('Account', 100);
        objAccount.setDefinition('RecordTypeId', 'static value(PersonAccount)');
        objAccount.setDefinition('LastName','random type(lastname) group(name)');
        objAccount.insertRecords(true);
 */
        FObject objAccount = new FObject('Account', 10);
        objAccount.setDefinition('RecordTypeId', 'static value(Branch)');
        objAccount.setDefinition('Name', 'static value(Filiale)');
        objAccount.setDefinition('Name', 'serial type(number) from(1) step(1) scale(0)');
        objAccount.insertRecords(true,'Filiali');    
        List<Account> lstFiliali=(List<Account>)objAccount.getInsertedGroupRecords('Filiali') ;

        FObject objDesk = new FObject('XCS_Desk__c', 100);
        //objDesk.setDefinition('Branch__c','random lookup(Account) field(RecordTypeId) value('+lstFiliali[0].RecordTypeId+') source(salesforce)');
        objDesk.setDefinition('Branch__c','random lookup(Account) group(Filiali) source(forceea)');
        objDesk.setDefinition('isActive__c','static value(true)');
        objDesk.insertRecords(true); 
        
        
       
    }
    private static User insertUserWithTimeZone(String timezone){  
        return insertUserWithTimeZone( timezone,'System Administrator');
    } 
    private static User insertUserWithTimeZone(String timezone,String profile){
        //INSERT USER with Timezone
        //
        system.debug('insertFestivita');
         FObject objUser = new FObject('User', 1);
		objUser.setDefinition('ProfileId', 'static lookup(Profile) field(Name) value('+profile+') source(salesforce)');
		//objUser.setDefinition('UserRoleId', 'static lookup(UserRole) field(Name) value(CEO) source(salesforce)');
        objUser.insertRecords(true);
       
         System.assert(objUser.getInsertedRecords().size()>0,'USER NOT INSERTED');      
        User u=(User)(objUser.getInsertedRecords()[0]);        
        USer u1=[select id from user where username=:u.username][0];
        System.debug('ID USER '+u1.id);        
        //u1.TimeZoneSidKey='Europe/Rome';
        //u1.TimeZoneSidKey='GMT';
        u1.TimeZoneSidKey=timezone;
        update u1;
        return u1;
    }
    @isTest
    public static void insertFestivita(){
        FObject.setGlobalVerbose('none');
        User u1=insertUserWithTimeZone('GMT');
        
        System.runAs(u1){
        
            //List<Account> lstFiliali=(List<Account>)objAccount.getInsertedGroupRecords('Account','Filiali') ;
            FObject objAppointment = new FObject('XCS_Appointment__c', 100);
            //RecordTypeId Filiale
            Id recordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Branch').getRecordTypeId();
            //Date__c data appuntamento
            objAppointment.setDefinition('Date__c','random type(date)  from(2019-9-1) to(2022-12-31)');
            objAppointment.setDefinition('XCS_Desk__c','random lookup(XCS_Desk__c)  source(salesforce)');
            objAppointment.setDefinition('Branch__c','copy field(XCS_Desk__c) from(XCS_Desk__c.Branch__c)');
            objAppointment.setDefinition('StartTime__c','static value(09:00:00)');
            objAppointment.setDefinition('EndTime__c','static value(18:00:00)');
            objAppointment.setDefinition('Type__c','static value(Fest)');
            objAppointment.insertRecords(true);
		
            Map<Id,XCS_Appointment__c> mapAppointment=new Map<Id,XCS_Appointment__c> ([select id,Branch__c,Date__c,StartTime__c,EndTime__c,StartDateTime__c,EndDateTime__c,XCS_Desk__c,Type__c from XCS_Appointment__c]);      
            List<Event> lstEvent=[select Appuntamento__c,type,whatId, StartDateTime, EndDateTime, ActivityDateTime,Desk__c from Event];
           
            //100 eventi per 10 filiali
            System.assertEquals(lstEvent.size(),100,'Messaggio '+lstEvent.size());
            for(Event evt: lstEvent){
                Id appId=evt.Appuntamento__c;
                XCS_Appointment__c app =mapAppointment.get(appId);
                //campi ora
                System.assertEquals(app.StartTime__c ,Time.newInstance(9,0,0,0),'TIME1');
                System.assertEquals(app.EndTime__c ,Time.newInstance(18,0,0,0),'TIME2'); 
                //campi datetime
                System.assertEquals(evt.StartDateTime.time() ,Time.newInstance(9,0,0,0),'TIMECHECKEVT');
                //System.assertEquals(app.StartDateTime__c.time() ,evt.StartDateTime.time(),'TIMECHECKEVENT'); 
                System.assertEquals(app.StartDateTime__c.time() ,Time.newInstance(9,0,0,0),'TIMECHECKAPPT');
                System.assertEquals(evt.type,'Festività');
                System.assertEquals(app.Branch__c,evt.WhatId);
                System.assertEquals(app.XCS_Desk__c,evt.Desk__c);
                System.assertEquals(app.id,evt.Appuntamento__c);
                System.assertEquals(app.Date__c , Date.parse(evt.StartDateTime.date().format()));
                
                System.assertEquals(app.StartDateTime__c, evt.StartDateTime, 'StartDateTime');
                System.assertEquals(app.StartDateTime__c, evt.StartDateTime, 'EndDateTime');
            }
        }

        /***
        FObject objEvent = new FObject('Event', 100);
        objEvent.setDefinition('type', 'static value(Festività)');
        objEvent.setDefinition('whatid','random lookup(Account) source(salesforce)');
        objEvent.setDefinition('StartDateTime','random type(datetime) from(2019-9-1) to(2022-12-31)');
        objEvent.setDefinition('DurationInMinutes', 'random type(number) from(1) to(1440) scale(30)');
        objEvent.insertRecords(true);
        ***/

    }

    @isTest
    public static void insertFestivitaAllBranch(){
        FObject.setGlobalVerbose('none');       
        Test.startTest();
        //List<Account> lstFiliali=(List<Account>)objAccount.getInsertedGroupRecords('Account','Filiali') ;
        FObject objAppointment = new FObject('XCS_Appointment__c', 100);
        //RecordTypeId Filiale
        Id recordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Branch').getRecordTypeId();
        //Date__c data appuntamento
        objAppointment.setDefinition('Date__c','random type(date)  from(2019-9-1) to(2022-12-31)');
        //objAppointment.setDefinition('XCS_Desk__c','random lookup(XCS_Desk__c)  source(salesforce)');
        //objAppointment.setDefinition('Branch__c','copy field(XCS_Desk__c) from(XCS_Desk__c.Branch__c)');
        objAppointment.setDefinition('StartTime__c','static value(09:00:00)');
        objAppointment.setDefinition('EndTime__c','static value(18:00:00)');
        objAppointment.setDefinition('Type__c','static value(Fest)');
        objAppointment.insertRecords(true);
        Test.stopTest();
        Map<Id,XCS_Appointment__c> mapAppointment=new Map<Id,XCS_Appointment__c> ([select id,Branch__c,Date__c,StartTime__c,EndTime__c,StartDateTime__c,EndDateTime__c,XCS_Desk__c,Type__c from XCS_Appointment__c]);      
        List<Event> lstEvent=[select Appuntamento__c,type,whatId, StartDateTime, EndDateTime, ActivityDateTime,Desk__c from Event];
        
        //100 eventi x 100 desk 
        System.assertEquals(lstEvent.size(),100*100,'Messaggio '+lstEvent.size());    
        

    }

    @isTest
    public static void deleteAppointment(){       
        //crea appuntamento
        FObject objAppointment = new FObject('XCS_Appointment__c', 100);
        //RecordTypeId Filiale
        Id recordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Branch').getRecordTypeId();
        //Date__c data appuntamento
        objAppointment.setDefinition('Date__c','random type(date)  from(2019-9-1) to(2022-12-31)');
        objAppointment.setDefinition('XCS_Desk__c','random lookup(XCS_Desk__c)  source(salesforce)');
        objAppointment.setDefinition('Branch__c','copy field(XCS_Desk__c) from(XCS_Desk__c.Branch__c)');
        objAppointment.setDefinition('StartTime__c','static value(09:00:00)');
        objAppointment.setDefinition('EndTime__c','static value(18:00:00)');
        objAppointment.setDefinition('Type__c','static value(Fest)');
        objAppointment.insertRecords(true);

        List<Event> lstEvent=[select Appuntamento__c,type,whatId, StartDateTime, EndDateTime, ActivityDateTime,Desk__c from Event];
        System.assert(lstEvent.size()>0, 'EVENT NOT INSERTED'); //verifica evento inserito
        //cancellazione appuntamento
        delete objAppointment.getInsertedRecords();

        lstEvent=[select Appuntamento__c,type,whatId, StartDateTime, EndDateTime, ActivityDateTime,Desk__c from Event];
        
        System.assert(lstEvent.size()==0,'EVENT NOT DELETED'); //verifica evento cancellato        

    }      

     @isTest
    public static void normalUserUpdate(){
       User u=insertUserWithTimeZone('GMT','Branch Manager');
       //User u=insertUserWithTimeZone('GMT','System Administrator');
        //User u=insertUserWithTimeZone('GMT');
        List<AccountShare> lstAccountShare=new List<AccountShare>();
        for(Account f : [select id from account ])//where recordtype.developerName='Branch'])
            lstAccountShare.add(new AccountShare(
                AccountId=f.id,
                UserOrGroupId=u.id,
                AccountAccessLevel='Read',
                RowCause='Manual',
                CaseAccessLevel='None',
                OpportunityAccessLevel='None'
               // ContactAccessLevel='Read'
                )
            );
        insert lstAccountShare;
       
        System.runAs(u){
             Test.startTest();
             FObject objAppointment = new FObject('XCS_Appointment__c', 1);       
            //Date__c data appuntamento
            objAppointment.setDefinition('Date__c','random type(date)  from(2019-9-1) to(2022-12-31)');
            objAppointment.setDefinition('XCS_Desk__c','random lookup(XCS_Desk__c)  source(salesforce)');
            objAppointment.setDefinition('Branch__c','copy field(XCS_Desk__c) from(XCS_Desk__c.Branch__c)');
            objAppointment.setDefinition('StartTime__c','static value(09:00:00)');
            objAppointment.setDefinition('EndTime__c','static value(18:00:00)');
            objAppointment.setDefinition('Type__c','static value(Fest)');
            objAppointment.insertRecords(true);
    /**
            XCS_Appointment__c app=[select StartDateTime__c,StartTime__c from XCS_Appointment__c];
            System.assertEquals(app.StartTime__c, Time.newInstance(9, 0, 0, 0), 'TIME NOT 10');
            Event evt=[select StartDateTime,Appuntamento__r.startDateTime__c from event];
            System.assertEquals(evt.startDateTime, app.StartDateTime__c, 'CHECK1 ORA EVENTO <> ORA APP');
***/            
            /* TEST REMOVED
            List<XCS_Appointment__c> lstApp=[select StartDateTime__c,StartTime__c from XCS_Appointment__c];
            System.assertEquals(lstApp.size(), 100, 'USER NOT SEE ALL XCS_APPOINTMENT');
            List<Event> lstEvt=[select StartDateTime,Appuntamento__r.startDateTime__c from event ];
            //APP X DESK
            System.assertEquals(lstEvt.size(), 100, 'USER NOT SEE ALL EVENTS');
            **/
            XCS_Appointment__c app=[select id,StartTime__c from XCS_Appointment__c] ; //lstApp[0];
            //update TIME
            app.StartTime__c=Time.newInstance(10, 0, 0, 0);
           
            update app;
            Test.stopTest();
            System.assert(!BypassRules__c.getInstance().BypassValidationRule__c,'CUSTOM SETTING');
            app=[select StartDateTime__c,StartTime__c from XCS_Appointment__c where id=:app.id];
            System.assertEquals(app.StartTime__c, Time.newInstance(10, 0, 0, 0), 'TIME NOT 10');
            List<Event> lstEvt=[select StartDateTime,Appuntamento__r.startDateTime__c from event where Appuntamento__c=:app.id];
            for(Event evt : lstEvt)
            	System.assertEquals(evt.startDateTime, app.StartDateTime__c, 'ORA EVENTO <> ORA APP');
        }
    }  
    
   

    class customException extends Exception{ }
}