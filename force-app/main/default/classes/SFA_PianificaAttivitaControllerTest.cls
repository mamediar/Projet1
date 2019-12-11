@isTest
public class SFA_PianificaAttivitaControllerTest {
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

            User monkey = new User(
                FirstName= 'penguin',
                LastName= 'Test1',
                Username= 'test1@compass.com.test',
                Email= 'test1@lynxspa.com',
                Alias= 'test1',
                TimeZoneSidKey= 'Europe/Rome',
                LocaleSidKey= 'it_IT',
                EmailEncodingKey= 'ISO-8859-1',
                ProfileId= p.Id,
                LanguageLocaleKey= 'en_US',
                DefaultQueueId__c= 'F01-TEST'
            );
            List<User> users= new List<User>{utenteMaster, monkey};
            insert users;
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
            theAccount.Zone__c= [SELECT Id FROM Zone__c WHERE Name= 'Mestre' LIMIT 1].Id;
            
            
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
            theAccount2.Zone__c= [SELECT Id FROM Zone__c WHERE Name= 'Mestre' LIMIT 1].Id;

            theAccount3= new Account();
            theAccount3.Name = 'test2';
            theAccount3.OCS_External_id__c = 'C0002';
            theAccount3.Data_Nascita__c = Date.today();
            theAccount3.Telefono_Casa__c = '0012345002';
            theAccount3.Telefono_Cellulare__c = '33001232';
            theAccount3.Fax = '3300123';
            theAccount3.Data_Depennamento__c = Date.today();
            theAccount3.RecordTypeId = recordTypeId;
            theAccount3.Zone__c= [SELECT Id FROM Zone__c WHERE Name= 'Mestre' LIMIT 1].Id;
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
        if(([SELECT Id FROM SFA_Slot__c WHERE Name= 'TEST']).size()==0){
            User u= [SELECT Id, DefaultQueueId__c FROM User WHERE LastName = 'Test'];
            String zoneId= [SELECT Id FROM Zone__c WHERE Name= 'Mestre' LIMIT 1].Id;
            SFA_Slot__c slot= new SFA_Slot__c(Date__c= Date.today() , Name='TEST', User__c=u.Id, XCS_Zone__c= zoneId, Time__c= 'AM');
            SFA_Slot__c slotx= new SFA_Slot__c(Date__c= Date.today()+1 , Name='TESTx', User__c=u.Id, XCS_Zone__c= zoneId, Time__c='PM');
            List<SFA_Slot__c> slots=new List<SFA_Slot__c>{slot, slotx};
            insert slots;
        }
        if(([SELECT Id FROM SFA_PianificaAttivita__c WHERE Dealer__r.LastName= 'test']).size()==0){
            
            SFA_Slot__c slot=[SELECT Id FROM SFA_Slot__c WHERE Name= 'TEST'];
            SFA_PianificaAttivita__c act= new SFA_PianificaAttivita__c();
            act.Dealer__c= theAccount.Id;
            act.SFA_Slot__c= slot.Id;

            SFA_PianificaAttivita__c actx= new SFA_PianificaAttivita__c();
            act.Dealer__c= theAccount3.Id;
            act.SFA_Slot__c= slot.Id;

            List<SFA_PianificaAttivita__c>  acts=new List<SFA_PianificaAttivita__c>{act, actx};
            insert acts;
        }
    }
    @isTest
    static void initApexTest(){
        User u = [SELECT Id, DefaultQueueId__c FROM User WHERE LastName = 'Test'];
        SFA_Slot__c slot=[SELECT Id, XCS_Zone__c, User__c,Name,Date__c,Time__c FROM SFA_Slot__c WHERE Name= 'TEST'];
        Test.startTest();
		System.runAs(u) {
            SFA_PianificaAttivitaController.InitWrapper Wr=SFA_PianificaAttivitaController.initApex(slot);
            System.debug(Wr + '@@@@@@@@@@@@@@@@@@@');
            System.assertEquals(2,Wr.dealers.size());
            System.assertEquals(1,Wr.dealersPianificati.size());
            System.assertEquals(1,Wr.otherSlots.size());
            
        }
        Test.stopTest();
    }

    @isTest
    static void pianificaAttivitaTest(){
        User u = [SELECT Id, DefaultQueueId__c FROM User WHERE LastName = 'Test'];
        List<Account> accList=[SELECT Id, OCS_External_Id__c FROM Account WHERE Name ='testx'];
        SFA_Slot__c slot=[SELECT Id, XCS_Zone__c, User__c,Name,Date__c,Time__c,Branch__c FROM SFA_Slot__c WHERE Name= 'TEST'];

        Test.startTest();
		System.runAs(u) {
            SFA_PianificaAttivitaController.PianificaAttivita(slot, accList);
            SFA_PianificaAttivitaController.InitWrapper Wr=SFA_PianificaAttivitaController.initApex(slot);
            System.debug(Wr + '@@@@@@@@@@@@@@@@@@@');
            System.assertEquals(0,Wr.dealers.size());
            System.assertEquals(3,Wr.dealersPianificati.size());
            System.assertEquals(1,Wr.otherSlots.size());

        }
        Test.stopTest();
    }

    @isTest
    static void removePianificaAttivitaTest(){
        User u = [SELECT Id, DefaultQueueId__c FROM User WHERE LastName = 'Test'];
        List<SFA_PianificaAttivita__c> actx=[SELECT Id FROM SFA_PianificaAttivita__c WHERE Dealer__r.LastName= 'test2'];
        SFA_Slot__c slot=[SELECT Id, Branch__c, User__c, Date__c, Time__c, Status__c FROM SFA_Slot__c WHERE Name= 'TEST'];
        Test.startTest();
		System.runAs(u) {
            SFA_PianificaAttivitaController.RemovePianificaAttivita(actx, slot);
            List<SFA_PianificaAttivita__c> empty=[SELECT Id FROM SFA_PianificaAttivita__c WHERE Dealer__r.LastName= 'test2'];
            System.assertEquals(0,empty.size());
        }
        Test.stopTest();
    } 

}