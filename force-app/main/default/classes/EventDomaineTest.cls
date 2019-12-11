@isTest
public  class EventDomaineTest {
    
   @TestSetup
    static void makeData(){
                    Datetime tempo = Datetime.newInstance(2019, 09, 10, 12, 59, 0);
                    XCS_CompassParameters__c cp = new XCS_CompassParameters__c(Name='Ora_Di_Fine', Intervallo_Di_Appuntamenti__c=tempo);
                    insert cp;
                    Datetime tempoIni = Datetime.newInstance(2019, 09, 10, 0, 0, 0);
                    XCS_CompassParameters__c cp2 = new XCS_CompassParameters__c(Name='Ora_Di_Inizio', Intervallo_Di_Appuntamenti__c=tempoIni);
                    insert cp2;

                    // ############################## Get recordType Client ###########################################
                    Id idRecordTypeAccount = CGMWSUtils_1_0.getRecordTypeId('Account', 'PersonAccount');
                    // Get recordType Branch
                    Id idRecordTypeAccountBranch = CGMWSUtils_1_0.getRecordTypeId('Account', 'Branch');
                    //################################ create client : Accout with recordType Customer #################
                    List<Account> listAccountCustomer = new List<Account>{
                    new Account (RecordTypeId = idRecordTypeAccount, LastName='BALDEmADICKE', PersonEmail='test@gmail.com', Codice_Fiscale__c ='RZZNNN69B25F158O'),
                    new Account (RecordTypeId = idRecordTypeAccount, LastName='BALDEMacky', PersonEmail='test@gmail.com', Codice_Fiscale__c ='447')
                    };
                    insert  listAccountCustomer;

                    //################################## create client : Accout with recordType Branch ##############
                    List<Account> listAccountBranch = new List<Account>{
                    new Account (RecordTypeId = idRecordTypeAccountBranch, Name='EMPOLI', OCS_External_Id__c='F18', ShippingCity='City',ShippingPostalCode='1245', ShippingStreet='zoulouka', Phone='332654123' ),
                    new Account (RecordTypeId = idRecordTypeAccountBranch, Name='Naple', OCS_External_Id__c='F19', ShippingCity='City',ShippingPostalCode='1245',Phone='332654123', ShippingStreet='zoulouka'),
                    new Account (RecordTypeId = idRecordTypeAccountBranch, Name='ROMA', OCS_External_Id__c='F212', ShippingCity='City',ShippingPostalCode='1245',Phone='332654123', ShippingStreet='zoulouka')
                    };
                    insert  listAccountBranch;

                    // #################################### Create XCS_Desk  Data ##################################
                    List<XCS_Desk__c> xcsDeskList = new  List<XCS_Desk__c>{
                    new XCS_Desk__c(Name ='Desk1', 	isActive__c=true, Branch__c=listAccountBranch[0].Id, DeskName__c='Desk1' ),
                    new XCS_Desk__c(Name ='Desk2', 	isActive__c = true, Branch__c=listAccountBranch[1].Id, DeskName__c='Desk1' ),
                    new XCS_Desk__c(Name ='Desk3',  isActive__c = true, Branch__c=listAccountBranch[0].Id, DeskName__c='Desk2' ),
                    new XCS_Desk__c(Name ='DeskR1', isActive__c = true, Branch__c=listAccountBranch[2].Id, DeskName__c='Desk1' ),
                    new XCS_Desk__c(Name ='DeskR2', isActive__c = true, Branch__c=listAccountBranch[1].Id, DeskName__c='Desk2' )
                    };
                    insert xcsDeskList;

                    // ######################################## Create XCS_DeskItem__c ############################
                    Datetime dt =getDateTime();

                    Datetime dt1 =  getDateTime();
                    Datetime dt2 = getDateTime();
                    Datetime dtt = dt.addHours(9);
                    Datetime dttE = dt1.addHours(9);
                    Integer duration = 9*60;
                    Integer dur = 9*60;
                    Datetime endApp = dt2.addMinutes(30);

                    Datetime dtEnd = Datetime.newInstance(2019, 08, 20, 08, 0, 0);
                    Datetime dEnd = dtEnd.addHours(2);
                    Integer dura = 2*60;

                    List<XCS_DeskItem__c> xcsDeskListItem = new  List<XCS_DeskItem__c>{
                    new XCS_DeskItem__c(Desk__c= xcsDeskList[0].Id,	StartTime__c= dt.time(),
                          EndTime__c= dt.addHours(4).time().addMinutes(30),Monday__c=true, Tuesday__c=true,Wednesday__c=true,
                          Thursday__c=true, Friday__c=true,Saturday__c=true,Sunday__c =true),

                    new XCS_DeskItem__c(Desk__c= xcsDeskList[0].Id,	StartTime__c=  dt1.time(),
                          EndTime__c= dt1.addHours(4).time().addMinutes(30) , Monday__c=true, Tuesday__c=true,Wednesday__c=true,
                          Thursday__c=true, 	Friday__c=true,Saturday__c=true,Sunday__c =true ),

                    new XCS_DeskItem__c(Desk__c= xcsDeskList[2].Id,	StartTime__c= dt2.time(),
                          EndTime__c=dt2.addHours(4).time().addMinutes(30), Monday__c=true, Tuesday__c= true,Wednesday__c= false,
                          Thursday__c=false, 	Friday__c=true,Saturday__c=false,Sunday__c =false ),

                    new XCS_DeskItem__c(Desk__c= xcsDeskList[3].Id,	StartTime__c= dt2.time(),
                      EndTime__c=dt2.addHours(9).time().addMinutes(30), Monday__c=true, Tuesday__c= true,Wednesday__c= true,
                      Thursday__c=true, 	Friday__c=true,Saturday__c=true,Sunday__c =true ),

                    new XCS_DeskItem__c(Desk__c= xcsDeskList[4].Id,	StartTime__c= dt2.time(),
                      EndTime__c=dt2.addHours(9).time().addMinutes(30), Monday__c=true, Tuesday__c= true,Wednesday__c= false,
                      Thursday__c=false, 	Friday__c=true,Saturday__c=true,Sunday__c =true )
                    };
                    insert xcsDeskListItem;

                    // ################################# Create Event Data test ####################################
                    Datetime dateAppStart = Datetime.newInstance(2019, 09, 20, 10, 0, 0);
                    Datetime dateAppEnd = Datetime.newInstance(2019, 09, 20, 11, 0, 0);
                    Datetime star = Datetime.newInstance(dt.year(), dt.month(), dt.day(), 8, 0, 0);
                    Datetime en = Datetime.newInstance(dt.year(), dt.month(), dt.day(), 12, 0, 0);
                    List<Event> listEvent = new List<Event>{
                    new Event(Desk__c=xcsDeskList[0].Id, ActivityDate=dtEnd.date() ,Type='Indisponibilità', startDateTime= dtEnd, DurationInMinutes= dura,endDateTime= dEnd, ActivityDateTime= dtEnd, Customer__c =listAccountCustomer[0].Id ),
                    new Event(Desk__c=xcsDeskList[1].Id, ActivityDate=dt1.date(),Type='Appuntamento',  startDateTime= dt, DurationInMinutes= duration, endDateTime= dtt, ActivityDateTime= dt, Customer__c= listAccountCustomer[1].Id, Stato_Azione__c ='Presentato' ),
                    new Event(Desk__c=xcsDeskList[0].Id, ActivityDate=dt1.date(),Type='Appuntamento',  startDateTime= dt1, DurationInMinutes= dur, endDateTime= dttE, ActivityDateTime= dt1, Customer__c= listAccountCustomer[0].Id, Stato_Azione__c ='Presentato' ),
                    new Event(Desk__c=xcsDeskList[2].Id, ActivityDate=dt2.date() , Type='Festività', DurationInMinutes= duration ,startDateTime= dt,  endDateTime= dtt, ActivityDateTime= dt, Customer__c=listAccountCustomer[1].Id, Stato_Azione__c ='Presentato' ),
                    new Event(Desk__c=xcsDeskList[2].Id, ActivityDate=dt2.date() , Type='Appuntamento', DurationInMinutes= duration ,startDateTime= dt,  endDateTime= dtt, ActivityDateTime= dt, Customer__c=listAccountCustomer[0].Id ),

                    new Event(Desk__c=xcsDeskList[3].Id, ActivityDate=dt2.date() , Type='Appuntamento', DurationInMinutes= duration ,startDateTime= dt,  endDateTime= dtt, ActivityDateTime= dt),
                    new Event(Desk__c=xcsDeskList[3].Id, ActivityDate=dt2.date() , Type='Appuntamento', DurationInMinutes= 30 ,startDateTime= dt,  endDateTime= endApp, ActivityDateTime= dt,Customer__c= listAccountCustomer[0].Id),
                    new Event(Desk__c=xcsDeskList[4].Id, ActivityDate=dt2.date() , Type='Appuntamento', DurationInMinutes= 30 ,startDateTime= dt,  endDateTime= endApp, ActivityDateTime= dt,Customer__c= listAccountCustomer[1].Id),
                    new Event(Desk__c=xcsDeskList[4].Id, ActivityDate=dateAppStart.date() , Type='Indisponibilità', DurationInMinutes= 60 ,startDateTime= dateAppStart,  endDateTime= dateAppEnd, ActivityDateTime= dateAppStart ),
                    new Event(Desk__c=xcsDeskList[4].Id, ActivityDate=dt2.date() , Type='Indisponibilità', DurationInMinutes= 240 ,startDateTime= star,  endDateTime= en, ActivityDateTime= star)
                    };

                    insert listEvent;

                    // ######################## Product2 Data #######################################################
                    Product2 prodotto = new Product2(Name='prodotto1',ProductCode='145',Livello__c = 2);
                    insert prodotto;
        }


