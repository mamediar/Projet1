@isTest
public class ProcessContractsListBarControllerTest {
    @testSetup 
    static void setup()
    {
     	SFALotto__c lotto1 = new SFALotto__c();
     	lotto1.Name = 'TEST';
        insert lotto1;
        Contract con1 = new Contract();
        Contract con2 = new Contract();
        Account acc = new Account();
        acc.Name = 'FOSCOLO';
        insert acc;
        
        con1.SFALotto__c = lotto1.id;
        con1.AccountId = acc.Id;
        con2.SFALotto__c = lotto1.id;
        con2.AccountId = acc.Id;
        insert con1 ;
        insert con2 ;
        
    }
    
    @isTest
    static void isIn()
    {
        SFALotto__c lot = [select id from SFALotto__c where Name ='TEST'];
        List<Contract> lista = ProcessContractsListBarController.returnContracts(lot.Id);
     	system.assert(lista.size() == 2 );   
    }
}