@isTest
private class GestioneZoneClassTest {
	
    @TestSetup
    static void setup(){   
        if(([SELECT Id FROM User WHERE DefaultQueueId__c = 'F00-TEST']).size()==0){
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

            Account Padova= new Account(
                Name= 'VENEZIA SUCCURSALE', 
                OCS_External_Id__c = 'F01-TEST',
                RecordTypeId = recordTypeId,
                Type= 'SUC'
            );
            Padova.Parent = new Account(OCS_External_Id__c = 'F00-TEST');
            insert Padova;
        }
        
        if(([SELECT Id FROM Zone__c WHERE Branch__r.OCS_External_Id__c = 'F00-TEST']).size()==0){
            Zone__c zona1 = new Zone__c(
                Name= 'Mestre'
            );
            zona1.Branch__r  = new Account(OCS_External_Id__c= 'F00-TEST');
            
            Zone__c zona2 = new Zone__c(
                Name= 'Marghera'
            );
            zona2.Branch__r  = new Account(OCS_External_Id__c= 'F00-TEST');
            
            Zone__c zona3 = new Zone__c(
                Name= 'Marcon'
            );
            zona3.Branch__r  = new Account(OCS_External_Id__c= 'F01-TEST');
            
            insert new List<Zone__c>{zona1,zona2,zona3};
        }
    }
    
    @isTest static void initApexTest() {
        User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
        GestioneZoneClass.InitWrapper Wr;
        Test.startTest();
		System.runAs(u) {
            Wr = GestioneZoneClass.initApex();
		}
		Test.stopTest();
        System.assertEquals(2,Wr.branchList.size());   
        System.assertEquals(2,Wr.ZonePerFiliale.size()); 
	}
    

    
    
	@isTest static void upsertZoneTest() {
		User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
        Map<String, List<Zone__c>> listaNew;
        List<Zone__c> listaDeleted;		
		
        Test.startTest();
		System.runAs(u) {

			Zone__c zonaNew = new Zone__c(Name = 'NuovaZona');
            zonaNew.Branch__r  = new Account(OCS_External_Id__c= 'F00-TEST');
			List<Zone__c> zoneToUpster = new List<Zone__c>{zonaNew};
			List<Zone__c> zoneToDel = [SELECT Id,Name,Branch__c,OCS_External_Id__c FROM Zone__c WHERE Name = 'Marcon'];
			GestioneZoneClass.upsertZone(zoneToUpster,zoneToDel);
            List<Account> branchList = [SELECT Id,Name,toLabel(Type) TypeLabel,OCS_External_Id__c FROM Account];
			listaNew = GestioneZoneClass.getZonePerFiliale(branchList);
			listaDeleted = [SELECT Id,Name,Branch__c,OCS_External_Id__c FROM Zone__c WHERE Name = 'zona2'];
		}
		Test.stopTest();
		System.assertEquals(1,listaNew.size());
		System.assertEquals(true,listaDeleted.isEmpty());
	}
    
    @isTest static void getManagerError(){
        User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'TestError'];
        String errorString;
        System.runAs(u){
        Test.startTest();
         try{
            GestioneZoneClass.getManager();   
         }catch(AuraHandledException error){
            errorString = error.getMessage();  
         }
        Test.stopTest();
        System.assertEquals('utente non correttamente configurato',errorString);    
        
        }
    }

}