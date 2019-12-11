/**
*@author 		Mame bousso kane
*created 		19/09/2019
*descripttion 	test of the AppuntamentoListaFilialiQuery class
*/
@isTest
public class AppuntamentoListaFilialiQueryTest {
	@testSetup 
    static void testSetup() {
    	Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get('Branch').getRecordTypeId();
    	Account acct2= new Account(Name='test', RecordTypeId = recordTypeId);
    	insert acct2;
	}
    
    @isTest
    static void test(){
        Test.startTest();
 			AppuntamentoListaFilialiQuery.getLisFiliale(); 
   		Test.stopTest();
    }
}