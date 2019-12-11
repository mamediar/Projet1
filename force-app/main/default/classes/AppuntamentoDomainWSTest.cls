@isTest
public class AppuntamentoDomainWSTest {

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
    
          @isTest
          static void getSlotOccupatoByDesktest(){
                  //  Datetime dt = Datetime.newInstance(2019, 08, 20, 8, 20, 30);
                  Datetime dt = getDateTime();
                  System.debug(' ####################### dt '+dt);
                  String dateAppuntamento = convertDateToString(dt.date());
                  Test.startTest();
                  AppuntamentoDomainWS.getSlotOccupatoByDesk('22', dt.date());
                  Test.stopTest();
          }

          @isTest
          static void filterOraAppuntamentotest(){
              AppuntamentoDomainWS.currentDateTime = Datetime.newInstance(2019, 09, 12, 10, 0, 0);
              Set<Time> timeSlots = new Set<Time>{
                Time.newInstance(8, 0, 0, 0),
                Time.newInstance(8, 30, 0, 0),
                Time.newInstance(9, 0, 0, 0),
                Time.newInstance(9, 30, 0, 0),
                Time.newInstance(10, 0, 0, 0),
                Time.newInstance(10, 30, 0, 0),
                Time.newInstance(11, 0, 0, 0),
                Time.newInstance(11, 30, 0, 0),
                Time.newInstance(12, 0, 0, 0),
                Time.newInstance(13, 0, 0, 0),
                Time.newInstance(13, 30, 0, 0),
                Time.newInstance(14, 0, 0, 0),
                Time.newInstance(14, 30, 0, 0),
                Time.newInstance(15, 0, 0, 0),
                Time.newInstance(15, 30, 0, 0) };
                Test.startTest();
                Datetime dt = Datetime.newInstance(2019, 09, 12, 0, 0, 0);
                AppuntamentoDomainWS.filterOraAppuntamento(timeSlots, dt.date());
                System.debug(' ############# filterOraAppuntamentotest '+timeSlots);
                System.debug(' ############# AppuntamentoError.errorMessage '+AppuntamentoError.errorMessage);
                Test.stopTest();
         }

      @isTest
      static void getCustumerByCodicetest() {
          // Set<String> fields = new Set<String>{'RZZNNN69B25F158O',''};
          Test.startTest();
          Account acc = AppuntamentoDomainWS.getCustumerByCodice('447','');
          System.assertEquals('BALDEMacky', acc.LastName, '##### pass ');

          Test.stopTest();
      }

      @isTest
      static void controllNumberOfdaysGreater15test(){
          Datetime dt = Datetime.newInstance(2019, 9, 13, 8, 20, 0);
          Test.startTest();
          Boolean b = AppuntamentoDomainWS.controllNumberOfdaysGreater15(dt.date());
          System.debug(' ###################### b '+b);
          System.assertEquals(false, b, '##### pass ####');
          Test.stopTest();
      }
    
   // @isTest
   /* public static void getSlotDesktest(){
        Map<String,List<Event>> mapDeskEvent = new Map<String,List<Event>> ();
        List<Event> listEvents = [SELECT Id, Desk__c, Desk__r.Branch__r.OCS_External_Id__c, Type, ActivityDate, StartDateTime, EndDateTime FROM Event WHERE Desk__r.Branch__r.OCS_External_Id__c ='F212'];
        System.debug(' ##################### event 1 '+listEvents[0].Desk__r.Branch__r.OCS_External_Id__c);
        System.debug(' ##################### event 2 '+listEvents[1]);
        mapDeskEvent.put('disponible',   new List<Event>{listEvents[0]} );
        mapDeskEvent.put('indisponibilita', new List<Event>{listEvents[1]});
        AppuntamentoDomainWS.appuntoDate = '20190920';
        
        Map<Id, Object> mapDeskSlot = new Map<Id, Object>();
        Test.startTest();
        System.debug(' ############### mapDeskEvent '+mapDeskEvent.keySet().size());
        System.debug('###############################');
        AppuntamentoDomainWS.getSlotDesk(mapDeskEvent, mapDeskSlot, false);
        System.assertNotEquals(0, mapDeskSlot.keySet().size(), '####### pass');
        Test.stopTest();
    } */
    
