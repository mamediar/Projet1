@isTest
public with sharing class CreaAppuntamentoControllerTest {
    
    @testSetup 
    static void testSetup() {
        Date myDate = Date.newInstance(1960, 2, 17);
        Account acct= new Account(FirstName='mame', LastName='kane', Sesso__pc='F', Data_Nascita__c=myDate);
        insert acct;
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get('Branch').getRecordTypeId();
        Account acct2= new Account(Name='test', RecordTypeId = recordTypeId);
        insert acct2;
        List<Product2> listproduit = new List<Product2>{
            new Product2(Name='P1', ProductCode='145', Family='PP_ONLINE_COMPASS_DS' , Livello__c = 0 ),
            new Product2(Name='P2', ProductCode='146', Family='PP_ONLINE_PARTNER_DS' , Livello__c = 0 ),
            new Product2(Name='P3', ProductCode='147', Family='PP_ONLINE_PARTNER_DS' , Livello__c = 1 )
        };
      insert listproduit;
        Product2 product1= new Product2(Name='test');
        insert product1;
        Datetime dataT =getDateTime();
        XCS_Desk__c desk = new XCS_Desk__c(Name ='Desk1',isActive__c=true, Branch__c=acct2.Id, DeskName__c='Desk1' );
        insert desk;
        XCS_DeskItem__c deskItem = new XCS_DeskItem__c(Desk__c= desk.Id,	StartTime__c= dataT.time(),
                            EndTime__c= dataT.addHours(4).time().addMinutes(30),Monday__c=true, Tuesday__c=true,Wednesday__c=true,
                            Thursday__c=true, Friday__c=true,Saturday__c=false,Sunday__c =false);
        insert deskItem;
        String inpputString='2019-10-15T11:30:00.000Z';
        DateTime resultDateTime = DateTime.ValueofGmt(inpputString.replace('T', ' ')); 
        XCS_Town__c town = new XCS_Town__c(Provincia_Desc__c='dakar',Catastale__c='A003',Comune__c='dakar plateau');
        Event event= new Event(Telefono_Cellulare__c='0238323',Product__c=product1.Id,
                               Tipo_Occupazione__c='Autonomo',DurationInMinutes=30,Type='Appuntamento',
                              ActivityDateTime=resultDateTime,ActivityDate=resultDateTime.date());
        insert event;
        
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
           new Account (RecordTypeId = idRecordTypeAccountBranch, Name='EMPOLI', OCS_External_Id__c='22' ),
           new Account (RecordTypeId = idRecordTypeAccountBranch, Name='Naple', OCS_External_Id__c='24'),
           new Account (RecordTypeId = idRecordTypeAccountBranch, Name='ROMA', OCS_External_Id__c='94')
       };
        insert  listAccountBranch;

        // #################################### Create XCS_Desk  Data ##################################
        List<XCS_Desk__c> xcsDeskList = new  List<XCS_Desk__c>{
            new XCS_Desk__c(Name ='Desk1',isActive__c=true, Branch__c=listAccountBranch[0].Id, DeskName__c='Desk1' ),
            new XCS_Desk__c(Name ='Desk2', isActive__c=true,Branch__c=listAccountBranch[1].Id, DeskName__c='Desk2' ),
            new XCS_Desk__c(Name ='Desk3', isActive__c=true, Branch__c=listAccountBranch[0].Id, DeskName__c='Desk3' ),
            new XCS_Desk__c(Name ='DeskR1', isActive__c=true, Branch__c=listAccountBranch[2].Id, DeskName__c='Desk4' ),
            new XCS_Desk__c(Name ='DeskR2', isActive__c=true, Branch__c=listAccountBranch[2].Id, DeskName__c='Desk5' )
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
                            EndTime__c= dt.addHours(4).time().addMinutes(30),Monday__c=false, Tuesday__c=false,Wednesday__c=false,
                            Thursday__c=false, Friday__c=true,Saturday__c=false,Sunday__c =false),

            new XCS_DeskItem__c(Desk__c= xcsDeskList[0].Id,	StartTime__c=  dt1.time(),
                            EndTime__c= dt1.addHours(4).time().addMinutes(30) , Monday__c=false, Tuesday__c=true,Wednesday__c=false,
                            Thursday__c=false, 	Friday__c=false,Saturday__c=false,Sunday__c =false ),

            new XCS_DeskItem__c(Desk__c= xcsDeskList[2].Id,	StartTime__c= dt2.time(),
                            EndTime__c=dt2.addHours(4).time().addMinutes(30), Monday__c=true, Tuesday__c= false,Wednesday__c= false,
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
         // new Event(Desk__c=xcsDeskList[2].Id, ActivityDate=dt2.date() , Type='Festività', DurationInMinutes= duration ,startDateTime= dt,  endDateTime= dtt, ActivityDateTime= dt, Customer__c=listAccountCustomer[1].Id, Stato_Azione__c ='Presentato' )
           new Event(Desk__c=xcsDeskList[2].Id, ActivityDate=dt2.date() , Type='Appuntamento', DurationInMinutes= duration ,startDateTime= dt,  endDateTime= dtt, ActivityDateTime= dt, Customer__c=listAccountCustomer[0].Id ),
           
          new Event(Desk__c=xcsDeskList[3].Id, ActivityDate=dt2.date() , Type='Appuntamento', DurationInMinutes= duration ,startDateTime= dt,  endDateTime= dtt, ActivityDateTime= dt),
           new Event(Desk__c=xcsDeskList[3].Id, ActivityDate=dt2.date() , Type='Appuntamento', DurationInMinutes= 30 ,startDateTime= dt,  endDateTime= endApp, ActivityDateTime= dt,Customer__c= listAccountCustomer[0].Id),
            new Event(Desk__c=xcsDeskList[4].Id, ActivityDate=dt2.date() , Type='Appuntamento', DurationInMinutes= 30 ,startDateTime= dt,  endDateTime= endApp, ActivityDateTime= dt,Customer__c= listAccountCustomer[1].Id),
          new Event(Desk__c=xcsDeskList[4].Id, ActivityDate=dateAppStart.date() , Type='Indisponibilità', DurationInMinutes= 60 ,startDateTime= dateAppStart,  endDateTime= dateAppEnd, ActivityDateTime= dateAppStart ),
          new Event(Desk__c=xcsDeskList[4].Id, ActivityDate=dt2.date() , Type='Indisponibilità', DurationInMinutes= 240 ,startDateTime= star,  endDateTime= en, ActivityDateTime= star)
        };
        
        //insert listEvent;

        // ######################## Product2 Data #######################################################
        Product2 prodotto = new Product2(Name='prodotto1',ProductCode='145',Livello__c = 2);
        insert prodotto;
	}
    
    @isTest
    public static void testGetAllProductInteressato(){
         Map<String ,Object>  result=CreaAppuntamentoController.getAllProductInteressato();
    }
        
    @isTest
    public static void testGetProvince(){
        Map<String ,Object> result = CreaAppuntamentoController.getProvince();
    }
    
    @isTest
    public static void testGetAllProductDettaglio(){
         Product2 product = [select Name,Livello__c from Product2 limit 1];
         Map<String ,Object>  result=CreaAppuntamentoController.getAllProductDettaglio(product.Id);
    }
    
    @isTest
    public static void testGetCommuneByProvince(){
         Map<String ,Object>  result=CreaAppuntamentoController.getCommuneByProvince('dakar plateau');
    }
    
    @isTest
    public static void testControlleDateEvent(){
        Event event= [select Id,ActivityDateTime, ActivityDate  from Event limit 1];
         Map<String ,Object>  result=CreaAppuntamentoController.controlleDateEvent(event.ActivityDate);
    }
    
    @isTest
    public static void testCreateEvent(){
        Map<Id ,Object> slotMap = new Map<Id ,Object>();
        Account account=[select Id from Account limit 1];
        String inpputString='2019-10-15T11:30:00.000Z';
        DateTime resultDateTime = DateTime.ValueofGmt(inpputString.replace('T', ' ')); 
        Event event= new Event(Telefono_Cellulare__c='0238323',Product__c='01t0Q0000022iMoQAI',
                               Tipo_Occupazione__c='Autonomo',DurationInMinutes=30,
                              ActivityDateTime=resultDateTime,ActivityDate=resultDateTime.date());
        Account act= new Account(Phone='77898934',FirstName='mame',LastName='kane');
        Account act2= new Account(Phone='77898454',FirstName='opqrs',LastName='tuvwxyz');
        Account filiale=[select Id,Name from Account where RecordType.Name='Branch' limit 1];
        Map<String ,Object> result2 =CreaAppuntamentoController.createEvent(event,act2,filiale.Name,'11:00',slotMap);
        Map<String ,Object> result =CreaAppuntamentoController.createEvent(event,act,filiale.Name,'11:00',slotMap);
        System.debug('Event '+result);
        Map<String ,Object> result3 =CreaAppuntamentoController.createEvent(event,account,filiale.Name,'11:00',slotMap);
    }
    
    @isTest
    public static void testCalcolaCodiceFiscale(){
        Account cliente=[select Id, FirstName, LastName, Sesso__pc, Data_Nascita__c
                         from Account limit 1];
        String catastale='A003';
        Map<String ,Object> result = CreaAppuntamentoController.CalcolaCodiceFiscale(cliente,catastale);
        Map<String ,Object> result2 = CreaAppuntamentoController.CalcolaCodiceFiscale(cliente,'');
        System.debug('codice '+result);
    }
    
    @isTest
    static void controleDateEventTest(){
        Test.startTest();
            Event event= [select Id,ActivityDateTime, ActivityDate  from Event limit 1];
            Map<String ,Object> result =CreaAppuntamentoController.controleDateEvent(event.ActivityDate,'');
            Map<String ,Object> result2 =CreaAppuntamentoController.controleDateEvent(event.ActivityDate,null);

        Test.stopTest();
    }
	
    @isTest
    static void controlDateNascitaClienteTest(){
        Test.startTest();
            Account account=[select Id, Data_Nascita__c from Account limit 1];
            Map<String ,Object> result =CreaAppuntamentoController.controlDateNascitaCliente(account.Data_Nascita__c);
            Map<String ,Object> result2 =CreaAppuntamentoController.controlDateNascitaCliente(null);

        Test.stopTest();
    }

    //chekDisponibleDeskByFiliale
    @isTest
    static void chekDisponibleDeskByFilialeTest(){
        Test.startTest();
        Event event= [select Id,ActivityDateTime,Customer__c ActivityDate  from Event limit 1];
        Account filiale=[select Id,Name from Account where RecordType.Name='Branch' limit 1];
        Map<String ,Object> result =CreaAppuntamentoController.chekDisponibleDeskByFiliale(filiale.Name, ''+event.Customer__c);

        Test.stopTest();
    }

    @isTest
    static void getAccountByIdClienteTest(){
        Test.startTest();
             Account account=[select Id, Data_Nascita__c from Account limit 1];
            Map<String ,Object> result =CreaAppuntamentoController.getAccountByIdCliente(account.Id);
            Map<String ,Object> result2 =CreaAppuntamentoController.getAccountByIdCliente(null);

        
        Test.stopTest();
    }

    /**
     * @Author ADIOP
     * @date  08/08/2019
     * @description 
     **/
    @isTest
    static void getFilialesTest(){
        Test.startTest();
            CreaAppuntamentoController.getFiliales('MILANO', 'Via Torino 10',  'MI','Jump Diamante');
        Test.stopTest();
    }

    /**
     * @Author ADIOP
     * @date  08/08/2019
     * @description 
     **/
    @isTest
    static void getDataLocationTest(){
        List<AppuntamentoListaFilialiResponse.FilialeOCS> filiales = new List<AppuntamentoListaFilialiResponse.FilialeOCS> ();
        AppuntamentoListaFilialiResponse.FilialeOCS filialeOCS = new AppuntamentoListaFilialiResponse.FilialeOCS();
        AppuntamentoListaFilialiResponse response = new AppuntamentoListaFilialiResponse();
        AppuntamentoListaFilialiResponse.XMLWrapper xml = new AppuntamentoListaFilialiResponse.XMLWrapper();
        AppuntamentoListaFilialiResponse.Result result = new AppuntamentoListaFilialiResponse.Result();
        AppuntamentoListaFilialiResponse.PuntoRicercatoOCS ptr= new AppuntamentoListaFilialiResponse.PuntoRicercatoOCS();
        
        ptr.addressGeoCode='test';
        ptr.coordinates='test';
        ptr.postalCodeNumber='test';
        result.puntoRicercato= ptr;
        xml.result=result;
        response.xml=xml;
        filialeOCS.id = 'dfghjklò';
        filialeOCS.idL = 'idl';
        filiales.add(filialeOCS);
        result.Filiali=filiales;
        Test.startTest();
            CreaAppuntamentoController.getDataLocation(response.xml.result);
        Test.stopTest();
    }
    //
     @isTest
    static void getFilialeByIdTest(){
        Account filiale=[select Id,Name from Account where RecordType.Name='Branch' limit 1];
        Test.startTest();
		CreaAppuntamentoController.getFilialeById(filiale.Id);
		CreaAppuntamentoController.getFilialeById(null);
        Test.stopTest();
    }

    @isTest
    static void checkOperatorTest(){
        Account filiale=[select Id,Name from Account where RecordType.Name='Branch' limit 1];
        Account client =[select Id,Name from Account limit 1];
        Test.startTest();
		CreaAppuntamentoController.checkOperator(''+client.Id);
        Test.stopTest();
    }
    
     static Datetime getDateTime(){
        Datetime dt = Datetime.now();
        dt = dt.addDays(3);
        Datetime dtnew = Datetime.newInstance(dt.year(), dt.month(), dt.day(), 8, 0, 0);
        System.debug(' ################# dtnew'+dtnew);
        return dtnew ;
    }
    
}