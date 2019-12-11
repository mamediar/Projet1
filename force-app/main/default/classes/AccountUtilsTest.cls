@isTest
public class AccountUtilsTest {
    
    @isTest
    public static void testGetDealer(){
       // AccountUtils.getDealer('12314');
       // AccountUtils.getDealer('21312', '213124');
    }
    
    @isTest
    public static void testMakeAccount(){
        Map<String,String> data = new Map<String,String>();
        data.put('email', 'mail@mail.com');
        data.put('telefonoCasa', '123-45678');
        data.put('telCellulare', '333555667');
        String societa = 'societa';
        Account acc = AccountUtils.makeAccount(data, societa);
        system.debug('Account creato: ' + acc.PersonEmail + ' ' + acc.Phone + ' ' + acc.PersonMobilePhone);
    }
    @isTest
    public static void testIsDummy()
    {
        Account a = new Account(Name ='NotDummy',OCS_External_Id__c = 'D123456789');
        System.assert(!AccountUtils.isDummy(a)); 
    }
    
    @isTest
    public static void testFilterDealer()
    {
        List<Account> lAcc = new List<Account>();
        Account a = new Account(Name='Dealer',recordtypeId = dealerRecordTypeId);
        Account b = new Account(Name='branch',recordtypeId = branchRecordTypeId);
        lAcc.add(a);
        lAcc.add(b);
 		System.assert(AccountUtils.filterDealer(lAcc).size() == 1);
    }
    
    private static String dealerRecordTypeId  = RecordTypeUtil.getDealerRecordType();
    private static String branchRecordTypeId  = RecordTypeUtil.getBranchRecordType();
    
}