@isTest
public class SFAArchiveLostContractsControllerTest
{
	@isTest
	static void testSetContractsArchived()
	{
		Case case1 = new Case();
		insert case1;

		Account account1 = new Account();
		account1.Name = 'Mario Rossi';
		insert account1;

		Contract contract1 = new Contract();
		contract1.Case__c = case1.Id;
		contract1.AccountId = account1.Id;
		contract1.WorkStatus__c = '3';
		insert contract1;

		Contract contract2 = new Contract();
		contract2.Case__c = case1.Id;
		contract2.AccountId = account1.Id;
		contract2.WorkStatus__c = '3';
		insert contract2;

		List<Id> contratti = new List<Id>();
		contratti.add(contract1.Id);
		contratti.add(contract2.Id);

		SFAArchiveLostContractsController.setContractsArchived(contratti);

		List<Contract> cList = [SELECT Id, WorkStatus__c FROM Contract WHERE Id IN(:Contract1.Id, :Contract2.Id)];

		System.assert('405'.equals(cList[0].WorkStatus__c));
		System.assert('405'.equals(cList[1].WorkStatus__c));
	}
}