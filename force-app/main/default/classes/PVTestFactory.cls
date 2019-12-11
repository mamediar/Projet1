/**
 * @File Name          : PVTestFactory.cls
 * @Description        :
 * @Author             : Lorenzo Marzocchi
 * @Group              :
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 22/10/2019, 15:52:14
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author                        Modification
 *==============================================================================
 * 1.0    2019-6-18 16:50:08   Lorenzo Marzocchi     Initial Version
 **/
@isTest (SeeAlldata=true)
public class PVTestFactory {


	private List<ApiRest__c> apiRestList = new List<ApiRest__c>();
	private List<String> UMRNameList = new List<String>();

	public PVForm initForm(String categoria, PVForm form) {

        form.pratica = new OCSPratica();
		form.cliente = new OCSCliente();
		form.cliente.email = 'POSTVENDITA@EMAIL.TEST';

		form.cliente.codCliente = '1';
		form.cliente.cognome = 'COGNOME';
		form.cliente.nome = 'NOME';
		form.cliente.denominazioneAzienda = 'NOME COGNOME';
		form.cliente.dataNascita = '20100101';
		form.userData = new PVForm.UserData();

		form.userData.user = [SELECT Alias, Name, LastName, FirstName, UserRole.Name, Branch_Or_Office__c,  UserRole.DeveloperName, DefaultQueueId__c FROM User Where Branch_Or_Office__c = 'CCInterno'][0];
		System.debug('### userData.user : '+form.userData.user);
		form.userData.accountOffice = [SELECT Id FROM Account where RecordType.Name = 'Uffici e Altro' AND Codice_Ufficio__c =: form.userData.user.Branch_Or_Office__c][0];
		form.categoriaPV = [SELECT Id,Name,XCS_Template__c,XCS_Disposition__c,XCS_Template__r.Body__c,External_Id__c FROM XCS_Categoria__c WHERE External_Id__c = :categoria][0];

		form.motivazione = 'MOTIVAZIONE';
		form.note = '';

		return form;
	}

	public void pushApiList(String response, String nome) {

		ApiRest__c test1 = new ApiRest__c(Method__c = 'POST',Test_Response__c= response,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC',Name = nome,EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
		apiRestList.add(test1);
		UMRNameList.add(nome);

	}

	public void finalizeApiList() {
		System.debug('PRE INSERT APIREST');
		System.debug('##### APIRESTLIST: '+apiRestList);
		insert apiRestList;
		System.debug('POST INSERT APIREST');
		UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(UMRNameList);
		Test.setMock(HttpCalloutMock.class,UMR);

	}

}