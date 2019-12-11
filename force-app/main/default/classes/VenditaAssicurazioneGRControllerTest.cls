@isTest
public class VenditaAssicurazioneGRControllerTest {
    
    @isTest
    public static void doInitTest(){                
        String response = '{"resultCode":0,"resultMessage":"Ok","pratiche":[{"numPratica":"800000329783","codCliente":"123456789"}],"cliente":[{"cognome":"UTMOBZE","codCliente":"123456789","nome":"LERRIO"}]}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDatiPostvendita',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
      
        Account tempAccount = new Account(Name = 'Account Test', Codice_Cliente__c = 'CU123456789');
        Case tempCase = new Case();
        Product2 prodOb = new Product2(Name = 'Casa_sempre_Assistita_Smart_2477', Description = 'Casa sempre Assistita Smart', ProductCode = '2477', isActive = true);
        
        insert test1;
        insert tempAccount;
        insert tempCase;
        insert prodOb;        
                
        Test.startTest();
        
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname = 'ocs.recuperaDatiPostvendita';
        Test.setMock(HttpCalloutMock.class,UMR);
        
        VenditaAssicurazioneGRController.doInit(tempAccount.getCodice_Cliente__c, 'Call_Center_Interno', tempCase.Id);
        
        Test.stopTest();
    }
    
    @isTest
    public static void callWebServicesTest(){
        String cartaDatiFinanziariResponse = '{"resultCode": 0,"resultMessage": "Ok","datiCartaDatiFinanziariResponse":{"numeroPratica": "800000329783","as400Status": "OK","as400Errore": ""}}';
        String recuperaMovAutViaggiantiResponse = '{"resultCode":0,"resultMessage":"Ok","recuperaMovimentiAutorizzazioniViaggiantiResponse":{"recuperaMovViaggiantiResponse":{"elencoMovimenti":[]},"recuperaAutViaggiantiResponse":{"elencoAutorizzazioni":[],"as400Status":null,"as400Errore":""}}}';
        
        ApiRest__c cdfr = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= cartaDatiFinanziariResponse,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.cartaDatiFinanziari',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        ApiRest__c rmavr = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= recuperaMovAutViaggiantiResponse,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaMovAutViaggianti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      

        insert cdfr;
        insert rmavr;
        
        Test.startTest();
        
        VenditaAssicurazioneGRController.APIVariables doTest = VenditaAssicurazioneGRController.callWebServices('800000329783');
        
        Test.stopTest();
    }
    
    @isTest
    public static void callUpdateOCSTest(){
        String response = '{"resultCode":0,"resultMessage":"Ok","pratiche":[{"numPratica":"800000329783","codCliente":"123456789"}],"cliente":[{"cognome":"UTMOBZE","codCliente":"123456789","nome":"LERRIO"}]}';
       
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDatiPostvendita',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');              
        Account tempAccount = new Account(Name = 'Account Test', Codice_Cliente__c = 'CU123456789');
        
        insert test1;
        insert tempAccount;
        
        Test.startTest();
        
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname = 'ocs.recuperaDatiPostvendita';
        Test.setMock(HttpCalloutMock.class,UMR);
        List<OCSPratica> doTest = VenditaAssicurazioneGRController.callUpdateOCS(tempAccount.getCodice_Cliente__c);
            
        Test.stopTest();
    }
    
    @isTest
    public static void scheduleTest(){
        Case tempCase = new Case();
        insert tempCase;
        String doTest = VenditaAssicurazioneGRController.schedule(tempCase.Id, Date.today());
    }
    
    @isTest
    public static void upshotTest(){
        Datetime today = Date.today();
		XCS_CompassParameters__c compassParameters = new XCS_CompassParameters__c(Name='venditaAssicurazioni.cc.list', value__c='NET;Num_Blu;Visiant;Call_Center_Interno' );
        insert compassParameters;
        String personAccountRecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'PersonAccount' LIMIT 1].Id;
        Account tempAccount = new Account(FirstName = 'test', LastName = 'account', RecordTypeId = personAccountRecordTypeId, PersonEmail = 'alexander.denti@lynxspa.com');
        insert tempAccount;
        Case tempCase = new Case(AccountId = tempAccount.Id); 
        insert tempCase;
        List<Object> products = new List<Object>{'2477'};
        Contact tempContact = new Contact(FirstName = 'Dummy', LastName = 'Dummy');
        insert tempContact;
        VenditaAssicurazioneGRController.upshot(tempCase.Id, 'Interessato', 'Inviata doc precontrattuale', products, 'email', today, ''); 
        VenditaAssicurazioneGRController.upshot(tempCase.Id, 'Interessato', 'Inviata doc precontrattuale', products, 'posta', null, ''); 
        VenditaAssicurazioneGRController.upshot(tempCase.Id, 'non_interessato', 'Inviata doc precontrattuale', products, 'email', null,''); 
        
    }
}