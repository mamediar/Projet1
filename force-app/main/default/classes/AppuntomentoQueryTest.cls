@isTest
public  class AppuntomentoQueryTest {
      @TestSetup
    static void makeData(){

         // ############################## Get recordType Client ###########################################
         Id idRecordTypeAccount = CGMWSUtils_1_0.getRecordTypeId('Account', 'PersonAccount');
        // Get recordType Branch
         Id idRecordTypeAccountBranch = CGMWSUtils_1_0.getRecordTypeId('Account', 'Branch');
        //################################ create client : Accout with recordType Customer #################
       List<Account> listAccountCustomer = new List<Account>{
           new Account (RecordTypeId = idRecordTypeAccount, LastName='BALDEmADICKE', Codice_Fiscale__c ='RZZNNN69B25F158O'),
           new Account (RecordTypeId = idRecordTypeAccount, LastName='BALDEMacky', Codice_Fiscale__c ='447')
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
            new XCS_Desk__c(Name ='Desk1', isActive__c=true, Branch__c=listAccountBranch[0].Id, DeskName__c='Desk1' ),
            new XCS_Desk__c(Name ='Desk2', isActive__c=true, Branch__c=listAccountBranch[1].Id, DeskName__c='Desk2' ),
            new XCS_Desk__c(Name ='Desk3', isActive__c=true, Branch__c=listAccountBranch[0].Id, DeskName__c='Desk3' ),
            new XCS_Desk__c(Name ='Desk4', isActive__c=false, Branch__c=listAccountBranch[0].Id, DeskName__c='Desk3' )
        };
       insert xcsDeskList;
    
       // Create XCS_DeskItem__c
       Datetime dt = Datetime.newInstance(2019, 08, 13, 08, 0, 0);
       Datetime dt1 = Datetime.newInstance(2019, 08, 13, 09, 30, 20);
       Datetime dt2 = Datetime.newInstance(2019, 08, 13, 10, 10, 30);
      Datetime dtt = dt.addHours(2);

      Datetime idDT = Datetime.newInstance(2019, 08, 13, 14, 0, 0);
      Datetime ind = idDT.addHours(2);

        List<XCS_DeskItem__c> xcsDeskListItem = new  List<XCS_DeskItem__c>{
            new XCS_DeskItem__c(Desk__c= xcsDeskList[0].Id,	StartTime__c= dt.time(),
                            EndTime__c= dt.addHours(4).time().addMinutes(30),Monday__c=true, Tuesday__c=true,Wednesday__c=true,
                            Thursday__c=true, Friday__c=true,Saturday__c=true,Sunday__c =true),

            new XCS_DeskItem__c(Desk__c= xcsDeskList[0].Id,	StartTime__c=  dt1.time(),
                            EndTime__c= dt1.addHours(4).time().addMinutes(30) , Monday__c=true, Tuesday__c=true,Wednesday__c=true,
                            Thursday__c=true, 	Friday__c=true,Saturday__c=true,Sunday__c =true ),

            new XCS_DeskItem__c(Desk__c= xcsDeskList[0].Id,	StartTime__c= dt2.time(),
                            EndTime__c=dt2.addHours(4).time().addMinutes(30), Monday__c=true, Tuesday__c= false,Wednesday__c= false,
                            Thursday__c=false, 	Friday__c=false,Saturday__c=true,Sunday__c =false )
        };
        insert xcsDeskListItem;
       
        // Create Event Data test
        List<Event> listEvent = new List<Event>{
            new Event(Desk__c=xcsDeskList[0].Id, ActivityDate=dt.date() , DurationInMinutes=4, Type='Appuntamento',  ActivityDateTime= dt.addMinutes(4), Customer__c =listAccountCustomer[0].Id ),
            new Event(Desk__c=xcsDeskList[1].Id, ActivityDate=dt1.date(), DurationInMinutes=4, Type='Appuntamento', ActivityDateTime= dt1.addMinutes(3)),
            new Event(Desk__c=xcsDeskList[2].Id, ActivityDate=dt2.date(), Type='Appuntamento' ,DurationInMinutes=4, ActivityDateTime= dt2.addMinutes(2), Customer__c=listAccountCustomer[1].Id ),
            new Event(Desk__c=xcsDeskList[2].Id, ActivityDate=dt.date() , Type='Indisponibilità', DurationInMinutes= 120 ,startDateTime= dt,  endDateTime= dtt, ActivityDateTime= dt ),
            new Event(Desk__c=xcsDeskList[2].Id, ActivityDate=idDT.date(), Type='Indisponibilità' ,DurationInMinutes=120, startDateTime= idDT,  endDateTime= ind, ActivityDateTime= idDT)
        };
        insert listEvent;
      /*  Calendar calendar = new Calendar(Name='18');
        insert calendar; */
      /*  Datetime idDT = Datetime.newInstance(2019, 08, 13, 14, 0, 0);
      Datetime ind = idDT.addHours(2); */
    }