     /*     @isTest
            static void isWorkingDaytest(){
            XCS_DeskItem__c x = [SELECT Monday__c FROM XCS_DeskItem__c];
            x.Monday__c = true;
            Test.startTest();
            Map<String,Object> returnValue = EventDomaine.isWorkingDay('Monday', '5000Q000001zWCEQA2');
            System.debug(' ************* b '+ returnValue);
            Test.stopTest();
    } */
    @isTest
    static void appuntamentoOccupazionniFilialeTest(){
        List<Event> eventList = [SELECT Id, ActivityDate FROM Event];
        System.debug('************* Event '+eventList);
        Test.startTest();
         EventDomaine.appuntamentoOccupazionniFiliale('16/08/2019', '18/08/2019', 'F18');
       // System.debug('********** nb '+nb);
        Test.stopTest();

    }
    @isTest
    static void getListDateStringtest(){
        Test.startTest();
       Map<String,Date> listData = EventDomaine.getListDateString('16/08/2019', '18/08/2019');
        System.debug('************ listDate'+ listData);
        Test.stopTest();
    }
    
    @isTest
    static void maxAppuntamentoByDeskForDaytest(){
        List<XCS_Desk__c> deskList = [SELECT Id FROM XCS_Desk__c LIMIT 2 ];
        Test.startTest();
        EventDomaine.maxAppuntamentoByDeskForDay(deskList, 'Friday__c');
        Test.stopTest();
    }
    @isTest
    static void appuntomentoDisponibilitaCompletatest(){
        Test.startTest();
        Map<String, Object> returnValue = EventDomaine.appuntomentoDisponibilitaCompleta('224','20190818');
        System.debug(returnValue);
        Test.stopTest();
    }
    
