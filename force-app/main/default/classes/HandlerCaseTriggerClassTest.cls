@isTest
public  class HandlerCaseTriggerClassTest {
   
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
        new Case(RO_Link_Bozza__c='xxx',Product__c=listproduit[2].Id),
         new Case (RO_Link_Bozza__c='xxx',Product__c=listproduit[3].Id),
        new Case(RO_Link_Bozza__c='xxx',Product__c=listproduit[4].Id),
         new Case(Description='xxx',RO_Engine_channel__c='WEB',Product__c=listproduit[5].Id),
        new Case (Description ='xxx' ,RO_Engine_channel__c='xxx',Product__c=listproduit[6].Id)
         /**   new Case(RO_Link_Bozza__c='xxx'),
        new Case(RO_Link_Bozza__c='xxx'),
         new Case(RO_Link_Bozza__c='xxx'),
        new Case(RO_Link_Bozza__c='xxx'),
         new Case (RO_Link_Bozza__c='xxx'),
        new Case(RO_Link_Bozza__c='xxx'),
        new Case(RO_Link_Bozza__c='xxx') */
    }; 

    insert v1;
    List<XCS_Template__c> templateTesto = new  List<XCS_Template__c>{
      new  XCS_Template__c (Name='SMSAbbandonoNONForzPreSecci', Body__c='template test'),
      new  XCS_Template__c (Name='SMSAbbandonoWEBPreSecci', Body__c='template test'),
      new  XCS_Template__c (Name='SMSAbbandonoWEBPostSecci', Body__c='template test'),
      new  XCS_Template__c (Name='SMSAbbandonoForz', Body__c='template test'),
       new  XCS_Template__c (Name='SMSAbbandonoPostSecci', Body__c='template test')
    };
    insert templateTesto;

}

@IsTest
static void methodName(){
    List<Case> listCase = [SELECT Id, CreatedDate, RO_Engine_channel__c , LastModifiedDate, RO_Link_Bozza__c, Time30__c FROM Case ];

    
    Test.startTest();
    for(Case c : listCase){
        System.debug('RO_Engine_channel__c  '+ c.RO_Engine_channel__c + ' RO_Link_Bozza__c  '+c.RO_Link_Bozza__c);
        c.Description ='test';
    }
    HandlerCaseTriggerClass.contattiInFaseDiCaricoDSPrimoInvio(listCase);
  

    Test.stopTest();
    System.debug('after test stoped');
    
}

@isTest
static void aggiornamentoHandlertest(){
    List<Case> listCases = [SELECT Id, Product__c FROM Case LIMIT 4];
    
    Test.startTest();
    //Map<String, List<Case>> mapCases =  HandlerCaseTriggerClass.aggiornamentoHandler(listCases);
 /**    for(String key : mapCases.keySet()){
        System.debug(' ********** '+mapCases.get(key));
    }
    System.assertEquals(3, mapCases.keySet().size(), '********* Yes ********** '); */
    Test.stopTest();
}

@isTest
static void dsEcomDSPaggiornamentotest(){
    List<Case> caseList = [SELECT Id, RO_Engine_channel__c, Time30__c FROM Case ];
    Test.startTest();
    Map<String, List<Case>> returnValue = HandlerCaseTriggerClass.DsEcomDSPaggiornamento(caseList);
    System.assertEquals(2, (returnValue.get('ECOM')).size(), '** pass ** ');
    System.assertEquals(3, (returnValue.get('DS')).size(), '** pass ** ');
    System.assertEquals(2, (returnValue.get('DSP')).size(), '** pass ** ');
    Test.stopTest();
}
@isTest
static void dsEcomDSPaggiornamentotestException(){
    List<Case> caseList = [SELECT  Product__c FROM Case];
    Test.startTest();
    Map<String, List<Case>> returnValue = HandlerCaseTriggerClass.DsEcomDSPaggiornamento(caseList);
    System.debug('******* test '+ (returnValue.get('ECOM')).size() );
     System.assertEquals(2, (returnValue.get('ECOM')).size() , '** pass ** ');

    Test.stopTest();
}
@isTest 
static void schedulableJobstestEmpty(){
    List<Case> listCase = new List<Case>();
    Test.startTest();
    Map<Id,Case> caseMap = new Map<Id,Case>(listCase);
    HandlerCaseTriggerClass.schedulableJobs(caseMap);
    System.debug('*********** schedulableJobstestEmpty ******** '+caseMap.keySet().size());
    System.assertEquals(0, caseMap.keySet().size(), '***** pass');
    Test.stopTest();
}                                                                                                                                           

@isTest
static void schedulableJobstestNotEmpty(){
     List<Case> listCase = [SELECT Id,RO_Engine_channel__c FROM Case];
     Test.startTest();
     Map<Id,Case> caseMap = new Map<Id,Case>(listCase);
     System.debug('*********** size case ******** '+caseMap.keySet().size());
     HandlerCaseTriggerClass.schedulableJobs(caseMap);
     System.assertEquals(7, caseMap.keySet().size(), '***** pass *****');
     Test.stopTest();
}
}