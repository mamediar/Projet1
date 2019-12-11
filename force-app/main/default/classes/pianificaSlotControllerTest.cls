@isTest
public class pianificaSlotControllerTest {
    
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
            insert new List<User>{utenteMaster,utente1,utente2,utente3,utenteError};
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

        Account theAccount;
        Account theAccount2;
        Account theAccount3;
        if(([SELECT Id FROM Account WHERE OCS_External_Id__c = 'C000']).size()==0){
            Zone__c zona = new Zone__c(
                Name= 'Mestre'
            );
            insert zona;
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId();
            theAccount= new Account();
            theAccount.Name = 'testx';
            theAccount.OCS_External_id__c = 'C000';
            theAccount.Data_Nascita__c = Date.today();
            theAccount.Telefono_Casa__c = '001234500';
            theAccount.Telefono_Cellulare__c = '3300123';
            theAccount.Fax = '3300123';
            theAccount.Data_Depennamento__c = Date.today();
            theAccount.RecordTypeId = recordTypeId;
            theAccount.Zone__c= [SELECT Id FROM Zone__c WHERE Name= 'MESTRE' LIMIT 1].Id;
            
            
            theAccount2= new Account();
            theAccount2.Name = 'testx';
            theAccount2.OCS_External_id__c = 'C0001';
            theAccount2.Data_Nascita__c = Date.today();
            theAccount2.Telefono_Casa__c = '0012345001';
            theAccount2.Telefono_Cellulare__c = '33001231';
            theAccount2.Fax = '3300123';
            theAccount2.Data_Depennamento__c = Date.today();
            theAccount2.RecordTypeId = recordTypeId;
            System.debug(theAccount2.RecordTypeId);
            theAccount2.Zone__c= [SELECT Id FROM Zone__c WHERE Name= 'MESTRE' LIMIT 1].Id;

            theAccount3= new Account();
            theAccount3.Name = 'test2';
            theAccount3.OCS_External_id__c = 'C0002';
            theAccount3.Data_Nascita__c = Date.today();
            theAccount3.Telefono_Casa__c = '0012345002';
            theAccount3.Telefono_Cellulare__c = '33001232';
            theAccount3.Fax = '3300123';
            theAccount3.Data_Depennamento__c = Date.today();
            theAccount3.RecordTypeId = recordTypeId;
            theAccount3.Zone__c= [SELECT Id FROM Zone__c WHERE Name= 'MARGHERA' LIMIT 1].Id;
            List<Account> accountList = new List<Account>{theAccount, theAccount2, theAccount3};
            insert accountList;
        }

        if(([SELECT Id FROM Case WHERE Status = 'New']).size()==0){
            Case c=new Case(Status='New', Note__c='TEST', AccountId= theAccount.id);
            Case c2=new Case(Status='New', Note__c='TEST1', AccountId= theAccount2.id);
            Case c3=new Case(Status='New', Note__c='TEST2', AccountId= theAccount3.id);
            List<Case> cases= new List<Case> {c, c2, c3};
            insert cases;
        }

        if(([SELECT Id FROM XCS_Desk__c]).size()==0){
            Account branch = [SELECT Id,OCS_External_Id__c,Name,RecordTypeId,OCSAreaId__c,Type FROM Account WHERE OCS_External_Id__c = 'F00-TEST'];    
        
            XCS_Desk__c desk1 = new XCS_Desk__c(
                Branch__c = branch.Id,
			    isActive__c = true,
			    DeskName__c = 'Desk1'
            );

            XCS_Desk__c desk2 = new XCS_Desk__c(
                Branch__c = branch.Id,
			    isActive__c = true,
			    DeskName__c = 'Desk2'
            );

            insert new List<XCS_Desk__c>{desk1,desk2};
        }