    @isTest
    static void getDeskItemByIdDesk(){
      //  XCS_Desk__c xcs = [SELECT Id FROM XCS_Desk__c LIMIT 1];
        Test.startTest();
        List<String> fields = new List<String>();
          List<String> fieldss = new List<String>();
        fields.add('Friday__c');
        fieldss.add('Monday__c');
      
        List<XCS_DeskItem__c> itemss = AppuntomentoQuery.getDeskItemByIdDesk('22',fieldss);
        List<XCS_DeskItem__c> items = AppuntomentoQuery.getDeskItemByIdDesk('22',fieldss);
        Test.stopTest();
    }

   /* @isTest
    static void checkDisponibilitaFilialetest(){

        Test.startTest();
         Datetime dt = Datetime.newInstance(2019, 08, 13, 08, 0, 0);
          Event ev = AppuntomentoQuery.checkDisponibilitaFiliale('22', dt.date());
          System.debug(' ############### ev '+ev);
        Test.stopTest();

    } */
    
    @isTest
    static void appuntomentoCercatest(){
        Test.startTest();
          List<Event> events = AppuntomentoQuery.appuntomentoCerca('RZZNNN69B25F158O');
          System.debug( ' ########### events'+events);
          System.assertEquals(1, events.size(), '#### pass');
        Test.stopTest();
    }
    
    @isTest
    static void getFilialeInfornationByCodeFilialetest(){
        Test.startTest();
         List<XCS_DeskItem__c> items = AppuntomentoQuery.getFilialeInfornationByCodeFiliale('22');
         System.debug(' ######### items '+items);
         System.assertNotEquals(0, items.size(), '######## pass ');
        Test.stopTest();
    }
    @isTest
    static void getFilialeByCodeFilialetest(){
        Test.startTest();
          Account acc = AppuntomentoQuery.getFilialeByCodeFiliale('22');
          System.debug(' ############### Account size  '+acc.XCS_Desk__r.size());
        System.assertEquals('EMPOLI', acc.Name, '####### pass');
        Test.stopTest();
    }
    @isTest
    static void getFilialeByCodeFilialetestException(){
        Test.startTest();
          Account acc = AppuntomentoQuery.getFilialeByCodeFiliale('2452');
        System.assertEquals(null, acc.Id, '####### pass');
        Test.stopTest();
    }
    @isTest
    static void getDeskItemByIdDesktest(){
        List<String> fields = new List<String>{'Friday__c'};
        Test.startTest();
        List<XCS_DeskItem__c> items = AppuntomentoQuery.getDeskItemByIdDesk('22', fields);
        System.debug(' ######### items '+items);
        System.assertEquals(1, items.size(), ' ##### pass');
        Test.stopTest();
    }
     @isTest
    static void getDeskItemByIdDesktestException(){
        List<String> fields = new List<String>{'Friday__c'};
        Test.startTest();
        List<XCS_DeskItem__c> items = AppuntomentoQuery.getDeskItemByIdDesk('222', fields);
        System.debug(' ######### items '+items);
        System.assertEquals(0, items.size(), ' ##### pass');
        Test.stopTest();
    }
    @isTest
    static void getClientByCodeFiscaletest(){
        Test.startTest();
        Account acc = AppuntomentoQuery.getClientByCodeFiscale('RZZNNN69B25F158O');
        System.assertEquals('BALDEmADICKE', acc.LastName, '######## pass');
        Test.stopTest();

    }
   // @isTest
    static void getClientByCodeFiscaletestException(){
        Test.startTest();
        Account acc = AppuntomentoQuery.getClientByCodeFiscale('RZZNNN69B2F158O');
        System.assertEquals(null, acc.LastName, '######## pass');
        Test.stopTest();

    }
    @isTest
    static void  getEventByDatetest(){
        Datetime dt = Datetime.newInstance(2019, 08, 13, 08, 0, 0);
        Test.startTest();
         List<Event>  events = AppuntomentoQuery.getEventByDate(new List<Date>{dt.date()});
         System.debug(' ############ events  '+events);
         Test.stopTest();
    }
     @isTest
    static void  getEventByDateExceptiontest(){
        Datetime dt = Datetime.newInstance(2019, 08, 20, 08, 0, 0);
        Test.startTest();
         List<Event>  events = AppuntomentoQuery.getEventByDate(new List<Date>{dt.date()});
         System.debug(' ############ events  '+events);
         System.assertEquals(0, events.size(), ' ######## pass');
         Test.stopTest();
    }
    