    @isTest
    static void disponibilitaAppuntamentotest(){
        Datetime dt = getDateTime();
        Account filiale = [SELECT Id, Name,FirstName,
                         RecordTypeId, getCodice_Cliente__c,
                         OCS_External_Id__c, Partita_IVA__c,
                         (SELECT Id  FROM XCS_Desk__r)
                         FROM Account where recordtype.name = 'Branch'
                         AND OCS_External_Id__c =  'F212'];
       //  Date appuntamentoDate =  CGMWSUtils_1_0.formatStringToDate('20190920');
        Test.startTest();
        Set<Time> slotList = AppuntamentoDomainWS.disponibilitaAppuntamento(filiale, dt.date());
        System.assertNotEquals(0, slotList.size(), ' ########### pass');

        Test.stopTest();
    }
    @isTest
    static void appuntamentoOccupazionniFilialetest(){
      Datetime dtIni = Datetime.newInstance(2019, 09, 20, 8,0 ,0 );
      Datetime dtEnd = Datetime.newInstance(2019, 09, 25, 8,0 ,0 );
      Account filiale = [SELECT Id, OCS_External_Id__c FROM Account WHERE RecordType.Name='Branch' AND  OCS_External_Id__c='F18'];
      Test.startTest();
       String response = AppuntamentoDomainWS.appuntamentoOccupazionniFiliale(dtIni.date(), dtEnd.date(), filiale);
      Test.stopTest();
    }
    
    @isTest
    static void getSotOccupatoForFilialetest(){
        Date d1 = Date.newInstance(2019, 09, 20);
        Date d2 = Date.newInstance(2019, 09, 21);
        List<Date> dateList = new List<Date>{d1,d2};
        //  Map<Date, Integer> maxApp = new Map<Date, Integer>();
        // List<Date> dateLis = new List<Date>(maxApp.keySet());
        // dateLis.addAll(maxApp.keySet());
        Test.startTest();
        Map<Date, Integer> mapData =  AppuntamentoDomainWS.getSotOccupatoForFiliale('F212', dateList);
        System.debug(' ################ mapData '+mapData);
        Test.stopTest();
    }
    
