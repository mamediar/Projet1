@isTest
public  class AggiornamentoPraticeDSPTest {
    
     @TestSetup
        static void makeData(){
        List<Product2> listproduit = new List<Product2>{
        new Product2(Name='Produit1', Family='PF_ECOMMERCE_STANDARD'),
        new Product2(Name='Produit2', Family='PP_ONLINE_PARTNER_DS'),
        new Product2(Name='Produit3', Family='PP_ONLINE_COMPASS_DS'),
        new Product2(Name='Produit4', Family='PF_ECOMMERCE_STANDARD'),
        new Product2(Name='Produit5', Family='PP_ONLINE_PARTNER_DS'),
        new Product2(Name='Produit6', Family='PP_ONLINE_COMPASS_DS'),
        new Product2(Name='Produit7', Family='PP_ONLINE_COMPASS_DS'),
        new Product2(Name='Produit8', Family='PP_ONLINE_COMPASS_DS'),
        new Product2(Name='Produit9', Family='PP_ONLINE_COMPASS_DS'),
        new Product2(Name='Produit10', Family='PF_ECOMMERCE_STANDARD'),
        new Product2(Name='Produit11', Family='PF_ECOMMERCE_STANDARD')
        };
        insert listproduit;

        List<Case> v1 = new List<Case>{
        new Case (RO_Link_Bozza__c='xxx',RO_Engine_channel__c='WEB', Product__c=listproduit[0].Id),
        new Case(RO_Link_Bozza__c='xxx',Product__c=listproduit[1].Id),
        new Case(RO_Link_Bozza__c='xxx',RO_Engine_channel__c = 'forzoso Filiale',
                 Product__c=listproduit[2].Id),
        new Case (RO_Link_Bozza__c='xxx',Product__c=listproduit[3].Id, RO_Engine_channel__c='WEB' ),
        new Case(RO_Link_Bozza__c='xxx', RO_Engine_channel__c = 'Non forzoso Filiale',
                RO_Current_Step__c = 'Step 1 - Scelta cliente', Product__c=listproduit[4].Id),
        new Case(Description='xxx',RO_Engine_channel__c='WEB',Product__c=listproduit[5].Id),
        new Case (Description ='xxx' ,RO_Engine_channel__c='xxx',Product__c=listproduit[6].Id)

        }; 

        insert v1;
        List<XCS_Template__c> templateTesto = new  List<XCS_Template__c>{
        new  XCS_Template__c (Name='SMSAbbandonoNONForzPreSecci', Body__c='template test'),
        new  XCS_Template__c (Name='SMSAbbandonoWEBPreSecci', Body__c='template test'),
        new  XCS_Template__c (Name='SMSAbbandonoWEBPostSecci', Body__c='template test'),
        new  XCS_Template__c (Name='SMSAbbandonoForz', Body__c='template test'),
        new  XCS_Template__c (Name='SMSAbbandonoPostSecci', Body__c='template test'),
        new  XCS_Template__c (Name='SMSAbbandonoPreSecci', Body__c='template test') 
        };
        insert templateTesto;

        Group g = new Group(Name ='q1',Type='Queue', DeveloperName ='Q1001');
        insert g;

        }

@isTest
static void aggiornamentoDSPTest(){
    Test.startTest();
        List<Case> cases = [SELECT Id , RO_Link_Bozza__c,LastModifiedDate, 
                                   AccountId, Account.getCodice_Cliente__c, 
                                  Product__r.DEMAnomalie__c, Account.Phone FROM Case];
        Map<Id, Case> caseMap = new Map<Id, Case>(cases);
        Map<Id, Case> casesR = new Map<Id, Case>();
        AggiornamentoPraticeDSP.aggiornamentoDSP(cases, casesR);
        System.assertEquals(0, casesR.keySet().size(), '******* pass');

    Test.stopTest();
}
@isTest
static void abbandonaPrimaDelSecciDSPEmptytest(){
  Test.startTest();
   Map<Id, Case> caseMap = new Map<Id, Case>();
    Map<Id, Case> casesR = new Map<Id, Case>();
   AggiornamentoPraticeDSP.abbandonaPrimaDelSecciDSP(caseMap, casesR);
   System.assertEquals(0, caseMap.keySet().size(), '****** pass ');
  Test.stopTest();
}
@isTest
static void abbandonaPrimaDelSecciDSPNotEmptytest(){
  Test.startTest();
     List<Case> cases = [SELECT Id , RO_Link_Bozza__c,LastModifiedDate, AccountId, Product__r.DEMAnomalie__c FROM Case];
   Map<Id, Case> caseMap = new Map<Id, Case>(cases);
    Map<Id, Case> casesR = new Map<Id, Case>();
   AggiornamentoPraticeDSP.abbandonaPrimaDelSecciDSP(caseMap, casesR);
   System.assertEquals(0, casesR.keySet().size(), '****** pass ');
  Test.stopTest();
}

@isTest
static void abbandonaPrimaDelSecciDSPAzioniTest(){
 Test.startTest();
  Map<Id, Case> caseMap = new Map<Id, Case>();
  AggiornamentoPraticeDSP.abbandonaPrimaDelSecciDSPAzioni(caseMap);
  System.assertEquals(0, caseMap.keySet().size(), '***** test');
 Test.stopTest();
}
@isTest
static void abbandonaPrimaDelSecciDSPAzioniNotEmptyTest(){
 Test.startTest();
   List<Case> cases = [SELECT Id , RO_Link_Bozza__c,
                              LastModifiedDate, AccountId, Account.getCodice_Cliente__c,
                              Account.Phone, Product__r.DEMAnomalie__c FROM Case];
  Map<Id, Case> caseMap = new Map<Id, Case>(cases);
   Map<Id, Case> caseMapR = new Map<Id, Case>();
   Contact c = new Contact( Email='layepythagore@gmail.com', FirstName='Laye', LastName='Diop', DEM_Param_7__c='yes', DEM_Param_8__c='NO', DEM_Param_9__c='yes', AccountId = cases[0].AccountId);
   insert c;
    
  AggiornamentoPraticeDSP.abbandonaPrimaDelSecciDSPAzioni(caseMap);
  System.assertEquals(0, caseMapR.keySet().size(), '***** test');
 Test.stopTest();
}
@isTest
static void abbandonaPostSecciDSPNotEmptytest(){
    Test.startTest();
      List<Case> cases = [SELECT Id , RO_Link_Bozza__c,
                              LastModifiedDate, AccountId, 
                              Account.Phone, Account.getCodice_Cliente__c,
                              Product__r.DEMAnomalie__c FROM Case];
    Map<Id, Case> caseMap = new Map<Id, Case>(cases);
    Map<Id, Case> casesR = new Map<Id, Case>();
    AggiornamentoPraticeDSP.abbandonaPostSecciDSP(caseMap, casesR);
    System.assertEquals(0, casesR.keySet().size(), '****** pass **');
    Test.stopTest();
}
@isTest
static void abbandonaPostSecciDSPEmptytest(){
    Test.startTest();
    Map<Id, Case> caseMap = new Map<Id, Case>();
    Map<Id, Case> casesR = new Map<Id, Case>();
    AggiornamentoPraticeDSP.abbandonaPostSecciDSP(caseMap, casesR);
    System.assertEquals(0, casesR.keySet().size(), '****** pass **');
    Test.stopTest();
}
@isTest
static void abbandonaPostSecciDSPAzioniEmtyTest(){
    Test.startTest();
      Map<Id, Case> caseMap = new Map<Id, Case>();
      AggiornamentoPraticeDSP.abbandonaPostSecciDSPAzioni(caseMap);
      System.assertEquals(0, caseMap.keySet().size(), '*** pas');
    Test.stopTest();

}
@isTest
static void abbandonaPostSecciDSPAzioniNotEmtyTest(){
    Test.startTest();
  List<Case> cases = [SELECT Id , RO_Link_Bozza__c,
                              LastModifiedDate, AccountId, 
                              Account.Phone, Account.getCodice_Cliente__c,
                              Product__r.DEMAnomalie__c FROM Case];
    Map<Id, Case> caseMap = new Map<Id, Case>(cases);
    Contact c = new Contact( Email='layepythagore@gmail.com', FirstName='Laye', LastName='Diop', DEM_Param_7__c='yes', DEM_Param_8__c='NO', DEM_Param_9__c='yes', AccountId = cases[0].AccountId);
   	insert c;
    AggiornamentoPraticeDSP.abbandonaPostSecciDSPAzioni(caseMap);
    System.assertNotEquals(0, caseMap.keySet().size(), '*** pas');
    Test.stopTest();

}

}