@isTest
public class ProcessContractsBarcodeControllerTest {
	@testSetup 
    static void setup()
    {
        Case c = new Case();
        c.Subject = 'TESTCASE';
        insert c;
        SFALotto__c lotto1 = new SFALotto__c();
     	lotto1.CaseId__c = c.Id;
        insert lotto1;
        
    }
    
    @isTest
    static void isIn()
    {
        Case c = [select id from Case where Subject ='TESTCASE'];
        List<SFALotto__c> lista = ProcessContractsBarcodeController.returnSfalottiRelatedToCase();
     	system.assert(lista.size() != null );   
    }
}