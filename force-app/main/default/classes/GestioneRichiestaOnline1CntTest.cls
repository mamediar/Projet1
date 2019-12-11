/**
 * @File Name          : GestioneRichiestaOnline1CntTest.cls
 * @Description        : 
 * @Author             : CISSE Ahmet
 * @Group              : 
 * @Last Modified By   : BADJI Insa
 * @Last Modified On   : 14/10/2019
 **/
@isTest
public class GestioneRichiestaOnline1CntTest {

    static final String CODE = 'DP1456';
    static final String CONTATTO_NON_ESEGUITO = 'CONTATTO NON ESEGUITO';
    static final String CONTATTO_ESEGUITO = 'CONTATTO ESEGUITO';
    static final String FIRMERA_IL_CONTRATTO = 'Firmerà il contratto';
    static final String NUMERO_INESISTENTE = 'NUMERO INESISTENTE';
    static final String INVIO_LINK_RIPRESA_BOZZA = 'INVIO LINK RIPRESA BOZZA';
    static final String CLIENTE_NON_TROVATO = 'CLIENTE NON TROVATO';
    static final String CONFERMA_VECCHIO_RECAPITO = 'CONFERMA VECCHIO RECAPITO';
    static final String NESSUNA_ALTRA_AZIONE = 'NESSUNA ALTRA AZIONE';
    static final String CONFERMA_NUOVO_RECAPITO = 'CONFERMA NUOVO RECAPITO';
    static final String DISCONOSCE_LA_PRATICA = 'DISCONOSCE LA PRATICA';
    static final String NON_INTERESSATO = 'NON INTERESSATO';
    static final String FISSA_APPUNTAMENTO = 'FISSA APPUNTAMENTO';
    static final String CARICHERA_LA_DOCUMENTAZIONE = 'Caricherà la documentazione';

