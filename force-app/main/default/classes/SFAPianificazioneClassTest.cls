@isTest
public class SFAPianificazioneClassTest {

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
                LanguageLocaleKey= 'en_US'
            );
        insert utenteMaster;
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
            insert testSlot;
      }
    }
    @isTest static void initApexTest() {
        User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
        SFAPianificazioneClass.InitWrapper Wr;
        Test.startTest();
		System.runAs(u) {
            Wr = SFAPianificazioneClass.initApex(null);
		}
		Test.stopTest();
        System.assertEquals(1,Wr.WrapperRowList.size());
        System.assertEquals(Date.today(),Wr.targetDate);
	}
    
}