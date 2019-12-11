@isTest
public class CaseUtilsTest {
    
    @TestSetup
    public static void setup()
    {
        Case c = new Case();
        c.Status = 'New';
        c.Subject = 'Test';
        c.Esito__c='Esit';
        
        Group g = new Group();
        g.Name = 'TestName';
        g.DeveloperName = 'devTest';
        g.Type = 'queue';
        
        insert g; 
        
        User u = new User(); 
        
        u.DefaultQueueId__c = g.DeveloperName;
        /*TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey*/
        u.Username = 'Giu@k.k';
        u.LastName='Seppe';
        u.Email='sij@iol.io';
        u.CommunityNickname='sid';
        u.TimeZoneSidKey='Europe/Rome';
        u.LocaleSidKey='it';
        u.EmailEncodingKey='UTF-8';
        u.ProfileId=[SELECT Id FROM Profile WHERE Name='System Administrator'].Id;
        u.LanguageLocaleKey='it';
        u.Alias='df';
        
        insert u;
 
        System.runAs(u)
        {      
            insert c;  
            
        }
        QueuesObject queObj = new QueueSObject(QueueId = g.id, SObjectType = 'Case');
        System.runAs(new User(Id=UserInfo.getUserId()))
        {      
            insert queObj;  
        }
    }
    
    @isTest
    public static void changeStatusTest()
    {
        Case c = [Select Id,Status from Case Where Subject ='Test'];
        CaseUtils.changeStatus(c.Id,'Closed');
        c = [Select Id,Status from Case Where Subject ='Test'];
        system.assert(c.Status == 'Closed');
        
    }
    @isTest
    public static void closeCaseTest()
    {
        Case c = [Select Id,Status from Case Where Subject ='Test'];
        CaseUtils.closeCase(c.Id);
        c = [Select Id,Status from Case Where Subject ='Test'];
        system.assert(c.Status == 'Closed');
    }
    @isTest
    public static void checkStatusTest()
    {
        Case c = [Select Id,Status from Case Where Subject ='Test'];
        system.assert(CaseUtils.checkStatus(c.Id,'New'));
        
    }
    
    @isTest
    public static void testEsitaCase() {
        Case c = [SELECT Id,Esito__c FROM Case WHERE Subject='Test'];
        CaseUtils.esitaCase(c.Id, c.Esito__c);
       	CaseUtils.esitaCase(c.Id, c.Esito__c,'');
        c = [SELECT Id,Esito__c FROM Case WHERE Subject='Test'];
        System.assert(c.Esito__c == 'Esit'); 
    }
    
    @isTest
    public static void testAssignToQueue() { 
        
        Group gro = [SELECT Id,DeveloperName FROM Group WHERE DeveloperName = 'devTest' and type='queue'];
        
        Case c = [ SELECT Id,OwnerId FROM Case WHERE Subject = 'Test'];
        CaseUtils.assignToQueue(c.Id, 'devTest');
        c=[ SELECT Id,OwnerId FROM Case WHERE Subject = 'Test'];
        System.debug('OWNER ID: ' + c.OwnerId + ' QUQUEId: ' + gro.Id);
        
        System.assert(c.OwnerId==gro.Id); 
    }
    
    @isTest
    public static void testAssignToQueueParent() {
        
        Case c=[ SELECT Id,OwnerId FROM Case WHERE Subject = 'Test'];
        Group g = [SELECT Id, DeveloperName FROM Group WHERE Name = 'TestName' and type='queue'];
        
        CaseUtils.assignToParentQueue(c.Id);
        
        
    }
    
    @isTest
    public static void testGetFlagCarte(){
        CaseUtils.getFlagCarte([Select Id,Status from Case Where Subject ='Test'].Id);
    }
    
    @isTest
    public static void testGetEsito(){
        CaseUtils.getEsito([Select Id,Status from Case Where Subject ='Test'].Id);
    }
    
    @isTest
    public static void testGetOwnerName(){
        CaseUtils.getOwnerName([Select Id,Status from Case Where Subject ='Test'].Id);
    }
    
    @isTest
    public static void testUpdateListCase(){
        CaseUtils.updateListCase(new List<Case>());
    }
    
    @isTest
    public static void testGetOCSIdAccount(){
        CaseUtils.getOCSIdAccount([Select Id,Status from Case Where Subject ='Test'].Id);
    }
    
    @isTest
    public static void testGetCaseNumber(){
        CaseUtils.getCaseNumber([Select Id,Status from Case Where Subject ='Test'].Id);
    }
    
    @isTest
    public static void testGetOCSAccountId(){
        CaseUtils.getOCSAccountId([Select Id,Status from Case Where Subject ='Test'].Id);
    }
    
    @isTest
    public static void testGetStatus(){
        CaseUtils.getStatus([Select Id,Status from Case Where Subject ='Test'].Id);
    }
    
    @isTest static void testWriteNotes(){
        CaseUtils.writeNotes([Select Id,Status from Case Where Subject ='Test'].Id,'Test');
        String note=[select Note__c from Case where Subject ='Test'].Note__c;
        System.assertEquals('Test',note);
    }
    @isTest
    public static void changeOwnerTest(){
        CaseUtils.changeOwner(5, '00G0Q000000VAsxUAG','ASC');
    }
    @isTest
    public static void caseListForAccountidOwnerTest()
    {
        Group g = [Select id from Group where Type = 'queue' AND DeveloperName = 'F32'];
        RecordType r = [Select id from recordtype where SobjectType = 'Account' AND name ='dealer'];
        Account a = new Account(Name='Dealer',recordtypeid = r.id);
        insert a ;
        List<Account> lAcc = new List<Account>();
        List<Group> lGroup = new List<Group>();
        Case c = new Case(Subject = 'CaseUtilsClassTest',Accountid = a.id ,OwnerId = g.id);
        Insert c;
        lAcc.add(a);
        lGroup.add(g);
        List<Case> lCase = CaseUtils.caseListForAccountidOwner('Id',lAcc,lGroup);
        system.assert(c.id.equals(lCase[0].id));
    }
}