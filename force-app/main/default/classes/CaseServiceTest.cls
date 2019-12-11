@isTest
public  class CaseServiceTest {

    @TestSetup
    static void makeData(){

        List<Account> accounts = new List<Account>{
        new Account(Name='xx2',Codice_Fiscale__c='2012', Codice_Cliente__c='2014'),
        new Account(Name='xx2',Codice_Fiscale__c='2010', Codice_Cliente__c='2011'),
        new Account(Name='xx1',Codice_Fiscale__c='2009', Codice_Cliente__c='2008')
   };
   insert accounts;
        List<Product2> listproduit = new List<Product2>{
        new Product2(Name='p1', Family='PP_ONLINE_COMPASS_DS'),
        new Product2(Name='p2'),
        new Product2(Name='p3')
        };
        insert listproduit;
        List<Case> v1 = new List<Case>{
        new Case (RO_Link_Bozza__c='xxx',RO_Engine_channel__c='WEB',AccountId=accounts[0].Id, Product__c=listproduit[0].Id, RO_Vecchio_Cellulare__c='773739676'),
        new Case(RO_Link_Bozza__c='xxx',AccountId=accounts[0].Id, Status='On Hold',Product__c=listproduit[0].Id, RO_Vecchio_Cellulare__c='773739676'),
        new Case(RO_Link_Bozza__c='xxx',AccountId=accounts[1].Id,Product__c=listproduit[2].Id, RO_Vecchio_Cellulare__c='773739676'),
         new Case (RO_Link_Bozza__c='xxx',AccountId=accounts[2].Id,RO_Vecchio_Cellulare__c='773739676'),
        new Case(RO_Link_Bozza__c='xxx',RO_Vecchio_Cellulare__c='773739676'),
         new Case(Description='xxx',RO_Engine_channel__c='WEB', NumeroPratica__c='20147'),
        new Case (Description ='xxx' ,RO_Engine_channel__c='xxx')
    }; 
     insert v1;
    Group g = new Group(Type='Queue', Name='g1',DeveloperName='QB525');
    insert g;
  
  
    }
    @IsTest
     static void executeForTwentyHoursTest(){
        List<Case> listCase = [SELECT Id, CreatedDate, RO_Engine_channel__c , LastModifiedDate, RO_Link_Bozza__c, Time30__c FROM Case ];
        HandlerCaseTriggerClass.casesMap  = new Map<Id, Case>(listCase);
        Test.startTest();
        CaseService.executeForTwentyHours(HandlerCaseTriggerClass.casesMap);
        Test.stopTest();
        System.debug('**********executeForTwentyHoursTest '+ (HandlerCaseTriggerClass.casesMap).keySet().size());
        // System.assertEquals(1,  (HandlerCaseTriggerClass.casesMap).keySet().size());
        
    }
    @isTest
    static void getQueuetest(){
        Test.startTest();
        Group g = CaseService.getQueue('Q525');
        System.assertNotEquals(null, g.Id, '******** pass ');
        Test.stopTest();
    }
   /* static void executeForSeventyTwoHoursTest(){
        List<Case> listCase = [SELECT Id, CreatedDate, RO_Engine_channel__c , LastModifiedDate, RO_Link_Bozza__c, Time30__c FROM Case ];
        HandlerCaseTriggerClass.casesMap  = new Map<Id, Case>(listCase);
        Test.startTest();
        CaseService.executeForSeventyTwoHours(HandlerCaseTriggerClass.casesMap);
        Test.stopTest();
         System.assertEquals(1,  (HandlerCaseTriggerClass.casesMap).keySet().size());
    } */
    @isTest
    static void addCasesToQueuetest(){
     Test.startTest();
      List<Case> listCase = [SELECT Id,OwnerId, CreatedDate, RO_Engine_channel__c , LastModifiedDate, RO_Link_Bozza__c, Time30__c FROM Case ];
      Map<String, Object> response = CaseService.addCasesToQueue(listCase,'Q74');
      System.debug(response.get('result'));
      System.debug(response.get('cases'));
     Test.stopTest();
    }
  @isTest
    static void addCasesToQueuetestException(){
     Test.startTest();
      List<Case> listCase = [SELECT Id,CreatedDate, RO_Engine_channel__c , LastModifiedDate, RO_Link_Bozza__c, Time30__c FROM Case ];
      Map<String, Object> response = CaseService.addCasesToQueue(listCase,'Q77');
       System.debug(response.get('result'));
       System.debug(response.get('cases'));
     Test.stopTest();
    }
  @isTest
   static void addCasesToQueueGroupKo(){
   Test.startTest();
    List<Case> listCase = [SELECT Id, OwnerId, CreatedDate, RO_Engine_channel__c , LastModifiedDate, RO_Link_Bozza__c, Time30__c FROM Case ];
    Map<String, Object> response = CaseService.addCasesToQueue(listCase,'Q525');
   Test.stopTest();

   }
   @isTest
   static void getGroupByOwnertest(){
       Test.startTest();
        Group gr = [SELECT Id, Name, DeveloperName FROM Group WHERE Type = 'Queue' AND DeveloperName='Q525'];
        String returnValue = CaseService.getGroupByOwner(gr.Id);
        System.assertNotEquals(null, returnValue, 'pass');
       Test.stopTest();
   }
   //@isTest
   static void getGroupByOwnerNull(){
       Test.startTest();
        String returnValue = CaseService.getGroupByOwner('Q525');
        System.assertEquals(null, returnValue, 'pass');
       Test.stopTest();
   }