		if(([SELECT Id FROM XCS_Appointment__c]).size()==0){
			XCS_Desk__c desk = [SELECT Id,Branch__c,DeskName__c,isActive__c FROM XCS_Desk__c WHERE DeskName__c = 'Desk1'];    
            Account branch = [SELECT Id,OCS_External_Id__c,Name,RecordTypeId,OCSAreaId__c,Type FROM Account WHERE OCS_External_Id__c = 'F00-TEST'];    

            XCS_Appointment__c appuntamento = new XCS_Appointment__c(
				XCS_Desk__c = desk.Id,
                Branch__c = branch.Id,
				Type__c = 'App',
                Date__c = Date.today()
			);

			XCS_Appointment__c appuntamento2 = new XCS_Appointment__c(
				XCS_Desk__c = desk.Id,
                Branch__c = branch.Id,
				Type__c = 'App',
				Date__c = Date.today()
			);

            insert new List<XCS_Appointment__c>{appuntamento,appuntamento2};
        }
    }
    
    @isTest static void initApexTest() {
        User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
		Test.startTest();
        pianificaSlotController.InitWrapper Wr;
		System.runAs(u) {
			Wr = pianificaSlotController.initApex();
			System.assertEquals(Wr.manager.FirstName,'Test');   
            System.assertEquals(Wr.filialistiPerFiliale.size(),2);
            System.assertEquals(Wr.slotList.size(),1);
            System.assertEquals(Wr.assenzeProlungateList.size(),1);
            System.assertEquals(Wr.branches.size(),2);
		}
		Test.stopTest();
	}
    
    @isTest static void changeTargetDateTest() {
        User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
        Date myDate = Date.today();
        Test.startTest();
		System.runAs(u) {
		pianificaSlotController.InitWrapper initWr = pianificaSlotController.initApex();
        pianificaSlotController.InitWrapper changerWr = pianificaSlotController.changeTargetDate(myDate.addDays(1),initWr.manager,initWr.filialistiPerFiliale);
        
			System.assertEquals(changerWr.targetDate,myDate.addDays(1));
		}
		Test.stopTest();
	}
    
    @isTest static void InitWeekDaysTest(){
        User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
        System.runAs(u){
        Test.startTest();
        List<pianificaSlotController.DataWrapper> weekDays= pianificaSlotController.initWeekDays(pianificaSlotControllerTest.myDate);
        Test.stopTest();
        System.assertEquals(pianificaSlotControllerTest.myDate, weekDays[0].theDate);
        System.assertEquals((pianificaSlotControllerTest.myDate).addDays(1), weekDays[1].theDate);
        System.assertEquals((pianificaSlotControllerTest.myDate).addDays(5), weekDays[5].theDate);
        }
    }

  	@isTest static void saveSlotsApexDaysTest(){
        User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
        System.runAs(u){
        Test.startTest();
        List<SFA_Slot__c> newSlotList = [SELECT Id,Type__c FROM SFA_Slot__c LIMIT 1];
        newSlotList[0].Type__c = 'F';
        List<SFA_Slot__c> slotList = pianificaSlotController.saveSlotsApex(newSlotList,null);    
        System.assertEquals(slotList[0].Type__c,'F');    
        Test.stopTest();
        }
    }
    
    @isTest static void deleteSlotsApexDaysTest(){
        User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
        System.runAs(u){
        Test.startTest();
        List<SFA_Slot__c> deleteSlotList = [SELECT Id,Type__c FROM SFA_Slot__c LIMIT 1];
        pianificaSlotController.saveSlotsApex(null,deleteSlotList);   
        List<SFA_Slot__c> newDeleteSlotList = [SELECT Id,Type__c FROM SFA_Slot__c];        
        System.assertEquals(newDeleteSlotList.isEmpty(),true);    
        Test.stopTest();
        }
    }
    
    @isTest static void getZonePerFilialeTest(){
        User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
        List<Zone__c> zoneToVerify = [SELECT Id,Name,Branch__c FROM Zone__c LIMIT 1];
        System.runAs(u){
        Test.startTest();
        pianificaSlotController.InitWrapper initWr = pianificaSlotController.initApex();
        Map<String, List<Zone__c>> zonePerFiliale = pianificaSlotController.getZonePerFiliale(initWr.branches);          
        //System.assertEquals(zonePerFiliale.get('F59'),zoneToVerify;
        System.assertEquals(zonePerFiliale.get('F00-TEST')[0].Id,zoneToVerify[0].Id);    
        Test.stopTest();
        }
    }
    
    @isTest static void getManagerError(){
        User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'TestError'];
        String errorString;
        System.runAs(u){
        Test.startTest();
         try{
            pianificaSlotController.getManager();   
         }catch(AuraHandledException error){
            errorString = error.getMessage();  
         }
        Test.stopTest();
        System.assertEquals('utente non correttamente configurato',errorString);    
        
        }
    }

    @isTest static void getCaseOpenOnZoneTest(){
        User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'TestError'];
        List<Zone__c> zoneList = [SELECT Id FROM Zone__c];
        Map<String,List<Account>> caseOpenMap = new Map<String,List<Account>>();
       
        System.runAs(u){
        Test.startTest();
            List<string> idStringList= new List<string> ();

            for(Zone__c a:zoneList){
                idStringList.add(String.valueOf(a.Id));
            }

            caseOpenMap = pianificaSlotController.getCaseOpenOnZone(idStringList);   

        Test.stopTest();        
        }
        System.assertEquals(2,caseOpenMap.get('MESTRE').size());    

    }
}