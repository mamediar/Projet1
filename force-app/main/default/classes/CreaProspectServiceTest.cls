@isTest
public  class CreaProspectServiceTest {

    @TestSetup
    static void makeData(){
      List<Account> listAccount = new List<Account>{
           new Account (LastName='xxxx', Codice_Cliente__c='54874', Codice_Fiscale__c ='GHDESXWZD'),
           new Account (LastName='Sana', Codice_Cliente__c='5487441', Codice_Fiscale__c ='GHDESXWZDSDE'),
           new Account (LastName='Sana', Codice_Cliente__c='5487', Codice_Fiscale__c ='GHDESX')
      };
      insert listAccount;
   //PP_ONLINE_PARTNER_DS
        Product2 produit = new Product2(Name='P1', ProductCode='145', Family='PP_ONLINE_COMPASS_DS');
        Product2 produit2 = new Product2(Name='P2DSP', ProductCode='146', Family='PP_ONLINE_PARTNER_DS');
        Product2 produit3 = new Product2(Name='P2DSP', ProductCode='146', Family='PP_ONLINE_PARTNER_DS');
        insert produit;
        insert produit2;
        insert produit3;

       List<Case> v1 = new List<Case>{
            new Case (RO_Link_Bozza__c='link', Codice_Cliente__c='54412587', Status='On Hold', AccountId= listAccount[0].Id, Product__c = produit.Id ),
            new Case ( RO_Link_Bozza__c= 'test', Codice_Cliente__c='544587'),
            new Case (Codice_Cliente__c ='5425', AccountId= listAccount[0].Id, Product__c = produit3.Id)
        };
       
      insert v1;    


      
     

    }
   //@IsTest
    static void search_Link_Boza_test(){
        
        Test.startTest();
        Case c = [SELECT Id, RO_Link_Bozza__c, Codice_Cliente__c FROM Case LIMIT  1 ];
        CreaProspectService.search_Link_Boza(c);
        Test.stopTest();
        
    }  
   // @IsTest
    static void createCaseDsTest(){  
        Test.startTest();
          Case c =  new Case (Codice_Cliente__c='xsdc', RO_Link_Bozza__c='');
          Product2 p = [SELECT Id, ProductCode, Family FROM Product2];
          Account acc = [SELECT Id, Codice_Cliente__c, Codice_Fiscale__c FROM Account LIMIT 1];
          c.Product__c = p.Id;
          c.AccountId = acc.Id;
          CreaProspectService.createCaseDs(c, p, acc,'');

        Test.stopTest();
        
    }

    @isTest
    static void createCaseDSPCresate(){
    Case c = new Case();
    List<Product2> ps = [SELECT Id, Family FROM Product2];
    Account account = [SELECT Id,  Codice_Cliente__c,Codice_Fiscale__c FROM Account LIMIT 1];
    Test.startTest();
    c.Product__c = ps[1].Id;
    c.AccountId = account.Id;
    CreaProspectService.createCaseDSP(c, ps[1], account);

    Test.stopTest();
    }
      @isTest
    static void createCaseDSPCresateElse(){
    Case c = new Case();
    List<Product2> ps = [SELECT Id, Family FROM Product2];
    Account account = [SELECT Id,  Codice_Cliente__c,Codice_Fiscale__c FROM Account WHERE  Codice_Fiscale__c ='GHDESXWZDSDE'];
    Test.startTest();
    c.Product__c = ps[1].Id;
    c.AccountId = account.Id;
    CreaProspectService.createCaseDSP(c, ps[1], account);

    Test.stopTest();
    }
     @isTest
    static void createCaseDSPCresateElseV(){
    Case c = [SELECT Id FROM Case LIMIT 1];
    List<Product2> ps = [SELECT Id, Family FROM Product2];
    Account account = [SELECT Id,  Codice_Cliente__c,Codice_Fiscale__c FROM Account WHERE  Codice_Fiscale__c ='GHDESX'];
    Test.startTest();
    c.Product__c = ps[1].Id;
    c.AccountId = account.Id;
    CreaProspectService.createCaseDSP(c, ps[1], account);

    Test.stopTest();
    }
    //@isTest 
    static void controleCaseTest (){
        Test.startTest();
        Case c = [SELECT Id, Codice_Cliente__c, Status, AccountId, Product__c  FROM Case LIMIT 1];
        System.debug('********* Case '+ c);
        Product2 p = [SELECT Id, ProductCode, Family FROM Product2];
        
        Case c2 = CreaProspectService.controleCase(p.Id, '54874', '');

        Test.stopTest();
    }
    @isTest
    static void gestatoRequestOnlineTest(){
     Test.startTest();
      Product2 p = [SELECT Id, ProductCode, Family FROM Product2 LIMIT 1];
          Account acc = [SELECT Id, Codice_Cliente__c, Codice_Fiscale__c FROM Account LIMIT 1];
      //  Case c = [SELECT Id, Codice_Cliente__c, Status, AccountId, Product__c  FROM Case LIMIT 1];
        Case c  = new Case (RO_Link_Bozza__c='link', Codice_Cliente__c='54412587', Status='On Hold', AccountId= acc.Id, Product__c = p.Id );
          //String idCRM =  Account.Id;
          CreaProspectService.gestatoRequestOnline(c, acc, p, '');

       Test.stopTest();

    }
    @isTest
    static void saveCasetest(){
      Case c = [SELECT Id FROM Case LIMIT 1];
      Product2 p = [SELECT Id, Family FROM Product2 LIMIT 1];
   
    Test.startTest();
    CreaProspectService.saveCase(c, p);
    System.assertNotEquals(null, c.Id, '* pass ');


    Test.stopTest();

    }
    
}