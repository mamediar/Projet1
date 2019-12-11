@isTest
public class XCS_DispositionForAppBuilderApexTest {
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

        if(([SELECT Id FROM Account WHERE OCS_External_Id__c = 'C000']).size()==0){
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
            Account theAccount= new Account(
                LastName = 'test',
				OCS_External_id__c = 'C000',
				FirstName = 'test',
				Data_Nascita__c = Date.today(),
				Luogo_Nascita__pc = 'test',
				Provincia_Nascita__pc = 'test',
				Sesso__pc = 'M',
				Codice_Fiscale__pc = 'tsttst',
				Partita_IVA__pc = 'test',
				PersonMailingStreet = 'test',
				PersonMailingPostalCode = '00010',
				PersonMailingCity = 'test',
				PersonMailingCountry = 'test',
				PersonEmail = 'test@test.com',
				Data_Rilascio__pc = Date.today(),
				Data_Scadenza__pc = Date.today(),
				Telefono_Casa__c = '001234500',
				Telefono_Cellulare__c = '3300123',
				Fax = '3300123',
				Ma_Opt_In__pc = true,
				Privacy_SMS__pc = true,
				Data_Depennamento__c = Date.today(),
				InvestFlag__pc = true,
				Qualitydetectionflag__pc = true,
				Interncommoffer__pc = true,
				Privacy_Profilazione__pc = true,
				Extcommoffer__pc = true,
				OtherService__pc = true,
            	RecordTypeId = recordTypeId);
            insert theAccount;
        }
		if([SELECT Id FROM Case].size()==0){
            //Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Inbound_Call').getRecordTypeId();
            Account acc = [SELECT Id FROM Account WHERE FirstName = 'test'];
            Case c= new Case(
                AccountId = acc.Id,
                Subject = 'TEST',
                Esito__c = 'TEST',
				Note__c= '',
                Status = 'OK'
            );
            insert c;
        }

		if([SELECT Id FROM XCS_Disposition__c].size()==0){

			XCS_Disposition__c disp= new XCS_Disposition__c(
				Name ='TEST2', 
				CaseStatus__c = 'NEW',
				External_Id__c= '1st'
			);
			insert disp;

			XCS_Disposition__c disp2= new XCS_Disposition__c(
				Name ='TEST', 
				CaseStatus__c = 'NEW',
				External_Id__c= '2nd', 
				Parent__c =disp.Id
			);
			XCS_Disposition__c disp3= new XCS_Disposition__c(
				Name ='TEST2', 
				CaseStatus__c = 'NEW',
				External_Id__c= '3rd', 
				Parent__c =disp.Id
			);
			insert new List<XCS_Disposition__c>{disp2,disp3};
		}
    }

	@isTest
	static void updateCaseTest(){
		User u = [SELECT Id FROM User WHERE LastName = 'Test']; 
		XCS_Disposition__c disp= [SELECT Id FROM XCS_Disposition__c where External_Id__c='3rd'];
        Test.startTest();
		System.runAs(u) {
           	Case theCase = [SELECT Id, Esito__c, Status FROM Case];
            XCS_DispositionForAppBuilderApex.updateObject(theCase.Id, theCase.Esito__c, 'TEST', theCase.Status, disp.id);
		}
		Test.stopTest();
		List<Case> cases = [SELECT Id, Esito__c, Status, Note__c FROM Case];

        System.assertEquals(1, cases.size());
		System.assertEquals('TEST', cases[0].Note__c);
	}

	@isTest
	static void getDispositionApexTest(){
		User u = [SELECT Id FROM User WHERE LastName = 'Test']; 
		Map<String, List<XCS_Disposition__c>> result;

        Test.startTest();
		System.runAs(u) {
            result= XCS_DispositionForAppBuilderApex.getDispositionApex('1st');
		}
		Test.stopTest();

        System.assertEquals(2, result.size());
		System.assertEquals(true, result.containsKey('1st'));
	}
}