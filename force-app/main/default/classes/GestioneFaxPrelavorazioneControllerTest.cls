@isTest
public class GestioneFaxPrelavorazioneControllerTest {  
    
     
    
    @isTest 
    public static void testGetQueueMailFax() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Call Center']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standt123123223@f.com');
        
        Group g1 = new Group(Type = 'queue', DeveloperName='Q900', Name='Coda1');
        insert g1; 

        
        
        System.runAs(u) {
            
            List<CRM_QueueMailFaxConfig__c> quefaxList = new  List<CRM_QueueMailFaxConfig__c>();
            CRM_QueueMailFaxConfig__c crmQue = new CRM_QueueMailFaxConfig__c();
            crmQue.MailBox__c ='gestionefaxsales@gmail.com';
            crmQue.DeveloperName__c='Q900';
            crmQue.Type__c ='Fax';
            quefaxList.add(crmQue);
            Insert crmQue;
            GestioneFaxPrelavorazioneController.getQueueMailFax();
            
        }
    }
    
    @isTest
    public static void testAggiungiTask() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Call Center'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standt123123223@f.com');
        System.runAs(u) {
            
            Case c = new Case();
            Insert c;
            
            OCSCliente cli = new OCSCliente(); 
            cli.codCliente='12345';
            GestioneFaxPrelavorazioneController.aggiungiCaseFiglio(c.Id, 'prodotto', 'categoria', 'codiceCliente', 'codicePratica', 1234, 12,cli);
        }
    }
    
    @isTest
    public static void testDoUpshot() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Call Center'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standt123123223@f.com');
        System.runAs(u) {
            
            
            Id RecordTypeIdTask = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Attività Gestione Fax').getRecordTypeId();
            System.debug('getInfo of ATTIVITA GESTIONE FAX ::::::::::>  ' + Schema.SObjectType.Task.getRecordTypeInfosByName().get('Attività Gestione Fax')); 
            
            Task tsk = new Task(); 
            tsk.RecordTypeId=RecordTypeIdTask; 
            Insert tsk;
            
            Case c = new Case();
            Insert c;
            
            
            GestioneFaxPrelavorazioneController.doUpshot(c.Id,'Doppio');
        }
    }
    
    @isTest
    public static void testDoRouting() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Call Center'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standt123123223@f.com');
        System.runAs(u) {
            
            Case c = new Case();
            Insert c;
            
            GestioneFaxPrelavorazioneController.doRouting( c.Id,'gestionefaxsales@gmail.com');
        }
    }
    
    @isTest
    public static void loadMetadata() { 
        Profile p = [SELECT Id FROM Profile WHERE Name='Call Center'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standt123123223@f.com');
        System.runAs(u) {
            
            GestioneFaxPrelavorazioneController.loadConfigs();
            GestioneFaxPrelavorazioneController.loadProducts();
            GestioneFaxPrelavorazioneController.getCategorie();
        }
    }
    
    @isTest
    public static void getEmettitore() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Call Center'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standt123123223@f.com');
        System.runAs(u) {
            
            String response = '{"resultCode":0,"resultMessage":"Ok","datiCartaDatiFinanziariResponse":{"numeroPratica":"818","emettitore":"1","dataValidita":"20130426","pan":"4","fidoTotale":"35","dispTotale":"35","as400Status":"OK","as400Errore":""}}';
            ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.cartaDatiFinanziari',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
            Insert test1;
            test.startTest();
            UtilityMockResponse UMR = new UtilityMockResponse();
            UMR.apiname='ocs.cartaDatiFinanziari';
            Test.setMock(HttpCalloutMock.class,UMR);
            System.assert(GestioneFaxPrelavorazioneController.getEmettitore('1101300423') == '1');
            test.stopTest(); 
            
        }
    }
    
    
    @isTest
    public static void hasTaskDuplicate() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Call Center'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standt123123223@f.com');
        System.runAs(u) {
            
            Case c = new Case();
            c.Status='New';
            Insert c;
            Task tsk = new Task();
            tsk.CategoriaID__c = 3694;
            tsk.ProdottoID__c = 3649;
            tsk.Codice_Cliente__c = '1231236';
            tsk.Pratica__c = '1101300423';
            tsk.WhatId=c.Id;
            Insert tsk;
            
            System.assert(GestioneFaxPrelavorazioneController.hasTaskDuplicate(3649, 3694, '1231236', '1101300423', true, tsk.id ));
            
        }
    }
    
    @isTest
    public static void testHasTaskAssociati() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Call Center'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standt123123223@f.com');
        System.runAs(u) {
            
            Case c = new Case();
            Insert c;
            Task tsk = new Task();
            tsk.WhatId=c.Id;
            Insert tsk;
            System.assert(GestioneFaxPrelavorazioneController.hasTaskAssociati(tsk.WhatId));
        }
        
    }
    
    
    
}