    @isTest
    static void getEventByDatetestDeskException(){
        XCS_Desk__c desk = [SELECT Id FROM XCS_Desk__c LIMIT 1];
         Datetime dt = Datetime.newInstance(2019, 08, 13, 08, 0, 0);
        Test.startTest();
         Event ev = AppuntomentoQuery.getEventByDate(dt.date(), dt, desk.Id );
         System.debug('########### ev '+ev);
         System.assertEquals(null, ev.Id, '####### pass');
        Test.stopTest();
    }
    
    @isTest
    static void appuntamentoCercaByOcsFiscaletest(){
        Set<String> fields = new Set<String>{'RZZNNN69B25F158O',''};
        Test.startTest();
        List<Event> events = AppuntomentoQuery.appuntamentoCercaByOcsFiscale(fields);
        System.assertEquals(4, events[0].DurationInMinutes, ' ######### pass ');
        Test.stopTest();
    }
    @isTest
    static void appuntamentoCercaByOcsFiscaleExceptest(){
        Set<String> fields = new Set<String>{'xcxcsf','shshhs'};
        Test.startTest();
        List<Event> events = AppuntomentoQuery.appuntamentoCercaByOcsFiscale(fields);
        System.assertEquals(0, events.size(), ' ######## pass ');
        Test.stopTest();
    }
    @isTest
    static void appuntomentoCercaActivetest(){ 
        Test.startTest();
        Event event = AppuntomentoQuery.appuntomentoCercaActive('RZZNNN69B25F158O');
        System.debug(' ############# event '+event);
        System.assertNotEquals(null, event.Id, ' ####### pass ');
        Test.stopTest();

    }
     @isTest
    static void appuntomentoCercaActiveExceptiontest(){ 
        Test.startTest();
        Event event = AppuntomentoQuery.appuntomentoCercaActive('RZZNNN69B25F15');
        System.debug(' ############# event '+event);
        System.assertEquals(null, event.Id, ' ####### pass ');
        Test.stopTest();
    }
    @isTest
    static void getEventCodeFilialeDatetest(){
       Datetime dt = Datetime.newInstance(2019, 08, 13, 08, 0, 0);
       Datetime dt1 = Datetime.newInstance(2019, 08, 13, 09, 30, 20);
        List<Date> dates = new List<Date>{dt.date(), dt1.date()};
        Test.startTest();
        List<Event>  events = AppuntomentoQuery.getEventCodeFilialeDate('24', dates);
        System.debug(' ########## events'+ events);
        System.assertNotEquals(0, events.size(), ' ########## pass ');
        Test.stopTest();
    }

     @isTest
    static void getEventCodeFilialeDateExceptiontest(){
       Datetime dt = Datetime.newInstance(2019, 08, 13, 08, 0, 0);
       Datetime dt1 = Datetime.newInstance(2019, 08, 13, 09, 30, 20);
        List<Date> dates = new List<Date>{dt.date(), dt1.date()};
        Test.startTest();
        List<Event>  events = AppuntomentoQuery.getEventCodeFilialeDate('25', dates);
        System.debug(' ########## events'+ events);
        System.assertEquals(0, events.size(), ' ########## pass ');
        Test.stopTest();

    }
    @isTest
    static void getXCSDeskItemByIdDesktest(){
        Test.startTest();
        List<XCS_Desk__c> desks = [SELECT id FROM XCS_Desk__c]; 
        List<XCS_DeskItem__c> items = AppuntomentoQuery.getXCSDeskItemByIdDesk(desks);
        System.debug(' ########## items '+items);
        System.assertNotEquals(0, items.size(), ' ####### pass ');
        Test.stopTest();
    }
    @isTest
    static void getXCSDeskItemByIdDeskExceptiontest(){
        XCS_Desk__c desk = new XCS_Desk__c();
        insert desk;
        Test.startTest();
        List<XCS_Desk__c> desks = new List<XCS_Desk__c>{desk}; 
        List<XCS_DeskItem__c> items = AppuntomentoQuery.getXCSDeskItemByIdDesk(desks);
        System.debug(' ########## items '+items);
        System.assertEquals(0, items.size(), ' ####### pass ');
        Test.stopTest();
    }
    
    @isTest
    public static void getEventByIdtest(){
        Event event = [SELECT Id FROM Event Limit 1];
       Test.startTest();
        Event  ev = AppuntomentoQuery.getEventById(event.Id);
        System.assertEquals('Appuntamento', ev.Type, ' ######### message ');
       Test.stopTest();
    }
     @isTest
     public static void getEventByIdExceptiontest(){
      //  Event ev = [SELECT Id FROM Event];
       Test.startTest();
        Event  ev = AppuntomentoQuery.getEventById('a0w5E000003RekCQAS');
        System.assertEquals(null, ev.Id, ' ######### message ');
       Test.stopTest();
    }
    
