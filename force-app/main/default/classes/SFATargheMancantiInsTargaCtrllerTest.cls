@isTest
public class SFATargheMancantiInsTargaCtrllerTest {
    
   
    @isTest
    public static void getDateScadenzaTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Branch Employee'][0];
        User user = new User();
		user.Username = 'username@abcd.com';
		user.LastName = 'Filiale Test';
		user.Email = 'abcd@abcd.com';
		user.Alias = 'abc';
		user.CommunityNickname = 'abc';
		user.TimeZoneSidKey = 'GMT';
		user.LocaleSidKey = 'it_IT';
		user.EmailEncodingKey = 'ISO-8859-1';
		user.ProfileId = p.Id;
		user.LanguageLocaleKey = 'it';
		user.DefaultQueueId__c = 'F84';

		insert user;

        XCS_CompassParameters__c obj = new XCS_CompassParameters__c();
        obj.Name = 'gdv.mail';
        obj.Value__c ='luca@prtova.it';
        insert obj;
        
        XCS_CompassParameters__c obj2 = new XCS_CompassParameters__c();
        obj2.Name = 'agenziaitalia.mail'; 
        obj2.Value__c ='luca@prtova.it';
        insert obj2;

        XCS_CompassParameters__c obj3 = new XCS_CompassParameters__c();
        obj3.Name = 'forwardandtrack.baseurl'; 
        obj3.Value__c ='https://dev-compass.cs109.force.com/ForwardAndTrack';
        insert obj3;                    
        
        string r =[select id from RecordType where Name = 'Branch'][0].id;
        Account a = new Account();
        a.Name = 'luca';
        a.BusinessEmail__c = 'lucacragno@prova.it';   
        a.RecordTypeId = r;
        a.OCS_External_Id__c = 'F84';
        a.OwnerId=user.id;
        insert a; 
        
        //string r =[select id from RecordType where Name = 'Branch'][0].id;
        //string z =[select id from RecordType where Name = 'Person Account'][0].id;
        
        	Account acc = new Account();
        	acc.Name='Dummy Dummy';
       	 	acc.Customer_Type__c='Compass';
        	acc.OwnerId=user.id;
        	insert acc;
        
            Contact cont = new Contact();
            cont.LastName = 'Dummy';
            cont.FirstName = 'Dummy';
        	cont.AccountId=acc.id;
            insert cont;
        
        Case c = new case();
        insert c;
        
        SFATargaMancante__c t = new SFATargaMancante__c();
        t.ActivityId__c = 12345;
        t.CodiceCliente__c = '1234';
        t.OcsCode__c = 'd';
        t.RagioneSociale__c = 'ad';
        t.Dipendenza__c = 'dip';
        t.NumeroPratica__c = '564';
        t.IdElaborazione__c = c.id;
        t.IdUploadList__c = 11;
        t.IdAttivita__c = c.Id;
        t.DataTermineLavoro__c = date.today();
        insert t;
        
