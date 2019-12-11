@isTest public class RitiroContrattiMassivoControllerTest {
    
    @isTest
    public static void testGetContracts() {
        
        Account acc = new Account();
        acc.Name = 'Stica';
        insert acc;
        
        Case c = new Case();
        c.ActivityType__c = 'RITCON';
        c.Status = 'New';
        insert c;
        
        Contract c1 = new Contract();
        Contract c2 = new Contract();
        Contract c3 = new Contract();
        
        c1.AccountId = acc.Id;
        c1.Procedure__c = 'AL';
        c1.ContractNumber__c = '1';
        c1.Case__c = c.Id;
        
        
        c2.AccountId = acc.Id;
        c2.Procedure__c = 'AN';
        c2.ContractNumber__c = '2';
        c2.Case__c = c.Id;
        
        
        c3.AccountId = acc.Id;
        c3.Procedure__c = 'GI';
        c3.ContractNumber__c = '3';
        c3.Case__c = c.Id;
        
        
        insert c1;
        insert c2;
        insert c3;
        
        List < Contract > conList = RitiroContrattiMassivoController.getContracts();
        System.assert(conList.size() == 3);
        
        for (Contract co: conList) {
            System.assert(co.AccountId == acc.Id);
        }
        
    }
    
    @isTest
    public static void testCheckContract() {
        
        Account acc = new Account();
        acc.Name = 'Stica';
        insert acc;
        
        Case c = new Case();
        c.ActivityType__c = 'RITCON';
        c.Status = 'New';
        insert c;
        
        Contract c1 = new Contract();
        Contract c2 = new Contract();
        Contract c3 = new Contract();
        
        c1.AccountId = acc.Id;
        c1.Procedure__c = 'AL';
        c1.ContractNumber__c = '1';
        c1.Case__c = c.Id;
        
        
        c2.AccountId = acc.Id;
        c2.Procedure__c = 'AN';
        c2.ContractNumber__c = '2';
        c2.Case__c = c.Id;
        
        
        c3.AccountId = acc.Id;
        c3.Procedure__c = 'GI';
        c3.ContractNumber__c = '3';
        c3.Case__c = c.Id;
        
        
        insert c1;
        insert c2;
        insert c3;
        
        
        Contract ctr = [SELECT Id,Barcode__c FROM Contract WHERE  Procedure__c = 'AL'][0]; 
        
        List<Contract> ctrList = [SELECT Id,Barcode__c,Case__c FROM Contract]; 
        
       
        
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='{"resultCode":0,"resultMessage":"Ok","errore":"OK"}',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.modificaStatoDocumento',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test1;
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.modificaStatoDocumento';
        Test.setMock(HttpCalloutMock.class,UMR);
       
        RitiroContrattiMassivoController.checkContract(ctr.Barcode__c, ctrList);  
        
        test.stopTest();	
        
    }
    
    
}