    @isTest
    static void getEventActiveByCLientIdtest(){
        Test.startTest();
         List<Event> events = EventDomaine.getEventActiveByCLientId('RZZNNN69B25F158O');
         System.debug('######## events '+events);
        Test.stopTest();

    }
    @isTest
    static void isSameFilialetest(){
        Account acc = [SELECT Id, OCS_External_Id__c FROM Account WHERE RecordType.Name='Branch' AND OCS_External_Id__c='F18'];

        Test.startTest();
             Boolean b = EventDomaine.isSameFiliale(acc.Id, 'F18');
             System.assertEquals(true, b, ' ###### pass ');
        Test.stopTest();
    }
    @isTest
    static void isSameFilialetestException(){
        //00U0Q000002JZDsUAO
        Test.startTest();
          Boolean b = EventDomaine.isSameFiliale('00U0Q000002JZDsUAO', 'F18');
          System.assertEquals(false, b, 'fail');
        Test.stopTest();
    }
    @isTest
    static void appuntomentoDisponibilitaCompletatestException(){
      Test.startTest();
      Map<String, Object> returnValue = EventDomaine.appuntomentoDisponibilitaCompleta('F18','20190820');
      System.debug(' ########### returnValue '+returnValue);
      Test.stopTest();
    }
    @isTest
    static void  maxNumberOfAppuntamentotest(){
        List<Event> events = [SELECT Id, OwnerId, Desk__r.Branch__c FROM Event];
        Map<String, Object> mapData = new Map<String, Object>();
        Test.startTest();
        System.debug(' ########### id Event '+events[0].Id);
         EventDomaine.appuntamentaCerca(events[0], 'F18',mapData);
         System.debug(mapData);
        Test.stopTest();

    }
    @isTest
    static void maxSlotByDesktest(){
        List<XCS_DeskItem__c> items = [SELECT Id, StartTime__c, EndTime__c FROM  XCS_DeskItem__c];
        Test.startTest();
        System.debug(' ############## items'+items);
        Map<Id, Integer> idMap = EventDomaine.maxSlotByDesk(new List<XCS_DeskItem__c>{items[1]});
        System.debug(' ############### idMap '+idMap);
        Test.stopTest();
    }

    @isTest
    static void getSlotDesktest(){
        List<XCS_Desk__c> desks = [SELECT id FROM XCS_Desk__c ];
        Map<Id, Object> mapDesk = new Map<Id, Object>();
        Test.startTest();
        EventDomaine.getSlotDesk(desks, mapDesk, 'Friday__c');
        System.debug('############### mapDesk '+mapDesk);
        System.assertNotEquals(0, mapDesk.keySet().size(), '#########  pass');
        Test.stopTest();
    }
    
