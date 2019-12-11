@isTest
public class contractTest {
    
    @isTest
    static void insertcontract() {
        Case case1 = new Case();
		case1.ActivityType__c = 'CONSMA';
		insert case1;

		Account account1 = new Account();
		account1.Name = 'Mario Rossi';
        account1.Customer_Type__c = 'Compass';
		insert account1;

		
    
    }

}