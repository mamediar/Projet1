@isTest
public class CRM_EasyCM_Research_ControllerApexTest {
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
				Data_Nascita__c = Date.newInstance(2019,4,3),
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
    }

    @isTest
    static void searchAccountsTest(){
        User u = [SELECT Id FROM User WHERE LastName = 'Test'];
        Map<String,String> inputWrapper=new Map<String,String>{};
        inputWrapper.put('FirstName','test');
        inputWrapper.put('LastName','test');
        inputWrapper.put('Data_Nascita','2019-04-03');
        inputWrapper.put('Codice_Fiscale','tsttst');
        inputWrapper.put('Telefono_Casa','001234500');
        inputWrapper.put('OCS_External_Id','C000');
        Test.startTest();
        Account acc;
		System.runAs(u) {
            acc= CRM_EasyCM_Research_ControllerApex.searchAccounts(inputWrapper)[0];
        }
        System.assertEquals('test',acc.FirstName);
    }
}