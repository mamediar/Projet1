@isTest
public class AssenzaProlungataControllerTest {

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
            User utente1 = new User(
                FirstName= 'Test1',
                LastName= 'Test1',
                Username= 'test1@compass.com.test',
                Email= 'test1@lynxspa.com',
                Alias= 'test1',
                TimeZoneSidKey= 'Europe/Rome',
                LocaleSidKey= 'it_IT',
                EmailEncodingKey= 'ISO-8859-1',
                ProfileId= p.Id,
                LanguageLocaleKey= 'en_US',
                DefaultQueueId__c= 'F00-TEST'
            );
            User utente2 = new User(
                FirstName= 'Test2',
                LastName= 'Test2',
                Username= 'test2@compass.com.test',
                Email= 'test2@lynxspa.com',
                Alias= 'test2',
                TimeZoneSidKey= 'Europe/Rome',
                LocaleSidKey= 'it_IT',
                EmailEncodingKey= 'ISO-8859-1',
                ProfileId= p.Id,
                LanguageLocaleKey= 'en_US',
                DefaultQueueId__c= 'F01-TEST'
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
            insert new List<User>{utenteMaster,utente1,utente2,utenteError};
        }
        if(([SELECT Id FROM Account WHERE OCS_External_Id__c = 'F00-TEST']).size()==0){
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Branch').getRecordTypeId();
            
            Account Venezia= new Account(
                Name= 'VENEZIA', 
                OCS_External_Id__c = 'F00-TEST',
                RecordTypeId = recordTypeId
            );
            insert Venezia;

            Account Padova= new Account(
                Name= 'VENEZIA SUCCURSALE', 
                OCS_External_Id__c = 'F01-TEST',
                RecordTypeId = recordTypeId
            );
            Padova.Parent = new Account(OCS_External_Id__c = 'F00-TEST');
            insert Padova;
        }
        if(([SELECT Id FROM SFA_Assenza_Prolungata__c]).size()==0){
            User u = [SELECT Id FROM User WHERE LastName = 'Test'];
            SFA_Assenza_Prolungata__c Assenza1= new SFA_Assenza_Prolungata__c(
                RisorsaFiliale__c = u.Id,
                StartDate__c = Date.today().addDays(-1),
                EndDate__c  = Date.today().addDays(1),
                MotivazioneAssenza__c = 'Appoggio' 
            );
            SFA_Assenza_Prolungata__c Assenza2= new SFA_Assenza_Prolungata__c(
                RisorsaFiliale__c = u.Id,
                StartDate__c = Date.today(),
                EndDate__c  = Date.today(),
                MotivazioneAssenza__c = 'Maternità' 
            );
            insert new List<SFA_Assenza_Prolungata__c>{Assenza1,Assenza2};
        }
        
    }
    
    @isTest static void initApexTest() {
        User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
        AssenzaProlungataController.InitWrapper Wr;
        Test.startTest();
		System.runAs(u) {
            Wr = AssenzaProlungataController.initApex();
		}
		Test.stopTest();
        System.assertEquals(2,Wr.branches.size());   
        System.assertEquals(2,Wr.filialistiPerFiliale.size()); 
        System.assertEquals(1,Wr.assenzePerFiliale.size());
	}
    
    @isTest static void upsertAssenzaApexTest() {
        User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
		SFA_Assenza_Prolungata__c Assenza = [SELECT Id,MotivazioneAssenza__c,RisorsaFiliale__c,StartDate__c,EndDate__c FROM SFA_Assenza_Prolungata__c LIMIT 1];
        Test.startTest();
		System.runAs(u) {
            Assenza.MotivazioneAssenza__c = 'Maternità'; 
            Map<String,String> messaggioTest = AssenzaProlungataController.upsertAssenzaApex(Assenza, 'F00-TEST');
            System.assertEquals('false',messaggioTest.get('isError'));
		}
		Test.stopTest();
	}
    
    @isTest static void deleteAssenzaApexTest() {
        User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
		SFA_Assenza_Prolungata__c Assenza = [SELECT Id FROM SFA_Assenza_Prolungata__c LIMIT 1];
        Test.startTest();
		System.runAs(u) {
            AssenzaProlungataController.deleteAssenzaApex(Assenza);
            List<SFA_Assenza_Prolungata__c> assenzeList = [SELECT Id FROM SFA_Assenza_Prolungata__c];
            System.assertEquals(1,assenzeList.size());
		}
		Test.stopTest();
	}
    
    @isTest static void upsertAssenzaApexErrorTest() {
        User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
        Account acc= [SELECT Id FROM Account WHERE Name= 'VENEZIA'];
        SFA_Slot__c slot = new SFA_Slot__c(User__c = u.Id,Date__c = date.today(),Branch__c = acc.Id);
		insert slot;
        Test.startTest();
		System.runAs(u) {
            SFA_Assenza_Prolungata__c Assenza = [SELECT Id,MotivazioneAssenza__c,RisorsaFiliale__c,StartDate__c,EndDate__c FROM SFA_Assenza_Prolungata__c LIMIT 1];
            Map<String,String> messaggioTest = AssenzaProlungataController.upsertAssenzaApex(Assenza, 'F00-TEST');
            System.assertEquals('true',messaggioTest.get('isError'));
		}
		Test.stopTest();
        delete slot;
	}
    
    @isTest static void getManagerError(){
        User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'TestError'];
        String errorString;
        System.runAs(u){
        Test.startTest();
         try{
            AssenzaProlungataController.getManager();   
         }catch(AuraHandledException error){
            errorString = error.getMessage();  
         }
        Test.stopTest();
        System.assertEquals('utente non correttamente configurato',errorString);    
        
        }
    } 
}