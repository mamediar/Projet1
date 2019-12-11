@isTest
public class CRM_GestioneEmailChiusuraControllerTest {
    
    @isTest
    public static void handleCaseTest(){
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Call Center'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standt123123223@f.com');
        System.runAs(u) {
            
            Case c_gestito = new Case();
            c_gestito.esito__c = 'Gestita';
            c_gestito.Subject = 'Test-Esito-Gestito';
            insert c_gestito;
            
            Case c_annullato = new Case();
            c_annullato.esito__c = 'Annullata';
            c_annullato.Subject = 'Test-Esito-Annullato';
            insert c_annullato;
            
            
            
            Case gestito = [Select id from Case where esito__c = 'Gestita'];
            Case annullato = [Select id from Case where esito__c = 'Annullata'];
            
            System.debug(gestito);
            
            
            System.debug('gestito nel runAs ' + gestito.id);
            CRM_GestioneEmailChiusuraController.handleCase('Gestita',gestito.id,'nota1');
            CRM_GestioneEmailChiusuraController.handleCase('Annullata',annullato.id,'');
        }
    }
}