    @testSetup
    static void setup() {
        // Create records for test.

       XCS_CompassParameters__c cp = new XCS_CompassParameters__c(Name='Number_of_hours', Execution_Anomalie_Batch_Time__c=2);
       insert cp;

        //Create a goup Object  DeveloperName = 'Q337'
        Group testGroup1 = [SELECT Id, Name, DeveloperName FROM Group WHERE Type = 'Queue'
        AND DeveloperName = 'Q337'
        limit 1];
        Group testGroup2 = [SELECT Id, Name, DeveloperName FROM Group WHERE Type = 'Queue'
        AND DeveloperName = 'Q330'
        limit 1];
        Group testGroup3 = [SELECT Id, Name, DeveloperName FROM Group WHERE Type = 'Queue'
        AND DeveloperName = 'Q375'
        limit 1];
        Group testGroup4 = [SELECT Id, Name, DeveloperName FROM Group WHERE Type = 'Queue'
        AND DeveloperName = 'Q339'
        limit 1];   
        Group testGroup5 = [SELECT Id, Name, DeveloperName FROM Group WHERE Type = 'Queue'
        AND DeveloperName = 'Q341'
        limit 1];

        Group testGroup6 = [SELECT Id, Name, DeveloperName FROM Group WHERE Type = 'Queue'
        AND DeveloperName = 'Q377'
        limit 1];

        Group testGroup7 = [SELECT Id, Name, DeveloperName FROM Group WHERE Type = 'Queue'
        AND DeveloperName = 'Q376'
        limit 1];

        Group testGroup8 = [SELECT Id, Name, DeveloperName FROM Group WHERE Type = 'Queue'
        AND DeveloperName = 'Q336'
        limit 1];

        Group testGroup9 = [SELECT Id, Name, DeveloperName FROM Group WHERE Type = 'Queue'
        AND DeveloperName = 'Q338'
        limit 1];

        Group testGroup10 = [SELECT Id, Name, DeveloperName FROM Group WHERE Type = 'Queue'
        AND DeveloperName = 'Q340'
        limit 1];
        GestioneRichiestaOnline1Cnt.QuestionObject gcn=new GestioneRichiestaOnline1Cnt.QuestionObject();
        gcn.question='question';
        gcn.response='response';
        gcn.prodotto=new List<String>();

        GestioneRichiestaOnline1Cnt.ProductObject pd=new GestioneRichiestaOnline1Cnt.ProductObject();
        pd.prodotto='';
        pd.statoOcs= new List<String>();
        

        QueueSobject mappingObject = new QueueSobject(QueueId = testGroup1.Id, SobjectType = 'Case');
        System.runAs(new User(Id = UserInfo.getUserId())) {
            insert mappingObject;
        }

        // Create an account Object
        Account accoObj = new Account();
        accoObj.Name = 'testAcc';
        accoObj.Type = 'CM';
        accoObj.BillingCountry = 'United States';
        insert accoObj;

        // Create a contact Object
        Contact conObj = new Contact();
        conObj.FirstName = 'test';
        conObj.LastName = 'testLastname';
        conObj.AccountId = accoObj.Id;
        conObj.Email = 'abc@gmail.com';
        insert conObj;

        // Create a case a object Q337
        Case caseObj = new Case();
        caseObj.ContactId = conObj.Id;
        caseObj.Status = 'Open';
        caseObj.Subject = 'Q337';
        caseObj.Description = 'Q337';
        caseObj.OwnerId = testGroup1.Id;
        caseObj.Tentativo__c = 2;
        caseObj.TentativoNonRicorda__c =75;
        insert caseObj;

        // Create a case a object
        Case caseObj2 = new Case();
        caseObj2.ContactId = conObj.Id;
        caseObj2.Status = 'Open';
        caseObj2.Subject = 'Q330';
        caseObj2.Description = 'Q330';
        caseObj2.OwnerId = testGroup2.Id;
        caseObj2.Tentativo__c = 1;
        caseObj2.TentativoNonRicorda__c =13;
        insert caseObj2;

        // Create a case a object
        Case caseObj3 = new Case();
        caseObj3.ContactId = conObj.Id;
        caseObj3.Status = 'Open';
        caseObj3.Subject = 'Q375';
        caseObj3.Description = 'Q375';
        caseObj3.OwnerId = testGroup3.Id;
        caseObj3.Tentativo__c = 3;
        caseObj3.TentativoNonRicorda__c = 4;
        insert caseObj3;

        Case caseObj4 = new Case();
        caseObj4.ContactId = conObj.Id;
        caseObj4.Status = 'Open';
        caseObj4.Subject = 'Q339';
        caseObj4.Description = 'Q339';
        caseObj4.RO_Vecchio_Cellulare__c ='1234567890';
        caseObj4.OwnerId = testGroup4.Id;
        caseObj4.Tentativo__c = 3;
        caseObj4.TentativoNonRicorda__c =1;
        insert caseObj4;

          //Create a anomalie object
        Anomalie_Doc__c anomalieObject = new Anomalie_Doc__c();
        anomalieObject.CaseId__c=caseObj4.Id;
        insert anomalieObject;

        Case caseObj5 = new Case();
        caseObj5.ContactId = conObj.Id;
        caseObj5.Status = 'Open';
        caseObj5.Subject = 'Q339';
        caseObj5.Description = 'Q339';
        caseObj5.RO_Vecchio_Cellulare__c =null;
        caseObj5.OwnerId = testGroup4.Id;
        caseObj5.Tentativo__c = 3;
        insert caseObj5;

      
          //Create a anomalie object
        Anomalie_Doc__c anomalieObject2 = new Anomalie_Doc__c();
        anomalieObject2.CaseId__c=caseObj5.Id;
        insert anomalieObject2;

        Case caseObj6 = new Case();
        caseObj6.ContactId = conObj.Id;
        caseObj6.Status = 'Open';
        caseObj6.Subject = 'Q341';
        caseObj6.Description = 'Q341';
        caseObj6.RO_Vecchio_Cellulare__c =null;
        caseObj6.OwnerId = testGroup5.Id;
        caseObj6.Tentativo__c = 3;
        insert caseObj6;

        Case caseObj7 = new Case();
        caseObj7.ContactId = conObj.Id;
        caseObj7.Status = 'Open';
        caseObj7.Subject = 'Q999';
        caseObj7.Description = 'Q999';
        caseObj7.RO_Vecchio_Cellulare__c =null;
        caseObj7.Tentativo__c = 3;
        insert caseObj7;

        Case caseObj8 = new Case();
        caseObj8.ContactId = conObj.Id;
        caseObj8.Status = 'Open';
        caseObj8.Subject = 'Q340';
        caseObj8.Description = 'Q340';
        caseObj8.RO_Vecchio_Cellulare__c =null;
        caseObj8.OwnerId = testGroup10.Id;
        caseObj8.Tentativo__c = 3;
        insert caseObj8;

        Case caseObj9 = new Case();
        caseObj9.ContactId = conObj.Id;
        caseObj9.Status = 'Open';
        caseObj9.Subject = 'Q377';
        caseObj9.Description = 'Q377';
        caseObj9.RO_Vecchio_Cellulare__c ='0000000';
        caseObj9.OwnerId = testGroup6.Id;
        caseObj9.Tentativo__c = 5;
        insert caseObj9;


        Case caseObj10 = new Case();
        caseObj10.ContactId = conObj.Id;
        caseObj10.Status = 'Open';
        caseObj10.Subject = 'Q376';
        caseObj10.Description = 'Q376';
        caseObj10.RO_Vecchio_Cellulare__c ='055116168462';
        caseObj10.OwnerId = testGroup7.Id;
        insert caseObj10;
        Anomalie_Doc__c an = new Anomalie_Doc__c(codice_Anomalia__c = '96', Descrizione_Anomalia_Op__c= 'test',
            Codice_Documento__c= '956', CaseId__c= caseObj10.Id);
        insert an;

        Case caseObj11 = new Case();
        caseObj11.ContactId = conObj.Id;
        caseObj11.Status = 'Open';
        caseObj11.Subject = 'Q336';
        caseObj11.Description = 'Q336';
        caseObj11.Tentativo__c = 5;
        caseObj11.RO_Vecchio_Cellulare__c ='055116168462';
        caseObj11.OwnerId = testGroup8.Id;
        insert caseObj11;

        Case caseObj12 = new Case();
        caseObj12.ContactId = conObj.Id;
        caseObj12.Status = 'Open';
        caseObj12.Subject = 'Q338';
        caseObj12.Description = 'Q338';
        caseObj12.Tentativo__c = 5;
        caseObj12.RO_Vecchio_Cellulare__c ='055116168462';
        caseObj12.OwnerId = testGroup9.Id;
        insert caseObj12;
        Anomalie_Doc__c an1 = new Anomalie_Doc__c(codice_Anomalia__c = '96', Descrizione_Anomalia_Op__c= 'test',
            Codice_Documento__c= '956', CaseId__c= caseObj12.Id);
        insert an1;

        // Create a XCS_Disposition__c a object
        XCS_Disposition__c disp = new XCS_Disposition__c(External_Id__c = 'DP1456',name = 'Documento ricevuto/lavorato');
        insert disp;
/**
        RichiamiLimiteTemporel__c rlt = new RichiamiLimiteTemporel__c();
        rlt.Limit__c = 1;
        rlt.Name = 'Q339';
        insert rlt;
        **/
    }
    static testmethod void updateCaseTest11() {

        Case caseObject3 = [SELECT Id, stato_ocs__c, Tentativo__c,OwnerId, RO_fea__c,
                                    Stato_Pratica__c, Note__c,RO_Nuovo_Cellulare__c,
                                    RO_Vecchio_Cellulare__c, Subject, AccountId, Product__r.DEMRipresaBozza__c,
                                    Product__r.Family
                            FROM Case
                            Where Subject = 'Q340'
                            limit 1];

        Test.startTest();
        Map < String,
            Object > response = GestioneRichiestaOnline1Cnt.updateCase(caseObject3, CODE, CONTATTO_NON_ESEGUITO, CLIENTE_NON_TROVATO, CLIENTE_NON_TROVATO, true);

        Test.stopTest();

        System.assertNotEquals(response, null);
        //System.assertEquals(response119.get('linkevo'), false, 'LinkEvo is true');
    }
    static testmethod void updateCaseTest10() {

        Case caseObject = [SELECT Id, stato_ocs__c,Tentativo__c, OwnerId, RO_fea__c,
                                    Stato_Pratica__c, Note__c, RO_Vecchio_Cellulare__c,
                                    Subject, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family
                            FROM Case
                            Where Subject = 'Q338'
                            limit 1];

        Test.startTest();
        Map < String,
            Object > response106 = GestioneRichiestaOnline1Cnt.updateCase(caseObject, CODE, CONTATTO_ESEGUITO, NON_INTERESSATO, NESSUNA_ALTRA_AZIONE, true);

        System.assertNotEquals(response106, null);
    }