    @isTest
    static void gestitoAppuntamentotest(){
        Datetime dt = getDateTime();
        System.debug(' ####################### dt '+dt);
        String dateAppuntamento = convertDateToString(dt.date());
        System.debug(' ####################### dateAppuntamento '+dateAppuntamento);
      /*  String jsonRequete = '{"codFiliale":"94",\n'+
                                ' "data":"'+dateAppuntamento+'","ora":"10:00","datiAggiuntivi":{"agente":"agent"},"datiCliente":{ \n'+
                                ' "nome":"Antonio","cognome":"Rizzo","sesso":"", "localitaNascita":"","provinciaNascita":"",\n'+
                                ' "capResidenza":"54100","dataNascita":"","privacyExtcommoffer":"0","privacyInterncommoffer":"1",\n'+
                                ' "privacyOtherservice":"0","privacyProfilazione":"0","tipoOccupazione":"2;1","contactID":"",\n'+
                                ' "email":"69antoninorizzo@gmail.com","cellulare":"3315437111","codiceFiscale":"RZZNNN69B25F158O"\n'+
                                ' },"datiMediaUTM":{"mediacode":"4389","utmDate":"2019081200"	},"codProdotto":"145"} ';*/
      String jsonRequete = '{"codFiliale":"F212","data":"'+dateAppuntamento+'","datiAggiuntivi":{"agente":"","crm_i_id":null,\n'+
        ' "durata":null,"extReferrer":null,"importo":null,"prodottoOcs":"145","rata":null,"tabella":null,"taeg":null,\n'+
        '"tan":null},"datiCliente":{"capResidenza":"90011","cellulare":"3440697087","codiceFiscale":"RZZNNN69B25F158O","cognome":"Trapani",\n'+
        '"contactID":"","dataNascita":"","email":"trapanirenzo@libero.it","indirizzoResidenza":null,"localitaNascita":"","localitaResidenza":null,\n'+
        '"nome":"Vincenzo","privacyExtcommoffer":"1","privacyInterncommoffer":"1","privacyOtherservice":"0","privacyProfilazione":"0","provinciaNascita":"",\n'+
        '"sesso":"","siglaProvinciaResidenza":null,"tipoOccupazione":"4"},"datiMediaUTM":{"mediacode":"4031","mediacodeInt":"","utmCampaign":"FA",\n'+
        '"utmContent":"SEARCH","utmDate":"","utmHistory":"1,20190414,4377;2,20190410,4421;3,20190410,4478;4,20190410,4422;5,20190409,4422;6,20190408,4422;7,20190306,4031;8,20190306,4035;",\n'+
        '"utmMedium":"CPC","utmSource":"GOOGLEBRAND","utmTerm":""},"oppID":null,"ora":"16:30","prodottoLvl1":"2","prodottoLvl2":"","societa":"MONFORTE","utenteEsterno":"127.0.0.1",\n'+
        '"utenteInterno":"127.0.0.1"}';

      AppuntamentoWService.AppuntamentoWrapper appunta = (AppuntamentoWService.AppuntamentoWrapper) JSON.deserializeStrict(jsonRequete, AppuntamentoWService.AppuntamentoWrapper.class);
        Test.startTest();
         Event ev = AppuntamentoDomainWS.gestitoAppuntamento(appunta);
         System.debug('################# '+AppuntamentoError.hasError);
         System.debug('################# '+AppuntamentoError.errorMessage);
         System.debug(' ################# event '+ev);
         System.assertEquals(false, AppuntamentoError.hasError, 'pass');
         System.assertEquals(null, AppuntamentoError.errorMessage, '#### pass');
        Test.stopTest();

    }
    //createAppuntamento

