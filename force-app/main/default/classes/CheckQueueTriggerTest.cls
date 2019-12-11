@isTest
public class CheckQueueTriggerTest {
    
    @isTest
    public static void testBeforeInsert(){
        Group codaTest = new Group();
        codaTest.Type = 'Queue';
        codaTest.Name = 'NameTest';
        codaTest.DeveloperName = 'DeveloperNameTest';
        
        insert codaTest;
        
        CRM_QueueMailFaxConfig__c qmfx = new CRM_QueueMailFaxConfig__c();
        qmfx.Balancing__c = 100;
        qmfx.DeveloperName__c = 'DeveloperNameTest';
        qmfx.MailBox__c = 'Mail@Test';
        qmfx.Name = 'nomeTest';
        qmfx.Type__c = 'fax';
        
        CRM_QueueMailFaxConfig__c qmfxFail = new CRM_QueueMailFaxConfig__c();
        qmfxFail.Balancing__c = 100;
        qmfxFail.DeveloperName__c = 'NonEsistente';
        qmfxFail.MailBox__c = 'Mail@Test';
        qmfxFail.Name = 'nomeTest';
        qmfxFail.Type__c = 'fax';
        
        Boolean caught = false;
        
        Test.startTest();
        insert qmfx;
        try {
            insert qmfxFail;
        } catch (DMLException e) {
            caught = true;
        }
        System.assertEquals(true, caught, 'caught the expected exception');
        
         // Query the newly inserted records
        CRM_QueueMailFaxConfig__c aa2 = [Select Name, DeveloperName__c FROM CRM_QueueMailFaxConfig__c where Id = :qmfx.Id];
        List<CRM_QueueMailFaxConfig__c> nullList = new List<CRM_QueueMailFaxConfig__c>();
        
        // If the trigger works, then DeveloperName__c will only be set on last account
        System.assertEquals(nullList, [Select Name, DeveloperName__c FROM CRM_QueueMailFaxConfig__c where Id = :qmfxFail.Id]);
        System.assertEquals('DeveloperNameTest',aa2.DeveloperName__c);
               
        Test.stopTest();
      
    }    
}