@isTest
global class SFAComunicazioneUtenzeServiceTest {


	@TestSetup
	static void makeData(){
		XCS_Categoria__c cat = new XCS_Categoria__c( External_Id__c = 'AT0114');
		insert cat;
		Account accountemail = TestDataFactory.insertAccountForEmail();
    }


    private  static void setRestRequestResponse(SFAComunicazioneUtenzeService.SFAComunicazioneUtenzeRequest request){

	        String myJSON = JSON.serialize(request);
	        RestRequest req = new RestRequest();
	        req.requestUri ='https://localhost/services/apexrest/sfa_comunicazione_utenze';
	        req.httpMethod = 'POST';
            req.addHeader('Content-Type', 'application/json'); 
	        req.requestBody = Blob.valueOf(myJSON);
	        RestContext.request = req;
			RestContext.response = new RestResponse();

     }

	@isTest
    static void testNoDealer(){
		Test.startTest();
		SFAComunicazioneUtenzeService.SFAComunicazioneUtenzeRequest request = new SFAComunicazioneUtenzeService.SFAComunicazioneUtenzeRequest('Utente44', '16342975','Rossi','184','CV','20010504','1','Giovanni','','');
		setRestRequestResponse(request);
		SFAComunicazioneUtenzeService.doPost('Utente44', '16342975','Rossi','184','CV','20010504','1','Giovanni','','');
		Test.stopTest();
		List<Case> attivita = [SELECT ID FROM Case];
		// verify nessuna attivita creata
		System.assert(attivita==null || attivita.size()==0);

    }


	@isTest
    static void testNoFiliale(){
		Account acc = TestDataFactory.insertDealer();
		Test.startTest();
		SFAComunicazioneUtenzeService.SFAComunicazioneUtenzeRequest request = new SFAComunicazioneUtenzeService.SFAComunicazioneUtenzeRequest('Utente44', '16342975','Rossi','184','CV','20010504','1','Giovanni','','');
		setRestRequestResponse(request);
		SFAComunicazioneUtenzeService.doPost('Utente44', '16342975','Rossi','184','CV','20010504','1','Giovanni','','');
		Test.stopTest();
		List<Case> attivita = [SELECT ID FROM Case];
		// attivita creata (errore non bloccante)
		System.assert(attivita!=null || attivita.size()==1);

    }
}