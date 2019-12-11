@isTest
public class SFA_CompilaRegistriControllerApexTest {

    @TestSetup
    static void setup(){   
        
        if(([SELECT Id FROM User WHERE DefaultQueueId__c = 'F00-TEST']).size()==0){
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User utenteMaster = new User(
                FirstName= 'Test',
                LastName= 'Test',
                Username= 'test@compass.com.test',
                Email= 'test@lynxspa.com',
                Alias= 'test',
                TimeZoneSidKey= 'Europe/Rome',
                LocaleSidKey= 'it_IT',
                EmailEncodingKey= 'ISO-8859-1',
                ProfileId= p.Id,
                LanguageLocaleKey= 'en_US',
                DefaultQueueId__c= 'F00-TEST'
            );
            insert utenteMaster;
        }
        
        if(([SELECT Id FROM Account WHERE OCS_External_Id__c = 'F00-TEST']).size()==0){
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Branch').getRecordTypeId();
            Account theAccount= new Account(
                Name = 'test',
				OCS_External_id__c = 'F00-TEST',
				Data_Nascita__c = Date.newInstance(2019,4,3),
				Telefono_Casa__c = '001234500',
				Telefono_Cellulare__c = '3300123',
				Fax = '3300123',
				Data_Depennamento__c = Date.today()
            	);
                theAccount.RecordTypeId = recordTypeId;
            insert theAccount;
        }

        if(([SELECT Id FROM SFA_Slot__c]).size()==0){
            User utenteMaster = [SELECT Id FROM User WHERE LastName = 'Test'];
            Account theAccount=[SELECT Id FROM Account WHERE OCS_External_id__c = 'F00-TEST'];
            SFA_Slot__c testSlot= new SFA_Slot__c(
                Type__c = 'B',
                Status__c = 'Valido',
                Date__c = Date.today(),
                Time__c = 'AM',
                User__c = utenteMaster.Id
            );
            testSlot.Branch__c = theAccount.Id;
            insert testSlot;
        }
    }

    @isTest
    public static void insertNotaSpeseTest(){
        User utenteMaster = [SELECT Id FROM User WHERE LastName = 'Test'];
        Account theAccount=[SELECT Id FROM Account WHERE OCS_External_id__c = 'F00-TEST'];
        SFA_NotaSpese__c ns=new SFA_NotaSpese__c(
            Date__c=Date.today(),
            Time__c='AM',
            Branch__c=theAccount.Id,
            Status__c='',
            User__c=utenteMaster.Id,
            Tratta__c='test',
            OraInizioUscita__c=Time.newInstance(14, 30, 2, 20),
            OraFineUscita__c=Time.newInstance(15, 30, 2, 20),
            KmInizioUscita__c=1.00,
            KmFineUscita__c=2.00,
            TargaVeicolo__c='11TEST11',
            DataApprovazione__c=Date.today(),
            Note__c='test',
            KmRifornimento__c=2.00,
            LuogoRifornimento__c='test',
            ImportoRifornimento__c=1.00,
            ManagerApprovazione__c=utenteMaster.Id
        );
        Test.startTest();
        System.runAs(utenteMaster){
            SFA_CompilaRegistriControllerApex.insertNotaSpese(ns);
        }
        Test.stopTest();
        List<SFA_NotaSpese__c> lista=[SELECT Id,Date__c,Time__c,Branch__c,Status__c,User__c,User__r.Alias, User__r.Name,Tratta__c,OraInizioUscita__c,OraFineUscita__c,KmInizioUscita__c,KmFineUscita__c,TargaVeicolo__c,DataApprovazione__c,Note__c,KmRifornimento__c,LuogoRifornimento__c,ImportoRifornimento__c,ManagerApprovazione__r.Alias,(SELECT Id,Dealer__c FROM Pianifica_Attivita__r) FROM SFA_NotaSpese__c];
        System.assertEquals(1,lista.size());
    }

