@isTest
public class NuovoCasoClienteControllerTest {
    
    
    @isTest
    public static void testLoadOpzioniNuovoCaso() {
        NuovoCasoClienteController.loadOpzioniNuovoCaso('B2C');
    }
    
    
    @isTest
    public static void testDoPreRedirectTest() {
        
        Account acc = new Account();
        acc.Name='AccName';
        acc.Customer_Type__c='Compass';
        insert acc;
        
        MenuConfigMatrix__mdt mdt = [SELECT ApexClass__c,Destination__c,Parent__c,Sort_Order__c,Type__c,View_Name__c,Visibility__c 
                                     FROM MenuConfigMatrix__mdt WHERE ApexClass__c  = 'XCSMenuComponentAction' LIMIT 1];
        
        NuovoCasoClienteController.doPreRedirect( mdt, acc.Id);
     
    }
    
}