public class TestMockUtils 
{

    public static Account getDummyAccount()
    {
            Account acc = new Account();
        	acc.Name='Dummy Dummy';
       	 	acc.Customer_Type__c='Compass';
            acc.OCS_External_Id__c = 'N00000';
        	return acc;
    }
    
    public static Contact getDummyContact(String idAccount)
    {
            Contact cont = new Contact();
            cont.LastName = 'Dummy';
            cont.FirstName = 'Dummy';
        	cont.AccountId=idAccount;
        	return cont;
    }
}