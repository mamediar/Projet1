@isTest
public class XCS_TabMenuControllerTest {
	@TestSetup
    static void setup(){
        if(([SELECT Id FROM User WHERE LastName= 'Test']).size()==0){ 
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User testerUser = new User(
                FirstName= 'Test',
                LastName= 'Test',
                Username= 'tst@compass.com',
                Email= 'test@lynxspa.com',
                Alias= 'testaaa',
                TimeZoneSidKey= 'Europe/Rome',
                LocaleSidKey= 'it_IT',
                EmailEncodingKey= 'ISO-8859-1',
                LanguageLocaleKey= 'en_US',
                DefaultQueueId__c= 'F106',
                ProfileId= p.Id
            );
    	insert testerUser;
        }
	}
    @isTest
    public static void TestDoInitApex(){
        User manager = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
        List<XCS_Tab_Menu_Config_Item__mdt> result;
        Test.startTest();
        System.runAs(manager){
            result= XCS_TabMenuController.doInitApex('TestTab');
        }
        System.assertEquals(3, result.size());
        Test.stopTest();
    }
}