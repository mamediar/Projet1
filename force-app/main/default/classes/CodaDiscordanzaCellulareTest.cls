//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - @Modified By ADIOP 01/11/2019
//-- - Date         : 29/07/2019
//-- - Description  : Handle CodaDiscordanzaCellulareTest
//----------------------------------------------------------------------
@isTest
public  class CodaDiscordanzaCellulareTest {


    public static final String AFTER_THIRTY_MINUTES = 'afterThirtyMinutes';
    public static final String AFTER_THREE_THREE_HOURS = 'afterThreeHours';
    public static final String AFTER_TWO_TWO_HOURS = 'afterTwoHours';
    
    @TestSetup
    static void makeData(){
            
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

        accts.add(a1);
        accts.add(a2);
        accts.add(a3);
        accts.add(a4);
        accts.add(a5);

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
        
        contacts.add(con1);
        contacts.add(con2);
        contacts.add(con3);
        contacts.add(con4);
        contacts.add(con5);

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

        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','CRM_RichiestaOnline');

        Case v1 = new Case (Stato_Pratica__c='20',AccountId=accts[0].Id,NumeroPratica__c='18866725',
        Attributi_Pratica__c ='SD',stato_ocs__c='20SD',RO_Vecchio_Cellulare__c='773528750',
        Product__c=listproduit[0].Id,RecordTypeId=recordType,Subject='This is a test case for testCaseForForum');    
        insert v1;
    }

    @IsTest
    static void performCRMActivityTest(){
    
        List<Case> listCase = [SELECT Id,LastModifiedDate ,caseNumber  FROM Case ];
        String caseNumber;
        Test.startTest();
        for(Case c : listCase){
            System.debug('Id  '+ c.id );
            caseNumber=c.caseNumber ;
            System.debug('caseNumber  '+ caseNumber );
        }
        //ID thisCaseId
        CodaDiscordanzaCellulare.PerformCRMActivityResponse performCRMActResp = CodaDiscordanzaCellulare.performCRMActivity(caseNumber, 'C0', '327 2635104', 
        '348 5958536' , 'note 1');
        System.assert(performCRMActResp.resultCode != 1,'');
        Case v1 = new Case (Stato_Pratica__c=null,AccountId=null,Product__c=null);

        CodaDiscordanzaCellulare.CaseWrapper caseW = new CodaDiscordanzaCellulare.CaseWrapper(v1);
        caseW.numeroPratica='';
        caseW.tipoPratica='';
        caseW.vecchioCell='';
        caseW.oldValue='';
        caseW.nuovoCell='';
        caseW.testoNota='';

        System.assertEquals(1, listCase.size(), 'listCase.size()==1');
        Test.stopTest();
    }

    @IsTest
    static void getnumeroPraticaAndIdTest(){

        Test.startTest();
        List<Case> listCase = [SELECT Id,LastModifiedDate ,caseNumber  FROM Case ];
        String caseNumber;
        for(Case c : listCase){
            System.debug('Id  '+ c.id );
            caseNumber=c.caseNumber ;
            System.debug('caseNumber  '+ caseNumber );
            }
        Case ca=CodaDiscordanzaCellulare.getnumeroPraticaAndId(caseNumber);
        System.assert(ca != null,'');  
        Test.stopTest();
    }

    @IsTest
    static void getnumeroPraticaAndIdExceptionTest(){

        Test.startTest();
        List<Case> listCase = [SELECT Id,LastModifiedDate ,caseNumber,NumeroPratica__c  FROM Case ];
        String numeroPratica;
        for(Case c : listCase){
            System.debug('Id  '+ c.id );
            numeroPratica=c.NumeroPratica__c ;
            System.debug('numeroPratica  '+ numeroPratica );
            }
        Case ca=CodaDiscordanzaCellulare.getnumeroPraticaAndId(numeroPratica);
        System.assert(ca == null,'');  
        Test.stopTest();
    }
}