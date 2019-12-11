@isTest
public  class CaseHandlerTriggerClassTest {
     
     private static String afterUpdateDEMAnomalieDocumentaliDS;
     private static String afterUpdateDEMAnomalieDocumentaliDSP;
     private static String afterUpdateDEMAccountReassuranceDS;
     private static String afterUpdateDEMAccountReassuranceDSP;
     
@TestSetup
static void makeData(){

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
     new Case (RO_Link_Bozza__c ='link', Stato_Pratica__c='20',AccountId=accts[0].Id,NumeroPratica__c='18866725',
     Attributi_Pratica__c ='SD',stato_ocs__c='20SD',RO_Vecchio_Cellulare__c='773528750',
     Product__c=listproduit[0].Id), 
     new Case(RO_Link_Bozza__c ='link', Stato_Pratica__c=null,AccountId=accts[1].Id,NumeroPratica__c='18866725',
     Attributi_Pratica__c =null,stato_ocs__c='30',RO_Vecchio_Cellulare__c='773528750',
     Product__c=listproduit[0].Id),
     new Case(RO_Link_Bozza__c ='link', Stato_Pratica__c='05', AccountId=accts[0].Id,NumeroPratica__c='18866725',
     Attributi_Pratica__c ='BT',stato_ocs__c='05BT',RO_Vecchio_Cellulare__c='773528750',
     Product__c=listproduit[0].Id)
//     new Case (Stato_Pratica__c='20',  AccountId=listAccount[0].Id,NumeroPratica__c='18866725',
//     Attributi_Pratica__c ='SD',stato_ocs__c='20SD',Product__c=listproduit[0].Id),
//     new Case(Stato_Pratica__c='20',AccountId=listAccount[0].Id,NumeroPratica__c='18866725',
//     Attributi_Pratica__c ='SD',stato_ocs__c='20SD',Product__c=listproduit[0].Id),
//     new Case(Stato_Pratica__c='20',AccountId=listAccount[0].Id,
//     NumeroPratica__c='18866725',Attributi_Pratica__c ='SD',stato_ocs__c='20SD',
//     Product__c=listproduit[0].Id),
//     new Case (Stato_Pratica__c='20',AccountId=listAccount[0].Id,NumeroPratica__c='18866725',
//     Attributi_Pratica__c ='SD',stato_ocs__c='20SD',Product__c=listproduit[0].Id)
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
static void afterUpdateDEMAnomalieDocumentaliDSTest(){
     List<Case> listCase = [SELECT Id,LastModifiedDate,NumeroPratica__c,stato_ocs__c      
                            FROM Case ];
     List<Case> listCaseToUpdateNumPratica = new List<Case>();
     List<Case> listCaseToUpdateStatoOCS   = new List<Case>(); 
    
     Set<Id> SetIdsCase  = new Set<Id>();
     DateTime fireTime;
     Test.startTest();
     for( Case c : listCase )
     {
          System.debug('Id  '+ c.id );
          fireTime=c.LastModifiedDate;
          SetIdsCase.add(c.Id);
          c.NumeroPratica__c = '';
          listCaseToUpdateNumPratica.add(c);
          //c.NumeroPratica__c = 'XXXX';
          c.stato_ocs__c     = '';
          listCaseToUpdateStatoOCS.add(c);
          
     }
     CaseHandlerTriggerClass.afterUpdateDEMAnomalieDocumentaliDS(listCase);
     CaseHandlerTriggerClass.createCronExpressionFromDateTimeThreeHours(fireTime);
     CaseHandlerTriggerClass.createCronExpressionFromDateTimeFiveDays(fireTime);
     CaseHandlerTriggerClass.createCronExpressionFromDateTimeTwoHours(fireTime);
     CaseHandlerTriggerClass.createCronExpressionFromDateTimeThirtyMinutes(fireTime);
     //System.assertEquals('afterUpdateDEMAnomalieDocumentaliDS', afterUpdateDEMAnomalieDocumentaliDS, '');
      List<Anomalie_Doc__c> anomaliById = [SELECT Id,
          Descrizione_Anomalia_Op__c,CaseId__r.stato_ocs__c,CaseId__r.NumeroPratica__c,
          CaseId__r.RO_Vecchio_Cellulare__c,CaseId__r.LastModifiedDate,
          CaseId__r.Tipo_Pratica__c,CaseId__r.Stato_Pratica__c,CaseId__r.Attributi_Pratica__c,
          CaseId__r.CanaleContatto__c,CaseId__r.AccountId,Codice_Macro_Documento__c
          FROM Anomalie_Doc__c 
          WHERE CaseId__c IN: SetIdsCase];
          
     Anomalie_Doc__c AnomalieDocObject = anomaliById[0];
    
     AnomalieDocObject.CaseId__r.NumeroPratica__c = '';
     ValidationField.validateFieldError(AnomalieDocObject);
     AnomalieDocObject.CaseId__r.stato_ocs__c     = '';
     ValidationField.validateFieldError(AnomalieDocObject);
     AnomalieDocObject.CaseId__r.RO_Vecchio_Cellulare__c = '';
     ValidationField.validateFieldError(AnomalieDocObject);

    
     ValidationField.validateFieldSollecitoContrattoError(SetIdsCase);
     update listCaseToUpdateNumPratica;
     ValidationField.validateFieldSollecitoContrattoError(SetIdsCase);
     update listCaseToUpdateStatoOCS;
     ValidationField.validateFieldSollecitoContrattoError(SetIdsCase);
     ValidationError ValidationErrorIstance = new ValidationError('ERROR','MESSAGE');
     
     /*
     AnomalieDocObject.Codice_Macro_Documento__c = '';
     ValidationField.validateFieldSollecitoContrattoError(SetIdsCase);
     AnomalieDocObject.codice_Anomalia__c = '';
     ValidationField.validateFieldSollecitoContrattoError(SetIdsCase);
     */

    

     
     Test.stopTest();
}

@IsTest
static void afterUpdateDEMAnomalieDocumentaliDSPTest(){
List<Case> listCase = [SELECT Id  FROM Case ];
Test.startTest();
for(Case c : listCase){
     System.debug('Id  '+ c.id );
     }
CaseHandlerTriggerClass.afterUpdateDEMAnomalieDocumentaliDSP(listCase);
//System.assertEquals('afterUpdateDEMAnomalieDocumentaliDSP', afterUpdateDEMAnomalieDocumentaliDSP, '');
Test.stopTest();
}


@IsTest
static void afterUpdateDEMAccountReassuranceDSTest(){
List<Case> listCase = [SELECT Id  FROM Case ];
Test.startTest();
for(Case c : listCase){
     System.debug('#l Id  '+ c.id );
     }
CaseHandlerTriggerClass.afterUpdateDEMAccountReassuranceDS(listCase);
//System.assertEquals('afterUpdateDEMAccountReassuranceDS', afterUpdateDEMAccountReassuranceDS, '');
Test.stopTest();
}


@IsTest
static void afterUpdateDEMAccountReassuranceDSPTest(){
List<Case> listCase = [SELECT Id  FROM Case ];
Test.startTest();
for(Case c : listCase){
     System.debug('Id  '+ c.id );
     }
CaseHandlerTriggerClass.afterUpdateDEMAccountReassuranceDSP(listCase);
//System.assertEquals('afterUpdateDEMAccountReassuranceDSP', afterUpdateDEMAccountReassuranceDSP, '');
Test.stopTest();
}


// @IsTest
// static void anomaliePreSicPPTest(){
//      List<Case> listCase = [SELECT Id  FROM Case ];
//      Set<Id> idsToProcess = new Set<Id>();
//      Test.startTest();
//      for(Case c : listCase){
//         System.debug('Id  '+ c.id );
//         idsToProcess.add(c.id);
//        }
//      AnomalieDocProductDS.anomaliePreSicPP(idsToProcess);
//  //AnomalieDocProductDS.anomaliePostSicPP(idsToProcess);
//      Test.stopTest();
// }


}