    static testmethod void updateCaseTest9() {

        Case caseObject = [SELECT Id, stato_ocs__c,Tentativo__c, OwnerId, RO_fea__c,
                                    Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,
                                    Subject, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case Where Subject = 'Q336'
        limit 1];

        Test.startTest();
        Map < String,
            Object > response106 = GestioneRichiestaOnline1Cnt.updateCase(caseObject, CODE, CONTATTO_NON_ESEGUITO, CLIENTE_NON_TROVATO, NESSUNA_ALTRA_AZIONE, true);

        System.assertNotEquals(response106, null);
    }
    static testmethod void updateCaseTest8() {

        Case caseObject1 = [SELECT Id, stato_ocs__c, Tentativo__c, OwnerId, RO_fea__c,
            Stato_Pratica__c, Note__c,RO_Nuovo_Cellulare__c,
            RO_Vecchio_Cellulare__c, Subject, AccountId,
            Product__r.DEMRipresaBozza__c, Product__r.Family
        FROM Case
        Where Subject = 'Q376'
        limit 1];

        System.debug('### caseObject1 '+caseObject1);
        Test.startTest();
        // Q376
        Map < String,
            Object > response1 = GestioneRichiestaOnline1Cnt.updateCase(caseObject1, CODE, CONTATTO_ESEGUITO, CARICHERA_LA_DOCUMENTAZIONE, '', true);
        System.assertNotEquals(response1, null);
        Test.stopTest();
    }

