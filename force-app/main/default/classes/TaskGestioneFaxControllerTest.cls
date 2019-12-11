@isTest
public class TaskGestioneFaxControllerTest {
    
    @testSetup
    public static void setup(){
        Task tk = new Task();
        tk.Subject = 'Task di Test';
        insert tk;
        
        Account acc = new Account();
        acc.Name = 'Account di Test';
        acc.Codice_Cliente__c = '123123123';
        insert acc;
        
        Case c = new Case();
        c.Status = 'Completato';
        Datetime dt = Datetime.Now().addDays(1);
        c.SLA_Date__c = dt;
        insert c;
    }
    
    @isTest
    public static void updateStatusTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Call Center Manager'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standt123123223@f.com');
        
        System.runAs(u) {
            Task tkSetup = new Task();
            tkSetup.Subject = 'Task di Test';
            insert tkSetup;
            
            Task tk = [select id,Stato_Azione__c from task where Subject = 'Task di Test'];
            TaskGestioneFaxController.updateStatus(tk.id, 'Azione Forzata'); 
            Task assertTk = new Task(stato_azione__c = 'Azione Forzata');
            String azioneAssert = [select Stato_Azione__c from task where Subject = 'Task di Test'].stato_azione__c;
            System.assert(azioneAssert == assertTk.Stato_Azione__c);
        }
    }
    @isTest
    public static void getTaskTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Call Center Manager'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standt123123223@f.com');
        
        System.runAs(u) {
            Case tkSetup = new Case();
            tkSetup.subject = 'Task di Test';
            insert tkSetup;
            Case tk = [select id from Case where Subject = 'Task di Test'];
            Case resultTask = TaskGestioneFaxController.getCase(tk.id);        
        }
    }
    
    @isTest
    public static void updateStatusConunicazioneTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Call Center Manager'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standt123123223@f.com');
        
        System.runAs(u) {
            Task tkSetup = new Task();
            tkSetup.Subject = 'Task di Test';
            insert tkSetup;
            
            Task tk = [select id from task where Subject = 'Task di Test'];
            TaskGestioneFaxController.updateStatusConunicazione(tk.id, 'Forzata'); 
            Task assertTk = new Task(stato_comunicazione__c = 'Forzata');
            String azioneAssert = [select Stato_comunicazione__c from task where Subject = 'Task di Test'].stato_comunicazione__c;
            System.assert(azioneAssert == assertTk.stato_comunicazione__c);
        }
    }
    @isTest
    public static void updateTaskStatusTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Call Center Manager'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standt123123223@f.com');
        
        System.runAs(u) {
            Task tkSetup = new Task();
            tkSetup.Subject = 'Task di Test';
            insert tkSetup;
            
            Task tk = [select id, status from task where Subject = 'Task di Test'];
            TaskGestioneFaxController.updateTaskStatus(tk.id, 'Completato'); 
            Task assertTk = new Task(status = 'Completato');
            String azioneAssert = [select status from task where Subject = 'Task di Test'].status;
            System.assert(azioneAssert == assertTk.status);
        }
    }
    
    @isTest
    public static void updateFlagContattoTrueTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Call Center Manager'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standt123123223@f.com');
        
        System.runAs(u) {
            Task tkSetup = new Task();
            tkSetup.Subject = 'Task di Test';
            insert tkSetup;
            
            Task tk = [select id, status from task where Subject = 'Task di Test'];
            TaskGestioneFaxController.updateFlagContatto(tk.id, true);
            Task assertTk = new Task(FlagContattoCliente__c = true);
            Boolean azioneAssert = [select FlagContattoCliente__c from task where Subject = 'Task di Test'].FlagContattoCliente__c;
            System.assert(azioneAssert == assertTk.FlagContattoCliente__c);
        }
    } 
    @isTest
    public static void updateFlagContattoFalseTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Call Center Manager'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standt123123223@f.com');
        
        System.runAs(u) {
            Task tkSetup = new Task();
            tkSetup.Subject = 'Task di Test';
            insert tkSetup;
            
            Task tk = [select id, status from task where Subject = 'Task di Test'];
            TaskGestioneFaxController.updateFlagContatto(tk.id, false);
            Task assertTk = new Task(FlagContattoCliente__c = false);
            Boolean azioneAssert = [select FlagContattoCliente__c from task where Subject = 'Task di Test'].FlagContattoCliente__c;
            System.assert(azioneAssert == assertTk.FlagContattoCliente__c);
        }
    }   
    @isTest
    public static void getConfigFaxTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Call Center Manager'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standt123123223@f.com');
        
        System.runAs(u) {
            Task tkSetup = new Task();
            tkSetup.Subject = 'Task di Test';
            insert tkSetup;
            
            TaskGestioneFaxController.getConfigFax(1415 ,3653);
        }
        
    }
    @isTest
    public static void checkStatusAzioneTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Call Center Manager'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standt123123223@f.com');
        
        System.runAs(u) {
            Task tkSetup = new Task();
            tkSetup.Subject = 'Task di Test';
            insert tkSetup;
            
            Task tk = [select id, status from task where Subject = 'Task di Test'];
            TaskGestioneFaxController.checkStatusAzione(tk.id);
        }
    }
    @isTest
    public static void checkStatusComunicazioneTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Call Center Manager'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standt123123223@f.com');
        
        System.runAs(u) {
            Task tkSetup = new Task();
            tkSetup.Subject = 'Task di Test';
            insert tkSetup;
            
            Task tk = [select id, status from task where Subject = 'Task di Test'];
            TaskGestioneFaxController.checkStatusComunicazione(tk.id);
        }
    }
    
    @isTest
    public static void launchPVTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Call Center Manager'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standt123123223@f.com');
        
        System.runAs(u) {
            Task tkSetup = new Task();
            tkSetup.Subject = 'Task di Test';
            insert tkSetup;
            
            Account accSetup = new Account();
            accSetup.Name = 'Account di Test';
            accSetup.Codice_Cliente__c = '123123123';
            insert accSetup;
            
            Task tk = [select id, status from task where Subject = 'Task di Test'];
            Account acc = [select codice_cliente__c from account where codice_cliente__c = '123123123'];
            TaskGestioneFaxController.launchPV(1415,3653,tk.id,'123123123');
        }
    }
    
    @isTest
    public static void getComunicazioniOkTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Call Center Manager'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standt123123223@f.com');
        
        System.runAs(u) {
            Task tkSetup = new Task();
            tkSetup.Subject = 'Task di Test';
            insert tkSetup;
            
            TaskGestioneFaxController.getComunicazioni('ok',3684,3693);
        }
    }
    
    @isTest
    public static void getComunicazioniKoTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Call Center Manager'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standt123123223@f.com');
        
        System.runAs(u) {
            Task tkSetup = new Task();
            tkSetup.Subject = 'Task di Test';
            insert tkSetup;
            
            TaskGestioneFaxController.getComunicazioni('ko',3684,3693);
        }
    }
    
    @isTest
    public static void updateCaseTaskStatusTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Call Center Manager'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standt123123223@f.com');
        
        System.runAs(u) {

            Case cSetup = new Case();
            cSetup.Status = 'Completato';
            Datetime dt = Datetime.Now().addDays(1);
            cSetup.note__c = 'noteDiTest';
            cSetup.SLA_Date__c = dt;
            insert cSetup;
            
            Task tkSetup = new Task();
            tkSetup.Subject = 'Task di Test';
            tkSetup.WhatId = cSetup.id;
            insert tkSetup;
            
            Task tk = [select id, status from task where Subject = 'Task di Test'];
            Case c = [select id from case where status = 'Completato' and note__c = 'noteDiTest'];
            TaskGestioneFaxController.updateCaseTaskStatus(c.id,tk.id,'Completato','nota');
        }
    }
    
    @isTest
    public static void updateSlaDateCaseTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Call Center Manager'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standt123123223@f.com');
        
        Group codaTest = new Group();
        codaTest.Type = 'Queue';
        codaTest.Name = 'NameTest';
        codaTest.DeveloperName = 'DeveloperNameTest';
        insert codaTest;
                              
        System.runAs(u) {   
            Task tkSetup = new Task();
            tkSetup.Subject = 'TaskTest';
            insert tkSetup;
            
            Case cSetup = new Case();
            cSetup.Status = 'Completato';
            cSetup.Subject = 'Pr';
            Datetime dtSetup = Datetime.Now().addDays(1);
            cSetup.SLA_Date__c = dtSetup;
            insert cSetup;
            
            EmailMessage eSetup = new EmailMessage();
            eSetup.ParentId = cSetup.id;
            eSetup.ToAddress = 'a@prova.com';
            insert eSetup;            
            
            CRM_QueueMailFaxConfig__c qmfxSetup = new CRM_QueueMailFaxConfig__c();
            qmfxSetup.Mailbox__c = 'a@prova.com';
            qmfxSetup.Recall_Queue__c = 'QTEST';
            qmfxSetup.DeveloperName__c = 'DeveloperNameTest';
            insert qmfxSetup;                     
     
            Task tk = [select id, status from task where Subject = 'TaskTest'];
            Case c = [select id from case where status = 'Completato' and subject = 'Pr'];
            DateTime dt = DateTime.now();
            TaskGestioneFaxController.updateSlaDateCase(tk.id,c.id,dt);
        }
    }
    
    @isTest
    public static void updateEsitoTaskTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Call Center Manager'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standt123123223@f.com');
        
        System.runAs(u) {
            Task tkSetup = new Task();
            tkSetup.Subject = 'Task di Test';
            insert tkSetup;
            
            Task tk = [select id, status from task where Subject = 'Task di Test'];
            TaskGestioneFaxController.updateEsitoTask(tk.id,'ok');
            Task assertTk = new Task(esito__c = 'ok');
            String azioneAssert = [select esito__c from task where Subject = 'Task di Test'].esito__c;
            System.assert(azioneAssert == assertTk.esito__c);
        }
    }
    public class PV{
        public String Id{get; set;}
        public String Label{get; set;}
        public String QueueNameId{get; set;}
        public String RecordTypeId{get; set;}
        public String Subject{get; set;}
        public String FlowName{get;set;}
        public String Tipologia{get;set;}
        public String AccountId{get;set;}       
    }
    
    public class Codice{
        public String Tipologia{get; set;}
        public String Codice{get; set;}
    }
    
    
}