@isTest
private class CapComuneClassTest {
	 
    @TestSetup
    static void setup(){   
         if(([SELECT Id FROM User WHERE DefaultQueueId__c IN ('F00-TEST')]).size()==0){
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User testerUser = new User(
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
            User utenteError = new User(
                FirstName= 'TestError',
                LastName= 'TestError',
                Username= 'testerror@compass.com.test',
                Email= 'testerror@lynxspa.com',
                Alias= 'tester',
                TimeZoneSidKey= 'Europe/Rome',
                LocaleSidKey= 'it_IT',
                EmailEncodingKey= 'ISO-8859-1',
                ProfileId= p.Id,
                LanguageLocaleKey= 'en_US'
            );
            insert new List<User>{testerUser,utenteError};
         }
        if(([SELECT Id FROM Account WHERE OCS_External_Id__c = 'F00-TEST']).size()==0){
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Branch').getRecordTypeId();
            Account Venezia= new Account(
                Name= 'VENEZIA', 
                OCS_External_Id__c = 'F00-TEST',
                RecordTypeId = recordTypeId,
                Type= 'FIL'
                
            );
            insert Venezia;
        }
        if(([SELECT Id FROM Zone__c WHERE Branch__r.OCS_External_Id__c = 'F00-TEST']).size()==0){
            Zone__c VeneziaZone = new Zone__c(
                Name= 'Venezia'
            );
            VeneziaZone.Branch__r  = new Account(OCS_External_Id__c= 'F00-TEST');
            
            Zone__c PadovaZone = new Zone__c(
                Name= 'Padova'
            );
            PadovaZone.Branch__r  = new Account(OCS_External_Id__c= 'F00-TEST');
            insert new List<Zone__c>{VeneziaZone,PadovaZone};
        }
        if(([SELECT Id FROM CAP_2_Branch__c WHERE Branch__r.OCS_External_Id__c = 'F00-TEST']).size()==0){
            CAP_2_Branch__c CapVenezia= new CAP_2_Branch__c(
                CAP__c = '1010', 
                CAP_Generico__c = '1010',
                Regione__c = 'Veneto', 
                Provincia__c = 'VN', 
                OCS_External_Id__c ='43656563',
                Comune__c = 'Venezia'
            );
            //CapVenezia.Zone__r = new Zone__c(Name = 'Venezia');
            CapVenezia.Branch__r = new Account(OCS_External_Id__c = 'F00-TEST');

            CAP_2_Branch__c CapPadova= new CAP_2_Branch__c(
                CAP__c = '35128', 
                CAP_Generico__c = '35128',
                Regione__c = 'Veneto', 
                Provincia__c = 'PD', 
                OCS_External_Id__c ='43656564',
                Comune__c = 'Padova'
            );
            //CapVenezia.Zone__r = new Zone__c(Name = 'Venezia');
            CapPadova.Branch__r = new Account(OCS_External_Id__c = 'F00-TEST');
            insert new List<CAP_2_Branch__c> {CapVenezia,CapPadova};
        }
    }
    
	@isTest static void getCapComuneTest() {
		User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
        List<CAP_2_Branch__c> listToVerify;
        Map<String, List<CAP_2_Branch__c>> capReturned;
        Test.startTest();
		System.runAs(u) {
            List<Account> branches= [SELECT FirstName,toLabel(Type) TypeLabel,Type, LastName, Name, OCS_External_Id__c FROM Account WHERE OCS_External_Id__c =: u.DefaultQueueId__c OR Parent.OCS_External_Id__c =: u.DefaultQueueId__c  OR Parent.Parent.OCS_External_Id__c =: u.DefaultQueueId__c];
            listToVerify = [SELECT Id ,Branch__c, Branch__r.OCS_External_Id__c, CAP__c, CAP_Generico__c,Zone__c , Zone__r.Name , Zone__r.OCS_External_Id__c,Regione__c, Provincia__c, OCS_External_Id__c ,Comune__c 
                FROM CAP_2_Branch__c WHERE Branch__r.OCS_External_Id__c = 'F00-TEST'];
			capReturned = CapComuneClass.getCapComune(branches);
			
		}
		Test.stopTest();
        System.assertEquals(listToVerify, capReturned.get('F00-TEST'));   
	}
    
    @isTest static void getZoneListTest() {
		User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
		List<Zone__c> listToVerify;
        Map<String, List<Zone__c>> zoneListReturned;
        Test.startTest();
		System.runAs(u) {
            List<Account> branches= [SELECT FirstName,toLabel(Type) TypeLabel,Type, LastName, Name, OCS_External_Id__c FROM Account WHERE OCS_External_Id__c =: u.DefaultQueueId__c OR Parent.OCS_External_Id__c =: u.DefaultQueueId__c  OR Parent.Parent.OCS_External_Id__c =: u.DefaultQueueId__c];
            listToVerify = [SELECT Id, Name, Branch__c, Branch__r.OCS_External_Id__c FROM Zone__c WHERE Branch__r.OCS_External_Id__c = 'F00-TEST'];
			zoneListReturned = CapComuneClass.getZoneList(branches);
			  
		}
		Test.stopTest();
        System.assertEquals(listToVerify,zoneListReturned.get('F00-TEST')); 
	}
    
     @isTest static void updateCapComuneTest() {
        User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
		Map<String, List<CAP_2_Branch__c>> capComuniMapNew;
        List<Account> branches= [SELECT FirstName,toLabel(Type) TypeLabel,Type, LastName, Name, OCS_External_Id__c FROM Account WHERE OCS_External_Id__c =: u.DefaultQueueId__c OR Parent.OCS_External_Id__c =: u.DefaultQueueId__c  OR Parent.Parent.OCS_External_Id__c =: u.DefaultQueueId__c];
        Test.startTest();
		System.runAs(u) {
            Map<String, List<CAP_2_Branch__c>> capComuniMap = CapComuneClass.getCapComune(branches);
        	capComuniMap.get('F00-TEST')[0].Comune__c = 'Test';
            CapComuneClass.updateCapComune(capComuniMap.get('F00-TEST'));
            capComuniMapNew = CapComuneClass.getCapComune(branches);
			
		}
		Test.stopTest();
        System.assertEquals(capComuniMapNew.get('F00-TEST')[0].Comune__c,'Test');   
	}
    
    @isTest static void initApexTest() {
       	User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
		CapComuneClass.InitWrapper Wr;
        Test.startTest();
		System.runAs(u) {
            Wr = CapComuneClass.initApex();
		}
		Test.stopTest();
        System.assertEquals(Wr.capComuniMap.get('F00-TEST').size(),2);   
        System.assertEquals(Wr.zoneList.size(),1);
	}
    
    @isTest static void getManagerError(){
        User us = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'TestError'];
        String errorString;
        System.runAs(us){
        Test.startTest();
         try{
            CapComuneClass.initApex();
         }catch(AuraHandledException error){
            errorString = error.getMessage();  
         }
        Test.stopTest();
        System.assertEquals('utente non correttamente configurato',errorString);    
        
        }
    }
	
}