    @isTest
    public static void getEventByDeskDatetest(){
        List<XCS_Desk__c> desks = [SELECT id FROM XCS_Desk__c]; 
        Datetime dt = Datetime.newInstance(2019, 08, 13, 08, 0, 0);
        Test.startTest();
        List<Event> events = AppuntomentoQuery.getEventByDeskDate(desks, dt.date());
        System.assertNotEquals(0, events.size(), ' ###### pass ');
        Test.stopTest();
    }
    @isTest
    public static void getDeskByIdstest(){
        List<XCS_Desk__c> desks = [SELECT id FROM XCS_Desk__c]; 
        Datetime dt = Datetime.newInstance(2019, 8, 13, 08, 0, 0);
        Set<Id> idSets = new Set<Id>();
        idSets.add(desks[0].Id);  idSets.add(desks[1].Id); 
        Test.startTest();
        List<Event> events = AppuntomentoQuery.getDeskByIds(idSets, dt.date());
        System.assertNotEquals(0, events.size(), ' ###### pass ');
        Test.stopTest();
    }
    @isTest
    public static void getDeskByIdsExceptiontest(){
        List<XCS_Desk__c> desks = [SELECT id FROM XCS_Desk__c]; 
        Datetime dt = Datetime.newInstance(2019, 10, 14, 08, 0, 0);
        Set<Id> idSets = new Set<Id>();
        idSets.add(desks[0].Id);  idSets.add(desks[1].Id);
        Test.startTest();
        List<Event> events = AppuntomentoQuery.getDeskByIds(idSets, dt.date());
        System.assertEquals(0, events.size(), ' ###### pass ');
        Test.stopTest();
    }
    
    @isTest
    static void getSlotOccupatoQuerytest(){
        Datetime dt = Datetime.newInstance(2019, 8, 13, 08, 0, 0);
        Test.startTest();
        List<Event> events = AppuntomentoQuery.getSlotOccupatoQuery('22',dt.date());
        System.assertNotEquals(0, events.size(), ' ####### pass ');
        Test.stopTest();
    }
     @isTest
    static void getSlotOccupatoQueryExceptiontest(){
        Datetime dt = Datetime.newInstance(2019, 10, 14, 08, 0, 0);
        Test.startTest();
        List<Event> events = AppuntomentoQuery.getSlotOccupatoQuery('224',dt.date());
        System.assertEquals(0, events.size(), ' ####### pass ');
        Test.stopTest();
    }
    
    @isTest
    static void getCustomertest(){
        Set<String> fields = new Set<String>();
        fields.add('RZZNNN69B25F158O');
        Test.startTest();
        Account acc = AppuntomentoQuery.getCustomer(fields);
        // System.debug(' ################## ')
        System.assertEquals('BALDEmADICKE', acc.LastName, '###### pass ');
        Test.stopTest();
    }

      @isTest
    static void getCustomerExceptiontest(){
        Set<String> fields = new Set<String>();
        fields.add('RZZNNN69B25F1');
        Test.startTest();
        Account acc = AppuntomentoQuery.getCustomer(fields);
        // System.debug(' ################## ')
        System.assertEquals(null , acc.Id, '###### pass ');
        Test.stopTest();
    }
    @isTest
    static void getCalendartest(){
        Test.startTest();
         Calendar  calendar = AppuntomentoQuery.getCalendar('18');
         System.assertNotEquals(null, calendar.Id, ' ###### pass ');
        Test.stopTest();
    }

     @isTest
    static void getCalendartestException(){
        Test.startTest();
         Calendar  calendar = AppuntomentoQuery.getCalendar('188');
         System.assertEquals(null, calendar.Id, ' ###### pass ');
        Test.stopTest();
    }
    
    @isTest
    static void getDeskByDatestest(){
        List<XCS_Desk__c> desks = [SELECT Id FROM  XCS_Desk__c];
        System.debug('################### desks '+desks);
      /*  Set<Id> setId = new Set<Id>();
        for(XCS_Desk__c desk : desks){
            setId.add(desk.Id);
        } */
        List<String> datest = new  List<String>{'Monday__c','Friday__c','Saturday__c'}; 
        Test.startTest();
         List<XCS_DeskItem__c> xdesk =  AppuntomentoQuery.getDeskByDates(desks, datest);
         System.debug('############# xdesk  '+xdesk);
         System.assertNotEquals(0, xdesk.size(),'########## pass ########## ');
        Test.stopTest();
    }
    
    @isTest
    static void getDeskIndisponiblatest(){
        List<XCS_Desk__c> desks = [SELECT Id FROM XCS_Desk__c WHERE Name='Desk3'];
         Datetime dt = Datetime.newInstance(2019, 08, 13, 08, 0, 0);
        List<Date> appuntamentoDates = new List<Date>{ dt.date()};
         
        Test.startTest();
         List<Event> events =  AppuntomentoQuery.getDeskIndisponibla(desks, appuntamentoDates);
         System.debug('######################## events  '+events);
        Test.stopTest();
    }

}