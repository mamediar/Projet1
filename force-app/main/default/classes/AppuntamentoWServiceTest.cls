@isTest
public class AppuntamentoWServiceTest {

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
        new Account (RecordTypeId = idRecordTypeAccount,  LastName='BALDEmADICKE', Codice_Fiscale__c ='RZZNNN69B25F158O'),
        new Account (RecordTypeId = idRecordTypeAccount, LastName='BALDEMacky', Codice_Fiscale__c ='447')
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
    static void appuntamentoWSrvtest(){
         Datetime dt = getDateTime();
         String dateAppuntamento = convertDateToString(dt.date());
      /*  String jsonRequete = '{"codFiliale":"F212",\n'+
                                ' "data":"'+dateAppuntamento+'","ora":"10:00","datiAggiuntivi":{"agente":"agent"},"datiCliente":{ \n'+
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
        List<Event> eventList = [SELECT Id FROM Event WHERE Customer__r.Codice_Fiscale__c ='4477' AND Stato_Azione__c !='Non presentato/Annullato'];
        System.debug('********** Liste event '+eventList);
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response = new RestResponse();
        req.requestURI ='/services/apexrest/AppuntamentoWS';
        req.requestBody = Blob.valueOf(jsonRequete);
        RestContext.request = req;
        RestContext.response = response;
        AppuntamentoWService.appuntamentoWSrv();
        System.debug(' ************************** response '+response);
        System.assertEquals(200, response.statusCode, '#### pass ###');
        Test.stopTest();
    }
    
   @isTest
    static void appuntamentoWSNoDeskAcyive(){
        List<XCS_Desk__c> xdesks = [SELECT Id, isActive__c FROM XCS_Desk__c];
        for(XCS_Desk__c xc :xdesks){
            xc.isActive__c = false;
        }
        update xdesks;
       /*  String jsonRequete = '{"codFiliale":"F212",\n'+
                                ' "data":"20191020","ora":"10:00","datiAggiuntivi":{"agente":"agent"},"datiCliente":{ \n'+
                                ' "nome":"Antonio","cognome":"Rizzo","sesso":"", "localitaNascita":"","provinciaNascita":"",\n'+
                                ' "capResidenza":"54100","dataNascita":"","privacyExtcommoffer":"0","privacyInterncommoffer":"1",\n'+
                                ' "privacyOtherservice":"0","privacyProfilazione":"0","tipoOccupazione":"2;1","contactID":"",\n'+
                                ' "email":"69antoninorizzo@gmail.com","cellulare":"3315437111","codiceFiscale":"RZZNNN69B25F158O"\n'+
                                ' },"datiMediaUTM":{"mediacode":"4389","utmDate":"2019081200"	},"codProdotto":"145"} '; */
         String jsonRequete = '{"codFiliale":"F212","data":"20191020","datiAggiuntivi":{"agente":"","crm_i_id":null,\n'+
        ' "durata":null,"extReferrer":null,"importo":null,"prodottoOcs":null,"rata":null,"tabella":null,"taeg":null,\n'+
        '"tan":null},"datiCliente":{"capResidenza":"90011","cellulare":"3440697087","codiceFiscale":"TRPVCN67T25G273T","cognome":"Trapani",\n'+
        '"contactID":"","dataNascita":"","email":"trapanirenzo@libero.it","indirizzoResidenza":null,"localitaNascita":"","localitaResidenza":null,\n'+
        '"nome":"Vincenzo","privacyExtcommoffer":"1","privacyInterncommoffer":"1","privacyOtherservice":"0","privacyProfilazione":"0","provinciaNascita":"",\n'+
        '"sesso":"","siglaProvinciaResidenza":null,"tipoOccupazione":"4"},"datiMediaUTM":{"mediacode":"4031","mediacodeInt":"","utmCampaign":"FA",\n'+
        '"utmContent":"SEARCH","utmDate":"","utmHistory":"1,20190414,4377;2,20190410,4421;3,20190410,4478;4,20190410,4422;5,20190409,4422;6,20190408,4422;7,20190306,4031;8,20190306,4035;",\n'+
        '"utmMedium":"CPC","utmSource":"GOOGLEBRAND","utmTerm":""},"oppID":null,"ora":"16:30","prodottoLvl1":"2","prodottoLvl2":"","societa":"MONFORTE","utenteEsterno":"127.0.0.1",\n'+
        '"utenteInterno":"127.0.0.1"}';

        List<Event> eventList = [SELECT Id FROM Event WHERE Customer__r.Codice_Fiscale__c ='4477' AND Stato_Azione__c !='Non presentato/Annullato'];
        System.debug('********** Liste event '+eventList);
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response = new RestResponse();
        req.requestURI ='/services/apexrest/AppuntamentoWS';
        req.requestBody = Blob.valueOf(jsonRequete);
        RestContext.request = req;
        RestContext.response = response;
        AppuntamentoWService.appuntamentoWSrv();
        System.debug(' ************************** response '+response);
        System.assertEquals(200, response.statusCode, '#### pass ###');
        Test.stopTest();

    }
     @isTest
    static void appuntamentoWSrvUpdate(){
       /* String jsonRequete = '{"codFiliale":"F212",\n'+
                                ' "data":"20190920","ora":"10:00","datiAggiuntivi":{"agente":"agent"},"datiCliente":{ \n'+
                                ' "nome":"Antonio","cognome":"Rizzo","sesso":"", "localitaNascita":"","provinciaNascita":"",\n'+
                                ' "capResidenza":"54100","dataNascita":"","privacyExtcommoffer":"0","privacyInterncommoffer":"1",\n'+
                                ' "privacyOtherservice":"0","privacyProfilazione":"0","tipoOccupazione":"2;1","contactID":"",\n'+
                                ' "email":"69antoninorizzo@gmail.com","cellulare":"3315437111","codiceFiscale":"RZZNNN69B25F158O"\n'+
                                ' },"datiMediaUTM":{"mediacode":"4389","utmDate":"2019081200"	},"codProdotto":"145"} '; */
         String jsonRequete = '{"codFiliale":"F212","data":"20190920","datiAggiuntivi":{"agente":"","crm_i_id":null,\n'+
        ' "durata":null,"extReferrer":null,"importo":null,"prodottoOcs":null,"rata":null,"tabella":null,"taeg":null,\n'+
        '"tan":null},"datiCliente":{"capResidenza":"90011","cellulare":"3440697087","codiceFiscale":"TRPVCN67T25G273T","cognome":"Trapani",\n'+
        '"contactID":"","dataNascita":"","email":"trapanirenzo@libero.it","indirizzoResidenza":null,"localitaNascita":"","localitaResidenza":null,\n'+
        '"nome":"Vincenzo","privacyExtcommoffer":"1","privacyInterncommoffer":"1","privacyOtherservice":"0","privacyProfilazione":"0","provinciaNascita":"",\n'+
        '"sesso":"","siglaProvinciaResidenza":null,"tipoOccupazione":"4"},"datiMediaUTM":{"mediacode":"4031","mediacodeInt":"","utmCampaign":"FA",\n'+
        '"utmContent":"SEARCH","utmDate":"","utmHistory":"1,20190414,4377;2,20190410,4421;3,20190410,4478;4,20190410,4422;5,20190409,4422;6,20190408,4422;7,20190306,4031;8,20190306,4035;",\n'+
        '"utmMedium":"CPC","utmSource":"GOOGLEBRAND","utmTerm":""},"oppID":null,"ora":"16:30","prodottoLvl1":"2","prodottoLvl2":"","societa":"MONFORTE","utenteEsterno":"127.0.0.1",\n'+
        '"utenteInterno":"127.0.0.1"}';
        List<Event> eventList = [SELECT Id FROM Event WHERE Customer__r.Codice_Fiscale__c ='4477' AND Stato_Azione__c !='Non presentato/Annullato'];
        System.debug('********** Liste event '+eventList);
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response = new RestResponse();
        req.requestURI ='/services/apexrest/AppuntamentoWS';
        req.requestBody = Blob.valueOf(jsonRequete);
        RestContext.request = req;
        RestContext.response = response;
        AppuntamentoWService.appuntamentoWSrv();
        System.debug(' ************************** response '+response);
        System.assertEquals(200, response.statusCode, '#### pass ###');
        Test.stopTest();
    }