        SFATargheMancantiInserimentoTargaCtrller.getDateScadenza((String)t.id);    
    }
    
    @isTest
    public static void callAggiornaDatiTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Branch Employee'][0];
        User user = new User();
		user.Username = 'username@abcd.com';
		user.LastName = 'Filiale Test';
		user.Email = 'abcd@abcd.com';
		user.Alias = 'abc';
		user.CommunityNickname = 'abc';
		user.TimeZoneSidKey = 'GMT';
		user.LocaleSidKey = 'it_IT';
		user.EmailEncodingKey = 'ISO-8859-1';
		user.ProfileId = p.Id;
		user.LanguageLocaleKey = 'it';
		user.DefaultQueueId__c = 'F84';

		insert user;

        XCS_CompassParameters__c obj = new XCS_CompassParameters__c();
        obj.Name = 'gdv.mail';
        obj.Value__c ='luca@prtova.it';
        insert obj;
        
        XCS_CompassParameters__c obj2 = new XCS_CompassParameters__c();
        obj2.Name = 'agenziaitalia.mail'; 
        obj2.Value__c ='luca@prtova.it';
        insert obj2;

        XCS_CompassParameters__c obj3 = new XCS_CompassParameters__c();
        obj3.Name = 'forwardandtrack.baseurl'; 
        obj3.Value__c ='https://dev-compass.cs109.force.com/ForwardAndTrack';
        insert obj3;                    
        
        string r =[select id from RecordType where Name = 'Branch'][0].id;
        Account a = new Account();
        a.Name = 'luca';
        a.BusinessEmail__c = 'lucacragno@prova.it';   
        a.RecordTypeId = r;
        a.OCS_External_Id__c = 'F84';
        a.OwnerId=user.id;
        insert a; 
        
        //string r =[select id from RecordType where Name = 'Branch'][0].id;
        //string z =[select id from RecordType where Name = 'Person Account'][0].id;
        
        	Account acc = new Account();
        	acc.Name='Dummy Dummy';
       	 	acc.Customer_Type__c='Compass';
        	acc.OwnerId=user.id;
        	insert acc;
        
            Contact cont = new Contact();
            cont.LastName = 'Dummy';
            cont.FirstName = 'Dummy';
        	cont.AccountId=acc.id;
            insert cont;
        
        String response = '{"resultCode":0,"resultMessage":"Ok","copsvdtaresponse":{"mftpsres_STATUS":"KO","mftpsres_PROCEDURA":"CO","mfterr_OMSFERR_OCCURS":[{"msferr_N_RECORD":1,"msferr_TIPO":"E"}]}}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.OCS_COPSVDTA_V1',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute',Ref__c='CompassInternal');      
        insert test1;
        ApiUtil__c test2 = new ApiUtil__c(Name = 'CompassInternal', EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute', User__c = 'CDSLF00', Password__c = 'P00FLSDC', Ref__c = 'CompassInternal');
        insert test2;
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.OCS_COPSVDTA_V1';
        Test.setMock(HttpCalloutMock.class,UMR);
        
        SFATargheMancantiInserimentoTargaCtrller.callAggiornaDati(0,'','','','',0,'');
        test.stopTest();
        
    }
    
    @isTest
    public static void completaPraticaTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Branch Employee'][0];
        User user = new User();
		user.Username = 'username@abcd.com';
		user.LastName = 'Filiale Test';
		user.Email = 'abcd@abcd.com';
		user.Alias = 'abc';
		user.CommunityNickname = 'abc';
		user.TimeZoneSidKey = 'GMT';
		user.LocaleSidKey = 'it_IT';
		user.EmailEncodingKey = 'ISO-8859-1';
		user.ProfileId = p.Id;
		user.LanguageLocaleKey = 'it';
		user.DefaultQueueId__c = 'F84';

		insert user;
        
        User utente = [ select id, DefaultQueueId__c from user where LastName = 'Filiale Test'][0];
        
        System.runAs(utente)
        {
            
        

        XCS_CompassParameters__c obj = new XCS_CompassParameters__c();
        obj.Name = 'gdv.mail';
        obj.Value__c ='luca@prtova.it';
        insert obj;
        
        XCS_CompassParameters__c obj2 = new XCS_CompassParameters__c();
        obj2.Name = 'agenziaitalia.mail'; 
        obj2.Value__c ='luca@prtova.it';
        insert obj2;

        XCS_CompassParameters__c obj3 = new XCS_CompassParameters__c();
        obj3.Name = 'forwardandtrack.baseurl'; 
        obj3.Value__c ='https://dev-compass.cs109.force.com/ForwardAndTrack';
        insert obj3;                    
        
        string r =[select id from RecordType where Name = 'Branch'][0].id;
        Account a = new Account();
        a.Name = 'luca';
        a.BusinessEmail__c = 'lucacragno@prova.it';   
        a.RecordTypeId = r;
        a.OCS_External_Id__c = 'F84';
        a.OwnerId=user.id;
        insert a; 
        
        //string r =[select id from RecordType where Name = 'Branch'][0].id;
        //string z =[select id from RecordType where Name = 'Person Account'][0].id;
        
        	Account acc = new Account();
        	acc.Name='Dummy Dummy';
       	 	acc.Customer_Type__c='Compass';
        	acc.OwnerId=user.id;
        	acc.OCS_External_Id__c = 'N00000';
        	insert acc;
        
            Contact cont = new Contact();
            cont.LastName = 'Dummy';
            cont.FirstName = 'Dummy';
        	cont.AccountId=acc.id;
            insert cont;
            
        Case c = new case();
        c.Status = 'New';
        insert c;
        
        SFATargaMancante__c t = new SFATargaMancante__c();
        t.ActivityId__c = 12345;
        t.CodiceCliente__c = '1234';
        t.OcsCode__c = 'd';
        t.RagioneSociale__c = 'ad';
        t.Dipendenza__c = 'dip';
        t.NumeroPratica__c = '564';
        t.IdElaborazione__c = c.id;
        t.IdUploadList__c = 11;
        t.DataTermineLavoro__c = date.today();
        t.IdAttivita__c = c.id;
        insert t;          
        
        SFATargheMancantiInserimentoTargaCtrller.completaPratica(t.id,'','',''); 
        SFATargheMancantiInserimentoTargaCtrller.completaPraticaEntroScadenziario(t.id,'','','');
        SFATargheMancantiInserimentoTargaCtrller.completaPraticaDopoScadenziario(t.id,'','',''); 
            
        }
    }      
    
}