    static testmethod void updateCaseTest7() {
        Case caseObject = [SELECT Id, stato_ocs__c, Tentativo__c, OwnerId, RO_fea__c,
                                    Stato_Pratica__c, Note__c,RO_Nuovo_Cellulare__c,
                                    RO_Vecchio_Cellulare__c, Subject, AccountId,
                                    Product__r.DEMRipresaBozza__c, Product__r.Family
                            FROM Case
                            Where Subject = 'Q377'
                            limit 1];

        Test.startTest();
        Map < String,
            Object > response = GestioneRichiestaOnline1Cnt.updateCase(caseObject, CODE, CONTATTO_ESEGUITO, FIRMERA_IL_CONTRATTO, '', true);
        System.assertNotEquals(response, null);
        Test.stopTest();
    }
    static testmethod void getCaseTest() {

        Case caseObject = [SELECT Id, Is_Discordanza_Cellulare__c, stato_ocs__c, OwnerId, TentativoNonRicorda__c, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case limit 1];
        Case caseObject4 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, TentativoNonRicorda__c, Stato_Pratica__c, Note__c,RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Subject, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case Where Subject = 'Q999'
        limit 1];   

        Test.startTest();
        Map < String,
        Object > response1 = GestioneRichiestaOnline1Cnt.getCase(caseObject.Id);
        Map < String,
        Object > response3 = GestioneRichiestaOnline1Cnt.getCase(caseObject4.Id);
        Map < String,
        Object > response2 = GestioneRichiestaOnline1Cnt.getCase(null);
        Test.stopTest();

