@isTest
public class Gua_AccountQueryTest {

    @testSetup
    public static void setUp(){
       Account a1 = new Account(
        Name = 'Affari e Delibere', OCSAreaId__c = 0.00, RecordTypeId ='0120Q0000004W48QAE'); 
        insert a1;        
    }
    @isTest
    static void getAreaAffariTest(){
        String name = 'Affari e Delibere%';
        Id recordTypeId = Gua_Service.getRecordTypeId('Branch', 'Account');
        List<Account> listAcc = [SELECT Id, Name, Region_Name__c, OCSAreaId__c FROM Account 
                    WHERE recordTypeId =:recordTypeId AND Name LIKE :name];
        Gua_AccountQuery.getAreaAffari();
      System.assertNotEquals(null, listAcc);
    }
}