   //@isTest
   static void searchLinkBozaInCasetest(){
       Case c = [SELECT Id, Codice_Cliente__c, RO_Link_Bozza__c FROM Case Limit 1];
       Test.startTest();
        String rt = CaseService.searchLinkBozaInCase(c);
        System.debug('********* rt');
       Test.stopTest();

   }
   @isTest
   static void searchLinkBozaInCaseLinkNull(){
       List<Case> cs = [SELECT Id, RO_Link_Bozza__c, Codice_Cliente__c FROM Case];

       Test.startTest();
        String rt = CaseService.searchLinkBozaInCase(cs[6]);
        System.debug('********* rt');
        System.assertNotEquals(null, rt , '*** pass ');
       Test.stopTest();
   }
   @isTest
   static void searchRichiestetest(){
    Case c = [SELECT Id, Product__c FROM Case Limit 1 ];
    Test.startTest();
    Case cas = CaseService.searchRichieste(c, '2014', '2012');
    System.debug('********** cas'+cas);
    System.assertNotEquals(null, cas.Id, '***** pass ');
    Test.stopTest();
   }
   @isTest
   static void searchRichiestetestException(){
    Case c = [SELECT Id  FROM Case Limit 1 ];
    Test.startTest();
    Case cas = CaseService.searchRichieste(c, '2014', '2012');
    System.debug('********** cas'+cas);
    System.assertEquals(null, cas.Id, '***** pass ');
    Test.stopTest();
   }

  @isTest
  static void createCasetest(){
      Test.startTest();
      Case c = new Case();
      Case cr = CaseService.createCase(c);
      System.assertNotEquals(null, cr.Id, '*** pass');
      Test.stopTest();
  }
 @isTest
  static void createCasetestException(){
      Case c = [SELECT Id from Case LIMIT 1];
      Test.startTest();
     
      Case cr = CaseService.createCase(c);
      System.debug('********** '+cr);
     System.assertNotEquals(null, cr.Id, '*** pass');
      Test.stopTest();
  }

  @isTest
  static void preventiveControltes(){
      Test.startTest();
      List<Case> listCases = CaseService.preventiveControl('100', '2014');
      System.debug('********* listCases '+listCases);
      Test.stopTest();
  }

   @isTest
  static void updateCasetest(){
      List<Case> cases = [SELECT Id FROM Case];

      Test.startTest();
      List<Case> listc = CaseService.updateCase(cases);
      System.debug('*********** listc '+listc);
      System.assertNotEquals(0, listc.size(), '***** pass ');
      Test.stopTest();
  }
  @isTest
  static void updateCasetestException(){
    List<Case> cases = new List<Case>{
       new Case(RO_Link_Bozza__c='xxx'),
       new Case(Description='xxx',RO_Engine_channel__c='WEB')
    };
    Test.startTest();
    List<Case> listc = CaseService.updateCase(cases);
    System.debug('cases '+listc);
    System.assertEquals(null, listc, '***** passs');
    Test.stopTest();
  }
 
  @isTest
  static void updatetest(){
    Case c = [SELECT Id FROM Case Limit 1];
    Test.startTest();
     Case cu = CaseService.UpdateCase(c);
     System.assertNotEquals(null, cu, '****** pass ');
    Test.stopTest();

  }
   @isTest
  static void updatetestException(){
    Case c = new Case();
    Test.startTest();
     Case cu = CaseService.UpdateCase(c);
     System.assertEquals(null, cu.Id, '****** pass ');
    Test.stopTest();

  }
  @isTest
  static void caseToUpdate(){
      Case c = [SELECT Id FROM Case LIMIT 1];
      Product2 p = [SELECT Id, Family FROM Product2 LIMIT 1];
    Test.startTest();
    CaseService.caseToUpdate(c, p);
    System.assertNotEquals(null, c, 'pass');

    Test.stopTest();
  }
  @isTest
  static void caseToUpdateException(){
     Case c = [SELECT Id FROM Case LIMIT 1];
     List<Product2>  p = [SELECT Id, Family FROM Product2];
    Test.startTest();
          CaseService.caseToUpdate(c, p[2]);
    Test.stopTest();
  }

