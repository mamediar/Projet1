@isTest
public class DealerVisibilityCheckTriggerTest 
{
    @isTest
    public static void dealerInsert()
    {
        Recordtype r2 = [select id from Recordtype Where sObjectType = 'Account' AND Name ='Branch'];
        Recordtype r = [select id from Recordtype Where sObjectType = 'Account' AND Name ='Dealer'];
        Account branch = new Account(Name = 'Alessandria',Recordtypeid = r2.id ,OCS_External_Id__c = 'F32',NameRoleReference__c='Alessandria');
        List<AccountShare> lAccShBefore = [Select id from AccountShare where rowCause = 'Manual'];
        insert branch;
        Account a = new Account(Name = 'AccountForTest',OCS_External_Id__c = 'D0000111059',Recordtypeid = r.id, branch__c = branch.id);
        insert a;
        List<AccountShare> lAccShAfter = [Select id from AccountShare where rowCause = 'Manual'];
        System.debug(lAccShAfter);
        System.assert(lAccShBefore.size() != lAccShAfter.size());
    }
    @isTest
    public static void dealerInsertNoBranch()
    {
        Recordtype r = [select id from Recordtype Where sObjectType = 'Account' AND Name ='Dealer'];
        List<AccountShare> lAccShBefore = [Select id from AccountShare where rowCause = 'Manual'];
        Account a = new Account(Name = 'AccountForTest',Recordtypeid = r.id);
        insert a;
        List<AccountShare> lAccShAfter = [Select id from AccountShare where rowCause = 'Manual'];
        System.debug(lAccShAfter);
        System.assert(lAccShBefore.size() == lAccShAfter.size());
    }
    @isTest
    public static void branchInsert()
    {
        Recordtype r = [select id from Recordtype Where sObjectType = 'Account' AND Name ='Branch'];
        List<AccountShare> lAccShBefore = [Select id from AccountShare where rowCause = 'Manual'];
        Account a = new Account(Name = 'AccountForTest',Recordtypeid = r.id);
        insert a;
        List<AccountShare> lAccShAfter = [Select id from AccountShare where rowCause = 'Manual'];
        System.assert(lAccShBefore.size() == lAccShAfter.size());
    }
    @isTest
    public static void CustomerInsert()
    {
        Recordtype r = [select id from Recordtype Where sObjectType = 'Account' AND Name ='Person Account'];
        List<AccountShare> lAccShBefore = [Select id from AccountShare where rowCause = 'Manual'];
        Account a = new Account(LastName = 'AccountForTest',Recordtypeid = r.id);
        insert a;
        List<AccountShare> lAccShAfter = [Select id from AccountShare where rowCause = 'Manual'];
        System.assert(lAccShBefore.size() == lAccShAfter.size());
    }
    @isTest
    public static void CustomerUpdate()
    {
        Recordtype r = [select id from Recordtype Where sObjectType = 'Account' AND Name ='Person Account'];
        List<AccountShare> lAccShBefore = [Select id from AccountShare where rowCause = 'Manual'];
        Account a = new Account(LastName = 'AccountForTest',Recordtypeid = r.id);
        insert a;
        a.OCS_External_Id__c = 'C9999999999';
        update a;
        List<AccountShare> lAccShAfter = [Select id from AccountShare where rowCause = 'Manual'];
        System.assert(lAccShBefore.size() == lAccShAfter.size());
    }
    @isTest
    public static void branchUpdate()
    {
        Recordtype r = [select id from Recordtype Where sObjectType = 'Account' AND Name ='Branch'];
        List<AccountShare> lAccShBefore = [Select id from AccountShare where rowCause = 'Manual'];
        Account a = new Account(Name = 'AccountForTest',Recordtypeid = r.id);
        insert a;
        a.OCS_External_Id__c = 'F999';
        update a;
        List<AccountShare> lAccShAfter = [Select id from AccountShare where rowCause = 'Manual'];
        System.assert(lAccShBefore.size() == lAccShAfter.size());
    }
    @isTest
    public static void dealerUpdateDifferentBranchNotNullAndDifferentRoleFieldValorize()
    {
        Recordtype r2 = [select id from Recordtype Where sObjectType = 'Account' AND Name ='Branch'];
        Recordtype r = [select id from Recordtype Where sObjectType = 'Account' AND Name ='Dealer'];
        Account branch = new Account(Name = 'Alessandria',Recordtypeid = r2.id ,OCS_External_Id__c = 'F32',NameRoleReference__c='Alessandria');
        Account branch2 = new Account(Name = 'Torino' ,Recordtypeid = r2.id ,OCS_External_Id__c = 'F30',NameRoleReference__c='Torino_Carducci');
        Group codaAlessandra = [Select id from Group Where DeveloperName='F32'];
        insert branch;
        insert branch2;
        Account a = new Account(Name = 'AccountForTest',OCS_External_Id__c = 'D0000111059',Recordtypeid = r.id, branch__c = branch.id);
        insert a;
        Case c = new Case(AccountId = a.id,Subject='CaseClasseTest',OwnerId=codaAlessandra.id);
        insert c;
        List<AccountShare> lAccShBefore = [Select id from AccountShare where rowCause = 'Manual'];
        a.branch__c = branch2.id;
        update a;
        List<AccountShare> lAccShAfter = [Select id from AccountShare where rowCause = 'Manual'];
        System.debug(lAccShAfter);
        System.assert(lAccShBefore.size() == lAccShAfter.size());
    }
    @isTest
    public static void dealerUpdateBranchNullBeforeAndAfter()
    {
        Recordtype r = [select id from Recordtype Where sObjectType = 'Account' AND Name ='Dealer'];
        Group codaAlessandra = [Select id from Group Where DeveloperName='F32'];
        Account a = new Account(Name = 'AccountForTest',OCS_External_Id__c = 'D0000111059',Recordtypeid = r.id);
        insert a;
        Case c = new Case(AccountId = a.id,Subject='CaseClasseTest',OwnerId=codaAlessandra.id);
        insert c;
        List<AccountShare> lAccShBefore = [Select id from AccountShare where rowCause = 'Manual'];
        a.Name = 'TestForAccount';
        update a;
        List<AccountShare> lAccShAfter = [Select id from AccountShare where rowCause = 'Manual'];
        System.debug(lAccShAfter);
    }
    @isTest
    public static void dealerUpdateBranchNullBeforeAndNotNullAfter()
    {
        Recordtype r2 = [select id from Recordtype Where sObjectType = 'Account' AND Name ='Branch'];
        Recordtype r = [select id from Recordtype Where sObjectType = 'Account' AND Name ='Dealer'];
        Account branch = new Account(Name = 'Torino',Recordtypeid = r2.id ,OCS_External_Id__c = 'F30');
        Account branch2 = new Account(Name = 'Alessandria' ,Recordtypeid = r2.id ,OCS_External_Id__c = 'F32',NameRoleReference__c='Alessandria');
        Group codaAlessandra = [Select id from Group Where DeveloperName='F30'];
        insert branch;
        insert branch2;
        Account a = new Account(Name = 'AccountForTest',OCS_External_Id__c = 'D0000111059',Recordtypeid = r.id);
        insert a;
        Case c = new Case(AccountId = a.id,Subject='CaseClasseTest',OwnerId=codaAlessandra.id);
        insert c;
        List<AccountShare> lAccShBefore = [Select id from AccountShare where rowCause = 'Manual'];
        a.branch__c = branch2.id;
        update a;
        List<AccountShare> lAccShAfter = [Select id from AccountShare where rowCause = 'Manual'];
        System.debug(lAccShAfter);
        //System.assert(lAccShBefore.size() == lAccShAfter.size());
    }
    @isTest
    public static void dealerUpdateBranchNotNullBeforeAndNullAfter()
    {
        Recordtype r2 = [select id from Recordtype Where sObjectType = 'Account' AND Name ='Branch'];
        Recordtype r = [select id from Recordtype Where sObjectType = 'Account' AND Name ='Dealer'];
        Account branch = new Account(Name = 'Alessandria',Recordtypeid = r2.id ,OCS_External_Id__c = 'F32',NameRoleReference__c='Alessandria');
        Account branch2 = new Account(Name = 'Torino' ,Recordtypeid = r2.id ,OCS_External_Id__c = 'F30');
        Group codaAlessandra = [Select id from Group Where DeveloperName='F32'];
        insert branch;
        insert branch2;
        Account a = new Account(Name = 'AccountForTest',OCS_External_Id__c = 'D0000111059',Recordtypeid = r.id, branch__c = branch.Id);
        insert a;
        Case c = new Case(AccountId = a.id,Subject='CaseClasseTest',OwnerId=codaAlessandra.id);
        insert c;
        List<AccountShare> lAccShBefore = [Select id from AccountShare where rowCause = 'Manual'];
        a.Branch__c = null;
        a.Name = 'CambioNome';
        update a;
        List<AccountShare> lAccShAfter = [Select id from AccountShare where rowCause = 'Manual'];
        System.debug(lAccShAfter);
        //System.assert(lAccShBefore.size() == lAccShAfter.size());
    }
    @isTest
    public static void dealerUpdateBranchNotNullAndEqual()
    {
        Recordtype r2 = [select id from Recordtype Where sObjectType = 'Account' AND Name ='Branch'];
        Recordtype r = [select id from Recordtype Where sObjectType = 'Account' AND Name ='Dealer'];
        Account branch = new Account(Name = 'Alessandria',Recordtypeid = r2.id ,OCS_External_Id__c = 'F32',NameRoleReference__c='Alessandria');
        Account branch2 = new Account(Name = 'Torino' ,Recordtypeid = r2.id ,OCS_External_Id__c = 'F30');
        Group codaAlessandra = [Select id from Group Where DeveloperName='F32'];
        insert branch;
        insert branch2;
        Account a = new Account(Name = 'AccountForTest',OCS_External_Id__c = 'D0000111059',Recordtypeid = r.id, branch__c = branch.Id);
        insert a;
        Case c = new Case(AccountId = a.id,Subject='CaseClasseTest',OwnerId=codaAlessandra.id);
        insert c;
        List<AccountShare> lAccShBefore = [Select id from AccountShare where rowCause = 'Manual'];
        a.Name = 'CambioNome';
        update a;
        List<AccountShare> lAccShAfter = [Select id from AccountShare where rowCause = 'Manual'];
        System.debug(lAccShAfter);
        //System.assert(lAccShBefore.size() == lAccShAfter.size());
    }
    
    
    
}