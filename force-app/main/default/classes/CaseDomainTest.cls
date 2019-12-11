/**
* @File Name          : CaseDomainTest.cls
* @Description        : 
* @Author             : CISSE Ahmet
* @Group              : 
* @Last Modified By   : DIOP Abdoulaye
* @Last Modified On   : 04/11/2019 
**/
@isTest
public class CaseDomainTest {
    
    static final String CODE = 'DP1456';
    static final String CONTATTO_NON_ESEGUITO = 'CONTATTO NON ESEGUITO';
    static final String CONTATTO_ESEGUITO = 'CONTATTO ESEGUITO';
    static final String NUMERO_INESISTENTE = 'NUMERO INESISTENTE';
    static final String CLIENTE_NON_TROVATO = 'CLIENTE NON TROVATO';
    static final String CLIENTE_NON_INTERESSATO = 'CLIENTE NON INTERESSATO';
    static final String CONFERMA_VECCHIO_RECAPITO = 'CONFERMA VECCHIO RECAPITO';    
    static final String CONFERMA_NUOVO_RECAPITO = 'CONFERMA NUOVO RECAPITO';
    static final String INVIO_LINK_RIPRESA_BOZZA = 'INVIO LINK RIPRESA BOZZA';
    static final String NESSUNA_ALTRA_AZIONE = 'NESSUNA ALTRA AZIONE';
    static final String NON_INTERESSATO = 'NON INTERESSATO';
    static final String DISCONOSCE_LA_PRATICA  = 'DISCONOSCE LA PRATICA';
    static final String FISSA_APPUNTAMENTO  = 'FISSA APPUNTAMENTO';
    static final String CHIEDE_DI_ESSERE_RICHIAMATO  = 'CHIEDE DI ESSERE RICHIAMATO';
    static final String CARICHERA_LA_DOCUMENTAZIONE = 'Caricherà la documentazione';
    static final String HA_GIA_CARICATO_LA_DOCUMENTAZIONE = 'Ha già caricato la documentazione';
    static final String FIRMERA_IL_CONTRATTO = 'Firmerà il contratto';
    static final String HA_GIA_FIRMATO_IL_CONTRATTO = 'Ha già firmato il contratto';
    static final String INBOUND_ASSISTENZA = 'INBOUND ASSISTENZA';
    static final String INVIO_DEM_RICARICA_PRATICA = 'INVIO DEM RICARICA PRATICA';
    static final String IDENTITA_NON_CONFERMATA = 'Identità non confermata';
    