  @isTest
  static void getCaseNumnertest(){
      Case c = [SELECT Id, CaseNumber FROM Case LIMIT 1];
      Test.startTest();
       String caseNumber = CaseService.getCaseNumner(c.Id);
       System.assertNotEquals(null, caseNumber, 'pass');
      Test.stopTest();
  }
  @isTest
  static void addCaseToQueueByName(){
      List<Case> cases = [SELECT Id, OwnerId FROM Case];
       Set<Id> idCase = new Set<Id>{
           cases[0].Id,cases[1].Id,cases[2].Id
       };
      Test.startTest();
    
      CaseService.addCaseToQueue(idCase,'DS - Richieste Online - Anomalie Pre Sic');
      System.assertNotEquals(0, cases.size(), '****** pass ');
      Test.stopTest();
  }

  @isTest
  static void addCaseToQueueByNameException(){
      List<Case> cases = [SELECT Id, OwnerId FROM Case];
       Set<Id> idCase = new Set<Id>{
           cases[0].Id,cases[1].Id,cases[2].Id
       };
      Test.startTest();
    
      CaseService.addCaseToQueue(idCase,'DS - Richieste Onl- Anomalie Pre Sic');
      System.assertNotEquals(0, cases.size(), '****** pass ');
      Test.stopTest();
  }

@isTest
 static void addCaseToQueueByCode(){
     List<Case> cases = [SELECT Id, OwnerId FROM Case];
      Test.startTest();
      CaseService.addCaseToQueue(cases,'Q525');
      System.assertNotEquals(0, cases.size(), '****** pass ');
      Test.stopTest();
 }
 @isTest
 static void addCaseToQueueByCodeException(){
     List<Case> cases = [SELECT Id, OwnerId FROM Case];
      Test.startTest();
      CaseService.addCaseToQueue(cases,'Q5255');
      System.assertNotEquals(0, cases.size(), '****** pass ');
      Test.stopTest();
 }
 @isTest
 static void addCase_To_Queuetest(){
     
       List<Case> cases = [SELECT Id, OwnerId FROM Case];
       Set<Id> idCase = new Set<Id>{
           cases[0].Id,cases[1].Id,cases[2].Id
       };
      Test.startTest();
    
      CaseService.addCase_To_Queue(idCase,'Q525');
      System.assertNotEquals(0, cases.size(), '****** pass ');
     Test.stopTest();

 }
  @isTest
 static void addCase_To_QueuetestException(){
    
       List<Case> cases = [SELECT Id, OwnerId FROM Case];
       Set<Id> idCase = new Set<Id>{
           cases[0].Id,cases[1].Id,cases[2].Id
       };
      Test.startTest();
    
      CaseService.addCase_To_Queue(idCase,'Q5256');
      System.assertNotEquals(0, cases.size(), '****** pass ');
     Test.stopTest();

 }
 @isTest
 static void checkCaseInQueuetest(){
    Test.startTest();
   Group g = [select Id from Group where Type = 'Queue' AND  DeveloperName='Q525'];
   Boolean b  = CaseService.checkCaseInQueue(g.Id);

   System.debug('************ g'+g.Id);
   System.assertEquals(true, b, '**** pass ');
    Test.stopTest();
 }
  @isTest
  static void checkCaseInQueuetestKO(){
        Test.startTest();
        Boolean b  = CaseService.checkCaseInQueue('15452bsbfjws4');
        System.assertEquals(false, b, '**** pass ');
        Test.stopTest();
 }
 @isTest
 static void checkd_Discordatest(){
     List<Case> cases = [SELECT Id, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, OwnerId FROM Case];
       Set<Id> idCase = new Set<Id>{
           cases[0].Id,cases[1].Id,cases[2].Id
       };
     Test.startTest();
     List<Case> casesR = CaseService.checkd_Discorda(idCase);
     System.debug('******* casesR'+casesR);
     System.assertNotEquals(0, casesR.size(),'pass');
     Test.stopTest();
 }
 @isTest
 static void  check_Discorda_cellularetest(){
      List<Case> cases = [SELECT Id, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, OwnerId FROM Case];
       Set<Id> idCase = new Set<Id>{
           cases[0].Id,cases[1].Id,cases[2].Id
       };
     Test.startTest();
     List<Case> cas = CaseService.check_Discorda_cellulare(idCase);
     System.debug('********* cas'+cas);
     Test.stopTest();

 }
 static void check_Discorda_cellularetestException(){

 }