    @isTest
    static void convertStringToDatetimetest(){
       Test.startTest();
       // 2019-08-20 06:20:00
       Datetime dt = EventDomaine.convertStringToDatetime('20190820', '08:20');
       Datetime d = Datetime.newInstance(2019, 08, 20, 06, 20, 00);
        System.debug(' ############# dt '+dt);
        System.assertEquals(d.date(), dt.date(), '######## pass');
        System.assertEquals(d.year(), dt.year(), '######## pass');
        System.assertEquals(d.month(), dt.month(), '######## pass');
        System.assertEquals(d.day(), dt.day(), '######## pass');
       Test.stopTest();
    }

    @isTest
    static void getEventGroupByDeskIdtest(){
         Datetime dt1 =  getDateTime();
        Test.startTest();
         Map<Id, List<Event>> mapData = EventDomaine.getEventGroupByDeskId(dt1.date());
         
         System.debug(' ############ mapData '+mapData);
         System.assertNotEquals(0, mapData.keySet().size(), ' ######## pass ');
        Test.stopTest();
    }
    
    @isTest
    static void convertStringToTimetest(){
        Time t = Time.newInstance(08, 20, 0,0);
        Test.startTest();
         Time testTime = EventDomaine.convertStringToTime('08:20');
         System.debug(' ######### time '+testTime);
          System.debug(' ######### time t '+t);
         System.assertEquals(t.hour(), testTime.hour(), '######## pass');
         System.assertEquals(t.minute(), testTime.minute(), '######## pass');
        Test.stopTest();
    }
    @isTest
    static void getEventByDayetest(){
       
        Test.startTest();
       //  Datetime dt = Datetime.newInstance(2019, 08, 16, 8, 0, 0);
            Datetime dt =  getDateTime();
        System.debug(' ############### dt '+dt.date());
         Map<Id, List<Event>>  mapData = EventDomaine.getEventByDaye(dt.date());
         System.debug(' ############ mapData '+mapData);
        Test.stopTest();
    }
    
    @isTest
    static void getEventByIDesktest(){
           // Datetime dt = Datetime.newInstance(2019, 08, 16, 08, 0, 0);
            Datetime dt =  getDateTime();
            List<XCS_Desk__c> desks = [SELECT Id FROM XCS_Desk__c];
            System.debug(' ##################### desks list  '+desks);
            Map<Id, XCS_Desk__c> mapName = new Map<Id, XCS_Desk__c>(desks);
            Test.startTest();
                    Map<Id,List<Event>> mapData = EventDomaine.getEventByIDesk(mapName.keySet(), dt.date());
                    System.debug(' ##################### mapData '+mapData);
                    System.debug(' ##################### mapData '+mapData.keySet().size());

            Test.stopTest();

    }
    @isTest
    static void appuntamentoByDatetest(){
        List<XCS_Desk__c> desks = [SELECT Id FROM  XCS_Desk__c];
        Map<String,Date> mapDataString = new  Map<String,Date>();
        System.debug('################### desks '+desks);
        List<String> dates = new  List<String>{'Monday__c','Friday__c','Saturday__c'}; 
        Test.startTest();
        Map<Date, Integer> returnValue = EventDomaine.appuntamentoByDate(desks, dates, mapDataString );
        System.debug('################# returnValue '+returnValue);
        Test.stopTest();
    }
    @isTest
    static void occupazionniFilialetest(){
        Account acc = [SELECT Id, (SELECT Id FROM XCS_Desk__r ) FROM Account WHERE OCS_External_Id__c='F18'];
        Test.startTest();
        String result = EventDomaine.occupazionniFiliale('16/08/2019', '18/08/2019', acc);
        System.debug('############## result ######### '+result);

        Test.stopTest();
    }

     static Datetime getDateTime(){
        Datetime dt = Datetime.now();
        dt = dt.addDays(2);
        Datetime dtnew = Datetime.newInstance(dt.year(), dt.month(), dt.day(), 8, 0, 0);
        System.debug(' ################# dtnew'+dtnew);
        return dtnew ;
    }

    static String convertDateToString(Date d){
      String year = (d.year() < 10) ?0+''+String.valueOf(d.year()):String.valueOf(d.year());
      String month = (d.month()< 10)?0+''+String.valueOf(d.month()):String.valueOf(d.month());
      String day = (d.day()< 10)?0+''+String.valueOf(d.day()):String.valueOf(d.day());
      String dayString = year+''+month+''+day;
      return dayString;
   }
}