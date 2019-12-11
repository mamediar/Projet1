@isTest
private class GestionePraticheSmarriteSGControllerTest {
	
	@isTest 
	static void testSelectContract() {
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

		List<Contract> listaContratti = GestionePraticheSmarriteSGController.selectContract();

		System.assert(listaContratti != null);
		System.assert(listaContratti.size() == 1);
	}

	@isTest 
	static void testGeneratePDF() {
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

		List<Contract> listaContratti = new List<Contract>();

		listaContratti.add(contract1);

		String testResponse = '{"resultCode":0,"resultMessage":"Ok","ebavaradpv1Response":{"msfres_STATUS":"OK","msfologon_STATUS":"a","msfologon_ERRORE":"a","mfterr_OMSFERR_OCCURS":[{"msferr_CODICE":"4044"}]}}';   

		ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c=testResponse,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ricerca.ocs.cambioStatoPratica',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
       	insert test1;
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ricerca.ocs.cambioStatoPratica';
        Test.setMock(HttpCalloutMock.class,UMR);
		GestionePraticheSmarriteSGController.generatePDF(listaContratti);
        test.stopTest();
		
		System.assert(listaContratti != null);
		System.assert(listaContratti.size() == 1);
	}

	@isTest 
	static void testDenounceContracts() {
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

		List<Contract> listaContratti = new List<Contract>();
		listaContratti.add(contract1);

		Boolean res = GestionePraticheSmarriteSGController.denounceContracts(listaContratti);

		System.assert(res == true);

	}

	@isTest 
	static void testGeneratePDFPreviewURL() {
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

		List<Contract> listaContratti = new List<Contract>();
		listaContratti.add(contract1);

		String isPreview = 'true';
		String uniqCode = '1234567890';

		String res = GestionePraticheSmarriteSGController.generatePDFPreviewURL(listaContratti, isPreview, uniqCode);

		System.assert(res == '/apex/GestionePraticheSmarritePDFSingolo?contractIds=' + contract1.Id + '&1234567890');

	}

	@isTest 
	static void testCaseGetInstance() {
		Case case1 = new Case();
		case1.ActivityType__c = 'CONSMA';
		insert case1;

		Account account1 = new Account();
		account1.Name = 'Mario Rossi';
		insert account1;

		Contract contract1 = new Contract();
		contract1.Case__c = case1.Id;
		contract1.AccountId = account1.Id;
		contract1.WorkStatus__c = '3';
		insert contract1;

		List<Contract> lstContratto = new List<Contract>();
		lstContratto.add(contract1);

		String res = GestionePraticheSmarriteSGController.caseGetInstance(lstContratto);

		DateTime data = Date.today();

		System.assert(res == data.format('yyyyMMdd') + '-2');

	}
	
}