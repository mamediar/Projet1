@isTest
public  class AppuntamentoCercaWebServiceTest {
   /* @TestSetup
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

         //################################## create client : Accout with recordType Branch ##############
       List<Account> listAccountBranch = new List<Account>{
           new Account (RecordTypeId = idRecordTypeAccountBranch, Name='EMPOLI', OCS_External_Id__c='22' ),
           new Account (RecordTypeId = idRecordTypeAccountBranch, Name='Naple', OCS_External_Id__c='24')
       };
        insert  listAccountBranch;

        // #################################### Create XCS_Desk  Data ##################################
        List<XCS_Desk__c> xcsDeskList = new  List<XCS_Desk__c>{
            new XCS_Desk__c(Name ='Desk1', Branch__c=listAccountBranch[0].Id, DeskName__c='Desk1' ),
            new XCS_Desk__c(Name ='Desk2', Branch__c=listAccountBranch[1].Id, DeskName__c='Desk2' ),
            new XCS_Desk__c(Name ='Desk3', Branch__c=listAccountBranch[0].Id, DeskName__c='Desk3' )
        };
       insert xcsDeskList;
    
       // ######################################## Create XCS_DeskItem__c ############################
        Datetime dt = Datetime.newInstance(2019, 08, 20, 08, 0, 0);
        Datetime dt1 = Datetime.newInstance(2019, 08, 18, 08, 0, 0);
        Datetime dt2 = Datetime.newInstance(2019, 08, 20, 08, 0, 0);
        Datetime dtt = dt.addHours(9);
        Datetime dttE = dt1.addHours(9);
        Integer duration = 9*60;
        Integer dur = 9*60;

        Datetime dtEnd = Datetime.newInstance(2019, 08, 20, 08, 0, 0);
        Datetime dEnd = dtEnd.addHours(2);
        Integer dura = 2*60;

        List<XCS_DeskItem__c> xcsDeskListItem = new  List<XCS_DeskItem__c>{
            new XCS_DeskItem__c(Desk__c= xcsDeskList[0].Id,	StartTime__c= dt.time(),
                            EndTime__c= dt.addHours(4).time().addMinutes(30),Monday__c=false, Tuesday__c=false,Wednesday__c=false,
                            Thursday__c=false, Friday__c=true,Saturday__c=false,Sunday__c =false),

            new XCS_DeskItem__c(Desk__c= xcsDeskList[0].Id,	StartTime__c=  dt1.time(),
                            EndTime__c= dt1.addHours(4).time().addMinutes(30) , Monday__c=false, Tuesday__c=true,Wednesday__c=false,
                            Thursday__c=false, 	Friday__c=false,Saturday__c=false,Sunday__c =false ),

            new XCS_DeskItem__c(Desk__c= xcsDeskList[2].Id,	StartTime__c= dt2.time(),
                            EndTime__c=dt2.addHours(4).time().addMinutes(30), Monday__c=true, Tuesday__c= false,Wednesday__c= false,
                            Thursday__c=false, 	Friday__c=true,Saturday__c=false,Sunday__c =false )
        };
        insert xcsDeskListItem;
       
        // ################################# Create Event Data test ####################################
        List<Event> listEvent = new List<Event>{
            new Event(Desk__c=xcsDeskList[0].Id, ActivityDate=dtEnd.date() ,Type='Indisponibilità', startDateTime= dtEnd, DurationInMinutes= dura,endDateTime= dEnd, ActivityDateTime= dtEnd, Customer__c =listAccountCustomer[0].Id ),
            new Event(Desk__c=xcsDeskList[1].Id, ActivityDate=dt1.date(),Type='Appuntamento',  startDateTime= dt, DurationInMinutes= duration, endDateTime= dtt, ActivityDateTime= dt, Customer__c= listAccountCustomer[1].Id, Stato_Azione__c ='Presentato' ),
            new Event(Desk__c=xcsDeskList[0].Id, ActivityDate=dt1.date(),Type='Appuntamento',  startDateTime= dt1, DurationInMinutes= dur, endDateTime= dttE, ActivityDateTime= dt1, Customer__c= listAccountCustomer[0].Id, Stato_Azione__c ='Presentato' ),
         // new Event(Desk__c=xcsDeskList[2].Id, ActivityDate=dt2.date() , Type='Festività', DurationInMinutes= duration ,startDateTime= dt,  endDateTime= dtt, ActivityDateTime= dt, Customer__c=listAccountCustomer[1].Id, Stato_Azione__c ='Presentato' )
           new Event(Desk__c=xcsDeskList[2].Id, ActivityDate=dt2.date() , Type='Appuntamento', DurationInMinutes= duration ,startDateTime= dt,  endDateTime= dtt, ActivityDateTime= dt, Customer__c=listAccountCustomer[0].Id )
        };
        
        insert listEvent;

        // ######################## Product2 Data #######################################################
        Product2 prodotto = new Product2(Name='prodotto1',Livello__c = 2);
        insert prodotto;
    } */
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
        new Account (RecordTypeId = idRecordTypeAccount, LastName='BALDEmADICKE', Codice_Fiscale__c ='RZZNNN69B25F158O'),
        new Account (RecordTypeId = idRecordTypeAccount, LastName='BALDEMacky', Codice_Fiscale__c ='447')
        };
        insert  listAccountCustomer;

         //################################## create client : Accout with recordType Branch ##############
       List<Account> listAccountBranch = new List<Account>{
           new Account (RecordTypeId = idRecordTypeAccountBranch, Name='EMPOLI', OCS_External_Id__c='F18' ),
           new Account (RecordTypeId = idRecordTypeAccountBranch, Name='Naple', OCS_External_Id__c='F19'),
           new Account (RecordTypeId = idRecordTypeAccountBranch, Name='ROMA', OCS_External_Id__c='F212')
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
     /*   Datetime dt = Datetime.newInstance(2019, 09, 20, 08, 0, 0);
        Datetime dt1 = Datetime.newInstance(2019, 09, 18, 08, 0, 0);
        Datetime dt2 = Datetime.newInstance(2019, 09, 20, 08, 0, 0); */
        Datetime dt = getDateTime();
        Datetime dt1 = getDateTime();
        Datetime dt2 = getDateTime();
        Datetime dtEnd = getDateTime();
        Datetime dtt = dt.addHours(9);
        Datetime dttE = dt1.addHours(9);
        Integer duration = 9*60;
        Integer dur = 9*60;

       // Datetime dtEnd = Datetime.newInstance(2019, 08, 20, 08, 0, 0);
        Datetime dEnd = dtEnd.addHours(2);
        Integer dura = 2*60;

        List<XCS_DeskItem__c> xcsDeskListItem = new  List<XCS_DeskItem__c>{
            new XCS_DeskItem__c(Desk__c= xcsDeskList[0].Id,	StartTime__c= dt.time(),
                            EndTime__c= dt.addHours(4).time().addMinutes(30),Monday__c=true, Tuesday__c=true,Wednesday__c=true,
                        Thursday__c=true, Friday__c=true,Saturday__c=true,Sunday__c =false),

            new XCS_DeskItem__c(Desk__c= xcsDeskList[0].Id,	StartTime__c=  dt1.time(),
                            EndTime__c= dt1.addHours(4).time().addMinutes(30) , Monday__c=true, Tuesday__c=true,Wednesday__c=true,
                            Thursday__c=true, 	Friday__c=true,Saturday__c=true,Sunday__c =false ),

            new XCS_DeskItem__c(Desk__c= xcsDeskList[2].Id,	StartTime__c= dt2.time(),
                            EndTime__c=dt2.addHours(4).time().addMinutes(30), Monday__c=true, Tuesday__c= true,Wednesday__c= true,
                            Thursday__c=true, 	Friday__c=true,Saturday__c=true,Sunday__c =false ),

            new XCS_DeskItem__c(Desk__c= xcsDeskList[3].Id,	StartTime__c= dt2.time(),
                        EndTime__c=dt2.addHours(9).time().addMinutes(30), Monday__c=true, Tuesday__c= true,Wednesday__c= true,
                        Thursday__c=true, 	Friday__c=true,Saturday__c=true,Sunday__c =false ),

            new XCS_DeskItem__c(Desk__c= xcsDeskList[4].Id,	StartTime__c= dt2.time(),
                        EndTime__c=dt2.addHours(9).time().addMinutes(30), Monday__c=true, Tuesday__c= true,Wednesday__c= true,
                        Thursday__c=true, 	Friday__c=true,Saturday__c=true,Sunday__c =false )
        };
        insert xcsDeskListItem;
       
        // ################################# Create Event Data test ####################################
            Datetime dateAppStart = Datetime.newInstance(2019, 09, 20, 10, 0, 0);
            Datetime dateAppEnd = Datetime.newInstance(2019, 09, 20, 11, 0, 0);

        List<Event> listEvent = new List<Event>{
            new Event(Desk__c=xcsDeskList[0].Id, ActivityDate=dtEnd.date() ,Type='Indisponibilità', startDateTime= dtEnd, DurationInMinutes= dura,endDateTime= dEnd, ActivityDateTime= dtEnd, Customer__c =listAccountCustomer[0].Id ),
            new Event(Desk__c=xcsDeskList[1].Id, ActivityDate=dt1.date(),Type='Appuntamento',  startDateTime= dt, DurationInMinutes= duration, endDateTime= dtt, ActivityDateTime= dt, Customer__c= listAccountCustomer[1].Id, Stato_Azione__c ='Presentato' ),
            new Event(Desk__c=xcsDeskList[0].Id, ActivityDate=dt1.date(),Type='Appuntamento',  startDateTime= dt1, DurationInMinutes= dur, endDateTime= dttE, ActivityDateTime= dt1, Customer__c= listAccountCustomer[0].Id, Stato_Azione__c ='Presentato' ),
         // new Event(Desk__c=xcsDeskList[2].Id, ActivityDate=dt2.date() , Type='Festività', DurationInMinutes= duration ,startDateTime= dt,  endDateTime= dtt, ActivityDateTime= dt, Customer__c=listAccountCustomer[1].Id, Stato_Azione__c ='Presentato' )
           new Event(Desk__c=xcsDeskList[2].Id, ActivityDate=dt2.date() , Type='Appuntamento', DurationInMinutes= duration ,startDateTime= dt,  endDateTime= dtt, ActivityDateTime= dt, Customer__c=listAccountCustomer[0].Id ),
           
          new Event(Desk__c=xcsDeskList[3].Id, ActivityDate=dt2.date() , Type='Appuntamento', DurationInMinutes= duration ,startDateTime= dt,  endDateTime= dtt, ActivityDateTime= dt),
          new Event(Desk__c=xcsDeskList[4].Id, ActivityDate=dateAppStart.date() , Type='Indisponibilità', DurationInMinutes= 60 ,startDateTime= dateAppStart,  endDateTime= dateAppEnd, ActivityDateTime= dateAppStart )
        // new Event(Desk__c=xcsDeskList[0].Id, ActivityDate=dt2.date() , Type='Appuntamento', DurationInMinutes= 30 ,startDateTime= dateAppStart,  endDateTime= dateAppEnd, ActivityDateTime= dateAppStart, Customer__c=listAccountCustomer[1].Id, Stato_Azione__c ='Non presentato/Annullato' ),
        };
        
        insert listEvent;

        // ######################## Product2 Data #######################################################
        Product2 prodotto = new Product2(Name='prodotto1',ProductCode='145',Livello__c = 2);
        insert prodotto;
    }

  @isTest
   static void appuntamentoCercatest(){
      
       String jsonRequest = '{"codiceFiscale":"RZZNNN69B25F158O","codiceOcs":""}';
       Test.startTest();
       RestRequest req = new RestRequest();
       RestResponse response = new RestResponse();
       req.requestURI ='/services/apexrest/appuntomentoCerca';
       req.requestBody = Blob.valueOf(jsonRequest);
       RestContext.request = req;
       RestContext.response = response;
       AppuntamentoCercaWebService.appuntamentoCerca();
       System.debug('######### response ######### '+response);
       Test.stopTest();
   }
    @isTest
   static void appuntamentoCercaNoEventtest(){
      
       String jsonRequest = '{"codiceFiscale":"RZZNNN625F158O","codiceOcs":""}';
       Test.startTest();
       RestRequest req = new RestRequest();
       RestResponse response = new RestResponse();
       req.requestURI ='/services/apexrest/appuntomentoCerca';
       req.requestBody = Blob.valueOf(jsonRequest);
       RestContext.request = req;
       RestContext.response = response;
       AppuntamentoCercaWebService.appuntamentoCerca();
       System.debug('######### response ######### '+response);
       String srv = String.valueOf(response.responseBody);
        System.debug('######### srv  ######### '+srv);
       Test.stopTest();
   }

   @isTest
   static void appuntamentoCercaExceptiontest(){
      
       String jsonRequest = '{"codiceFiscale":"","codiceOcs":""}';
       Test.startTest();
       RestRequest req = new RestRequest();
       RestResponse response = new RestResponse();
       req.requestURI ='/services/apexrest/appuntomentoCerca';
       req.requestBody = Blob.valueOf(jsonRequest);
       RestContext.request = req;
       RestContext.response = response;
       AppuntamentoCercaWebService.appuntamentoCerca();
       System.debug('######### response ######### '+response);
       System.assertEquals(500, response.statusCode, '####### pass ');
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