    @isTest
    static void gestitoAppuntamentotestActiviDate(){
        Datetime dt = getDateTime();
        System.debug(' ####################### dt '+dt);
        String dateAppuntamento = convertDateToString(dt.date());
        System.debug(' ####################### dateAppuntamento '+dateAppuntamento);
       /* String jsonRequete = '{"codFiliale":"F212",\n'+
                                ' "data":"20190920","ora":"10:00","datiAggiuntivi":{"agente":"agent"},"datiCliente":{ \n'+
                                ' "nome":"Antonio","cognome":"Rizzo","sesso":"", "localitaNascita":"","provinciaNascita":"",\n'+
                                ' "capResidenza":"54100","dataNascita":"","privacyExtcommoffer":"0","privacyInterncommoffer":"1",\n'+
                                ' "privacyOtherservice":"0","privacyProfilazione":"0","tipoOccupazione":"2;1","contactID":"",\n'+
                                ' "email":"69antoninorizzo@gmail.com","cellulare":"3315437111","codiceFiscale":"RZZNNN69B25F158O"\n'+
                                ' },"datiMediaUTM":{"mediacode":"4389","utmDate":"2019081200"	},"codProdotto":"145"} '; */
      String jsonRequete = '{"codFiliale":"F212","data":"'+dateAppuntamento+'","datiAggiuntivi":{"agente":"","crm_i_id":null,\n'+
        ' "durata":null,"extReferrer":null,"importo":null,"prodottoOcs":"145","rata":null,"tabella":null,"taeg":null,\n'+
        '"tan":null},"datiCliente":{"capResidenza":"90011","cellulare":"3440697087","codiceFiscale":"RZZNNN69B25F158O","cognome":"Trapani",\n'+
        '"contactID":"","dataNascita":"","email":"trapanirenzo@libero.it","indirizzoResidenza":null,"localitaNascita":"","localitaResidenza":null,\n'+
        '"nome":"Vincenzo","privacyExtcommoffer":"1","privacyInterncommoffer":"1","privacyOtherservice":"0","privacyProfilazione":"0","provinciaNascita":"",\n'+
        '"sesso":"","siglaProvinciaResidenza":null,"tipoOccupazione":"4"},"datiMediaUTM":{"mediacode":"4031","mediacodeInt":"","utmCampaign":"FA",\n'+
        '"utmContent":"SEARCH","utmDate":"","utmHistory":"1,20190414,4377;2,20190410,4421;3,20190410,4478;4,20190410,4422;5,20190409,4422;6,20190408,4422;7,20190306,4031;8,20190306,4035;",\n'+
        '"utmMedium":"CPC","utmSource":"GOOGLEBRAND","utmTerm":""},"oppID":null,"ora":"16:30","prodottoLvl1":"2","prodottoLvl2":"","societa":"MONFORTE","utenteEsterno":"127.0.0.1",\n'+
        '"utenteInterno":"127.0.0.1"}';
      AppuntamentoWService.AppuntamentoWrapper appunta = (AppuntamentoWService.AppuntamentoWrapper) JSON.deserializeStrict(jsonRequete, AppuntamentoWService.AppuntamentoWrapper.class);
        Test.startTest();
         Event ev = AppuntamentoDomainWS.gestitoAppuntamento(appunta);
         System.debug('################# '+AppuntamentoError.hasError);
         System.debug('################# '+AppuntamentoError.errorMessage);
         System.debug(' ################# event '+ev);
         System.assertEquals(false, AppuntamentoError.hasError, 'pass');
        Test.stopTest();

    }

