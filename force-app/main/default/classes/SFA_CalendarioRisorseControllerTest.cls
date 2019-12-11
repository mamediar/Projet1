@isTest
public class SFA_CalendarioRisorseControllerTest {
 private static Date myDate = Date.newInstance(2019, 3, 11);
    
	@TestSetup
    static void setup(){
        if(([SELECT Id FROM User WHERE LastName= 'Test']).size()==0){
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
            User utente3 = new User(
                FirstName= 'Test3',
                LastName= 'Test3',
                Username= 'test3@compass.com.test',
                Email= 'test3@lynxspa.com',
                Alias= 'test3',
                TimeZoneSidKey= 'Europe/Rome',
                LocaleSidKey= 'it_IT',
                EmailEncodingKey= 'ISO-8859-1',
                ProfileId= p.Id,
                LanguageLocaleKey= 'en_US',
                DefaultQueueId__c= 'F01-TEST'
            );
            User utenteSolitario = new User(
                FirstName= 'TestS',
                LastName= 'TestS',
                Username= 'testS@compass.com.test',
                Email= 'testS@lynxspa.com',
                Alias= 'testS',
                TimeZoneSidKey= 'Europe/Rome',
                LocaleSidKey= 'it_IT',
                EmailEncodingKey= 'ISO-8859-1',
                ProfileId= p.Id,
                LanguageLocaleKey= 'en_US',
                DefaultQueueId__c= 'F00S-TEST'
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
            insert new List<User>{utenteMaster,utente1,utente2,utente3,utenteSolitario,utenteError};
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

            Account Rovigo= new Account(
                Name= 'ROVIGO', 
                OCS_External_Id__c = 'F00S-TEST',
                RecordTypeId = recordTypeId
            );
            insert Rovigo;
        }
        
        if(([SELECT Id FROM SFA_Slot__c]).size()==0){
            User u = [SELECT Id FROM User WHERE LastName = 'Test'];
            SFA_Slot__c testSlot= new SFA_Slot__c(
                Type__c = 'B',
                Status__c = 'Valido',
                Date__c = Date.today(),
                Time__c = 'AM',
                User__c = u.Id
            );
            testSlot.Branch__r = new Account(OCS_External_Id__c = 'F00-TEST');
            insert testSlot;
        }
        
        if(([SELECT Id FROM SFA_Assenza_Prolungata__c]).size()==0){
            User u = [SELECT Id FROM User WHERE LastName = 'Test'];
            SFA_Assenza_Prolungata__c Assenza= new SFA_Assenza_Prolungata__c(
                RisorsaFiliale__c = u.Id,
                StartDate__c = Date.today(),
                EndDate__c  = Date.today(),
                MotivazioneAssenza__c = 'Appoggio' 
            );
            insert Assenza;
        }
        
        if(([SELECT Id FROM Zone__c]).size()==0){
            Zone__c zonaMestre= new Zone__c(
                Name= 'MESTRE'
            );
            zonaMestre.Branch__r = new Account(OCS_External_Id__c = 'F00-TEST');
           
            Zone__c zonaMarghera= new Zone__c(
                Name= 'MARGHERA'
            );
            zonaMarghera.Branch__r = new Account(OCS_External_Id__c = 'F00-TEST');
            insert new List<Zone__c>{zonaMestre,zonaMarghera};
        }
    }

    @isTest 
    public static void initApexTest() {
        User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
		Test.startTest();
        SFA_CalendarioRisorseController.InitWrapper Wr;
		System.runAs(u) {
			Wr = SFA_CalendarioRisorseController.initApex();
			System.assertEquals(Wr.manager.FirstName,'Test');   
            System.assertEquals(Wr.filialistiPerFiliale.size(),2);
            System.assertEquals(Wr.slotList.size(),1);
            System.assertEquals(Wr.assenzeProlungateList.size(),1);
            System.assertEquals(Wr.branches.size(),2);
		}
		Test.stopTest();
	}

    @isTest 
    public static void changeTargetDateTest() {
        User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
        Date myDate = Date.today();
        Test.startTest();
		System.runAs(u) {
		SFA_CalendarioRisorseController.InitWrapper initWr = SFA_CalendarioRisorseController.initApex();
        SFA_CalendarioRisorseController.InitWrapper changerWr = SFA_CalendarioRisorseController.changeTargetDate(myDate.addDays(1),initWr.manager,initWr.filialistiPerFiliale);
			System.assertEquals(changerWr.targetDate,myDate.addDays(1));
		}
		Test.stopTest();
	}

    @isTest
    public static void getFilialistiPerFilialeTest(){
         User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
        Test.startTest();
		System.runAs(u) {
            User manager= pianificaSlotController.getManager();
            List<Account> branches= pianificaSlotController.getBranches(manager);
            Map<String, List<User>> filialistiPerFiliale= SFA_CalendarioRisorseController.getFilialistiPerFiliale(manager, branches);
            System.assertEquals(true, filialistiPerFiliale.containsKey('F00-TEST'));
            System.assertEquals(true, filialistiPerFiliale.containsKey('F01-TEST'));
            System.assertEquals(2, filialistiPerFiliale.size());
        }
        Test.stopTest();
    }
    @isTest
    public static void getFilialistiPerFilialeTestSolitario(){
         User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'TestS'];
        Test.startTest();
		System.runAs(u) {
            User manager= pianificaSlotController.getManager();
            List<Account> branches= pianificaSlotController.getBranches(manager);
            Map<String, List<User>> filialistiPerFiliale= SFA_CalendarioRisorseController.getFilialistiPerFiliale(manager, branches);
            System.assertEquals(true, filialistiPerFiliale.containsKey('F00S-TEST'));
            /*System.assertEquals(2, filialistiPerFiliale.size());
            System.debug(filialistiPerFiliale + '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');*/
        }
        Test.stopTest();
    }

}