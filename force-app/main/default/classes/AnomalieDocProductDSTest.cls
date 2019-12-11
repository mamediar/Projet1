//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 15/07/2019
//-- - Description  : Handle AnomalieDocProductDSTest
//----------------------------------------------------------------------
@isTest
public  class AnomalieDocProductDSTest {

public static final String AFTER_THIRTY_MINUTES = 'afterThirtyMinutes';
public static final String AFTER_THREE_THREE_HOURS = 'afterThreeHours';
public static final String AFTER_TWO_TWO_HOURS = 'afterTwoHours';
@TestSetup
static void makeData(){
    String response = '{"resultCode": 0,"resultMessage": "Ok","recuperaStatiAttributiPrtResponse": {  "elencoPratiche": [{"tipoPratica": "CA","numPratica": "33190097388","statoPratica": "05","attrbutoPratica": "BT","canale": "MAE"}]}}';
    ApiRest__c apiRest = new ApiRest__c(Method__c = 'POST' ,
                                        Test_Response__c= response ,
                                        Test_Request__c = 'testRequest',
                                        Mock__c = false, 
                                        User__c = 'CDSLF00',
                                        Password__c = 'P00FLSDC' ,
                                        Name ='recuperaStatiAttributiPrt',
                                        EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
    insert apiRest;  

    List<XCS_Template__c> templateTesto = new List<XCS_Template__c>{
        new XCS_Template__c(Body__c='Gentile Cliente',Name='SMSAnomalieContratto_DS'),
        new XCS_Template__c(Body__c='Siamo lieti',Name='SMSAnomalieContratto_DSP'),
        new XCS_Template__c(Body__c='Abbiamo riscontrato',Name='SMSAnomalieDoc_DS'),
        new XCS_Template__c(Body__c='Abbiamo riscontrato',Name='SMSAnomalieDoc_DSP'),
        new XCS_Template__c(Body__c='Gentile Cliente',Name='SMSRassicuraCliente_DS'),
        new XCS_Template__c(Body__c='Gentile Cliente',Name='SMSRassicuraCliente_DSP')
        };
        insert templateTesto;
        
    Account[] accts = new List < Account > ();

    Account a1 = new Account(
    Name = 'test1', DEM_Da_Inviare__c = false,  BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911134');

    Account a2 = new Account(
    Name = 'test2', DEM_Da_Inviare__c = true, BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911135');

    Account a3 = new Account(
    Name = 'test3', DEM_Da_Inviare__c = false,  BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911136');

    Account a4 = new Account(
    Name = 'test4', DEM_Da_Inviare__c = false,  BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911137');

    Account a5 = new Account(
    Name = 'test5', DEM_Da_Inviare__c = true,  BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911138');

    
    Account a6 = new Account(
    Name = 'test6', DEM_Da_Inviare__c = true,  BillingCity = 'San Francisco', OCS_External_Id__c = null);


    accts.add(a1);
    accts.add(a2);
    accts.add(a3);
    accts.add(a4);
    accts.add(a5);
    accts.add(a6);

    insert accts;

    System.debug(' listAccount '+ accts );


    Contact[] contacts = new List < Contact > ();
    Contact con1 = new Contact(
    FirstName = 'Joe', LastName = 'Smith', Phone = '415.555.1212', DEM_Da_Inviare__c = false, Ultima_DEM_Inserita__c = DateTime.now(), AccountId = a1.ID);
    Contact con2 = new Contact(
    FirstName = 'Ahmet', LastName = 'CISSE', Phone = '415.655.1312', DEM_Da_Inviare__c = false, Ultima_DEM_Inserita__c = DateTime.newInstance(2019, 5, 8, 10, 8, 16), AccountId = a2.ID);

    Contact con3 = new Contact(
    FirstName = 'Joe', LastName = 'Smith', Phone = '415.555.1212', DEM_Da_Inviare__c = true, Ultima_DEM_Inserita__c = DateTime.newInstance(2019, 5, 8, 10, 8, 16), AccountId = a3.ID);
    Contact con4 = new Contact(
    FirstName = 'Ahmet', LastName = 'CISSE', Phone = '415.655.1312', DEM_Da_Inviare__c = true, Ultima_DEM_Inserita__c = DateTime.now(), AccountId = a4.ID);

    Contact con5 = new Contact(
    FirstName = 'Joe', LastName = 'Smith', Phone = '415.555.1212', DEM_Da_Inviare__c = true, Ultima_DEM_Inserita__c = null, AccountId = a5.ID);

    Contact con6 = new Contact(
    FirstName = 'Joe', LastName = 'Smith', Phone = '415.555.1212', DEM_Da_Inviare__c = true, Ultima_DEM_Inserita__c = null, AccountId = a6.ID);
    

    
    contacts.add(con1);
    contacts.add(con2);
    contacts.add(con3);
    contacts.add(con4);
    contacts.add(con5);
    contacts.add(con6);
    
    insert contacts;


List<Product2> listproduit = new List<Product2>{
        new Product2(Name='Produit1', Family='PP_ONLINE_COMPASS_DS',DEMAnomalie__c='2072'),
        new Product2(Name='Produit2', Family='PP_ONLINE_PARTNER_DS',DEMAnomalie__c='2072'),
        new Product2(Name='Produit3', Family='PP_ONLINE_COMPASS_DS',DEMAnomalie__c='2072'),
        new Product2(Name='Produit4', Family='PF_ECOMMERCE_STANDARD',DEMAnomalie__c='2072'),
        new Product2(Name='Produit5', Family='PP_ONLINE_PARTNER_DS',DEMAnomalie__c='2072'),
        new Product2(Name='Produit6', Family='PP_ONLINE_COMPASS_DS',DEMAnomalie__c='2072'),
        new Product2(Name='Produit7', Family='PP_ONLINE_COMPASS_DS',DEMAnomalie__c='2072'),
        new Product2(Name='Produit8', Family='PP_ONLINE_COMPASS_DS',DEMAnomalie__c='2072'),
        new Product2(Name='Produit9', Family='PP_ONLINE_COMPASS_DS',DEMAnomalie__c='2072'),
        new Product2(Name='Produit10', Family='PF_ECOMMERCE_STANDARD',DEMAnomalie__c='2072'),
        new Product2(Name='Produit11', Family='PF_ECOMMERCE_STANDARD',DEMAnomalie__c='2072')
};
insert listproduit;
System.debug(' listproduit '+ listproduit );

List<Case> v1 = new List<Case>{
        new Case (Stato_Pratica__c='20',AccountId=accts[0].Id,NumeroPratica__c='18866725',
        Attributi_Pratica__c ='SD',stato_ocs__c='20SD',RO_Link_Bozza__c='https://compass--dev3.lightning.force.com/lightning/n/Gestione_Campagna',RO_Vecchio_Cellulare__c='773528750',
        Product__c=listproduit[0].Id),
        new Case(Stato_Pratica__c=null,AccountId=accts[1].Id,NumeroPratica__c='18866725',
        Attributi_Pratica__c =null,stato_ocs__c='30',RO_Link_Bozza__c='https://compass--dev3.lightning.force.com/lightning/n/Gestione_Campagna',RO_Vecchio_Cellulare__c='773528750',
        Product__c=listproduit[0].Id),
        new Case(Stato_Pratica__c='05', AccountId=accts[0].Id,NumeroPratica__c='18866725',
        Attributi_Pratica__c ='BT',stato_ocs__c='05BT',RO_Link_Bozza__c='https://compass--dev3.lightning.force.com/lightning/n/Gestione_Campagna',RO_Vecchio_Cellulare__c='773528750',
        Product__c=listproduit[0].Id),
        new Case(Stato_Pratica__c=null, AccountId=accts[5].Id,NumeroPratica__c=null,
        Attributi_Pratica__c =null,stato_ocs__c=null,RO_Link_Bozza__c='https://compass--dev3.lightning.force.com/lightning/n/Gestione_Campagna',RO_Vecchio_Cellulare__c='773528750',
        Product__c=listproduit[0].Id)
}; 

insert v1;
System.debug(' case '+ v1 );

List<Anomalie_Doc__c> ano = new List<Anomalie_Doc__c>{
        new Anomalie_Doc__c (Descrizione_Anomalia_Op__c='Descrizione_Anomalia',Codice_Macro_Documento__c=null,
        codice_Anomalia__c=null,CaseId__c=v1[0].Id),
        new Anomalie_Doc__c(Descrizione_Anomalia_Op__c=null,Codice_Macro_Documento__c='RIC',
        codice_Anomalia__c='codice_Anomalia',CaseId__c=v1[1].Id),
        new Anomalie_Doc__c(Descrizione_Anomalia_Op__c='Descrizione_Anomalia',Codice_Macro_Documento__c=null,
        codice_Anomalia__c='codice_Anomalia',CaseId__c=v1[2].Id),
        new Anomalie_Doc__c(Descrizione_Anomalia_Op__c=null,Codice_Macro_Documento__c=null,
        codice_Anomalia__c='codice_Anomalia',CaseId__c=v1[3].Id)
}; 
System.debug(' ano '+ ano );
insert ano;
List<RO_CRMRich_online_steplog__c> richOnlineStepLog = new List<RO_CRMRich_online_steplog__c>
{
    new RO_CRMRich_online_steplog__c (RO_CRMStep__c='Step 10 - Contratto Firmato con FEA',
    RO_CRMRichiesta_Online__c=v1[1].Id),
    new RO_CRMRich_online_steplog__c (RO_CRMStep__c='Step 8 - Scelta Firma',
    RO_CRMRichiesta_Online__c=v1[1].Id)
};
insert richOnlineStepLog;


Group[] codaGroup = new List < Group > ();
Group codaTest = new Group(Type = 'Queue',
            Name = 'DS - Richieste Online - Abbandono Web',
            DeveloperName = 'Q330');

Group codaTest1 =   new Group(Type = 'Queue',
    Name = 'DS - Richieste Online - Abbandono Non Fo',
    DeveloperName = 'Q331');
Group codaTest2  =new Group(Type = 'Queue',
        Name = 'DS - Richieste Online - Abbandono Forzos',
        DeveloperName = 'Q332');

Group codaTest3  =new Group(Type = 'Queue',
        Name = 'DS - Richieste Online - Abbandono Richia',
        DeveloperName = 'Q333');
Group codaTest4  =new Group(Type = 'Queue',
        Name = 'DS - Richieste Online - Abbandono Web',
        DeveloperName = 'Q336');
Group codaTest5  =new Group(Type = 'Queue',
        Name = 'DS - Richieste Online - Anomalie Pre Sic',
        DeveloperName = 'Q339');
Group codaTest6  = new Group(Type = 'Queue',Name = 'DS - Richieste Online - Anomalie Post Si',
        DeveloperName = 'Q340');
Group codaTest7   =new Group(Type = 'Queue',
        Name = 'DS - Richieste Online - Sollecito Contra',
        DeveloperName = 'Q341');
Group codaTest8   =new Group(Type = 'Queue',
        Name = 'DP - Abbandono',
        DeveloperName = 'Q375');
Group codaTest9 = new Group(Type = 'Queue',
        Name = 'DP - Anomalie',
        DeveloperName = 'Q376');
Group codaTest10 =new Group(Type = 'Queue',
        Name = 'DP - Sollecito Contratto',
        DeveloperName = 'Q377');

codaGroup.add(codaTest);
codaGroup.add(codaTest1);
codaGroup.add(codaTest2);
codaGroup.add(codaTest3);
codaGroup.add(codaTest4);
codaGroup.add(codaTest5);
codaGroup.add(codaTest6);
codaGroup.add(codaTest7);
codaGroup.add(codaTest8);
codaGroup.add(codaTest9);
codaGroup.add(codaTest10);
//insert codaGroup;
        

}


@IsTest
static void dEMAnomalieDocumentaliDSCodiceClientNotExistTest(){
    List<Case> listCase = [SELECT Id,LastModifiedDate ,
    Product__r.DEMAnomalie__c , Product__r.Family,AccountId  FROM Case ];
    DateTime fireTime;
    Set<Id> caseIds = new Set<Id>();
    Id idAccount;
    String nameOfCampaign;
    Test.startTest();
    System.debug(' listCase '+ listCase );
    for(Case c : listCase){
        System.debug('Id  '+ c.id );
        caseIds.add(c.Id);
        fireTime=c.LastModifiedDate;
        nameOfCampaign = 'DEM'+c.Product__r.DEMAnomalie__c;
        idAccount = c.AccountId;
        }
        AnomalieDocProductDS.dEMAnomalieDocumentaliDS(idAccount,caseIds);
        System.assertEquals(4, listCase.size(), 'listCase.size()==4');
     Test.stopTest();
}

@IsTest
static void dEMAnomalieDocumentaliDSCodiceClientExistTest(){
    List<Case> listCase = [SELECT Id,LastModifiedDate ,
    Product__r.DEMAnomalie__c , Product__r.Family,AccountId  FROM Case ];
    Set<Id> caseIds = new Set<Id>();
    Id idlistCase=listCase[1].Id;
    caseIds.add(idlistCase);
    List<Anomalie_Doc__c> anomalibyId =AnomalieSelector.listAnomalieByID(caseIds);
    DateTime fireTime;
    Id idAccount;
    Test.startTest();
    System.debug(' listCase '+ listCase );
    for(Anomalie_Doc__c ano : anomalibyId){
        idAccount = ano.CaseId__r.AccountId;
        }
        AnomalieDocProductDS.dEMAnomalieDocumentaliDS(idAccount,caseIds);
        System.assertEquals(4, listCase.size(), 'listCase.size()==5');
     Test.stopTest();
}

// @IsTest
// static void dEMAccountReassuranceDSTest(){
//     List<Case> listCase = [SELECT Id,LastModifiedDate ,
//     Product__r.DEMAnomalie__c , Product__r.Family,AccountId  FROM Case ];
//     DateTime fireTime;
//     Set<Id> caseIds = new Set<Id>();
//     Id idAccount;
//     String nameOfCampaign;
//     Test.startTest();
//     System.debug(' listCase '+ listCase );
//     for(Case c : listCase){
//         System.debug('Id  '+ c.id );
        
//         caseIds.add(c.Id);
//         fireTime=c.LastModifiedDate;
//         nameOfCampaign = 'DEM'+c.Product__r.DEMAnomalie__c;
//         idAccount = c.AccountId;
//         }
//         AnomalieDocProductDS.dEMAccountReassuranceDS(idAccount,caseIds, nameOfCampaign);
//         System.assertEquals(4, listCase.size(), 'listCase.size()==4');
//      Test.stopTest();
// }

// @IsTest
// static void anomaliePreSicPPTest(){
//     List<Case> listCase = [SELECT Id,LastModifiedDate ,
//     Product__r.DEMAnomalie__c , Product__r.Family,AccountId  FROM Case WHERE stato_ocs__c='05BT' ];
//     DateTime fireTime;
//     Set<Id> caseIds = new Set<Id>();
//     Id idAccount;
//     String nameOfCampaign;
//     Test.startTest();
//     System.debug(' listCase '+ listCase );
//     for(Case c : listCase){
//         System.debug('Id  '+ c.id );
        
//         caseIds.add(c.Id);
//         fireTime=c.LastModifiedDate;
//         nameOfCampaign = 'DEM'+c.Product__r.DEMAnomalie__c;
//         idAccount = c.AccountId;
//         }
//         UtilityMockResponse umr = new UtilityMockResponse();
//         umr.apiname ='recuperaStatiAttributiPrt';
//         Test.setMock(HttpCalloutMock.class, umr);
//         AnomalieDocProductDS.anomaliePreSicPP(caseIds);
//         System.assertEquals(1, listCase.size(), 'listCase.size()==1');
//      Test.stopTest();
// }
// @IsTest
// static void anomaliePostSicPPTest(){
//     List<Case> listCase = [SELECT Id,LastModifiedDate ,
//     Product__r.DEMAnomalie__c , Product__r.Family,AccountId  FROM Case ];
//     DateTime fireTime;
//     Set<Id> caseIds = new Set<Id>();
//     Id idAccount;
//     String nameOfCampaign;
//     Test.startTest();
//     System.debug(' listCase '+ listCase );
//     for(Case c : listCase){
//         System.debug('Id  '+ c.id );
        
//         caseIds.add(c.Id);
//         fireTime=c.LastModifiedDate;
//         nameOfCampaign = 'DEM'+c.Product__r.DEMAnomalie__c;
//         idAccount = c.AccountId;
//         }
//         UtilityMockResponse umr = new UtilityMockResponse();
//         umr.apiname ='recuperaStatiAttributiPrt';
//         Test.setMock(HttpCalloutMock.class, umr);

//         AnomalieDocProductDS.anomaliePostSicPP(caseIds);
//         System.assertEquals(4, listCase.size(), 'listCase.size()==4');
//      Test.stopTest();
// }

// @IsTest
// static void codaSollecitoContrattoTest(){
//     List<Case> listCase = [SELECT Id,LastModifiedDate ,
//     Product__r.DEMAnomalie__c , Product__r.Family,AccountId  FROM Case ];
//     DateTime fireTime;
//     Set<Id> caseIds = new Set<Id>();
//     Id idAccount;
//     String nameOfCampaign;
//     String cronAfterFiveDays;
//     Test.startTest();
//     System.debug(' listCase '+ listCase );
//     for(Case c : listCase){
//         System.debug('Id  '+ c.id );
        
//         caseIds.add(c.Id);
//         fireTime=c.LastModifiedDate;
//         cronAfterFiveDays=CaseHandlerTriggerClass.createCronExpressionFromDateTimeFiveDays(c.LastModifiedDate);
//         nameOfCampaign = 'DEM'+c.Product__r.DEMAnomalie__c;
//         idAccount = c.AccountId;
//         }
//         AnomalieDocProductDS.codaSollecitoContratto(caseIds);
//         AnomalieDocProductDS.checkCodaSolContrattoAfterThirtyMinutes(caseIds);
//         AnomalieDocProductDS.checkCodaSolContrattoAfterFiveDays(caseIds);
//         AnomalieDocProductDS.executeSheduleFiveDays(cronAfterFiveDays,caseIds);
//         System.assertEquals(4, listCase.size(), 'listCase.size()==4');
//      Test.stopTest();
// }

}