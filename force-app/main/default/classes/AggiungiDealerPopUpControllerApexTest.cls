@isTest
private class AggiungiDealerPopUpControllerApexTest {
	
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

		if(([SELECT Id FROM Account WHERE OCS_External_Id__c = 'F00-TEST' AND RecordType.Name = 'Branch']).size()==0){
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Branch').getRecordTypeId();
            Account theAccount= new Account(
                Name = 'test',
				OCS_External_id__c = 'F00-TEST',
				Data_Nascita__c = Date.newInstance(2019,4,3),
				Telefono_Casa__c = '001234500',
				Telefono_Cellulare__c = '3300123',
				Fax = '3300123',
				Data_Depennamento__c = Date.today()
            	);
                theAccount.RecordTypeId = recordTypeId;
            insert theAccount;
        }

		if(([SELECT Id FROM Zone__c WHERE Branch__r.OCS_External_Id__c = 'F00-TEST']).size()==0){
			Account acc=[SELECT Id, OCS_External_Id__c FROM Account WHERE OCS_External_Id__c = 'F00-TEST' AND RecordType.Name = 'Branch'];
            Zone__c VeneziaZone = new Zone__c(
                Name= 'Venezia',
				Branch__c= acc.Id
            );
			insert VeneziaZone;
		}
        
        if(([SELECT Id FROM Account WHERE OCS_External_Id__c = 'F00-TEST' AND RecordType.Name = 'Dealer']).size()==0){
			Zone__c zona=[SELECT Id FROM Zone__c WHERE Branch__r.OCS_External_Id__c= 'F00-TEST'];
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId();
			Account branchAccount=[SELECT Id, OCS_External_Id__c FROM Account WHERE OCS_External_Id__c = 'F00-TEST' AND RecordType.Name = 'Branch'];
            Account theAccount= new Account(
                Name = 'test',
				Zone__c= zona.Id,
				OCS_External_id__c = 'F01-TEST',
				shippingStreet = 'test',
				shippingCity = 'test',
				Vat_Code__c = 'F01-TEST',
				FiscalCode__c = 'F01-TEST',
				ParentId= branchAccount.Id
            	);
                theAccount.RecordTypeId = recordTypeId;
            insert theAccount;
        }

	}

	@isTest 
	static void searchDealersTest() {
		User utenteMaster=[SELECT Id FROM User WHERE DefaultQueueId__c = 'F00-TEST'];
		List<Account> accountsFetched;
		Test.startTest();
        System.runAs(utenteMaster){		
			accountsFetched=AggiungiDealerPopUpControllerApex.searchDealers('F01-TEST','test');
		}
		test.stopTest();
		System.assertEquals(1 ,accountsFetched.size());
	}
	
	
	
}