    @isTest
    static void gestitoAppuntamentotestTocreateAppuntamento(){
        Datetime dt = getDateTime();
        System.debug(' ####################### dt '+dt);
        String dateAppuntamento = convertDateToString(dt.date());
        System.debug(' ####################### dateAppuntamento '+dateAppuntamento);
       /* String jsonRequete = '{"codFiliale":"94",\n'+
                                ' "data":"'+dateAppuntamento+'","ora":"10:00","datiAggiuntivi":{"agente":"agent"},"datiCliente":{ \n'+
                                ' "nome":"Antonio","cognome":"Rizzo","sesso":"", "localitaNascita":"","provinciaNascita":"",\n'+
                                ' "capResidenza":"54100","dataNascita":"","privacyExtcommoffer":"0","privacyInterncommoffer":"1",\n'+
                                ' "privacyOtherservice":"0","privacyProfilazione":"0","tipoOccupazione":"2;1","contactID":"",\n'+
                                ' "email":"69antoninorizzo@gmail.com","cellulare":"3315437111","codiceFiscale":"RZZNNN68B25F158O"\n'+
                                ' },"datiMediaUTM":{"mediacode":"4389","utmDate":"2019081200"	},"codProdotto":"145"} '; */
       String jsonRequete = '{"codFiliale":"F212","data":"'+dateAppuntamento+'","datiAggiuntivi":{"agente":"","crm_i_id":null,\n'+
        ' "durata":null,"extReferrer":null,"importo":null,"prodottoOcs":"145","rata":null,"tabella":null,"taeg":null,\n'+
        '"tan":null},"datiCliente":{"capResidenza":"90011","cellulare":"3440697087","codiceFiscale":"RBZNNN69B25F158O","cognome":"Trapani",\n'+
        '"contactID":"","dataNascita":"","email":"trapanirenzo@libero.it","indirizzoResidenza":null,"localitaNascita":"","localitaResidenza":null,\n'+
        '"nome":"Vincenzo","privacyExtcommoffer":"1","privacyInterncommoffer":"1","privacyOtherservice":"0","privacyProfilazione":"0","provinciaNascita":"",\n'+
        '"sesso":"","siglaProvinciaResidenza":null,"tipoOccupazione":"4"},"datiMediaUTM":{"mediacode":"4031","mediacodeInt":"","utmCampaign":"FA",\n'+
        '"utmContent":"SEARCH","utmDate":"","utmHistory":"1,20190414,4377;2,20190410,4421;3,20190410,4478;4,20190410,4422;5,20190409,4422;6,20190408,4422;7,20190306,4031;8,20190306,4035;",\n'+
        '"utmMedium":"CPC","utmSource":"GOOGLEBRAND","utmTerm":""},"oppID":null,"ora":"16:30","prodottoLvl1":"2","prodottoLvl2":"","societa":"MONFORTE","utenteEsterno":"127.0.0.1",\n'+
        '"utenteInterno":"127.0.0.1"}';
      AppuntamentoWService.AppuntamentoWrapper appunta = (AppuntamentoWService.AppuntamentoWrapper) JSON.deserializeStrict(jsonRequete, AppuntamentoWService.AppuntamentoWrapper.class);
        Test.startTest();
         Event ev = AppuntamentoDomainWS.gestitoAppuntamento(appunta);
         System.debug('################# '+AppuntamentoError.hasError);
         System.debug('################# '+AppuntamentoError.errorMessage);
         System.debug(' ################# event '+ev);
         System.assertEquals(false, AppuntamentoError.hasError, 'pass');
         System.assertEquals(null, AppuntamentoError.errorMessage, '#### pass');
        Test.stopTest();

    }
    @isTest
    static void appuntamentoModificatest(){
        Datetime dt = getDateTime();
        System.debug(' ####################### dt '+dt);
        String dateAppuntamento = convertDateToString(dt.date());
        System.debug(' ####################### dateAppuntamento '+dateAppuntamento);
        List<Event> eventList = [SELECT Id FROM Event];
        String idEvent = String.valueOf(eventList[0].Id) ;
        String jsonRequest = '{"codFiliale":"F212","codiceFiscale":"447", "oppID": "'+idEvent +'","ora":"09:30","data":"'+dateAppuntamento+'"}';
        AppuntamentoWService.AppuntamentoModifica appunta = (AppuntamentoWService.AppuntamentoModifica) JSON.deserializeStrict(jsonRequest, AppuntamentoWService.AppuntamentoModifica.class);
        Map<String, Object> returnValue = AppuntamentoDomainWS.appuntamentoModifica(appunta);
        System.debug('################ returnValue '+returnValue);
        System.assertNotEquals(null, returnValue.get('event'), '******* pass');
    }
    
    @isTest
    static void getEventByCodeOcsFiscaletest(){
       Test.startTest();
       List<Event> events = AppuntamentoDomainWS.getEventByCodeOcsFiscale('447','');
       System.assertNotEquals(0, events.size(), '###### pass ###### ');
       Test.stopTest();
    }
    