    @isTest
    static void appuntamentoWSrvFilialeNotAvailable(){
   /*  String jsonRequete = '{"codFiliale":"F18",\n'+
                                ' "data":"20190827","ora":"10:00","datiAggiuntivi":{"agente":"agent"},"datiCliente":{ \n'+
                                ' "nome":"Antonio","cognome":"Rizzo","sesso":"", "localitaNascita":"","provinciaNascita":"",\n'+
                                ' "capResidenza":"54100","dataNascita":"","privacyExtcommoffer":"0","privacyInterncommoffer":"1",\n'+
                                ' "privacyOtherservice":"0","privacyProfilazione":"0","tipoOccupazione":"2;1","contactID":"",\n'+
                                ' "email":"69antoninorizzo@gmail.com","cellulare":"3315437111","codiceFiscale":"RZZNNN69B25F158O"\n'+
                                ' },"datiMediaUTM":{"mediacode":"4389","utmDate":"2019081200"	},"prodottoLvl1":"2","prodottoLvl2":"prodottoLvl2"} '; */
         String jsonRequete = '{"codFiliale":"F212","data":"20190827","datiAggiuntivi":{"agente":"","crm_i_id":null,\n'+
        ' "durata":null,"extReferrer":null,"importo":null,"prodottoOcs":null,"rata":null,"tabella":null,"taeg":null,\n'+
        '"tan":null},"datiCliente":{"capResidenza":"90011","cellulare":"3440697087","codiceFiscale":"TRPVCN67T25G273T","cognome":"Trapani",\n'+
        '"contactID":"","dataNascita":"","email":"trapanirenzo@libero.it","indirizzoResidenza":null,"localitaNascita":"","localitaResidenza":null,\n'+
        '"nome":"Vincenzo","privacyExtcommoffer":"1","privacyInterncommoffer":"1","privacyOtherservice":"0","privacyProfilazione":"0","provinciaNascita":"",\n'+
        '"sesso":"","siglaProvinciaResidenza":null,"tipoOccupazione":"4"},"datiMediaUTM":{"mediacode":"4031","mediacodeInt":"","utmCampaign":"FA",\n'+
        '"utmContent":"SEARCH","utmDate":"","utmHistory":"1,20190414,4377;2,20190410,4421;3,20190410,4478;4,20190410,4422;5,20190409,4422;6,20190408,4422;7,20190306,4031;8,20190306,4035;",\n'+
        '"utmMedium":"CPC","utmSource":"GOOGLEBRAND","utmTerm":""},"oppID":null,"ora":"16:30","prodottoLvl1":"2","prodottoLvl2":"","societa":"MONFORTE","utenteEsterno":"127.0.0.1",\n'+
        '"utenteInterno":"127.0.0.1"}';
     
        List<Event> eventList = [SELECT Id FROM Event WHERE Customer__r.Codice_Fiscale__c ='4477' AND Stato_Azione__c !='Non presentato/Annullato'];
        System.debug('********** Liste event '+eventList);
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response = new RestResponse();
        req.requestURI ='/services/apexrest/AppuntamentoWS';
        req.requestBody = Blob.valueOf(jsonRequete);
        RestContext.request = req;
        RestContext.response = response;
        AppuntamentoWService.appuntamentoWSrv();
        System.debug(' ************************** response '+response);
     //   System.assertEquals(200, response.statusCode, '#### pass ###');
        //System.assertEquals(1, response.resultCode, '#### pass ###');
       // System.assertEquals('Filiale Has Not Available at this Date', response.errorMessage, '#### pass ###');
        Test.stopTest();
        //"errorMessage":"Filiale Has Not Available at this Date"
    }
    
