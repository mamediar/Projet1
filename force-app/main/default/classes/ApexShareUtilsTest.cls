@isTest
public class ApexShareUtilsTest 
{
	@isTest
    public static void DealerVisibilityTest()
    {
        Recordtype r2 = [select id from Recordtype Where sObjectType = 'Account' AND Name ='Branch'];
        Recordtype r = [select id from Recordtype Where sObjectType = 'Account' AND Name ='Dealer'];
        List<Account> lAcc = new List<Account>();
        Account branch = new Account(Name = 'Alessandria',Recordtypeid = r2.id ,OCS_External_Id__c = 'F32',NameRoleReference__c='Alessandria');
        Account branch2 = new Account(Name = 'Torino' ,Recordtypeid = r2.id ,OCS_External_Id__c = 'F30',NameRoleReference__c='Torino_Carducci');
        Group codaAlessandra = [Select id from Group Where DeveloperName='F32'];
        insert branch;
        insert branch2;
        Account a = new Account(Name = 'AccountForTest',OCS_External_Id__c = 'D0000111059',Recordtypeid = r.id, branch__c = branch.id);
        List<AccountShare> lAccShBefore = [Select id from AccountShare where rowCause = 'Manual'];
        insert a;
        lAcc.add(a);
        ApexShareUtils.VisibilityDealerOnBranch(lAcc);
        List<AccountShare> lAccShAfter = [Select id from AccountShare where rowCause = 'Manual'];
        System.debug(lAccShAfter);
        System.assert(lAccShBefore.size() != lAccShAfter.size());
    }
}