@isTest
public class ContractUtilsTest {
    
    @isTest
    public static void testRitiraContratto() {
        
        Account acc = new Account();
        acc.Name='Mario';
        Insert acc;
        
        Contract c1 = new Contract();
        c1.WorkStatus__c='403';
        c1.AccountId=acc.Id;
        
        Documento__c d1 = new Documento__c();
        d1.SituazioneDocumento__c='S';
        
        insert c1; insert d1;
        
        ContractUtils.ritiraContratto(c1);
        
    }

}