    @isTest
    public static void getTimbratureTest(){
        OCSrecuperaTimbratureZucchettiResponse.elencoTimbrature[] elenco;
        User utenteMaster = [SELECT Id FROM User WHERE LastName = 'Test'];
        String response1 = '{"resultCode":0,"resultMessage":"Ok","recuperaDatiUtenteZucchettiResponse":{"codFiscale":"PSCMHL79M19A662C","idCompany":"000551","idEmploy":"0001518","username":"CU1518","tipoAuto":"A","modelloAuto":"N108"}}';
        String response2 = '{"resultCode":0,"resultMessage":"Ok","recuperaTimbratureZucchettiResponse":{"elencoTimbrature":[{"giorno":"2017-11-06","ora":"09:25","verso":"x","ordinamento":"xx"}]}}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response1,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDatiUtenteZucchetti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/recuperaDatiUtenteZucchetti');
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaTimbratureZucchetti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/recuperaTimbratureZucchetti');
        insert new List<ApiRest__c>{test1,test2};
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.recuperaDatiUtenteZucchetti','ocs.recuperaTimbratureZucchetti'});
        Test.setMock(HttpCalloutMock.class,UMR);
        Test.startTest();
        System.runAs(utenteMaster){
            elenco=SFA_CompilaRegistriControllerApex.getTimbrature(Date.today());
        }
        Test.stopTest();
        System.assertEquals(1,elenco.size());
    }

    @isTest
    public static void getTimbratureNoDatiUtenteTest(){
        User utenteMaster = [SELECT Id FROM User WHERE LastName = 'Test'];
        String response1 = '{"resultCode":0,"resultMessage":"Ok","recuperaDatiUtenteZucchettiResponse":null}';
        String response2 = '{"resultCode":0,"resultMessage":"Ok","recuperaTimbratureZucchettiResponse":{"elencoTimbrature":[{"giorno":"2017-11-06","ora":"09:25","verso":"x","ordinamento":"xx"}]}}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response1,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDatiUtenteZucchetti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/recuperaDatiUtenteZucchetti');
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaTimbratureZucchetti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/recuperaTimbratureZucchetti');
        insert new List<ApiRest__c>{test1,test2};
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.recuperaDatiUtenteZucchetti','ocs.recuperaTimbratureZucchetti'});
        Test.setMock(HttpCalloutMock.class,UMR);
        Test.startTest();
        String errorMessage;
        System.runAs(utenteMaster){
            try{
                OCSrecuperaTimbratureZucchettiResponse.elencoTimbrature[] elenco=SFA_CompilaRegistriControllerApex.getTimbrature(Date.today());
            }
            catch(AuraHandledException error){
                errorMessage = error.getMessage();  
            }
        }
        Test.stopTest();
        System.assertEquals('utente non trovato',errorMessage);
    }

    @isTest
    public static void getTimbratureNoTimbratureTest(){
        User utenteMaster = [SELECT Id FROM User WHERE LastName = 'Test'];
        String response1 = '{"resultCode":0,"resultMessage":"Ok","recuperaDatiUtenteZucchettiResponse":{"codFiscale":"PSCMHL79M19A662C","idCompany":"000551","idEmploy":"0001518","username":"CU1518","tipoAuto":"A","modelloAuto":"N108"}}';
        String response2 = '{"resultCode":0,"resultMessage":"Ok","recuperaTimbratureZucchettiResponse":null}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response1,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDatiUtenteZucchetti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/recuperaDatiUtenteZucchetti');
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaTimbratureZucchetti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/recuperaTimbratureZucchetti');
        insert new List<ApiRest__c>{test1,test2};
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.recuperaDatiUtenteZucchetti','ocs.recuperaTimbratureZucchetti'});
        Test.setMock(HttpCalloutMock.class,UMR);
        String errorMessage;
        Test.startTest();
        System.runAs(utenteMaster){
            try{
                OCSrecuperaTimbratureZucchettiResponse.elencoTimbrature[] elenco=SFA_CompilaRegistriControllerApex.getTimbrature(Date.today());
            }
            catch(AuraHandledException error){
                errorMessage = error.getMessage();  
            }
        }
        Test.stopTest();
        System.assertEquals('Nessuna timbratura presente',errorMessage);
    }

    @isTest
    public static void onInitGetDateTest(){
        Date d;
        User utenteMaster = [SELECT Id FROM User WHERE LastName = 'Test'];
        Test.startTest();
        System.runAs(utenteMaster){
            d=SFA_CompilaRegistriControllerApex.onInitGetDate();
        }
        Test.stopTest();
        System.assertEquals(Date.today(),d);
    }
}