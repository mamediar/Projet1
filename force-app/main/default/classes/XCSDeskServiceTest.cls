@isTest
public class XCSDeskServiceTest {
    
    @isTest
    static void TestMethod1()
    {
        Account testComFiliale= new Account(Name='test account', 
                                            OCS_External_Id__c='ocs test',
                                            COM_NumeroTotali_Pratiche__c='10',
                                            COM_PraticheChiuse_Conforme__c='5',
                                            COM_ChiusoNon_Conforme__c='2',
                                            RecordtypeId = getAccountRecordTypeId());
        insert testComFiliale;
      
        XCS_Desk__c XCSDeskItem = new XCS_Desk__c();
        XCSDeskItem.Branch__c   = testComFiliale.Id;
        XCSDeskItem.isActive__c = true;
        insert XCSDeskItem;
        XCSDeskService.getListDesk(testComFiliale.Id);
    }
            
    static Id getAccountRecordTypeId() 
    {
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Branch').getRecordTypeId();
        return RecordTypeId;
    }

}