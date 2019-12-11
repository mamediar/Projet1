@isTest
public class GestioneEmailControllerTest {
    
    @isTest
    public static void doInitTest(){ 
        Profile p = [SELECT Id FROM Profile WHERE Name='Call Center Manager'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standt123123223@f.com');
        
        For(Integer i = 1; i <= 10; i++){
            Group g = new Group();
            g.name = 'qx' + i;
            g.type = 'Queue';
            g.DeveloperName = 'qx' + i;
            insert g;
        }
        
        System.runAs(u) {            
            List<CRM_QueueMailFaxConfig__c> queueMailFaxStatic = test.loadData(CRM_QueueMailFaxConfig__c.sObjectType, 'CRM_QueueMailFaxConfigTest');
            List<CRM_QueueMailFaxConfig__c> queueMailFax = GestioneEmailController.doInit();           
        }
    }
    
    @isTest
    public static void checkRecordsTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Call Center Manager'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standt123123223@f.com');
        
        For(Integer i = 1; i <= 10; i++){
            Group g = new Group();
            g.name = 'qx' + i;
            g.type = 'Queue';
            g.DeveloperName = 'qx' + i;
            insert g;
        }
        
        System.runAs(u) {
            
            List<CRM_QueueMailFaxConfig__c> queueMailFaxStatic = test.loadData(CRM_QueueMailFaxConfig__c.sObjectType, 'CRM_QueueMailFaxConfigTest');
            GestioneEmailController.checkRecords(queueMailFaxStatic);
        }
    }
    
}