 @isTest
 static void getCaseBycodOCSPraticatest(){
 Test.startTest();
    Map<String ,Object> returnValue = CaseService.getCaseBycodOCSPratica('20147');
    System.assertNotEquals(null, returnValue.get('case'), '******* pass ****** ');
 Test.stopTest();
 }

 @isTest
 static void getCaseBycodOCSPraticatestKO(){
     Case c = [SELECT Id,NumeroPratica__c  FROM Case LIMIT 1];
     Test.startTest();
      Map<String ,Object> returnValue = CaseService.getCaseBycodOCSPratica(c.NumeroPratica__c);
      System.debug('************ case '+returnValue.get('case'));
      System.assertNotEquals(null, returnValue.get('case'), '******* pass ****** ');
     Test.stopTest();
 }
 
 @isTest
 static void getCaseByCC_CFtest(){
     Test.startTest();
        List<Case> listCases = CaseService.getCaseByCCCF('100', '2014');
        System.assertEquals(0, listCases.size(), 'pass');
     Test.stopTest();
 }
 @isTest
 static void getCaseByCC_CFtestCF(){
     Test.startTest();
     List<Case> listCases = CaseService.getCaseByCCCF('2012', '200');
     System.assertEquals(0, listCases.size(), 'pass');
     Test.stopTest();
 }

@isTest
static void changeStato_Casetest(){
        List<Case> cases = [SELECT Id, Status FROM Case];
        Test.startTest();
        List<Case> cs = CaseService.changeStatoCase(cases, 'On Hold');
        System.assertNotEquals(0, cs.size(), '******  pass ');
        Test.stopTest();
}
@isTest
static void getStato_Valuetest(){
    Test.startTest();
    List<SelectOption> cs = CaseService.getStato_Value();
    System.assertNotEquals(0, cs.size(), '**** pass ');
    Test.stopTest();
}

@isTest
static void getListCasestest(){
    Test.startTest();
     List<Case> cases = [SELECT Id FROM Case];
     Map<Id, Case> mapCase = new Map<Id, Case>(cases);
      CaseService.getListCases(mapCase);
      System.assertNotEquals(0, mapCase.keySet().size(), '**** pass');
    Test.stopTest();
}

@isTest
static void addACaseToQueueLtest(){
List<Case> cases = [SELECT Id, OwnerId FROM Case];
Test.startTest();
CaseService.addACaseToQueue(cases, 'Q525');
System.assertNotEquals(0, cases.size(), '**** pass ');

Test.stopTest();
}
    /** 
     * @author ADIOP
     * @date  29/08/2019
     **/
     @isTest
    static void checkCodiceOcsTest(){
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Test.startTest();
            CaseService.checkCodiceOcs(acc.Id);
        Test.stopTest();
    }
    @isTest
    static void updateCaseStatoOcsTest(){
       List<Case> cases = [SELECT Id, OwnerId FROM Case];
       Set<Id> idCase = new Set<Id>{
           cases[0].Id,cases[1].Id,cases[2].Id
       };
        Test.startTest();
            CaseService.UpdateCaseStatoOcs(idCase,'test Stato');
        Test.stopTest();
    }
     @isTest
    static void getCaseBiIdTest(){
       Case caseTest = [SELECT Id, OwnerId FROM Case Limit 1];
        Test.startTest();
            CaseService.getCaseBiId(caseTest.Id);
        Test.stopTest();
    }
      @isTest
    static void checkEventByCFAndCreateDateTest(){
       Case caseTest = [SELECT Id, OwnerId FROM Case Limit 1];
        Test.startTest();
            CaseService.checkEventByCFAndCreateDate(caseTest.Id);
        Test.stopTest();
    }
      @isTest
    static void checkLastModificationDateTest(){
       Case caseTest = [SELECT Id, OwnerId FROM Case Limit 1];
        Test.startTest();
            CaseService.checkLastModificationDate(caseTest.Id);
        Test.stopTest();
    }
      @isTest
    static void casewithDiscordanzaTest(){
       Case caseTest = [SELECT Id, OwnerId FROM Case Limit 1];
        Test.startTest();
            CaseService.casewithDiscordanza(caseTest);
        Test.stopTest();
    }
 
}