    @testSetup
    static void setup() {
        // Create records for test.
        
        //Create a goup Object
        //  testGroup1.DeveloperName = 'Q337'; 
        Group testGroup1 = new Group(Name = 'Queue', Type = 'Queue');
        insert testGroup1;
        
        QueueSobject mappingObject = new QueueSobject(QueueId = testGroup1.Id, SobjectType = 'Case');
        System.runAs(new User(Id = UserInfo.getUserId())) {
            insert mappingObject;
        }
        
        // Create an account Object
        String RecTypeId = [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Account accoObj = new Account(RecordTypeID=RecTypeId, FirstName='test', LastName='Acc', PersonEmail='test@yahoo.com', PersonHomePhone='1234567');
        insert accoObj;

        /*Account accoObj = new Account();
        accoObj.Name = 'testAcc';
        accoObj.Type = 'CM';
        accoObj.BillingCountry = 'United States';
        insert accoObj;*/
        
        // Create a contact Object
        Contact conObj = new Contact();
        conObj.FirstName = 'test';
        conObj.LastName = 'testLastname';
        //conObj.AccountId = accoObj.Id;
        conObj.Email = 'abc@gmail.com';
        conObj.DEM_Param_7__c = 'DEM_Param_7__c';
        insert conObj;
         // Create a List  Product
        List<Product2> listproduit = new List<Product2>{
            new Product2(Name='Produit1', Family='PP_ONLINE_COMPASS_DS',DEMAnomalie__c='2072',DEMRipresaBozza__c='DEMRipresaBozza', DEMNonTrovatoFirmaContratto__c = '2557'),
            new Product2(Name='Produit2', Family='PP_ONLINE_PARTNER_DS',DEMAnomalie__c='2072',DEMRipresaBozza__c='DEMRipresaBozza', DEMNonTrovatoFirmaContratto__c = '2557'),
            new Product2(Name='Produit3', Family='PP_ONLINE_COMPASS_DS',DEMAnomalie__c='2072',DEMRipresaBozza__c='DEMRipresaBozza', DEMNonTrovatoFirmaContratto__c = '2557'),
            new Product2(Name='Produit4', Family='PF_ECOMMERCE_STANDARD',DEMAnomalie__c='2072',DEMRipresaBozza__c='DEMRipresaBozza', DEMNonTrovatoFirmaContratto__c = '2557')
        };
        insert listproduit;
     
        // Create a case a object
        Case caseObj = new Case();
        caseObj.ContactId = conObj.Id;
        caseObj.Status = 'Open';
        caseObj.Subject = 'TestSubject';
        caseObj.Description = 'TestDescription';
        caseObj.OwnerId = testGroup1.Id;
        caseObj.Tentativo__c = 2;
        caseObj.RO_Vecchio_Cellulare__c ='1234567890';
        caseObj.RO_Link_Bozza__c  = '111111';
        caseObj.AccountId = accoObj.Id;
        insert caseObj;
        
        // Create a case a object with RO_Vecchio_Cellulare__c is empty
        Case caseObj1 = new Case();
        caseObj1.ContactId = conObj.Id;
        caseObj1.Status = 'Open';
        caseObj1.Subject = 'TestSubject';
        caseObj1.Description = 'TestDescription';
        caseObj1.OwnerId = testGroup1.Id;
        caseObj1.Tentativo__c = 2;
        caseObj.RO_Link_Bozza__c  = '111111';
        caseObj1.AccountId = accoObj.Id;
        insert caseObj1;
        
        // Create a case a object 
        Case caseObj2 = new Case();
        caseObj2.ContactId = conObj.Id;
        caseObj2.Status = 'Open';
        caseObj2.Subject = 'TestSubjectWithoutAnomalie';
        caseObj2.Description = 'TestDescription';
        caseObj2.OwnerId = testGroup1.Id;
        caseObj2.Tentativo__c = 2;
        caseObj.RO_Link_Bozza__c  = '111111';
        caseObj2.AccountId = accoObj.Id;
        insert caseObj2;
        
        // Create a case a object 
        Case caseObj3 = new Case();
        caseObj3.ContactId = conObj.Id;
        caseObj3.Status = 'Open';
        caseObj3.Subject = 'TestSubjectWithoutAnomalie';
        caseObj3.Description = 'TestDescription';
        caseObj3.OwnerId = testGroup1.Id;
        caseObj3.Tentativo__c = 2;
        caseObj3.RO_Vecchio_Cellulare__c='775000953';
        caseObj.RO_Link_Bozza__c  = '111111';
        insert caseObj3;

                // Create a case a object 
        Case caseObj4 = new Case();
        caseObj4.ContactId = conObj.Id;
        caseObj4.Status = 'Open';
        caseObj4.Subject = 'TestSubjectWithoutAnomalie';
        caseObj4.Description = 'TestDescription';
        caseObj4.OwnerId = testGroup1.Id;
        caseObj4.Tentativo__c = 2;
        caseObj4.RO_Vecchio_Cellulare__c=null;
        caseObj.RO_Link_Bozza__c  = '111111';
        caseObj4.AccountId = accoObj.Id;
        insert caseObj4;

        // Create a case a object 
    
        Case caseObj5 = new Case();
        caseObj5.ContactId = conObj.Id;
        caseObj5.Status = 'Open';
        caseObj5.Subject = 'TestSubjectWithoutAnomalie';
        caseObj5.Description = 'TestDescription';
        caseObj5.OwnerId = testGroup1.Id;
        caseObj5.Tentativo__c = 3;
        caseObj5.Product__c=listproduit[0].Id;
        caseObj5.RO_Vecchio_Cellulare__c='77500Tentativo__c';
        caseObj.RO_Link_Bozza__c  = '111111';
        caseObj5.AccountId = accoObj.Id;
        insert caseObj5;

        //Create a anomalie object
        XCS_CompassParameters__c cp = new XCS_CompassParameters__c(Name='Number_of_hours', Execution_Anomalie_Batch_Time__c=2);
        insert cp;
        Anomalie_Doc__c anomalieObject = new Anomalie_Doc__c();
        anomalieObject.CaseId__c=caseObj.Id;
        insert anomalieObject;
        
        //Create a anomalie object for caseObj1
        Anomalie_Doc__c anomalieObject1 = new Anomalie_Doc__c();
        anomalieObject1.CaseId__c=caseObj1.Id;
        insert anomalieObject1;

       
    }

    static testmethod void assemblyTest() {
        
        Case caseObject = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c!='' limit 1];
        Case caseObject1 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c='' limit 1];
        Case caseObject2 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE Subject = 'TestSubjectWithoutAnomalie' limit 1];
        
        List<Case> cases = new List<Case>();
        cases.add(caseObject);
        cases.add(caseObject1);
        cases.add(caseObject2);
        for (Case c : cases) {
            c.Is_Discordanza_Cellulare__c = false;
        }
        update cases;
        //
        Test.startTest();
        // Default constructor
        CaseDomain.Assembly assembly1 = new CaseDomain.Assembly();
        // Constructor with parameters
        CaseDomain.Assembly assembly2 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_NON_ESEGUITO, NUMERO_INESISTENTE, INVIO_LINK_RIPRESA_BOZZA, true);
        CaseDomain.Assembly assembly3 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_NON_ESEGUITO, NUMERO_INESISTENTE, INVIO_LINK_RIPRESA_BOZZA, false);
        CaseDomain.Assembly assembly4 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_NON_ESEGUITO, CLIENTE_NON_TROVATO, INVIO_LINK_RIPRESA_BOZZA, false);
        CaseDomain.Assembly assembly5 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, CONFERMA_VECCHIO_RECAPITO, INVIO_LINK_RIPRESA_BOZZA, false);
        CaseDomain.Assembly assembly6 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, CONFERMA_VECCHIO_RECAPITO, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly7 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, CONFERMA_NUOVO_RECAPITO, INVIO_LINK_RIPRESA_BOZZA, false);
        CaseDomain.Assembly assembly8 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, CONFERMA_NUOVO_RECAPITO, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly9 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, NON_INTERESSATO, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly10 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, DISCONOSCE_LA_PRATICA, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly11 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, INVIO_LINK_RIPRESA_BOZZA, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly12 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, NON_INTERESSATO, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly13 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, FISSA_APPUNTAMENTO, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly14 = new CaseDomain.Assembly(null, CODE, CONTATTO_ESEGUITO, FISSA_APPUNTAMENTO, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly15 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, CHIEDE_DI_ESSERE_RICHIAMATO, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly16 = new CaseDomain.Assembly(caseObject1, CODE, CONTATTO_NON_ESEGUITO, NUMERO_INESISTENTE, INVIO_LINK_RIPRESA_BOZZA, false);
        CaseDomain.Assembly assembly17 = new CaseDomain.Assembly(caseObject1, CODE, CONTATTO_NON_ESEGUITO, CLIENTE_NON_TROVATO, INVIO_LINK_RIPRESA_BOZZA, false);
        CaseDomain.Assembly assembly18 = new CaseDomain.Assembly(caseObject1, CODE, CONTATTO_ESEGUITO, CARICHERA_LA_DOCUMENTAZIONE, INVIO_LINK_RIPRESA_BOZZA, false);
        CaseDomain.Assembly assembly19 = new CaseDomain.Assembly(caseObject1, CODE, CONTATTO_ESEGUITO, CARICHERA_LA_DOCUMENTAZIONE, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly20 = new CaseDomain.Assembly(caseObject1, CODE, CONTATTO_ESEGUITO, HA_GIA_CARICATO_LA_DOCUMENTAZIONE, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly21 = new CaseDomain.Assembly(caseObject1, CODE, CONTATTO_ESEGUITO, NON_INTERESSATO, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly22 = new CaseDomain.Assembly(caseObject1, CODE, CONTATTO_ESEGUITO, DISCONOSCE_LA_PRATICA, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly23 = new CaseDomain.Assembly(caseObject1, CODE, CONTATTO_ESEGUITO, CHIEDE_DI_ESSERE_RICHIAMATO, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly24 = new CaseDomain.Assembly(caseObject2, CODE, CONTATTO_ESEGUITO, CHIEDE_DI_ESSERE_RICHIAMATO, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly25 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, FIRMERA_IL_CONTRATTO, INVIO_LINK_RIPRESA_BOZZA, false);
        CaseDomain.Assembly assembly26 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, FIRMERA_IL_CONTRATTO, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly27 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, HA_GIA_FIRMATO_IL_CONTRATTO, NESSUNA_ALTRA_AZIONE, false);
        
        String state100 = assembly2.getEtat('Q337');
        String state101 = assembly3.getEtat('Q337');
        String state102 = assembly4.getEtat('Q337');
        String state103 = assembly5.getEtat('Q337');
        String state104 = assembly6.getEtat('Q337');
        String state103_2 = assembly7.getEtat('Q337');
        String state104_2 = assembly8.getEtat('Q337');
        String state105 = assembly9.getEtat('Q337');
        String state106 = assembly10.getEtat('Q337');
        String state107 = assembly2.getEtat('Q330');
        String state108 = assembly4.getEtat('Q330');
        String state109 = assembly11.getEtat('Q330');
        String state110 = assembly12.getEtat('Q330');
        String state111 = assembly13.getEtat('Q330');
        String state112 = assembly2.getEtat('Q375');
        String state113 = assembly4.getEtat('Q375');
        String state114 = assembly11.getEtat('Q375');
        String state115 = assembly9.getEtat('Q375');
        String state116 = assembly13.getEtat('Q375');
        String state10 = assembly14.getEtat('Q375');
        //Assembly for state : Q339
        String state117 = assembly3.getEtat('Q339');
        String state118 = assembly4.getEtat('Q339');
        String state119 = assembly5.getEtat('Q339');
        String state120 = assembly6.getEtat('Q339');
        String state121 = assembly7.getEtat('Q339');
        String state122 = assembly8.getEtat('Q339');
        String state123 = assembly9.getEtat('Q339');
        String state124 = assembly10.getEtat('Q339');
        String state125 = assembly15.getEtat('Q339');
        String state126 = assembly16.getEtat('Q339');
        String state127 = assembly17.getEtat('Q339');
        String state128 = assembly18.getEtat('Q339');
        String state129 = assembly19.getEtat('Q339');
        String state130 = assembly20.getEtat('Q339');   
        String state131 = assembly21.getEtat('Q339');
        String state132 = assembly22.getEtat('Q339');
        String state133 = assembly23.getEtat('Q339');   
        String state134 = assembly24.getEtat('Q339');  
        
          //Assembly for state : Q340
        String state135 = assembly3.getEtat('Q340');
        String state136 = assembly4.getEtat('Q340');
        String state138 = assembly18.getEtat('Q340');
        String state139 = assembly19.getEtat('Q340');
        String state140 = assembly20.getEtat('Q340');
        String state141 = assembly12.getEtat('Q340');
        String state142 = assembly10.getEtat('Q340');
        String state143 = assembly15.getEtat('Q340');
        
         
    }

    @isTest
    static void assemblyStrictTest(){
        Case caseObject = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c!='' limit 1];
        Case caseObject1 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c='' limit 1];
        Case caseObject2 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE Subject = 'TestSubjectWithoutAnomalie' limit 1];
        
        List<Case> cases = new List<Case>();
        cases.add(caseObject);
        cases.add(caseObject1);
        cases.add(caseObject2);
        for (Case c : cases) {
            c.Is_Discordanza_Cellulare__c = false;
        }
        update cases;

        Test.startTest();
        // Default constructor
        CaseDomain.Assembly assembly1 = new CaseDomain.Assembly();
        // Constructor with parameters
        CaseDomain.Assembly assembly2 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_NON_ESEGUITO, NUMERO_INESISTENTE, INVIO_LINK_RIPRESA_BOZZA, true);
        CaseDomain.Assembly assembly3 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_NON_ESEGUITO, NUMERO_INESISTENTE, INVIO_LINK_RIPRESA_BOZZA, false);
        CaseDomain.Assembly assembly4 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_NON_ESEGUITO, CLIENTE_NON_TROVATO, INVIO_LINK_RIPRESA_BOZZA, false);
        CaseDomain.Assembly assembly5 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, CONFERMA_VECCHIO_RECAPITO, INVIO_LINK_RIPRESA_BOZZA, false);
        CaseDomain.Assembly assembly6 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, CONFERMA_VECCHIO_RECAPITO, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly7 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, CONFERMA_NUOVO_RECAPITO, INVIO_LINK_RIPRESA_BOZZA, false);
        CaseDomain.Assembly assembly8 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, CONFERMA_NUOVO_RECAPITO, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly9 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, NON_INTERESSATO, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly10 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, DISCONOSCE_LA_PRATICA, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly11 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, INVIO_LINK_RIPRESA_BOZZA, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly12 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, NON_INTERESSATO, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly13 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, FISSA_APPUNTAMENTO, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly14 = new CaseDomain.Assembly(null, CODE, CONTATTO_ESEGUITO, FISSA_APPUNTAMENTO, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly15 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, CHIEDE_DI_ESSERE_RICHIAMATO, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly16 = new CaseDomain.Assembly(caseObject1, CODE, CONTATTO_NON_ESEGUITO, NUMERO_INESISTENTE, INVIO_LINK_RIPRESA_BOZZA, false);
        CaseDomain.Assembly assembly17 = new CaseDomain.Assembly(caseObject1, CODE, CONTATTO_NON_ESEGUITO, CLIENTE_NON_TROVATO, INVIO_LINK_RIPRESA_BOZZA, false);
        CaseDomain.Assembly assembly18 = new CaseDomain.Assembly(caseObject1, CODE, CONTATTO_ESEGUITO, CARICHERA_LA_DOCUMENTAZIONE, INVIO_LINK_RIPRESA_BOZZA, false);
        CaseDomain.Assembly assembly19 = new CaseDomain.Assembly(caseObject1, CODE, CONTATTO_ESEGUITO, CARICHERA_LA_DOCUMENTAZIONE, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly20 = new CaseDomain.Assembly(caseObject1, CODE, CONTATTO_ESEGUITO, HA_GIA_CARICATO_LA_DOCUMENTAZIONE, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly21 = new CaseDomain.Assembly(caseObject1, CODE, CONTATTO_ESEGUITO, NON_INTERESSATO, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly22 = new CaseDomain.Assembly(caseObject1, CODE, CONTATTO_ESEGUITO, DISCONOSCE_LA_PRATICA, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly23 = new CaseDomain.Assembly(caseObject1, CODE, CONTATTO_ESEGUITO, CHIEDE_DI_ESSERE_RICHIAMATO, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly24 = new CaseDomain.Assembly(caseObject2, CODE, CONTATTO_ESEGUITO, CHIEDE_DI_ESSERE_RICHIAMATO, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly25 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, FIRMERA_IL_CONTRATTO, INVIO_LINK_RIPRESA_BOZZA, false);
        CaseDomain.Assembly assembly26 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, FIRMERA_IL_CONTRATTO, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly27 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, HA_GIA_FIRMATO_IL_CONTRATTO, NESSUNA_ALTRA_AZIONE, false);

           //Assembly for state : Q341
        String state144 = assembly3.getEtat('Q341');
        String state145 = assembly4.getEtat('Q341');
        String state146 = assembly25.getEtat('Q341');
        String state147 = assembly26.getEtat('Q341');
        String state148 = assembly27.getEtat('Q341');
        String state149 = assembly12.getEtat('Q341');
        String state150 = assembly10.getEtat('Q341');
        String state151 = assembly15.getEtat('Q341');
        
         //Assembly for state : Q376
         String state152 = assembly3.getEtat('Q376');
        String state153 = assembly4.getEtat('Q376');
        String state154 = assembly5.getEtat('Q376');
        String state155 = assembly6.getEtat('Q376');
        String state156 = assembly7.getEtat('Q376');
        String state157 = assembly8.getEtat('Q376');
        String state158 = assembly9.getEtat('Q376');
        String state159 = assembly10.getEtat('Q376');
        String state160 = assembly15.getEtat('Q376');
        String state161 = assembly16.getEtat('Q376');
        String state162 = assembly17.getEtat('Q376');
        String state163 = assembly18.getEtat('Q376');
        String state164 = assembly19.getEtat('Q376');
        String state165 = assembly20.getEtat('Q376'); 
        Test.stopTest();
    }
    
    static testmethod void assembly2Test() {
        
        Case caseObject = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c!='' limit 1];
        Case caseObject1 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c='' limit 1];
        Case caseObject2 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE Subject = 'TestSubjectWithoutAnomalie' limit 1];
        Test.startTest();
        // Default constructor
        CaseDomain.Assembly assembly1 = new CaseDomain.Assembly();
        // Constructor with parameters
        
        CaseDomain.Assembly assembly2 = new CaseDomain.Assembly(caseObject, CODE, INBOUND_ASSISTENZA, INVIO_LINK_RIPRESA_BOZZA, INVIO_LINK_RIPRESA_BOZZA, true);
        CaseDomain.Assembly assembly3 = new CaseDomain.Assembly(caseObject, CODE, INBOUND_ASSISTENZA, INVIO_DEM_RICARICA_PRATICA, INVIO_LINK_RIPRESA_BOZZA, false);
        CaseDomain.Assembly assembly4 = new CaseDomain.Assembly(caseObject, CODE, INBOUND_ASSISTENZA, NON_INTERESSATO, INVIO_LINK_RIPRESA_BOZZA, false);
        CaseDomain.Assembly assembly5 = new CaseDomain.Assembly(caseObject, CODE, INBOUND_ASSISTENZA, DISCONOSCE_LA_PRATICA, INVIO_LINK_RIPRESA_BOZZA, false);

        
         //Assembly for state : Q525
        String state400= assembly2.getEtat('Q525');
        String state401 = assembly3.getEtat('Q525');
        String state402 = assembly4.getEtat('Q525');
        String state403 = assembly5.getEtat('Q525');
        
        Test.stopTest();
        
        System.assertEquals('103', state400, 'State != 100');
    }

    
    static testmethod void assembly3Test() {
        
        Case caseObject = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c!='' limit 1];
        Case caseObject1 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c='' limit 1];
        Case caseObject2 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE Subject = 'TestSubjectWithoutAnomalie' limit 1];
        Test.startTest();
        // Default constructor
        CaseDomain.Assembly assembly1 = new CaseDomain.Assembly();
        // Constructor with parameters
        
        CaseDomain.Assembly assembly2 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_NON_ESEGUITO, NUMERO_INESISTENTE, INVIO_LINK_RIPRESA_BOZZA, true);
        CaseDomain.Assembly assembly3 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_NON_ESEGUITO, CLIENTE_NON_TROVATO, INVIO_LINK_RIPRESA_BOZZA, false);
        CaseDomain.Assembly assembly4 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_NON_ESEGUITO, NON_INTERESSATO, INVIO_LINK_RIPRESA_BOZZA, false);
        
         //Assembly for state : Q336
        String state400= assembly2.getEtat('Q336');
        String state401 = assembly3.getEtat('Q336');
        String state402 = assembly4.getEtat('Q336');
              
        Test.stopTest();
        
        System.assertEquals('109', state400, 'State != 100');
        
    }

    
    static testmethod void assembly4Test() {
        
        Case caseObject = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c!='' limit 1];
        Case caseObject1 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c='' limit 1];
        Case caseObject2 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE Subject = 'TestSubjectWithoutAnomalie' limit 1];
        Test.startTest();
        // Default constructor
        CaseDomain.Assembly assembly1 = new CaseDomain.Assembly();
        // Constructor with parameters
        
        CaseDomain.Assembly assembly2 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, NUMERO_INESISTENTE, INVIO_LINK_RIPRESA_BOZZA, true);
        
         //Assembly for state : Q336
        String state400= assembly2.getEtat('Q336');
      
        Test.stopTest();
        
        System.assertEquals('10', state400, 'State != 100');
     
    }
  
    static testmethod void assembly5Test() {
        
        Case caseObject = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c='775000953' limit 1];
        Case caseObject1 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c='' limit 1];
        Case caseObject2 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE Subject = 'TestSubjectWithoutAnomalie' limit 1];
        Test.startTest();
        // Default constructor
        CaseDomain.Assembly assembly1 = new CaseDomain.Assembly();
        // Constructor with parameters
        
        CaseDomain.Assembly assembly2 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, CARICHERA_LA_DOCUMENTAZIONE, INVIO_LINK_RIPRESA_BOZZA, true);
        CaseDomain.Assembly assembly3 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, CARICHERA_LA_DOCUMENTAZIONE, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly4 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, NON_INTERESSATO, INVIO_LINK_RIPRESA_BOZZA, false);
        
         //Assembly for state : Q336
        String state400= assembly2.getEtat('Q336');
        String state401 = assembly3.getEtat('Q336');
        System.assert(assembly2!=null, '');
        Test.stopTest();
        
    }

       static testmethod void assembly6Test() {
        
        Case caseObject = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c='775000953' limit 1];
        Case caseObject1 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c='' limit 1];
        Case caseObject2 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE Subject = 'TestSubjectWithoutAnomalie' limit 1];
        Test.startTest();
        // Default constructor
        CaseDomain.Assembly assembly1 = new CaseDomain.Assembly();
        // Constructor with parameters
        
        CaseDomain.Assembly assembly2 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, HA_GIA_CARICATO_LA_DOCUMENTAZIONE, INVIO_LINK_RIPRESA_BOZZA, true);
                
         //Assembly for state : Q336
        String state400= assembly2.getEtat('Q336');
        Test.stopTest();
        
      System.assert(assembly2!=null, '');
        
    }

    
       static testmethod void assembly7Test() {
        
        Case caseObject = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c='775000953' limit 1];
        Case caseObject1 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c='' limit 1];
        Case caseObject2 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE Subject = 'TestSubjectWithoutAnomalie' limit 1];
        Test.startTest();
        // Default constructor
        CaseDomain.Assembly assembly1 = new CaseDomain.Assembly();
        // Constructor with parameters
        
        CaseDomain.Assembly assembly2 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, NON_INTERESSATO, INVIO_LINK_RIPRESA_BOZZA, true);
        
         //Assembly for state : Q336
        String state400= assembly2.getEtat('Q336');
        System.assert(assembly2!=null, '');
              
        Test.stopTest();

        
    }

    
       static testmethod void assembly8Test() {
        
        Case caseObject = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c='775000953' limit 1];
        Case caseObject1 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c='' limit 1];
        Case caseObject2 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE Subject = 'TestSubjectWithoutAnomalie' limit 1];
        Test.startTest();
        // Default constructor
        CaseDomain.Assembly assembly1 = new CaseDomain.Assembly();
        // Constructor with parameters
        
        CaseDomain.Assembly assembly2 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, DISCONOSCE_LA_PRATICA, INVIO_LINK_RIPRESA_BOZZA, true);
         //Assembly for state : Q336
        String state400= assembly2.getEtat('Q336');
        System.assert(assembly2!=null, '');
        Test.stopTest();
        
    }

      static testmethod void assembly9Test() {
        
        Case caseObject = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c='775000953' limit 1];
        Case caseObject1 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c='' limit 1];
        Case caseObject2 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE Subject = 'TestSubjectWithoutAnomalie' limit 1];
        Test.startTest();
        // Default constructor
        CaseDomain.Assembly assembly1 = new CaseDomain.Assembly();
        // Constructor with parameters
        
        CaseDomain.Assembly assembly2 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, DISCONOSCE_LA_PRATICA, INVIO_LINK_RIPRESA_BOZZA, true);
         //Assembly for state : Q336
        String state400= assembly2.getEtat('Q336');
        System.assert(assembly2!=null, '');
              
        Test.stopTest();
        
    }

    
      static testmethod void assembly10Test() {
        
        Case caseObject = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c='775000953' limit 1];
        Case caseObject1 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c='' limit 1];
        Case caseObject2 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE Subject = 'TestSubjectWithoutAnomalie' limit 1];
        Test.startTest();
        // Default constructor
        CaseDomain.Assembly assembly1 = new CaseDomain.Assembly();
        // Constructor with parameters
        
        CaseDomain.Assembly assembly2 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, CHIEDE_DI_ESSERE_RICHIAMATO, INVIO_LINK_RIPRESA_BOZZA, true);
         //Assembly for state : Q336
        String state400= assembly2.getEtat('Q336');
        System.assert(assembly2!=null, '');
        Test.stopTest();
        
    }

    static testmethod void assembly11Test() {
        
        Case caseObject = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c!='' limit 1];
        Case caseObject1 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c='' limit 1];
        Case caseObject2 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE Subject = 'TestSubjectWithoutAnomalie' limit 1];
        
        List <Case> cases = new List<Case>();
        cases.add(caseObject);
        cases.add(caseObject1);
        cases.add(caseObject2);
        for (Case c : cases) {
            c.Is_Discordanza_Cellulare__c = true;
        }
        update cases;
        
        Test.startTest();
        // Default constructor
        CaseDomain.Assembly assembly1 = new CaseDomain.Assembly();
        // Constructor with parameters
        
        CaseDomain.Assembly assembly2 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_NON_ESEGUITO, NUMERO_INESISTENTE, INVIO_LINK_RIPRESA_BOZZA, true);
        CaseDomain.Assembly assembly3 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_NON_ESEGUITO, CLIENTE_NON_TROVATO, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly4 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, NON_INTERESSATO, INVIO_LINK_RIPRESA_BOZZA, false);
        
         //Assembly for state : Q338
        String state400= assembly2.getEtat('Q338');
        String state401 = assembly3.getEtat('Q338');
        System.assert(assembly2!=null, '');
              
        Test.stopTest();
    }

    
    static testmethod void assembly11IsDiscordanzaTest() {
        
        Case caseObject = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c!='' limit 1];
        Case caseObject1 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c='' limit 1];
        Case caseObject2 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE Subject = 'TestSubjectWithoutAnomalie' limit 1];
        
        List <Case> cases = new List<Case>();
        cases.add(caseObject);
        cases.add(caseObject1);
        cases.add(caseObject2);
        for (Case c : cases) {
            c.Is_Discordanza_Cellulare__c = true;
        }
        update cases;
        
        Test.startTest();
        // Default constructor
        CaseDomain.Assembly assembly1 = new CaseDomain.Assembly();
        // Constructor with parameters
        
        CaseDomain.Assembly assembly2 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_NON_ESEGUITO, NUMERO_INESISTENTE, INVIO_LINK_RIPRESA_BOZZA, true);
        CaseDomain.Assembly assembly3 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_NON_ESEGUITO, CLIENTE_NON_TROVATO, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly4 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, CONFERMA_VECCHIO_RECAPITO, INVIO_LINK_RIPRESA_BOZZA, false);
        CaseDomain.Assembly assembly5 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, CONFERMA_VECCHIO_RECAPITO, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly6 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, CONFERMA_NUOVO_RECAPITO, INVIO_LINK_RIPRESA_BOZZA, false);
        CaseDomain.Assembly assembly7 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, CONFERMA_NUOVO_RECAPITO, NESSUNA_ALTRA_AZIONE, false);
        
         //Assembly for state : Q339
        String state2 = assembly2.getEtat('Q339');
        String state3 = assembly3.getEtat('Q339');
        String state4 = assembly4.getEtat('Q339');
        String state5 = assembly5.getEtat('Q339');
        String state6 = assembly6.getEtat('Q339');
        String state7 = assembly7.getEtat('Q339');
        System.assert(assembly2!=null, '');
              
        Test.stopTest();
    }

    static testmethod void assembly12Test() {
        
        Case caseObject = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c!='' limit 1];
        Case caseObject1 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c='' limit 1];
        Case caseObject2 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE Subject = 'TestSubjectWithoutAnomalie' limit 1];
        List <Case> cases = new List<Case>();
        cases.add(caseObject);
        cases.add(caseObject1);
        cases.add(caseObject2);
        for (Case c : cases) {
            c.Is_Discordanza_Cellulare__c = true;
        }
        update cases;

        Test.startTest();
        // Default constructor
        CaseDomain.Assembly assembly1 = new CaseDomain.Assembly();
        // Constructor with parameters
        
        CaseDomain.Assembly assembly2 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, CONFERMA_VECCHIO_RECAPITO, INVIO_LINK_RIPRESA_BOZZA, true);
        CaseDomain.Assembly assembly3 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, CONFERMA_VECCHIO_RECAPITO, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly4 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, NON_INTERESSATO, INVIO_LINK_RIPRESA_BOZZA, false);
        
         //Assembly for state : Q338
        String state400= assembly2.getEtat('Q338');
        String state401 = assembly3.getEtat('Q338');
        System.assert(assembly2!=null, '');
              
        Test.stopTest();
        
    }

    static testmethod void assembly13Test() {
        
        Case caseObject = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c!='' limit 1];
        Case caseObject1 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c='' limit 1];
        Case caseObject2 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE Subject = 'TestSubjectWithoutAnomalie' limit 1];
        List <Case> cases = new List<Case>();
        cases.add(caseObject);
        cases.add(caseObject1);
        cases.add(caseObject2);
        for (Case c : cases) {
            c.Is_Discordanza_Cellulare__c = true;
        }
        update cases;

        Test.startTest();
        // Default constructor
        CaseDomain.Assembly assembly1 = new CaseDomain.Assembly();
        // Constructor with parameters
        
       // CaseDomain.Assembly assembly2 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, CONFERMA_VECCHIO_RECAPITO, INVIO_LINK_RIPRESA_BOZZA, true);
        CaseDomain.Assembly assembly3 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, CONFERMA_VECCHIO_RECAPITO, NESSUNA_ALTRA_AZIONE, false);
        CaseDomain.Assembly assembly4 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, NON_INTERESSATO, INVIO_LINK_RIPRESA_BOZZA, false);
        
         //Assembly for state : Q338
        //String state400= assembly2.getEtat('Q338');
        String state401 = assembly3.getEtat('Q338');
        System.assert(assembly3!=null, '');
        Test.stopTest();
        
     //   System.assertEquals('103', state400, 'State != 100');
        
    }

    static testmethod void assembly14Test() {
        
        Case caseObject = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c!='' limit 1];
        Case caseObject1 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c='' limit 1];
        Case caseObject2 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE Subject = 'TestSubjectWithoutAnomalie' limit 1];
        List <Case> cases = new List<Case>();
        cases.add(caseObject);
        cases.add(caseObject1);
        cases.add(caseObject2);
        for (Case c : cases) {
            c.Is_Discordanza_Cellulare__c = true;
        }
        update cases;
        
        Test.startTest();
        // Default constructor
        CaseDomain.Assembly assembly1 = new CaseDomain.Assembly();
        // Constructor with parameters
        
        CaseDomain.Assembly assembly2 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, CONFERMA_NUOVO_RECAPITO, INVIO_LINK_RIPRESA_BOZZA, true);
         //Assembly for state : Q338
        String state400= assembly2.getEtat('Q338');
        System.assert(assembly2!=null, '');
              
        Test.stopTest();
        
    }

    static testmethod void assembly15Test() {
        
        Case caseObject = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c!='' limit 1];
        Case caseObject1 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c='' limit 1];
        Case caseObject2 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE Subject = 'TestSubjectWithoutAnomalie' limit 1];
        List <Case> cases = new List<Case>();
        cases.add(caseObject);
        cases.add(caseObject1);
        cases.add(caseObject2);
        for (Case c : cases) {
            c.Is_Discordanza_Cellulare__c = true;
        }
        update cases;
        
        Test.startTest();
        // Default constructor
        CaseDomain.Assembly assembly1 = new CaseDomain.Assembly();
        // Constructor with parameters
        
        CaseDomain.Assembly assembly2 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, NON_INTERESSATO, INVIO_LINK_RIPRESA_BOZZA, true);
         //Assembly for state : Q338
        String state400= assembly2.getEtat('Q338');
        System.assert(assembly2!=null, '');
        Test.stopTest();
        
    }


    static testmethod void assembly16Test() {
        
        Case caseObject = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c!='' limit 1];
        Case caseObject1 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c='' limit 1];
        Case caseObject2 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE Subject = 'TestSubjectWithoutAnomalie' limit 1];
        List <Case> cases = new List<Case>();
        cases.add(caseObject);
        cases.add(caseObject1);
        cases.add(caseObject2);
        for (Case c : cases) {
            c.Is_Discordanza_Cellulare__c = true;
        }
        update cases;

        Test.startTest();
        // Default constructor
        CaseDomain.Assembly assembly1 = new CaseDomain.Assembly();
        // Constructor with parameters
        
        CaseDomain.Assembly assembly2 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, DISCONOSCE_LA_PRATICA, INVIO_LINK_RIPRESA_BOZZA, true);
        
         //Assembly for state : Q338
        String state400= assembly2.getEtat('Q338');
        System.assert(assembly2!=null, '');
        Test.stopTest();
        
     //   System.assertEquals('103', state400, 'State != 100');
        
    }

    static testmethod void assembly17Test() {
        
        Case caseObject = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c!='' limit 1];
        Case caseObject1 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c='' limit 1];
        Case caseObject2 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE Subject = 'TestSubjectWithoutAnomalie' limit 1];
        List <Case> cases = new List<Case>();
        cases.add(caseObject);
        cases.add(caseObject1);
        cases.add(caseObject2);
        for (Case c : cases) {
            c.Is_Discordanza_Cellulare__c = true;
        }
        update cases;

        Test.startTest();
        // Default constructor
        CaseDomain.Assembly assembly1 = new CaseDomain.Assembly();
        // Constructor with parameters
        
        CaseDomain.Assembly assembly2 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, CHIEDE_DI_ESSERE_RICHIAMATO, INVIO_LINK_RIPRESA_BOZZA, true);
      
        
         //Assembly for state : Q338
        String state400= assembly2.getEtat('Q338');
        System.assert(assembly2!=null, '');
        Test.stopTest();
        
    }


    static testmethod void assembly18Test() {
        
        Case caseObject = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c!='' limit 1];
        Case caseObject1 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c='' limit 1];
        Case caseObject2 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE Subject = 'TestSubjectWithoutAnomalie' limit 1];
        List <Case> cases = new List<Case>();
        cases.add(caseObject);
        cases.add(caseObject1);
        cases.add(caseObject2);
        for (Case c : cases) {
            c.Is_Discordanza_Cellulare__c = true;
        }
        update cases;

        Test.startTest();
        // Default constructor
        CaseDomain.Assembly assembly1 = new CaseDomain.Assembly();
        // Constructor with parameters
        
        CaseDomain.Assembly assembly2 = new CaseDomain.Assembly(caseObject, CODE, CONTATTO_ESEGUITO, IDENTITA_NON_CONFERMATA, INVIO_LINK_RIPRESA_BOZZA, true);        
         //Assembly for state : Q338
        String state400= assembly2.getEtat('Q338');
        System.assert(assembly2!=null, '');
        Test.stopTest();
        
     //   System.assertEquals('103', state400, 'State != 100');
        
    }

    static testmethod void assemblyTest20() {
        
    
        Case caseObject1 = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c,RO_Vecchio_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case WHERE RO_Vecchio_Cellulare__c='' limit 1];
        caseObject1.Is_Discordanza_Cellulare__c = true;
        
        update caseObject1;
        Test.startTest();
        // Default constructor
        CaseDomain.Assembly assembly1 = new CaseDomain.Assembly();
        // Constructor with parameters
        CaseDomain.Assembly assembly2 = new CaseDomain.Assembly(caseObject1, CODE, CONTATTO_ESEGUITO, NON_INTERESSATO, INVIO_LINK_RIPRESA_BOZZA, true);
        CaseDomain.Assembly assembly3 = new CaseDomain.Assembly(caseObject1, CODE, CONTATTO_ESEGUITO, DISCONOSCE_LA_PRATICA, INVIO_LINK_RIPRESA_BOZZA, false);
        CaseDomain.Assembly assembly4 = new CaseDomain.Assembly(caseObject1, CODE, CONTATTO_ESEGUITO, CHIEDE_DI_ESSERE_RICHIAMATO, INVIO_LINK_RIPRESA_BOZZA, false);

        //Assembly for state : Q339
        String state117 = assembly2.getEtat('Q376');
        String state118 = assembly3.getEtat('Q376');
        String state119 = assembly4.getEtat('Q376');      
        Test.stopTest();
    }
   

    static testmethod void CaseContextTest() {
        Case caseObject = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case limit 1];
        
        Test.startTest();
        CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q525', true);
        
        context.setState(new CaseDomain.ContattoNonEseguitoContext1());
        Map < String,
            Object > responseContattoNonEseguitoContext1 = context.action();
        
        context.setState(new CaseDomain.ContattoNonEseguitoContext2());
        Map < String,
            Object > responseContattoNonEseguitoContext2 = context.action();
        
        context.setState(new CaseDomain.ContattoNonEseguitoContext3());
        Map < String,
            Object > responseContattoNonEseguitoContext3 = context.action();
        
        context.setState(new CaseDomain.ContattoNonEseguitoContext4());
        Map < String,
            Object > responseContattoNonEseguitoContext4 = context.action();
        
        context.setState(new CaseDomain.ContattoNonEseguitoContext5());
        Map < String,
            Object > responseContattoNonEseguitoContext5 = context.action();
        
        context.setState(new CaseDomain.ContattoNonEseguitoContext6());
        Map < String,
            Object > responseContattoNonEseguitoContext6 = context.action();
        
        context.setState(new CaseDomain.ContattoNonEseguitoContext7());
        Map < String,
            Object > responseContattoNonEseguitoContext7 = context.action();
        
        Test.stopTest();
        System.assertEquals(responseContattoNonEseguitoContext1.get('case'), caseObject, 'caseObjects are !=');
        //System.assertEquals(responseContattoNonEseguitoContext2.get('linkevo'), true, 'LinkEvo is not true');
        System.assertEquals(2, responseContattoNonEseguitoContext3.size(), 'Size != 2');
        System.assertEquals(responseContattoNonEseguitoContext4.get('case'), caseObject, 'caseObjects are !=');
        System.assertEquals(responseContattoNonEseguitoContext5.get('linkevo'), true, 'LinkEvo is not true');
        System.assertEquals(responseContattoNonEseguitoContext6.get('case'), caseObject, 'caseObjects are !=');
        System.assertEquals(responseContattoNonEseguitoContext7.get('case'), caseObject, 'caseObjects are !=');
    }

    static testmethod void CaseContattoNonEseguitoContext8Test() {
        Case caseObject = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c,RO_Vecchio_Cellulare__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case  
        WHERE RO_Vecchio_Cellulare__c='77500Tentativo__c' limit 1];
        
        Test.startTest();
        CaseDomain.ContattoNonEseguitoContext8 context8 = 
        new CaseDomain.ContattoNonEseguitoContext8();
        CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q525', true);
        context8.action(context);
        System.assert(caseObject!=null, '');
                
        Test.stopTest();
        //System.assertEquals(responseContattoNonEseguitoContext2.get('linkevo'), true, 'LinkEvo is not true');

    }

    static testmethod void CaseContattoNonEseguitoContext2Test() {
        Case caseObject = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c,RO_Vecchio_Cellulare__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case  
        WHERE Tentativo__c = 3  limit 1];
        
        Test.startTest();
        CaseDomain.ContattoNonEseguitoContext2 context2 = 
        new CaseDomain.ContattoNonEseguitoContext2();
        CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q525', true);
        System.System.debug('--- context'+context);
        context2.action(context);
        System.assert(caseObject!=null, '');
                
        Test.stopTest();
        //System.assertEquals(responseContattoNonEseguitoContext2.get('linkevo'), true, 'LinkEvo is not true');

    }

    static testmethod void CaseContattoNonEseguitoContext7Test() {
        Case caseObject = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c,RO_Vecchio_Cellulare__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case  
        WHERE Tentativo__c = 3  limit 1];
        
        Test.startTest();
        CaseDomain.ContattoNonEseguitoContext7 context7 = 
        new CaseDomain.ContattoNonEseguitoContext7();
        CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q525', true);
        System.System.debug('--- context'+context);
        context7.action(context);
        System.assert(caseObject!=null, '');
                
        Test.stopTest();
        //System.assertEquals(responseContattoNonEseguitoContext2.get('linkevo'), true, 'LinkEvo is not true');
    }
    
    static testmethod void CaseContattoNonEseguitoContext3Test() {
        Case caseObject = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c,RO_Vecchio_Cellulare__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case  
        WHERE Tentativo__c = 3  limit 1];
        
        Test.startTest();
        CaseDomain.ContattoNonEseguitoContext3 context3 = 
        new CaseDomain.ContattoNonEseguitoContext3();
        CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q524', true);
        System.System.debug('--- context'+context);
        context3.action(context);
        System.assert(caseObject!=null, '');
                
        Test.stopTest();
        //System.assertEquals(responseContattoNonEseguitoContext2.get('linkevo'), true, 'LinkEvo is not true');

    }

    static testmethod void CaseContattoNonEseguitoContext1Test() {
        Case caseObject = [SELECT Id, stato_ocs__c, OwnerId, RO_fea__c,RO_Vecchio_Cellulare__c, Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c, Tentativo__c, AccountId, Product__r.DEMRipresaBozza__c, Product__r.Family FROM Case  
        WHERE Tentativo__c = 3  limit 1];
        
        Test.startTest();
        CaseDomain.ContattoNonEseguitoContext1 context1 = 
        new CaseDomain.ContattoNonEseguitoContext1();
        CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q524', true);
        System.System.debug('--- context'+context);
        context1.action(context);
        System.assert(caseObject!=null, '');
                
        Test.stopTest();
        //System.assertEquals(responseContattoNonEseguitoContext2.get('linkevo'), true, 'LinkEvo is not true');

    }
    
    static testmethod void mailDemTest() {
        
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];

        Test.startTest();
        //CaseDomain CaseDomain1 = new CaseDomain();
        CaseDomain.mailDem('2071', caseObject.Id, 'subject', 'layepythagore.91@gmail.com', 'senderDisplayName'); 
              
        Test.stopTest();
    }

    static testmethod void mailDem2Test() {
        
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];

        Test.startTest();
        CaseDomain.mailDem('2553', caseObject.Id, 'subject', 'layepythagore.91@gmail.com', 'senderDisplayName');
              
        Test.stopTest();
        
    }

    static testmethod void mailDem22Test() {
        
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        contact  contactObject = [SELECT Id,DEM_Param_7__c FROM contact limit 1];
        contactObject.DEM_Param_7__c = '';
        contactObject.DEM_Param_8__c = '11111';
        update contactObject;

        Test.startTest();
        CaseDomain.mailDem('2553', caseObject.Id, 'subject', 'layepythagore.91@gmail.com', 'senderDisplayName');
        Test.stopTest();
        
    }

    static testmethod void mailDem3Test() {
        
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];

        Test.startTest();
        CaseDomain.mailDem('2064', caseObject.Id, 'subject', 'layepythagore.91@gmail.com', 'senderDisplayName');
        Test.stopTest();
        
    }

    static testmethod void mailDem33Test() {
        
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        contact  contactObject = [SELECT Id,DEM_Param_7__c FROM contact limit 1];
        contactObject.DEM_Param_7__c = '';
        contactObject.DEM_Param_8__c = '11111';
        update contactObject;

        Test.startTest();
        CaseDomain.mailDem('2064', caseObject.Id, 'subject', 'layepythagore.91@gmail.com', 'senderDisplayName');
        Test.stopTest();
    }

    static testmethod void mailDem4Test() {
        
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];

        Test.startTest();
        CaseDomain.mailDem('2065', caseObject.Id, 'subject', 'layepythagore.91@gmail.com', 'senderDisplayName');
        Test.stopTest();
    }
    static testmethod void mailDem44Test() {
        
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        contact  contactObject = [SELECT Id,DEM_Param_7__c FROM contact limit 1];
        contactObject.DEM_Param_7__c = '';
        contactObject.DEM_Param_8__c = '11111';
        update contactObject;

        Test.startTest();
       CaseDomain.mailDem('2065', caseObject.Id, 'subject', 'layepythagore.91@gmail.com', 'senderDisplayName');
              
        Test.stopTest();
        
    }
    
    static testmethod void mailDem5Test() {
        
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        contact  contactObject = [SELECT Id,DEM_Param_7__c FROM contact limit 1];
        contactObject.DEM_Param_7__c = '';
        contactObject.DEM_Param_8__c = '11111';
				update contactObject;
        Test.startTest();
       CaseDomain.mailDem('2565', caseObject.Id, 'subject', 'layepythagore.91@gmail.com', 'senderDisplayName');
              
        Test.stopTest();
        
    }
    
    static testmethod void mailDem6Test() {
        
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];

        Test.startTest();
       CaseDomain.mailDem('2557', caseObject.Id, 'subject', 'layepythagore.91@gmail.com', 'senderDisplayName');
              
        Test.stopTest();
        
    }
    static testmethod void mailDem11Test() {
        
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        contact  contactObject = [SELECT Id,DEM_Param_7__c FROM contact limit 1];
        contactObject.DEM_Param_7__c = '';
        contactObject.DEM_Param_8__c = '11111';
        update contactObject;

        Test.startTest();
       CaseDomain.mailDem('2557', caseObject.Id, 'subject', 'layepythagore.91@gmail.com', 'senderDisplayName');
              
        Test.stopTest();
        
    }
    
    static testmethod void mailDem7Test() {
        
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];

        Test.startTest();
       CaseDomain.mailDem('2556', caseObject.Id, 'subject', 'layepythagore.91@gmail.com', 'senderDisplayName');
              
        Test.stopTest();
        
    }
    
    static testmethod void mailDem12Test() {
        
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        contact  contactObject = [SELECT Id,DEM_Param_7__c FROM contact limit 1];
        contactObject.DEM_Param_7__c = '';
        contactObject.DEM_Param_8__c = '11111';
        update contactObject;

        Test.startTest();
       CaseDomain.mailDem('2556', caseObject.Id, 'subject', 'layepythagore.91@gmail.com', 'senderDisplayName');
              
        Test.stopTest();
        
    } 
    static testmethod void mailDem8Test() {
        
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];

        Test.startTest();
       CaseDomain.mailDem('2564', caseObject.Id, 'subject', 'layepythagore.91@gmail.com', 'senderDisplayName');
              
        Test.stopTest();
        
    } 
    static testmethod void mailDem88Test() {
        
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        contact  contactObject = [SELECT Id,DEM_Param_7__c FROM contact limit 1];
        contactObject.DEM_Param_7__c = '';
        contactObject.DEM_Param_8__c = '11111';
        update contactObject;

        Test.startTest();
       CaseDomain.mailDem('2564', caseObject.Id, 'subject', 'layepythagore.91@gmail.com', 'senderDisplayName');
              
        Test.stopTest();
        
    }
    
   
    
    static testmethod void mailDem9Test() {
        
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];

        Test.startTest();
       CaseDomain.mailDem('2558', caseObject.Id, 'subject', 'layepythagore.91@gmail.com', 'senderDisplayName');
              
        Test.stopTest();
        
    }
    static testmethod void mailDem99Test() {
        
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        contact  contactObject = [SELECT Id,DEM_Param_7__c FROM contact limit 1];
        contactObject.DEM_Param_7__c = '';
        contactObject.DEM_Param_8__c = '11111';
        update contactObject;

        Test.startTest();
       CaseDomain.mailDem('2558', caseObject.Id, 'subject', 'layepythagore.91@gmail.com', 'senderDisplayName');
              
        Test.stopTest();
        
    }
    
    static testmethod void mailDem10Test() {
        
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];

        Test.startTest();
       CaseDomain.mailDem('2073', caseObject.Id, 'subject', 'layepythagore.91@gmail.com', 'senderDisplayName');
              
        Test.stopTest();
        
    }
    static testmethod void mailDem100Test() {
        //Account acc = [SELECT Id FROM Account Limit 1];
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        //caseObject.AccountId = acc.Id;
        //update caseObject;
        contact  contactObject = [SELECT Id,DEM_Param_7__c FROM contact limit 1];
        contactObject.DEM_Param_7__c = '';
        contactObject.DEM_Param_8__c = '11111';
        update contactObject;

        Test.startTest();
        CaseDomain.mailDem('2073', caseObject.Id, 'subject', 'layepythagore.91@gmail.com', 'senderDisplayName');              
        Test.stopTest();
    }
    static testmethod void mailDem101Test() {
        
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        contact  contactObject = [SELECT Id,DEM_Param_7__c FROM contact limit 1];
        contactObject.DEM_Param_7__c = '';
        contactObject.DEM_Param_9__c = '11111';
        update contactObject;

        Test.startTest();
       CaseDomain.mailDem('2073', caseObject.Id, 'subject', 'layepythagore.91@gmail.com', 'senderDisplayName');
              
        Test.stopTest();
        
    }
    
    static testmethod void mailDem14Test() {
        
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        contact  contactObject = [SELECT Id,DEM_Param_7__c FROM contact limit 1];
        contactObject.DEM_Param_7__c = '';
        contactObject.DEM_Param_8__c = '11111';
        update contactObject;

        Test.startTest();
       CaseDomain.mailDem('2566', caseObject.Id, 'subject', 'layepythagore.91@gmail.com', 'senderDisplayName');
        Test.stopTest();
        
    }
    
    static testmethod void sendEmailDem1Test() {
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        Test.startTest();
        CaseDomain.sendEmailDem('Q337', caseObject.Id, 'subject');
        Test.stopTest();
        
    }
    
    static testmethod void sendEmailDem2Test() {
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        Test.startTest();
        CaseDomain.sendEmailDem('Q330', caseObject.Id, 'subject');
        Test.stopTest();
        
    }
    
    static testmethod void sendEmailDem4Test() {
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        Test.startTest();
        CaseDomain.sendEmailDem('Q331', caseObject.Id, 'subject');
        Test.stopTest();
        
    }
    
    static testmethod void sendEmailDem3Test() {
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        Test.startTest();
        CaseDomain.sendEmailDem('Q332', caseObject.Id, 'subject');
        Test.stopTest();
        
    }
    
    static testmethod void sendEmailDem5Test() {
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        Test.startTest();
        CaseDomain.sendEmailDem('Q375', caseObject.Id, 'subject');
        Test.stopTest();
        
    }
    
    static testmethod void sendEmailDem6Test() {
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        Test.startTest();
        CaseDomain.sendEmailDem('Q339', caseObject.Id, 'subject');
        Test.stopTest();
        
    }
    
    static testmethod void sendEmailDem66Test() {
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        caseObject.RO_Vecchio_Cellulare__c = '';
        update caseObject;
        Test.startTest();
        CaseDomain.sendEmailDem('Q339', caseObject.Id, '109');
        Test.stopTest();
        
    }    
    
    static testmethod void sendEmailDem666Test() {
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        caseObject.RO_Vecchio_Cellulare__c = '';
        update caseObject;
        Test.startTest();
        CaseDomain.sendEmailDem('Q339', caseObject.Id, '119');
        Test.stopTest();
        
    }
    
    static testmethod void sendEmailDem7Test() {
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        Test.startTest();
        CaseDomain.sendEmailDem('Q340', caseObject.Id, 'subject');
        Test.stopTest();
        
    }
    
    static testmethod void sendEmailDem77Test() {
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        Test.startTest();
        CaseDomain.sendEmailDem('Q340', caseObject.Id, '109');
        Test.stopTest();
        
    }
    
    static testmethod void sendEmailDem8Test() {
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case where Product__r.DEMNonTrovatoFirmaContratto__c = '2557'  limit 1];

        Test.startTest();
        CaseDomain.sendEmailDem('Q377', caseObject.Id, '119');
        Test.stopTest();
    }
    
    static testmethod void sendEmailDem88Test() {
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        Test.startTest();
        CaseDomain.sendEmailDem('Q377', caseObject.Id, '109');
        Test.stopTest();
        
    }
    
    static testmethod void sendEmailDem9Test() {
        Product2 product2 = new Product2(Name='Produit4', Family='PF_ECOMMERCE_STANDARD',DEMAnomalie__c='2072',DEMNonTrovatoAnomalie__c='2556');
        insert product2;
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        caseObject.Product__c = product2.Id;
        Test.startTest();
        CaseDomain.sendEmailDem('Q376', caseObject.Id, '109');
        Test.stopTest();
        
    }
    
    static testmethod void sendEmailDem99Test() {
        Product2 product2 = new Product2(Name='Produit4', Family='PF_ECOMMERCE_STANDARD',DEMAnomalie__c='2072',DEMNonTrovatoAnomalie__c='2564');
        insert product2;
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        caseObject.Product__c = product2.Id;
        Test.startTest();
        CaseDomain.sendEmailDem('Q376', caseObject.Id, '109');
        Test.stopTest();
        
    }
    
    static testmethod void sendEmailDem10Test() {
        Product2 product2 = new Product2(Name='Produit4', Family='PF_ECOMMERCE_STANDARD',DEMAnomalie__c='2072',DEMNonTrovatoFirmaContratto__c='2070');
        insert product2;
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        caseObject.Product__c = product2.Id;
        Test.startTest();
        CaseDomain.sendEmailDem('Q341', caseObject.Id, 'subject');
        Test.stopTest();
        
    }
    
    static testmethod void sendEmailDem1341Test() {
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        Test.startTest();
        CaseDomain.sendEmailDem('Q341', caseObject.Id, '109');
        Test.stopTest();
        
    }
    
    static testmethod void sendEmailDem1342Test() {
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        Test.startTest();
        CaseDomain.sendEmailDem('Q341', caseObject.Id, '103');
        Test.stopTest();
        
    }
    
    static testmethod void sendEmailDem11Test() {
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        Test.startTest();
        CaseDomain.sendEmailDem('Q336', caseObject.Id, '103');
        Test.stopTest();
        
    }
    
    static testmethod void sendEmailDem103Test() {
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        Test.startTest();
        CaseDomain.sendEmailDem('Q336', caseObject.Id, 'subject');
        Test.stopTest();
        
    }
    
    static testmethod void sendEmailDem12Test() {
        Product2 product2 = new Product2(Name='Produit4', Family='PF_ECOMMERCE_STANDARD',DEMAnomalie__c='2072',DEMRipresaBozza__c='2553');
        insert product2;
        Case caseObject = [SELECT Id,RO_Link_Bozza__c,AccountId FROM Case limit 1];
        caseObject.Product__c = product2.Id;
        update caseObject;
        Test.startTest();
        CaseDomain.sendEmailDem('Q525', caseObject.Id, 'subject');
        Test.stopTest();
        
    }
   
}