@isTest
public class DealerVisibilityCheckClassTest 
{
	@isTest
    public static void checkInsert()
    {
        List<Account> lAcc = new List<Account>();
        Id recordtypeid = RecordtypeUtil.getDealerRecordType();
        Account a = new Account(name = 'DealerCaseTest', recordtypeId = recordtypeid,OCS_External_Id__c='D000000001');
        insert a;
        lAcc.add(a);
        DealerVisibilityCheck.DealerInsert(lAcc);
    }
    @isTest
    public static void checkUpdate()
    {
     	List<Account> lAcc = new List<Account>();
        List<Account> lAccAfter = new List<Account>();
        Id recordtypeid = RecordtypeUtil.getDealerRecordType();
        Account a = new Account(name = 'DealerCaseTest', recordtypeId = recordtypeid,OCS_External_Id__c='D000000001');
        insert a;
        lAcc.add(a);
        a.OCS_External_Id__c = 'D000000002';
        lAccAfter.add(a);
        DealerVisibilityCheck.DealerUpdate(lAcc,lAccAfter);
    }
}