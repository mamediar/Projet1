@isTest
public class SFAContractListControllerTest
{
	@isTest
	static void testGetContratti()
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

		List<String> lstStatus = new List<String>();
		lstStatus.add('3');
		lstStatus.add('4');

		List<Contract> listaContratti = SFAContractListController.getContratti('WorkStatus__c', lstStatus, case1.Id);

		System.assert(listaContratti != null);
		System.assert(listaContratti.size() == 1);

	}
}