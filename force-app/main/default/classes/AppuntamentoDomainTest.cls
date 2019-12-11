@isTest
public  class AppuntamentoDomainTest {
    @TestSetup
   static void makeData(){
       Id recordType =CGMWSUtils_1_0.getRecordTypeId('Case','CRM_RichiestaOnline');
       XCS_DeskItem__c x = new XCS_DeskItem__c();
       insert x;
          // Get recordType Client
         Id idRecordTypeAccount = CGMWSUtils_1_0.getRecordTypeId('Account', 'PersonAccount');
        // Get recordType Branch
         Id idRecordTypeAccountBranch = CGMWSUtils_1_0.getRecordTypeId('Account', 'Branch');
        // create client : Accout with recordType Customer
       List<Account> listAccountCustomer = new List<Account>{
           new Account (RecordTypeId = idRecordTypeAccount,LastName='Madicke',  Codice_Fiscale__c ='RZZNNN69B25F158O'),
           new Account (RecordTypeId = idRecordTypeAccount, LastName='Macky', Codice_Fiscale__c ='447')
       };
       insert  listAccountCustomer;

         // create client : Accout with recordType Branch
       List<Account> listAccountBranch = new List<Account>{
           new Account (RecordTypeId = idRecordTypeAccountBranch, Name='EMPOLI', OCS_External_Id__c='22' ),
           new Account (RecordTypeId = idRecordTypeAccountBranch, Name='Naple', OCS_External_Id__c='24')
       };
        insert  listAccountBranch;

        // Create XCS_Desk  Data
        List<XCS_Desk__c> xcsDeskList = new  List<XCS_Desk__c>{
            new XCS_Desk__c(Name ='Desk1', Branch__c=listAccountBranch[0].Id, DeskName__c='Desk1' ),
            new XCS_Desk__c(Name ='Desk2', Branch__c=listAccountBranch[1].Id, DeskName__c='Desk2' ),
            new XCS_Desk__c(Name ='Desk3', Branch__c=listAccountBranch[0].Id, DeskName__c='Desk3' )
        };
       insert xcsDeskList;
    
       // Create XCS_DeskItem__c
       Datetime dt = Datetime.newInstance(2019, 08, 16, 08, 0, 0);
       Datetime dt1 = Datetime.newInstance(2019, 08, 17, 09, 30, 20);
       Datetime dt2 = Datetime.newInstance(2019, 08, 13, 10, 10, 30);

        List<XCS_DeskItem__c> xcsDeskListItem = new  List<XCS_DeskItem__c>{
            new XCS_DeskItem__c(Desk__c= xcsDeskList[0].Id,	StartTime__c= dt.time(),
                            EndTime__c= dt.addHours(4).time().addMinutes(30),Monday__c=false, Tuesday__c=false,Wednesday__c=false,
                            Thursday__c=false, Friday__c=true,Saturday__c=false,Sunday__c =false),

            new XCS_DeskItem__c(Desk__c= xcsDeskList[0].Id,	StartTime__c=  dt1.time(),
                            EndTime__c= dt1.addHours(4).time().addMinutes(30) , Monday__c=false, Tuesday__c=true,Wednesday__c=false,
                            Thursday__c=false, 	Friday__c=false,Saturday__c=false,Sunday__c =false ),

            new XCS_DeskItem__c(Desk__c= xcsDeskList[2].Id,	StartTime__c= dt2.time(),
                            EndTime__c=dt2.addHours(4).time().addMinutes(30), Monday__c=false, Tuesday__c= false,Wednesday__c= false,
                            Thursday__c=false, 	Friday__c=false,Saturday__c=true,Sunday__c =false )
        };
        insert xcsDeskListItem;
       
        // Create Event Data test
        // startDate 2019-08-16 06:30:00
        Datetime startd = Datetime.newInstance(2019, 08, 16, 08, 30, 0);
        System.debug('*******************  datetime makedata '+startd);
        List<Event> listEvent = new List<Event>{
            new Event(Desk__c=xcsDeskList[0].Id, ActivityDate =startd.date() , StartDateTime = startd,  DurationInMinutes=4,  ActivityDateTime= startd,  Customer__c =listAccountCustomer[0].Id ),
            new Event(Desk__c=xcsDeskList[1].Id, ActivityDate=startd.date(),   StartDateTime = startd, DurationInMinutes=4, ActivityDateTime= startd, Customer__c= listAccountCustomer[1].Id ),
            new Event(Desk__c=xcsDeskList[2].Id, ActivityDate=startd.date() ,  StartDateTime = startd, DurationInMinutes=4, ActivityDateTime= startd, Customer__c=listAccountCustomer[1].Id )
        };
        insert listEvent;
   }
   
   @isTest
   static void updateAppuntamentotest(){
        Datetime startd = Datetime.newInstance(2019, 08, 16, 06, 30, 0);
       List<Event> listevent = [SELECT Id, Desk__c, ActivityDate, StartDateTime, EndDateTime  FROM Event ] ;
     //  Event ev = [SELECT Id FROM Event WHERE ActivityDate =: startd.date() AND StartDateTime= :startd AND Desk__c ='a1Z0Q000000hjN9UAI'];
     //  System.debug('*********  event found '+ev);    
       for(Event e : listevent){
            System.debug('*******  activityDate '+e.ActivityDate);
            System.debug('*******  StartDateTime '+e.StartDateTime);
            System.debug('*******  IdDesk '+e.Desk__c);
       }            
       Test.startTest();
       //Map<String, Object> returnValue = AppuntamentoDomain.updateAppuntamento(listevent[0],'20190816', '08:30','22' );
       //System.debug('***************  returnVlue '+returnValue);

       Test.stopTest();
   }

   @isTest
   static void createAppuntamentotest(){
       Test.startTest();
        AppuntamentoDomain.createAppuntamento('20190816', '08:30', '22');
       Test.stopTest();
   }
   @isTest
   static void checkDisponibilitatest(){
       Test.startTest();
       Map<String, Object> returnValue = new Map<String, Object>();
       AppuntamentoDomain.checkDisponibilita('20190816', '22','09:22', returnValue);
       System.assertEquals(true, returnValue.get('isAvalable'), 'pass');
       Test.stopTest();
   }
}