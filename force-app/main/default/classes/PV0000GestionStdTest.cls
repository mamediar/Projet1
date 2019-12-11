/**
 * @File Name          : PV0000GestionStdTest.cls
 * @Description        :
 * @Author             : Andrea Vanelli
 * @Group              :
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 2019-6-20 14:09:40
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-6-20 12:04:09   Andrea Vanelli     Initial Version
 **/
@isTest (SeeAllData=true)
public with sharing class PV0000GestionStdTest {
	@isTest static void testOK() {
		// prendo la categoria variazione anagrafica step 2
		String categId = [SELECT Id FROM XCS_Categoria__c WHERE External_Id__c = '1763'][0].Id;

		PV0000GestionStd.PV0000GestionStdForm form = new PV0000GestionStd.PV0000GestionStdForm();
        PVForm.UserData userData = new PVForm.UserData();
        userData.accountOffice = [Select Id from Account where RecordType.Name = 'Uffici e Altro' AND Codice_Ufficio__c =: 'back'][0];
        userData.user = [Select Alias, Name, LastName, FirstName, UserRole.Name, Branch_Or_Office__c,  UserRole.DeveloperName from User Where Branch_Or_Office__c = 'back'][0];
        form.userData = userData;
        form.note = 'test';



// preparo un case
		Case caseObj = new Case(
			Categoria_Riferimento__c =  categId,
			Step_PV__c = '9',
			Status = 'new',
			FlagCarteDaRitirare__c = true);


		Test.startTest();
		PV0000GestionStd.saveCase( form,  caseObj);

        try{
                // secondo caso con note nulle che manda in erorre
    form.note = null;
		    PV0000GestionStd.saveCase( form,  caseObj);
		}
		catch(Exception e)
		{
			System.assertNotEquals(e.getMessage(),'');
		}

		Test.stopTest();
	}
}