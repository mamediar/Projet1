@isTest
public class AppointmentTriggerHandlerTest2 {
    @TestSetup
    static void makeData(){
         FObject.setGlobalVerbose('none');
         /**
        FObject objAccount = new FObject('Account', 100);
        objAccount.setDefinition('RecordTypeId', 'static value(PersonAccount)');
        objAccount.setDefinition('LastName','random type(lastname) group(name)');
        objAccount.insertRecords(true);
        **/

        User u=insertUserWithTimeZone('GMT','Branch Manager',true);
        System.runAs(u){
        FObject objAccount = new FObject('Account', 10);
        objAccount.setDefinition('RecordTypeId', 'static value(Branch)');
        objAccount.setDefinition('Name', 'static value(Filiale)');
        objAccount.setDefinition('Name', 'serial type(number) from(1) step(1) scale(0)');
        objAccount.insertRecords(true,'Filiali');    
        List<Account> lstFiliali=(List<Account>)objAccount.getInsertedGroupRecords('Filiali') ;

        FObject objDesk = new FObject('XCS_Desk__c', 1);
        //objDesk.setDefinition('Branch__c','random lookup(Account) field(RecordTypeId) value('+lstFiliali[0].RecordTypeId+') source(salesforce)');
        objDesk.setDefinition('Branch__c','random lookup(Account) group(Filiali) source(forceea)');
        objDesk.setDefinition('isActive__c','static value(true)');
        objDesk.insertRecords(true); 
        
        //Test.startTest();

        //List<Account> lstFiliali=(List<Account>)objAccount.getInsertedGroupRecords('Account','Filiali') ;
        FObject objAppointment = new FObject('XCS_Appointment__c', 1);
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
        }
        //Test.stopTest();

        /****
        Map<Id,XCS_Appointment__c> mapAppointment=new Map<Id,XCS_Appointment__c> ([select id,Branch__c,Date__c,StartTime__c,EndTime__c,StartDateTime__c,EndDateTime__c,XCS_Desk__c,Type__c from XCS_Appointment__c]);      
        List<Event> lstEvent=[select Appuntamento__c,type,whatId, StartDateTime, EndDateTime, ActivityDateTime,Desk__c from Event];
        
        //100 eventi x 100 desk 
        System.assertEquals(lstEvent.size(),100*100,'Messaggio '+lstEvent.size());   

         */
       
    }   

    @isTest
    public static void deleteAllBranchApp(){
        List<XCS_Appointment__c> lstAppointment=[select id from XCS_Appointment__c];
        System.assertNotEquals(lstAppointment.size(),0,'NO APPOINTMENT INSERTED');
        //100 Event x 100 Desk
        System.assertEquals([select id from Event].size(),100*100,'EVENT <> APPOINTMENT');
        Test.startTest();
        //delete appointment
        delete  lstAppointment;
        Test.stopTest();
        //check event deleted
        System.assertEquals([select id from XCS_Appointment__c].size(),0,'NOT ALL APPOINTMENT DELETED');
        //check event deleted
        System.assertEquals([select id from Event].size(),0,'NOT ALL EVENT DELETED');
    }
    private static User insertUserWithTimeZone(String timezone){  
        return insertUserWithTimeZone( timezone,'System Administrator');
    
    }
    private static User insertUserWithTimeZone(String timezone,String profileName){ 
        return  insertUserWithTimeZone( timezone,profileName,false);   
    }
    private static User insertUserWithTimeZone(String timezone,String profileName, Boolean username){
        //INSERT USER with Timezone
        //
        system.debug('insertFestivita');
         FObject objUser = new FObject('User', 1);
         if(userName)
            objUser.setDefinition('username','static value(test@lynxspa.com)');
		objUser.setDefinition('ProfileId', 'static lookup(Profile) field(Name) value('+profileName+') source(salesforce)');
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
    public static void updateAllBranchApp(){
        User u=insertUserWithTimeZone('GMT');       
        System.runAs(u){
            //create 
            List<XCS_Appointment__c> lstAppointment=[select id,StartDateTime__c from XCS_Appointment__c];
            System.assertNotEquals(lstAppointment.size(),0,'NO APPOINTMENT INSERTED');
            for(XCS_Appointment__c app: lstAppointment){
                app.startTime__c=Time.newInstance(10, 0, 0, 0);
            }
            
            //100 Event x 100 Desk
            //System.assertEquals([select id,StartDateTime,Appuntamento__r.StartDateTime__c from Event].size(),100*100,'EVENT <> APPOINTMENT');
            Test.startTest();
            //delete appointment
                update lstAppointment;
            Test.stopTest();
            //check appointment updated
            for(XCS_Appointment__c app: [select id,StartTime__c from XCS_Appointment__c])
                System.assertEquals(app.startTime__c,Time.newInstance(10, 0, 0, 0), 'APPOINTMENT STARTTIME NOT UPDATED');
            

            //check event updated            
            for(Event evt:[select id, StartDateTime,Appuntamento__r.StartDateTime__c from Event where Appuntamento__c=:lstAppointment])
                System.assertEquals(evt.StartDateTime, evt.Appuntamento__r.StartDateTime__c,'StartDateTime Not Correct');
        }
    }

     @isTest
    public static void normalUserUpdate(){
        //List<User> u=(List<User>) FObject.getInsertedRecords('User');
        User u=[select id,username from User where username='test@lynxspa.com'];
       //User u=insertUserWithTimeZone('GMT','Branch Manager');
       //User u=insertUserWithTimeZone('GMT','System Administrator');
        //User u=insertUserWithTimeZone('GMT');
        /**
        List<AccountShare> lstAccountShare=new List<AccountShare>();
        for(Account f : [select id from account ])//where recordtype.developerName='Branch'])
            lstAccountShare.add(new AccountShare(
                AccountId=f.id,
                UserOrGroupId=u.id,
                AccountAccessLevel='Edit',
                RowCause='Manual',
                CaseAccessLevel='None',
                OpportunityAccessLevel='None'
               // ContactAccessLevel='Read'
                )
            );
        insert lstAccountShare;
       **/
        System.runAs(u){
             Test.startTest();
            
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
            List<XCS_Appointment__c> lstApp=[select id,StartTime__c from XCS_Appointment__c] ; //lstApp[0];
            //update 
            for(XCS_Appointment__c app : lstApp)
                app.StartTime__c=Time.newInstance(10, 0, 0, 0);
           
            update lstApp;
            Test.stopTest();

            System.assert(!BypassRules__c.getInstance().BypassValidationRule__c,'CUSTOM SETTING');
            lstApp=[select StartDateTime__c,StartTime__c from XCS_Appointment__c];
            for(XCS_Appointment__c app: lstApp)
                System.assertEquals(app.StartTime__c, Time.newInstance(10, 0, 0, 0), 'TIME NOT 10');
            List<Event> lstEvt=[select StartDateTime,Appuntamento__r.startDateTime__c from event];
            for(Event evt : lstEvt)
            	System.assertEquals(evt.startDateTime, evt.Appuntamento__r.startDateTime__c, 'ORA EVENTO <> ORA APP');
        }
    }  

    
}