    @isTest
    static void appuntamentoWSrvtestErrortest(){
         /* String jsonRequete = '{"codFiliale":"222",\n'+
                                ' "data":"20190820","ora":"10:00","datiAggiuntivi":{"agente":"agent"},"datiCliente":{ \n'+
                                ' "nome":"Antonio","cognome":"Rizzo","sesso":"", "localitaNascita":"","provinciaNascita":"",\n'+
                                ' "capResidenza":"54100","dataNascita":"","privacyExtcommoffer":"0","privacyInterncommoffer":"1",\n'+
                                ' "privacyOtherservice":"0","privacyProfilazione":"0","tipoOccupazione":"2;1","contactID":"",\n'+
                                ' "email":"69antoninorizzo@gmail.com","cellulare":"3315437111","codiceFiscale":"RZZNNN69B25F158O"\n'+
                                ' },"datiMediaUTM":{"mediacode":"4389","utmDate":"2019081200"	},"prodottoLvl1":"2","prodottoLvl2":"prodottoLvl2"} ';*/
        String jsonRequete = '{"codFiliale":"F212","data":"20190820","datiAggiuntivi":{"agente":"","crm_i_id":null,\n'+
        ' "durata":null,"extReferrer":null,"importo":null,"prodottoOcs":null,"rata":null,"tabella":null,"taeg":null,\n'+
        '"tan":null},"datiCliente":{"capResidenza":"90011","cellulare":"3440697087","codiceFiscale":"TRPVCN67T25G273T","cognome":"Trapani",\n'+
        '"contactID":"","dataNascita":"","email":"trapanirenzo@libero.it","indirizzoResidenza":null,"localitaNascita":"","localitaResidenza":null,\n'+
        '"nome":"Vincenzo","privacyExtcommoffer":"1","privacyInterncommoffer":"1","privacyOtherservice":"0","privacyProfilazione":"0","provinciaNascita":"",\n'+
        '"sesso":"","siglaProvinciaResidenza":null,"tipoOccupazione":"4"},"datiMediaUTM":{"mediacode":"4031","mediacodeInt":"","utmCampaign":"FA",\n'+
        '"utmContent":"SEARCH","utmDate":"","utmHistory":"1,20190414,4377;2,20190410,4421;3,20190410,4478;4,20190410,4422;5,20190409,4422;6,20190408,4422;7,20190306,4031;8,20190306,4035;",\n'+
        '"utmMedium":"CPC","utmSource":"GOOGLEBRAND","utmTerm":""},"oppID":null,"ora":"16:30","prodottoLvl1":"2","prodottoLvl2":"","societa":"MONFORTE","utenteEsterno":"127.0.0.1",\n'+
        '"utenteInterno":"127.0.0.1"}';
      
      
        List<Event> eventList = [SELECT Id FROM Event WHERE Customer__r.Codice_Fiscale__c ='4477' AND Stato_Azione__c !='Non presentato/Annullato'];
        System.debug('********** Liste event '+eventList);
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response = new RestResponse();
        req.requestURI ='/services/apexrest/AppuntamentoWS';
        req.requestBody = Blob.valueOf(jsonRequete);
        RestContext.request = req;
        RestContext.response = response;
        AppuntamentoWService.appuntamentoWSrv();
        System.debug(' ************************** response '+response);
        System.assertEquals(200, response.statusCode, '#### pass ###');
        Test.stopTest();

    }

