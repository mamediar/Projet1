/**
 * @File Name          : MdGestioneDossierController_Test.cls
 * @Description        : This class is created to test the MdGestioneDossierController controller.
 * @Author             : CISSE Ahmet
 * @Group              : 
 * @Last Modified By   : CISSE Ahmet
 * @Last Modified On   : 09/08/2019 à 11:20:30
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    09/08/2019 à 10:58:45   CISSE Ahmet     Initial Version
**/
@isTest
public class MdGestioneDossierController_Test {@testSetup
	static void setup() {
		// Create records for test. 
		Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
		Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SFA Convenzionamento').getRecordTypeId();
		//Account	
		Account a1 = new Account(
		Name = 'test1', DEM_Da_Inviare__c = false, BillingCity = 'San Francisco', OCS_External_Id__c = 'C19200437', DealerPersonaRiferimento__c = 'value test', DealerPersonaRiferimentoCellulare__c = 'value test', Dealership_Code__c = 3658, Last_Status__c = 'value test', Partita_IVA__c ='12541254632');

		insert a1;

		XCS_Categoria__c categoria = new XCS_Categoria__c(Name = 'Gestione Dossier Convenzionamento');
		insert categoria;
		// Case
		Case casex = new Case();
		casex.Status = 'Chiuso';
		casex.RecordTypeId = caseRecordTypeId;
		casex.Categoria_Riferimento__c = categoria.Id;
		//casex.Motivo__c = 'Altro';
		casex.AccountId = a1.Id;

		insert casex;

		// dossier
		Dossier__c dossier = new Dossier__c();
		dossier.Tipo__c = 'Dossier Fittizio';
		dossier.DataRiferimento__c = date.valueOf('2015-02-12');
		dossier.IdAttivita__c = casex.Id;

		insert dossier;
	}

	static testmethod void saveInDossierAndAccount_test() {
		Map < String,
		Object > response = new Map < String,
		Object > ();
		Case casex = [SELECT Id FROM Case Limit 1];
		test.startTest();
		response = MdGestioneDossierController.getInfos(casex.Id);
		test.stopTest();

        System.assertEquals(false, response.get('error'), 'it is true');
        System.assertEquals('test1', response.get('name'), 'it is not test1');
        System.assertEquals('12541254632', response.get('PartitaIVADealer__c'), 'it is not 12541254632');
	}
}