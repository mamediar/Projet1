@isTest
public class VenditaAssicurazioniControllerTest {
    
    @isTest
    public static void doInitTest(){
        Account tempAccount = new Account(Codice_Cliente__C = 'CU16288843', FirstName = 'Simone', LastName = 'lastName');
        insert tempAccount;
        Case tempCase = new Case(AccountId = tempAccount.Id, PrivacyAccount__c = true, Esito__c = 'Richiesta inserita');
        insert tempCase;
        VenditaAssicurazioniController.InitVariables expected = new VenditaAssicurazioniController.InitVariables();
        expected.textBadge = 'Privacy OK';
        VenditaAssicurazioniController.InitVariables Actual = VenditaAssicurazioniController.doinit(tempCase.Id);        
    	//System.assertEquals(expected.textBadge, actual.textBadge);
    }
    
    
    @isTest
    public static void goNextTest(){
        Datetime today = Date.today();
        Case tempCase = new Case();
        insert tempCase;
        VenditaAssicurazioniController.UtilVariables expected = new VenditaAssicurazioniController.UtilVariables();
        VenditaAssicurazioniController.UtilVariables actual = VenditaAssicurazioniController.goNext(tempCase.Id, 'interessato', 'schedula', today, false, '');
        VenditaAssicurazioniController.UtilVariables runTest = VenditaAssicurazioniController.goNext(tempCase.Id, 'interessato', 'gestisci', today, false, '');

    }
       
     
}