    @isTest
    static void appuntamentoWSrvtestException(){
        /*  String jsonRequete = '{"societa":"compass","codFiliale":"222",\n'+
                                ' "data":"20190820","ora":"10:00","datiAggiuntivi":{"agente":"agent"},"datiCliente":{ \n'+
                                ' "nome":"Antonio","cognome":"Rizzo","sesso":"", "localitaNascita":"","provinciaNascita":"",\n'+
                                ' "capResidenza":"54100","dataNascita":"","privacyExtcommoffer":"0","privacyInterncommoffer":"1",\n'+
                                ' "privacyOtherservice":"0","privacyProfilazione":"0","tipoOccupazione":"2;1","contactID":"",\n'+
                                ' "email":"69antoninorizzo@gmail.com","cellulare":"3315437111","codiceFiscale":"RZZ9B25F158O"\n'+
                                ' },"datiMediaUTM":{"mediacode":"4389","utmDate":"2019081200"	},"prodottoLvl1":"2","prodottoLvl2":"prodottoLvl2"} ';*/
         String jsonRequete = '{"codFiliale":"F212","data":"20190820","datiAggiuntivi":{"agente":"","crm_i_id":null,\n'+
        ' "durata":null,"extReferrer":null,"importo":null,"prodottoOcs":null,"rata":null,"tabella":null,"taeg":null,\n'+
        '"tan":null},"datiCliente":{"capResidenza":"90011","cellulare":"3440697087","codiceFiscale":"TRPVCN67T25G273T","cognome":"Trapani",\n'+
        '"contactID":"","dataNascita":"","email":"trapanirenzo@libero.it","indirizzoResidenza":null,"localitaNascita":"","localitaResidenza":null,\n'+
        '"nome":"Vincenzo","privacyExtcommoffer":"1","privacyInterncommoffer":"1","privacyOtherservice":"0","privacyProfilazione":"0","provinciaNascita":"",\n'+
        '"sesso":"","siglaProvinciaResidenza":null,"tipoOccupazione":"4"},"datiMediaUTM":{"mediacode":"4031","mediacodeInt":"","utmCampaign":"FA",\n'+
        '"utmContent":"SEARCH","utmDate":"","utmHistory":"1,20190414,4377;2,20190410,4421;3,20190410,4478;4,20190410,4422;5,20190409,4422;6,20190408,4422;7,20190306,4031;8,20190306,4035;",\n'+
        '"utmMedium":"CPC","utmSource":"GOOGLEBRAND","utmTerm":""},"oppID":null,"ora":"16:30","prodottoLvl1":"2","prodottoLvl2":"","societa":"MONFORTE","utenteEsterno":"127.0.0.1",\n'+
        '"utenteInterno":"127.0.0.1"}';
        List<Event> eventList = [SELECT Id FROM Event WHERE Customer__r.Codice_Fiscale__c ='4477' AND Stato_Azione__c !='Non presentato/Annullato'];
        System.debug('********** Liste event '+eventList);
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse response = new RestResponse();
        req.requestURI ='/services/apexrest/AppuntamentoWS';
        req.requestBody = Blob.valueOf(jsonRequete);
        RestContext.request = req;
        RestContext.response = response;
        AppuntamentoWService.appuntamentoWSrv();
        System.debug(' ************************** response '+response);
        System.assertEquals(200, response.statusCode, '#### pass ###');
        Test.stopTest();

    }
    
