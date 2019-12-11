@isTest
public class GestionePratSmarPDFControllerTest {
    @testSetup static void setup(){
        Account a=new Account();
        a.Name='TEST';
        insert a;
        
        Contract c=new Contract();
        c.AccountId=a.Id; c.ContractNumber__c='123123'; c.Description='TEST';
        
    }
    
    @isTest static void testInit(){
        PageReference pr=Page.GestionePraticheSmarritePDFSingolo;
        Test.setCurrentPage(pr);
        pr.getParameters().put('contractIds','800123');
        GestionePraticheSmarritePDFController ctrl=new GestionePraticheSmarritePDFController();
        ctrl.init();
    }
    
}