    @isTest
    static void calcolaNumeroMassimotest(){
     Test.startTest();
     Datetime dt = Datetime.newInstance(2019, 9, 20, 8, 0, 0);
      Datetime dt2 = Datetime.newInstance(2019, 9, 24, 8, 0, 0);
      Datetime dt3 = Datetime.newInstance(2019, 9, 25, 8, 0, 0);
      Map<Date, Integer> mpdata = new Map<Date, Integer>();
      mpdata.put(dt.date(), 5);  mpdata.put(dt2.date(), 0);
      mpdata.put(dt3.date(), 2);

      Map<Date, Integer> mapMaxSlotOccupatoByDate = new Map<Date, Integer>();
      mapMaxSlotOccupatoByDate.put(dt.date(), 2);
      mapMaxSlotOccupatoByDate.put(dt2.date(), 0);
      mapMaxSlotOccupatoByDate.put(dt3.date(), 2);
     String ch = AppuntamentoDomainWS.CalcolaNumeroMassimo(mpdata, mapMaxSlotOccupatoByDate);
     System.debug('########### chaine '+ch);
     System.assertEquals('40|C|C', ch, '##### pass ########');

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

   @isTest
   static void removeSlotstest(){
       Map<Id, Object> mapDeskSlot = new  Map<Id, Object>();
       Map<Id, Object> slotMap = new Map<Id, Object>();
       XCS_Desk__c desk = [SELECT Id FROM XCS_Desk__c LIMIT 1];
       Set<Time> listTimeSlot = new Set<Time>{
                Time.newInstance(9, 0, 0, 0),
                Time.newInstance(9, 30, 0, 0),
                Time.newInstance(10, 0, 0, 0),
                Time.newInstance(10, 30, 0, 0),
                Time.newInstance(11, 0, 0, 0),
                Time.newInstance(11, 30, 0, 0)
       };
         Set<Time> listSlot = new Set<Time>{
                 Time.newInstance(8, 0, 0, 0),
                Time.newInstance(8, 30, 0, 0),
                Time.newInstance(9, 0, 0, 0),
                Time.newInstance(9, 30, 0, 0),
                Time.newInstance(10, 0, 0, 0),
                Time.newInstance(10, 30, 0, 0),
                Time.newInstance(11, 0, 0, 0),
                Time.newInstance(11, 30, 0, 0),
                 Time.newInstance(12, 0, 0, 0),
                Time.newInstance(12, 30, 0, 0)
       };
        List< Set<Time>> listTS = new List< Set<Time>>();
        listTS.add(listTimeSlot);
        slotMap.put(desk.Id, listTS);
         mapDeskSlot.put(desk.Id, listSlot);
       Test.startTest();
       System.debug('################# mapDeskSlot size  '+mapDeskSlot.keySet().size());
       System.debug('################# slotMap size  '+slotMap.keySet().size());
       AppuntamentoDomainWS.removeSlots(mapDeskSlot, slotMap);
       System.debug('################# testSlot '+mapDeskSlot);
       Test.stopTest();
   }
   
   @isTest
   static void removeSlotNoDisponibletest(){
     Map<Id, Object> mapDeskSlot = new  Map<Id, Object>();
       Map<Id, Object> slotMap = new Map<Id, Object>();
       XCS_Desk__c desk = [SELECT Id FROM XCS_Desk__c LIMIT 1];
       Set<Time> listTimeSlot = new Set<Time>{
                Time.newInstance(9, 0, 0, 0),
                Time.newInstance(9, 30, 0, 0),
                Time.newInstance(10, 0, 0, 0),
                Time.newInstance(10, 30, 0, 0),
                Time.newInstance(11, 0, 0, 0),
                Time.newInstance(11, 30, 0, 0)
       };
         Set<Time> listSlot = new Set<Time>{
                 Time.newInstance(8, 0, 0, 0),
                Time.newInstance(8, 30, 0, 0),
                Time.newInstance(9, 0, 0, 0),
                Time.newInstance(9, 30, 0, 0),
                Time.newInstance(10, 0, 0, 0),
                Time.newInstance(10, 30, 0, 0),
                Time.newInstance(11, 0, 0, 0),
                Time.newInstance(11, 30, 0, 0),
                 Time.newInstance(12, 0, 0, 0),
                Time.newInstance(12, 30, 0, 0)
       };
        List< Set<Time>> listTS = new List< Set<Time>>();
         List< Set<Time>> listTS2 = new List< Set<Time>>();
         listTS2.add(listSlot);
        listTS.add(listTimeSlot);
        slotMap.put(desk.Id, listTS);
         mapDeskSlot.put(desk.Id, listTS2);
     Test.startTest();
     AppuntamentoDomainWS.removeSlotNoDisponible(slotMap, mapDeskSlot );
     Test.stopTest();
   }
   @isTest
   static void getSlotIndisponibletest(){
    List<Event> events = [SELECT Id, Desk__c, StartDateTime, EndDateTime FROM Event];
     Map<Id, List<Event>> mapEventsByDesk = new   Map<Id, List<Event>>();
     for(Event ev : events){
       if(!mapEventsByDesk.containsKey(ev.Desk__c) ){
          mapEventsByDesk.put(ev.Desk__c, new List<Event>{ev});
       }
       else {
            mapEventsByDesk.get(ev.Desk__c).add(ev);
       }
     }
     Test.startTest();
      Map<Id, Object> returnValue = AppuntamentoDomainWS.getSlotIndisponible(mapEventsByDesk);

     Test.stopTest();
   }
    @isTest
   static void occupareSlottest(){
       List<Event> eventList = [SELECT Id, startDateTime,endDateTime FROM Event LIMIT 4];
       System.debug('############  eventList '+eventList);
       Test.startTest();
       Set<Time> slots = AppuntamentoDomainWS.occupareSlot(eventList);
       System.debug('################### slots '+slots);
       System.assertEquals(1, slots.size(), '###########  pass');
       Test.stopTest();

   }
   
  /* @isTest
   static void cercaDisponibilitatest(){
       List<XCS_Desk__c> desks = [Select Id,  Branch__r.OCS_External_Id__c FROM XCS_Desk__c WHERE  Branch__r.OCS_External_Id__c='94' ];
       System.debug(' ###################### desks '+desks.size());
        Datetime dt = getDateTime();
        String  dayOfWeek = 'Saturday__c';
        String query = 'SELECT Id, Desk__c, StartTime__c, EndTime__c FROM XCS_DeskItem__c WHERE '+dayOfWeek +'= true AND Desk__c IN :desks' ;
        List<XCS_DeskItem__c> items = Database.query(query);
        System.debug(' ########################## cercaDisponibilitatest test '+items);
       Test.startTest();
       Map<Id, Object> mapDeskSlot = new Map<Id, Object>();
       AppuntamentoDomainWS.cercaDisponibilita(desks, dt.date(), mapDeskSlot);
       Test.stopTest();
   } */
 /*  @isTest
   static void cercaDisponibilitaNoDeskDisponibletest(){
        List<XCS_Desk__c> desks = [Select Id FROM XCS_Desk__c WHERE  Branch__r.OCS_External_Id__c='94' ];
        List<XCS_DeskItem__c> items = [SELECT id ];
       Test.startTest();


       Test.stopTest();
   } */
   @isTest
   static void getDeskDisponibletest(){
       List<XCS_Desk__c> desks = [Select Id FROM XCS_Desk__c WHERE  Branch__r.OCS_External_Id__c='F212' ];
       List<XCS_DeskItem__c> items = [SELECT Id, Desk__c FROM  XCS_DeskItem__c WHERE Desk__c IN : desks];
       List<Event> events = [SELECT Id, Desk__c, Type FROM Event WHERE Desk__c IN :desks];
       Test.startTest();
       Map<Id,List<XCS_DeskItem__c>>  mp = AppuntamentoDomainWS.getDeskDisponible(items, events);
       Test.stopTest();
   }
   @isTest
   static void groupEventByTypetest(){
      List<Event> events = [SELECT Id, Type FROM Event];
      Map<String,List<Event>> mapRetuenValue = new  Map<String,List<Event>>();
     Test.startTest();
     AppuntamentoDomainWS.groupEventByType(events, mapRetuenValue);


     Test.stopTest();

   }
          @isTest
          static void appuntamentoDisponilitaCompletatest(){
              Datetime dt = getDateTime();
              System.debug(' ####################### dt '+dt);
              String dateAppuntamento = convertDateToString(dt.date());
              Test.startTest();
              String appuntamentoDate ='20191025';
              String codeFiliale = 'F18';
              Set<Time> times = AppuntamentoDomainWS.appuntamentoDisponilitaCompleta(codeFiliale, dateAppuntamento);


            Test.stopTest();
          }
          @isTest
          static void appuntamentoDisponilitaCompletaExceptionTest(){
              
              Datetime dt = getDateTime();
              System.debug(' ####################### dt '+dt);
              String dateAppuntamento = convertDateToString(dt.date());
              Test.startTest();
              String appuntamentoDate ='20191025';
              String codeFiliale = 'F18';
              Set<Time> times = AppuntamentoDomainWS.appuntamentoDisponilitaCompleta(codeFiliale, '20191020');

               Test.stopTest();

          }
          @isTest
          static void getSlotDeskFestivitatest(){
            List<Event> events = [SELECT Id, Type, ActivityDate, startDateTime, endDateTime FROM Event WHERE Type=:'Festività'];
            Map<String,List<Event>> mapDeskEvent = new  Map<String,List<Event>>();
            Map<Id, Object> mapDeskSlot = new Map<Id, Object> ();
            for(Event ev : events){
              if(!mapDeskEvent.containsKey('festivita')){
                  mapDeskEvent.put('festivita', new List<Event>{ev});
              }
              else {
                  mapDeskEvent.get('festivita').add(ev);
              }
            }
            Test.startTest();
            AppuntamentoDomainWS.getSlotDeskFestivita(mapDeskEvent, mapDeskSlot);
            Test.stopTest();

          }

           @isTest
          static void getSlotDeskFestivitaMapDeskSlotNotNulltest(){
              Set<Time> listSlot = new Set<Time>{
                        Time.newInstance(8, 0, 0, 0),
                        Time.newInstance(8, 30, 0, 0),
                        Time.newInstance(9, 0, 0, 0),
                        Time.newInstance(9, 30, 0, 0),
                        Time.newInstance(10, 0, 0, 0),
                        Time.newInstance(10, 30, 0, 0),
                        Time.newInstance(11, 0, 0, 0),
                        Time.newInstance(11, 30, 0, 0),
                        Time.newInstance(12, 0, 0, 0),
                        Time.newInstance(12, 30, 0, 0)
              };

            List<Event> events = [SELECT Id, Type, ActivityDate, startDateTime, endDateTime FROM Event WHERE Type=:'Festività'];
            Map<String,List<Event>> mapDeskEvent = new  Map<String,List<Event>>();
            Map<Id, Object> mapDeskSlot = new Map<Id, Object> ();
            mapDeskSlot.put(events[0].Id, listSlot);
            for(Event ev : events){
              if(!mapDeskEvent.containsKey('festivita')){
                  mapDeskEvent.put('festivita', new List<Event>{ev});
              }
              else {
                  mapDeskEvent.get('festivita').add(ev);
              }
            }
            Test.startTest();
            AppuntamentoDomainWS.getSlotDeskFestivita(mapDeskEvent, mapDeskSlot);
            Test.stopTest();

          }
           
          @isTest
          static void getSlotFilialetest(){
              Set<Time> listSlot = new Set<Time>{
                        Time.newInstance(8, 0, 0, 0),
                        Time.newInstance(8, 30, 0, 0),
                        Time.newInstance(9, 0, 0, 0),
                        Time.newInstance(9, 30, 0, 0),
                        Time.newInstance(10, 0, 0, 0),
                        Time.newInstance(10, 30, 0, 0),
                        Time.newInstance(11, 0, 0, 0),
                        Time.newInstance(11, 30, 0, 0),
                        Time.newInstance(12, 0, 0, 0),
                        Time.newInstance(12, 30, 0, 0)
              };
              XCS_Desk__c desk = [SELECT Id FROM XCS_Desk__c LIMIT 1];
              Map<Id, Object> mapSlots = new Map<Id, Object>();
              mapSlots.put(desk.Id, listSlot);
              Test.startTest();
              Set<Time> timeSlot = AppuntamentoDomainWS.getSlotFiliale(mapSlots);
              System.debug('########### timeSlot '+timeSlot);

              Test.stopTest();
            
          }
   
}