    @isTest
    static void appuntamentoModificaPut(){
       //00U0Q000002IMXZUA4
       List<Event> eventList = [SELECT Id FROM Event];
       String idEvent = String.valueOf(eventList[0].Id) ;
       //"'+idEvent +'"
       String jsonRequest = '{"codFiliale":"F18","codiceFiscale":"4478", "oppID": "'+idEvent +'","ora":"09:30","data":"20190820"}';
       System.debug(eventList[0].Id);
       Test.startTest();
       RestRequest req = new RestRequest();
       RestResponse response = new RestResponse();
       req.requestURI ='/services/apexrest/Appuntamento';
       req.requestBody = Blob.valueOf(jsonRequest);
       RestContext.request = req;
       RestContext.response = response;
       AppuntamentoWService.appuntamentoModifica(); 
       System.debug(' ************************** response '+response);
       System.assertEquals(200, response.statusCode, '#### pass ###');
       Test.stopTest();
   }

   @isTest
    static void appuntamentoModificaPutErrortest(){
       //00U0Q000002IMXZUA4
       List<Event> eventList = [SELECT Id FROM Event];
       String idEvent = String.valueOf(eventList[0].Id) ;
       //"'+idEvent +'"
       String jsonRequest = '{"codFiliale":"F18","codiceFiscale":"447", "oppID": "'+idEvent +'" ,"ora":"09:30","data":"20190810"}';
       System.debug(eventList[0].Id);
       Test.startTest();
       RestRequest req = new RestRequest();
       RestResponse response = new RestResponse();
       req.requestURI ='/services/apexrest/Appuntamento';
       req.requestBody = Blob.valueOf(jsonRequest);
       RestContext.request = req;
       RestContext.response = response;
       AppuntamentoWService.appuntamentoModifica(); 
       System.debug(' ************************** response '+response);
       System.assertEquals(200, response.statusCode, '#### pass ###');
       Test.stopTest();
   }