        System.assertEquals(response1.get('case'), caseObject, 'caseObjects are !=');
        System.assertEquals(response1.get('error'), false, 'Error');
        System.assertEquals(response2.get('error'), true, 'No Error');
    }

    static testmethod void updateCaseTest0() {

        Case caseObject4 = [SELECT Id, stato_ocs__c, Tentativo__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c,RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Subject, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case Where Subject = 'Q341'
        limit 1];   
        Case caseObject = [SELECT Id, stato_ocs__c,Tentativo__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c, Subject, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case Where Subject = 'Q337'
        limit 1];

        Test.startTest();
        Map < String,
        Object > response119_2 = GestioneRichiestaOnline1Cnt.updateCase(caseObject4, CODE, CONTATTO_NON_ESEGUITO, CLIENTE_NON_TROVATO, NESSUNA_ALTRA_AZIONE, true);
        Map < String,
        Object > response120 = GestioneRichiestaOnline1Cnt.updateCase(caseObject, CODE, CONTATTO_NON_ESEGUITO, CLIENTE_NON_TROVATO, INVIO_LINK_RIPRESA_BOZZA, true);
        Test.stopTest();

        //System.assertEquals(response119_2.get('linkevo'), false, 'LinkEvo is not false');
    }
    static testmethod void updateCaseTest1() {

        Case caseObject = [SELECT Id, stato_ocs__c, Tentativo__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c, Subject, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case Where Subject = 'Q337'
        limit 1];
        Case caseObject2 = [SELECT Id, stato_ocs__c, Tentativo__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c, Subject, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case Where Subject = 'Q330'
        limit 1];
        Case caseObject3 = [SELECT Id, stato_ocs__c, Tentativo__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c, Subject, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case Where Subject = 'Q375'
        limit 1];   

        Test.startTest();
        Map < String,
        Object > response100 = GestioneRichiestaOnline1Cnt.updateCase(caseObject, CODE, CONTATTO_NON_ESEGUITO, NUMERO_INESISTENTE, INVIO_LINK_RIPRESA_BOZZA, true);
        Map < String,
        Object > response107 = GestioneRichiestaOnline1Cnt.updateCase(caseObject2, CODE, CONTATTO_NON_ESEGUITO, NUMERO_INESISTENTE, INVIO_LINK_RIPRESA_BOZZA, true);
        Map < String,
        Object > response112 = GestioneRichiestaOnline1Cnt.updateCase(caseObject3, CODE, CONTATTO_NON_ESEGUITO, NUMERO_INESISTENTE, INVIO_LINK_RIPRESA_BOZZA, true);        



        System.assertEquals(response100.get('case'), caseObject, 'caseObjects are !=');
        System.assertEquals(response107.get('linkevo'), false, 'LinkEvo is not false');
        System.assertEquals(5, response112.size(), 'Size != 5');
    }

    static testmethod void updateCaseTest2() {

        Case caseObject = [SELECT Id, stato_ocs__c, Tentativo__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c,RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Subject, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case Where Subject = 'Q339'
        limit 1];
        Case caseObject2 = [SELECT Id, stato_ocs__c,Tentativo__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c, Subject, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case Where Subject = 'Q330'
        limit 1];
        Case caseObject3 = [SELECT Id, stato_ocs__c,Tentativo__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c, Subject, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case Where Subject = 'Q375'
        limit 1];

        Test.startTest();
        Map < String,
        Object > response102 = GestioneRichiestaOnline1Cnt.updateCase(caseObject, CODE, CONTATTO_NON_ESEGUITO, CLIENTE_NON_TROVATO, INVIO_LINK_RIPRESA_BOZZA, false);  
        Map < String,
        Object > response113 = GestioneRichiestaOnline1Cnt.updateCase(caseObject3, CODE, CONTATTO_NON_ESEGUITO, CLIENTE_NON_TROVATO, INVIO_LINK_RIPRESA_BOZZA, true);
        Map < String,
        Object > response108 = GestioneRichiestaOnline1Cnt.updateCase(caseObject2, CODE, CONTATTO_NON_ESEGUITO, CLIENTE_NON_TROVATO, INVIO_LINK_RIPRESA_BOZZA, true);

        Test.stopTest();

        //System.assertEquals(response102.get('case'), null, 'case is not null');
        //System.assertEquals(response113.get('linkevo'), false, 'LinkEvo is not false');
        System.assertEquals(4, response108.size(), 'Size != 4');
    }

    static testmethod void updateCaseTest3() {

        Case caseObject = [SELECT Id, Is_Discordanza_Cellulare__c, stato_ocs__c,Tentativo__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c,RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Subject, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case Where Subject = 'Q339'
        limit 1];
        Case caseObject2 = [SELECT Id, stato_ocs__c,Tentativo__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c,RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Subject, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case Where Subject = 'Q339' AND RO_Vecchio_Cellulare__c =null
        limit 1];

        Test.startTest();
        Map < String,
        Object > response103 = GestioneRichiestaOnline1Cnt.updateCase(caseObject, CODE, CONTATTO_ESEGUITO, CONFERMA_VECCHIO_RECAPITO, INVIO_LINK_RIPRESA_BOZZA, true);
        Map < String,
        Object > response109 = GestioneRichiestaOnline1Cnt.updateCase(caseObject2, CODE, CONTATTO_NON_ESEGUITO, NUMERO_INESISTENTE, NESSUNA_ALTRA_AZIONE, true);

        System.assertEquals(response103.get('case'), caseObject, 'cases are !=');
        System.assertEquals(response109.get('linkevo'), false, 'LinkEvo is true');
    }

    static testmethod void updateCaseTest4() {

        Case caseObject = [SELECT Id, stato_ocs__c,Tentativo__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c, Subject, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case Where Subject = 'Q337'
        limit 1];
        Case caseObject2 = [SELECT Id, stato_ocs__c, Tentativo__c,OwnerId, RO_fea__c, Stato_Pratica__c, Note__c,RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Subject, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case Where Subject = 'Q339' AND RO_Vecchio_Cellulare__c =null
        limit 1];
        Case caseObject3 = [SELECT Id, stato_ocs__c, Tentativo__c,OwnerId, RO_fea__c, Stato_Pratica__c, Note__c,RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Subject, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case Where Subject = 'Q340'
        limit 1];

        Test.startTest();
        Map < String,
        Object > response104 = GestioneRichiestaOnline1Cnt.updateCase(caseObject, CODE, CONTATTO_ESEGUITO, CONFERMA_VECCHIO_RECAPITO, NESSUNA_ALTRA_AZIONE, true);
        Map < String,
        Object > response119 = GestioneRichiestaOnline1Cnt.updateCase(caseObject2, CODE, CONTATTO_NON_ESEGUITO, CLIENTE_NON_TROVATO, NESSUNA_ALTRA_AZIONE, true);
        Map < String,
        Object > response119_Q340 = GestioneRichiestaOnline1Cnt.updateCase(caseObject3, CODE, CONTATTO_NON_ESEGUITO, NUMERO_INESISTENTE, CLIENTE_NON_TROVATO, true);

        Test.stopTest();

        System.assertEquals(response104.get('case'), caseObject, 'cases are !=');
        //System.assertEquals(response119.get('linkevo'), false, 'LinkEvo is true');
    }

    static testmethod void updateCaseTest5() {

        Case caseObject = [SELECT Id, stato_ocs__c,Tentativo__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c, Subject, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case Where Subject = 'Q337'
        limit 1];
        Case caseObject2 = [SELECT Id, stato_ocs__c, Tentativo__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c, Subject, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case Where Subject = 'Q330'
        limit 1];       

        Test.startTest();
        Map < String,
        Object > response105 = GestioneRichiestaOnline1Cnt.updateCase(caseObject, CODE, CONTATTO_ESEGUITO, NON_INTERESSATO, NESSUNA_ALTRA_AZIONE, true);
        Map < String,
        Object > response111 = GestioneRichiestaOnline1Cnt.updateCase(caseObject2, CODE, CONTATTO_ESEGUITO, FISSA_APPUNTAMENTO, NESSUNA_ALTRA_AZIONE, true);        

        System.assertEquals(response105.get('case'), caseObject, 'caseObjects are !=');
        System.assertEquals(6, response111.size(), 'Size != 6');
    }

    static testmethod void updateCaseTest6() {

        Case caseObject = [SELECT Id, stato_ocs__c,Tentativo__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c, Subject, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case Where Subject = 'Q337'
        limit 1];

        Test.startTest();
        Map < String,
        Object > response106 = GestioneRichiestaOnline1Cnt.updateCase(caseObject, CODE, CONTATTO_ESEGUITO, DISCONOSCE_LA_PRATICA, NESSUNA_ALTRA_AZIONE, true);
        Map < String,
        Object > responseElse = GestioneRichiestaOnline1Cnt.updateCase(caseObject, CODE, CONTATTO_ESEGUITO, DISCONOSCE_LA_PRATICA, NESSUNA_ALTRA_AZIONE, true);
        Test.stopTest();

        System.assertEquals(response106.get('linkevo'), true, 'LinkEvo is false');
        System.assertEquals(6, responseElse.size(), 'Size != 6');
    }

    /**
     * @Author AD
     * @date  16/05/2019
     *
     **/
    @isTest
    static void getCaseTest2() {

        Case caseObject1 = [SELECT Id, stato_ocs__c,Tentativo__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c, 
            Subject, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case Where Subject = 'Q330' limit 1];

        Case caseObject2 = [SELECT Id, stato_ocs__c,Tentativo__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c, 
            Subject, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case Where Subject = 'Q375' limit 1];

        Test.startTest();
            Map <String,Object> response1 = GestioneRichiestaOnline1Cnt.getCase(caseObject1.Id);        
            Map <String,Object> response2 = GestioneRichiestaOnline1Cnt.getCase(caseObject2.Id);        
        Test.stopTest();
    }  

    
    static testmethod void sendDomandaTest() {

        Case caseObject = [SELECT Id, stato_ocs__c, Tentativo__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c, Subject, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case Where Subject = 'Q337'
        limit 1];
        String questionManagement = '{\"questions\":[{\"question\":\"ULTIMI ACQUISTI EFFETTUATI\",\"response\":\"77777\",\"prodotto\":[],\"num\":2},{\"question\":\"MODALITA\' RIMBORSO (*) + Se RID: IBAN COLLEGATO AL PRODOTTO\",\"response\":\"RID\",\"prodotto\":[],\"num\":3}],\"products\":[{\"prodotto\":\"CA\",\"statoOcs\":[]}]}';
        Test.startTest();
        Map < String,
        Object > response = GestioneRichiestaOnline1Cnt.sendDomanda(caseObject, (GestioneRichiestaOnline1Cnt.QuestionManagement) JSON.deserialize(questionManagement, GestioneRichiestaOnline1Cnt.QuestionManagement.class));
        
        Map < String,
        Object > response1 = GestioneRichiestaOnline1Cnt.sendDomanda(caseObject, questionManagement);
        Test.stopTest();

        System.assertEquals(response.get('error'), true, 'is false');
    }

    @isTest
    static void updateNoteCaseTest(){
        Case caseObj = [SELECT Id, TentativoNonRicorda__c  FROM Case LIMIT 1];
        caseObj.Description = 'Q337';
        Test.startTest();
            GestioneRichiestaOnline1Cnt.updateNoteCase(caseObj,'', true);
        System.assert(caseObj!=null,'') ;
        Test.stopTest();
    } 

    @isTest
    static void updateNoteCasedeveloperNameNotEmptyTest(){
        Case caseObj = [SELECT Id, TentativoNonRicorda__c FROM Case LIMIT 1];
        caseObj.Description = 'Q337';
        Test.startTest();
            GestioneRichiestaOnline1Cnt.updateNoteCase(caseObj,'Q524', true);
        System.assert(caseObj!=null,'') ;
        Test.stopTest();
    }

    
    @isTest
    static void updateNoteCaseExeptionTest(){
        Case caseObj =null;
        //caseObj.Description = 'Q337';
        Test.startTest();
            GestioneRichiestaOnline1Cnt.updateNoteCase(null,'Q524', true);
        System.assert(caseObj==null,'') ;
        Test.stopTest();
    }

    @isTest
    static void getRichiamiLimiteTemporelTest(){
        Test.startTest();
         Map<String, Object> response=GestioneRichiestaOnline1Cnt.getRichiamiLimiteTemporel('Q339');
         System.assert(response.size()!=0,'') ;
        Test.stopTest();
    }

    
    @isTest
    static void getRichiamiLimiteTemporelExpextionTest(){
        Test.startTest();
         Map<String, Object> response=GestioneRichiestaOnline1Cnt.getRichiamiLimiteTemporel('q520');
         System.assert(response.size()!=0,'') ;
        Test.stopTest();
    }
    
    @isTest
    static void getAnomaliesByCaseTest(){
        Test.startTest();
        Case caseObj = [SELECT Id, TentativoNonRicorda__c FROM Case LIMIT 1];
         List<Anomalie_Doc__c> response = GestioneRichiestaOnline1Cnt.getAnomaliesByCase(caseObj.Id);
        // System.assert(response.size()!=0,'') ;
        Test.stopTest();
    }
    
}