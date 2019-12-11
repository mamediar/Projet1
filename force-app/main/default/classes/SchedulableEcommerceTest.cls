@IsTest
public class SchedulableEcommerceTest {
    
    public static final String AFTER_THIRTY_MINUTES    = 'afterThirtyMinutes';
    public static final String AFTER_THREE_THREE_HOURS = 'afterThreeHours';
    public static final String AFTER_TWO_TWO_HOURS     = 'afterTwoHours';
    
    public static final String AFTER_FIVE_DAYS         = 'afterFiveDays';

    @TestSetup
    static void makeData()
    {
        String response = '{"resultCode": 0,"resultMessage": "Ok","recuperaStatiAttributiPrtResponse": {  "elencoPratiche": [{"tipoPratica": "CA","numPratica": "33190097388","statoPratica": "60","attrbutoPratica": "RT","canale": "MAE"}]}}';
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

        List<Case> v1 = new List<Case>{
                    new Case (Stato_Pratica__c='20',AccountId=accts[0].Id,NumeroPratica__c='18866725',
                    Attributi_Pratica__c ='SD',stato_ocs__c='20SD',RO_Vecchio_Cellulare__c='773528750',
                    Product__c=listproduit[0].Id),
                    new Case(Stato_Pratica__c=null,AccountId=accts[1].Id,NumeroPratica__c='18866725',
                    Attributi_Pratica__c =null,stato_ocs__c='30',RO_Vecchio_Cellulare__c='773528750',
                    Product__c=listproduit[0].Id),
                    new Case(Stato_Pratica__c='05', AccountId=accts[0].Id,NumeroPratica__c='18866725',
                    Attributi_Pratica__c ='BT',stato_ocs__c='05BT',RO_Vecchio_Cellulare__c='773528750',
                    Product__c=listproduit[0].Id)
        }; 

        insert v1;
        System.debug(' case '+ v1 );
        List<Anomalie_Doc__c> ano = new List<Anomalie_Doc__c>{
                    new Anomalie_Doc__c (Descrizione_Anomalia_Op__c='Descrizione_Anomalia',Codice_Macro_Documento__c='RIC',
                    codice_Anomalia__c='codice_Anomalia',CaseId__c=v1[0].Id),
                    new Anomalie_Doc__c(Descrizione_Anomalia_Op__c=null,Codice_Macro_Documento__c='RIC',
                    codice_Anomalia__c='codice_Anomalia',CaseId__c=v1[1].Id),
                    new Anomalie_Doc__c(Descrizione_Anomalia_Op__c='Descrizione_Anomalia',Codice_Macro_Documento__c='RIC',
                    codice_Anomalia__c='codice_Anomalia',CaseId__c=v1[2].Id),
                    new Anomalie_Doc__c (Descrizione_Anomalia_Op__c='Descrizione_Anomalia',Codice_Macro_Documento__c='RIC',
                    codice_Anomalia__c='codice_Anomalia',CaseId__c=v1[2].Id),
                    new Anomalie_Doc__c(Descrizione_Anomalia_Op__c='Descrizione_Anomalia',Codice_Macro_Documento__c='RIC',
                    codice_Anomalia__c='codice_Anomalia',CaseId__c=v1[2].Id)
       }; 
       System.debug(' ano '+ ano );
       insert ano;

}

    @IsTest
    static void executeshedulableTest()
    {
        List<Case> listCase = [SELECT Id,LastModifiedDate  FROM Case ];
        Set<Id> idsToProcess = new Set<Id>();
        String cronAfterThreeHours;
        String cronAfterThirtyMinutes;
        String cronAfterTwoHours;
        String cronAfterFiveDays;
        
        DateTime fireTime;
        Test.startTest();
        for(Case c : listCase)
        {
                System.debug('Id  '+ c.id );
                idsToProcess.add(c.Id);
                fireTime=c.LastModifiedDate;
                System.debug('****** fireTime '+ fireTime);
                cronAfterThreeHours= CaseHandlerTriggerClass.createCronExpressionFromDateTimeThreeHours(c.LastModifiedDate); 
                cronAfterThirtyMinutes= CaseHandlerTriggerClass.createCronExpressionFromDateTimeThirtyMinutes(c.LastModifiedDate);
                cronAfterFiveDays=CaseHandlerTriggerClass.createCronExpressionFromDateTimeFiveDays(c.LastModifiedDate);
                cronAfterTwoHours=CaseHandlerTriggerClass.createCronExpressionFromDateTimeTwoHours(c.LastModifiedDate); 

        }
        
    // Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
    SchedulableEcommerce SchedulableEcommerceIstance = new SchedulableEcommerce(idsToProcess,AFTER_FIVE_DAYS);  
        
    String jobIDAfterFiveDaysDSP = System.schedule('SchedulableEcommerce_'+cronAfterFiveDays, cronAfterThreeHours, SchedulableEcommerceIstance);
        
        /*
    SchedulableDS anoSchedulAfterThirtyMinutesDS = new SchedulableDS(idsToProcess,AFTER_THIRTY_MINUTES,cronAfterFiveDays);  
    String jobIDAfterThirtyMinutesDS = System.schedule('anoSchedul_DS_afterThirtyMinutes_'+cronAfterThirtyMinutes, cronAfterThirtyMinutes, anoSchedulAfterThirtyMinutesDS);
    System.debug('****** jobIDAfterThirtyMinutesDS '+ jobIDAfterThirtyMinutesDS);
    System.debug('****** jobIDAfterThreeHoursDS '+ jobIDAfterThreeHoursDS);
    // System.assertEquals(1, listmftcoecoELEMENTO[0].mftcoecoPARTITA,'') ; */

    Test.stopTest();
}

}