    @isTest
    static void appuntamentoModificaPutException(){
       //00U0Q000002IMXZUA4
       List<Event> eventList = [SELECT Id FROM Event];
       String idEvent = String.valueOf(eventList[0].Id) ;
       //"'+idEvent +'"
       String jsonRequest = '{"codFiliale":"2224","codiceFiscale":"447", "oppID": "'+idEvent +'","ora":"09:30","data":"20190820"}';
       System.debug(eventList[0].Id);
       Test.startTest();
       RestRequest req = new RestRequest();
       RestResponse response = new RestResponse();
       req.requestURI ='/services/apexrest/Appuntamento';
       req.requestBody = Blob.valueOf(jsonRequest);
       RestContext.request = req;
       RestContext.response = response;
       AppuntamentoWService.appuntamentoModifica(); 
       System.debug(' ************************** response '+response);
       System.assertEquals(200, response.statusCode, '#### pass ###');
       Test.stopTest();
   }

   @isTest
   static void appuntamentoCercatest(){
       List<Event> events  = [Select Id,Esito__c, Nome__c,Sesso__c, Stato_Azione__c, Prodotto__c, Product__r.Name,Tipo_Occupazione__c,Customer__c,
                     		Customer__r.LastName, Note__c, Telefono_Cellulare__c, Customer__r.Provincia_Nascita__pc, 
                     		Customer__r.Sesso__pc,Customer__r.Type,ActivityDate,ActivityDateTime,Customer__r.FirstName,
                     		Customer__r.PersonEmail,Customer__r.Phone,DurationInMinutes, Desk__c, Desk__r.Branch__r.Name,Desk__r.Branch__r.OCS_External_Id__c
                        FROM Event where Customer__r.Codice_Fiscale__c ='RZZNNN69B25F158O'];
       System.debug(' ############## events test'+ events);
       Test.startTest();
       RestRequest req = new RestRequest();
       RestResponse response = new RestResponse();    
       req.requestURI ='/services/apexrest/AppuntamentoWS/RZZNNN69B25F158O';
       RestContext.request = req;
       RestContext.response = response;
       AppuntamentoWService.appuntamentoCerca();
       System.debug('######### response ######### '+response);
       Test.stopTest();
   }
   @isTest
   static void appuntamentoCercaExceptiontest(){
       Test.startTest();
       RestRequest req = new RestRequest();
       RestResponse response = new RestResponse();
       req.requestURI ='/services/apexrest/AppuntamentoWS/RZZNNN69B218O';
       RestContext.request = req;
       RestContext.response = response;
       AppuntamentoWService.appuntamentoCerca();
       System.debug('######### response ######### '+response);
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
 /*  @isTest
   static void appuntamentoDisponilitaCompletatest(){
       Test.startTest();
        Map<String,Object> returnValue = AppuntamentoDomainWS.appuntamentoDisponilitaCompleta('22','20190820');
        System.assertNotEquals(null, returnValue, 'pass');
       Test.stopTest();

   } */
}