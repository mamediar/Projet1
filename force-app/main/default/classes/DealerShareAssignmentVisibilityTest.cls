@isTest
public class DealerShareAssignmentVisibilityTest {
    
    @TestSetup
    public static void setup()
    {
        Account Branch = new Account();
        Branch.Name = 'Andria';
        branch.NameRoleReference__c = 'Andria';
        branch.OCS_External_Id__c = 'F255';
        branch.RecordTypeId = [select id from recordtype where Name ='Branch' AND sObjectType = 'Account'].id;
        Insert branch;
        Account Branch2 = new Account();
        Branch2.Name = 'Alessandria';
        branch2.NameRoleReference__c = 'Alessandria';
        branch2.OCS_External_Id__c = 'F32';
        branch2.RecordTypeId = [select id from recordtype where Name ='Branch' AND sObjectType = 'Account'].id;
        Insert branch2;
        Account dealer = new account();
        dealer.RecordTypeId = [Select id,Name from recordtype where Name = 'Dealer'].id;
        dealer.Name = 'DealerShareAssignmentVisibilityTestPreRecord';
        dealer.Branch__c = branch.id;
        insert dealer;
        insert new AccountShare(
            Accountid=dealer.id,
            UserOrGroupId=[SELECT Id FROM Group where DeveloperName = 'Alessandria' AND type = 'Role'].id,
            AccountAccessLevel='Read',
            OpportunityAccessLevel='None'
        );
    }
    
    @isTest
    public static void InsertDealerNotSetVisibility()
    {
    	Account dealer = new Account();
        List<AccountShare> act =  [SELECT Id, AccountId, UserOrGroupId, AccountAccessLevel, OpportunityAccessLevel, ContactAccessLevel, RowCause FROM AccountShare where LastModifiedDate = TODAY AND AccountId = :dealer.id AND RowCause = 'Manual' ];
        dealer.RecordTypeId = [Select id,Name from recordtype where Name = 'Dealer'].id;
        dealer.Name = 'DealerShareAssignmentVisibilityTest';
        insert dealer;
        List<AccountShare> act2 =  [SELECT Id, AccountId, UserOrGroupId, AccountAccessLevel, OpportunityAccessLevel, ContactAccessLevel, RowCause FROM AccountShare where LastModifiedDate = TODAY AND AccountId = :dealer.id AND RowCause = 'Manual' ];
   		System.assertEquals(act.size(), act2.size());
    }
    @isTest
    public static void InsertDealerSetVisibility()
    {
    	Account dealer = new Account();
        List<AccountShare> act =  [SELECT Id, AccountId, UserOrGroupId, AccountAccessLevel, OpportunityAccessLevel, ContactAccessLevel, RowCause FROM AccountShare where LastModifiedDate = TODAY AND AccountId = :dealer.id AND RowCause = 'Manual' ];
        dealer.RecordTypeId = [Select id,Name from recordtype where Name = 'Dealer'].id;
        dealer.Name = 'DealerShareAssignmentVisibilityTest';
        dealer.Branch__c = [Select id from Account Where OCS_External_Id__c = 'F255'][0].id;
        insert dealer;
        List<AccountShare> act2 =  [SELECT Id, AccountId, UserOrGroupId, AccountAccessLevel, OpportunityAccessLevel, ContactAccessLevel, RowCause FROM AccountShare where LastModifiedDate = TODAY AND AccountId = :dealer.id AND RowCause = 'Manual' ];
   		System.debug(act2.size());
    }
    @isTest
    public static void UpdateDealerSetVisibility()
    {
    	Account dealer = [Select id,Branch__c from account where OCS_External_id__c = 'F255'][0];
        dealer.Branch__c = [Select id from Account Where OCS_External_Id__c = 'F32'][0].id;
        Group groupAlessandria = [SELECT Id FROM Group where DeveloperName = 'Alessandria' AND type = 'Role'];
        Group groupAndria = [SELECT Id FROM Group where DeveloperName = 'Andria' AND type = 'Role'];
        Update dealer;
        List<AccountShare> AccShaAless =  [SELECT Id, AccountId, UserOrGroupId FROM AccountShare where AccountId = :dealer.id AND UserOrGroupId = :groupAlessandria.id AND RowCause = 'Manual' ];
   		List<AccountShare> AccShaAndr =  [SELECT Id, AccountId, UserOrGroupId FROM AccountShare where AccountId = :dealer.id AND UserOrGroupId = :groupAndria.id AND RowCause = 'Manual' ];
   		system.debug(AccShaAless.size()); 
    }    
}