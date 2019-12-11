@isTest
public class GiustificaAttivitaNotaSpeseClassTest {
	
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
            insert utenteMaster;
        }


        if(([SELECT Id FROM Account WHERE OCS_External_Id__c = 'F00-TEST']).size()==0){
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Branch').getRecordTypeId();
            
            Account Venezia= new Account(
                Name= 'VENEZIA', 
                OCS_External_Id__c = 'F00-TEST',
                RecordTypeId = recordTypeId,
                Type = 'FIL'
            );
            insert Venezia;
        }

        if(([SELECT Id FROM Zone__c WHERE Name= 'Venezia']).size()==0){
            Zone__c zona = new Zone__c(
                Name= 'Venezia'
            );
            zona.Branch__r  = new Account(OCS_External_Id__c= 'F00-TEST');
            insert zona;
        }

		//dealer
		if(([SELECT Id FROM Account WHERE OCS_External_Id__c = '00DEALER']).size()==0){
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId();
            Zone__c zona = [SELECT Id FROM Zone__c WHERE Name= 'Venezia'];

            Account dealer = new Account(
                Name = 'Dealer', 
                OCS_External_Id__c = '00DEALER',
                RecordTypeId = recordTypeId,
				Vat_Code__c = '0000000000'
            );
            dealer.Zone__c = zona.Id;
            insert dealer;
        }
        
        if(([SELECT Id FROM SFA_Slot__c]).size()==0){
            Account branch = [SELECT Id FROM Account WHERE OCS_External_Id__c = 'F00-TEST'];
            User utente = [SELECT Id FROM User WHERE LastName= 'Test'];
            Zone__c zona = [SELECT Id FROM Zone__c WHERE Name= 'Venezia'];
            SFA_Slot__c slot = new SFA_Slot__c(
                Date__c= Date.today(),
                Time__c= 'PM',
                Status__c= 'Valido'
            );
            
            slot.Branch__c = branch.Id;
            slot.User__c = utente.Id;
            slot.XCS_Zone__c = zona.Id;
            insert slot;
        }
        
        if(([SELECT Id FROM SFA_NotaSpese__c]).size()==0){
            Account branch = [SELECT Id FROM Account WHERE OCS_External_Id__c = 'F00-TEST'];
            User utente = [SELECT Id FROM User WHERE LastName= 'Test'];
            SFA_NotaSpese__c notaSpese = new SFA_NotaSpese__c(
                Date__c= Date.today(),
                Time__c= 'PM',
                Status__c= 'Aperta'
            );
            
            notaSpese.Branch__c = branch.Id;
            notaSpese.User__c = utente.Id;

            SFA_NotaSpese__c notaSpese2 = new SFA_NotaSpese__c(
                Date__c= Date.today(),
                Time__c= 'AM',
                Status__c= 'Aperta'
            );
            
            notaSpese2.Branch__c = branch.Id;
            notaSpese2.User__c = utente.Id;

            insert new List<SFA_NotaSpese__c>{notaSpese,notaSpese2};
        }
        
        if(([SELECT Id FROM SFA_PianificaAttivita__c]).size()==0){
            Account dealer = [SELECT Id FROM Account WHERE Name = 'Dealer'];
            List<SFA_NotaSpese__c> notaSpese = [SELECT Id FROM SFA_NotaSpese__c WHERE Status__c= 'Aperta'];
            SFA_Slot__c slot = [SELECT Id FROM SFA_Slot__c WHERE Time__c = 'PM'];
            
            SFA_PianificaAttivita__c pa1 = new SFA_PianificaAttivita__c();
            
            pa1.SFA_Nota_Spese__c = notaSpese[0].Id;
            pa1.SFA_Slot__c = slot.Id;
            pa1.Dealer__c = dealer.Id;

            SFA_PianificaAttivita__c pa2 = new SFA_PianificaAttivita__c();
            
            pa2.SFA_Nota_Spese__c = notaSpese[1].Id;
            pa2.SFA_Slot__c = slot.Id;
            pa2.Dealer__c = dealer.Id;

            insert new List<SFA_PianificaAttivita__c>{pa1,pa2};
        }
        
    }
    
    @isTest static void initApexTest() {
        User u = [SELECT Id,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
        GiustificaAttivitaNotaSpeseClass.InitWrapper Wr;
        Test.startTest();
		System.runAs(u) {
            Wr = GiustificaAttivitaNotaSpeseClass.initApex();
		}
		Test.stopTest();
        System.assertEquals(2,Wr.notaSpeseList.size());   
         
	}

    @isTest static void deleteNotaSpeseTest() {
        User u = [SELECT Id,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
        SFA_NotaSpese__c notaSpese = [SELECT Id FROM SFA_NotaSpese__c WHERE Time__c= 'AM'];
        List<SFA_PianificaAttivita__c> paList = [SELECT Id FROM SFA_PianificaAttivita__c WHERE SFA_Nota_Spese__c =: notaSpese.Id];
        GiustificaAttivitaNotaSpeseClass.InitWrapper Wr;
        Test.startTest();
		System.runAs(u) {
            GiustificaAttivitaNotaSpeseClass.deleteNotaSpese(notaSpese,paList);
            Wr = GiustificaAttivitaNotaSpeseClass.initApex();
		}
		Test.stopTest();
        System.assertEquals(1,Wr.notaSpeseList.size());   
         
	}

    @isTest static void initApexWithUserDetailsTest() {
        User u = [SELECT Id,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
        GiustificaAttivitaNotaSpeseClass.branchWrapper branchWr;

        Test.startTest();
		System.runAs(u) {
            branchWr = GiustificaAttivitaNotaSpeseClass.initApexWithUserDetails();
            
		}
		Test.stopTest();
        System.assertEquals(2,branchWr.branchMap.get('F00-TEST').size());   
         
	}
	
}