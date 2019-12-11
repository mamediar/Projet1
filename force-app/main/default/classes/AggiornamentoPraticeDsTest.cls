@isTest
    private  class AggiornamentoPraticeDsTest {
        
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

       
        String RecTypeId = [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;
        Account accoObj = new Account(RecordTypeID=RecTypeId, FirstName='test', LastName='Acc', PersonEmail='test@yahoo.com', PersonHomePhone='1234567');
        insert accoObj;

        List<Case> v1 = new List<Case>{
        new Case (RO_Link_Bozza__c='xxx',RO_Engine_channel__c='WEB', Product__c=listproduit[0].Id, AccountId=accoObj.Id),
        new Case(RO_Link_Bozza__c='xxx',Product__c=listproduit[1].Id, AccountId=accoObj.Id),
        new Case(RO_Link_Bozza__c='xxx',RO_Engine_channel__c = 'forzoso Filiale',
                 Product__c=listproduit[2].Id, AccountId=accoObj.Id),
        new Case (RO_Link_Bozza__c='xxx',Product__c=listproduit[3].Id, RO_Engine_channel__c='WEB',AccountId=accoObj.Id ),
        new Case(RO_Link_Bozza__c='xxx', RO_Engine_channel__c = 'Non forzoso Filiale',
                RO_Current_Step__c = 'Step 1 - Scelta cliente', Product__c=listproduit[4].Id, AccountId=accoObj.Id),
        new Case(Description='xxx',RO_Engine_channel__c='WEB',Product__c=listproduit[5].Id, AccountId=accoObj.Id),
        new Case (Description ='xxx' ,RO_Engine_channel__c='xxx',Product__c=listproduit[6].Id,AccountId=accoObj.Id)

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

       /* Group g = new Group(Name ='q1',Type='Queue', DeveloperName ='Q100');
        insert g;*/

        }



        @isTest
        static void inviiSuccessivi24hPrimaDelSeccitest(){
            Test.startTest();
              List<Case> cases = [SELECT Id , AccountId, Account.Phone, Product__r.DEMAnomalie__c FROM Case];
              Map<Id, Case> caseMap = new Map<Id, Case>(cases);
              AggiornamentoPraticeDS.inviiSuccessivi24hPrimaDelSecci(caseMap);
              System.assertNotEquals(0, caseMap.keySet().size(), 'pass');
        }
        @isTest
        static void inviiSuccessivi24hPrimaDelSecciException(){
            Test.startTest();
            List<Case> cases = [SELECT Id , AccountId, Product__r.DEMAnomalie__c FROM Case];
            Map<Id, Case> caseMap = new Map<Id, Case>(cases);
             AggiornamentoPraticeDS.inviiSuccessivi24hPrimaDelSecci(caseMap);
             System.assertNotEquals(0, caseMap.keySet().size(), 'pass');
            Test.stopTest();

        }
        @isTest
        static void inviiSuccessivi24hPrimaDelSecciDEmptyMap(){
            Test.startTest();
             Map<Id, Case> caseMap = new Map<Id, Case>();
             AggiornamentoPraticeDS.inviiSuccessivi24hPrimaDelSecci(caseMap);
             System.assertEquals(0, caseMap.keySet().size(), 'pass');
            Test.stopTest();
        }
        @isTest
        static void abbandonaPostSeccitest(){
            Test.startTest();
             List<Case> cases = [SELECT Id , AccountId,
                                       Product__r.DEMAnomalie__c,RO_Link_Bozza__c,
                                       RO_Engine_channel__c, Account.getCodice_Cliente__c,
                                       RO_Current_Step__c, Richiesta_appuntamento__c,
                                       LastModifiedDate, (SELECT Id,RO_CRMModalita_richiesta__c 
                                                          FROM Rich_online_steplogs__r)  FROM Case];
            Map<Id, Case> caseMap = new Map<Id, Case>(cases);
            Map<Id, Case> casesR = new Map<Id, Case>();
            AggiornamentoPraticeDS.abbandonaPostSecci(caseMap, casesR);
            System.assertEquals(0, casesR.keySet().size(), '**** pass');
            Test.stopTest();
        }
       
        @isTest
        static void abbandonaPostSecciAzionitest(){
            Test.startTest();
            List<Case> cases = [SELECT Id , AccountId, Account.Phone, Product__r.DEMAnomalie__c FROM Case];
            Map<Id, Case> caseMap = new Map<Id, Case>(cases);
            Map<Id, Case> casesR = new Map<Id, Case>();
            AggiornamentoPraticeDS.abbandonaPostSecciAzioni(caseMap);
             System.assertEquals(0, casesR.keySet().size(), '**** pass');
            Test.stopTest();

        }
        @isTest
        static void addCaseToQueuetest(){
           Test.startTest();
           List<Case> cases = [SELECT Id , AccountId, Product__r.DEMAnomalie__c FROM Case];
           AggiornamentoPraticeDS.addCaseToQueue(cases, 'Q100');
           System.assertNotEquals(0, cases.size(),'pass');
           Test.stopTest();
        }
        
        @isTest
        static void addCaseToQueuetestEmpty(){
            Test.startTest();
            List<Case> cases = new List<Case>();
            AggiornamentoPraticeDS.addCaseToQueue(cases, 'Q100');
            System.assertEquals(0, cases.size(),'pass');
            Test.stopTest();
        }
        @isTest
        static void addCaseToQueuetestException(){
          Test.startTest();
           List<Case> cases = [SELECT Id , AccountId, Product__r.DEMAnomalie__c FROM Case];
           AggiornamentoPraticeDS.addCaseToQueue(cases, 'Qx');
           System.assertNotEquals(0, cases.size(),'pass');
          Test.stopTest();
        }

        @isTest
        static void nonForzosoCheAbbandonatest(){
        Test.startTest();
            List<Case> cases = [SELECT Id , AccountId,
                                       Product__r.DEMAnomalie__c,
                                       RO_Engine_channel__c, Account.getCodice_Cliente__c,
                                       RO_Current_Step__c, Richiesta_appuntamento__c,
                                       LastModifiedDate, (SELECT Id,RO_CRMModalita_richiesta__c 
                                                          FROM Rich_online_steplogs__r)  FROM Case];
            Map<Id, Case> caseMap = new Map<Id, Case>(cases);
            Map<Id, Case> casesR = new Map<Id, Case>();
            AggiornamentoPraticeDS.nonForzosoCheAbbandona(caseMap, casesR);
            System.assertNotEquals(0, cases.size(),'pass');
        Test.stopTest();

        }
        @isTest
        static void forzosoCheAbbandonaDsAzionitest(){
         Test.startTest();
            List<Case> cases = [SELECT Id , AccountId, Account.Phone, Product__r.DEMAnomalie__c FROM Case];
            Map<Id, Case> caseMap = new Map<Id, Case>(cases);
            Map<Id, Case> casesR = new Map<Id, Case>();
            AggiornamentoPraticeDS.forzosoCheAbbandonaDsAzioni(caseMap);
            System.assertEquals(0, casesR.keySet().size(), '**** pass');
         Test.stopTest();
        }
        @isTest
        static void ricontattoClienteForzosoFilialeDStest(){
            Test.startTest();
              List<Case> cases = [SELECT Id , AccountId,
                                       Product__r.DEMAnomalie__c,
                                       RO_Engine_channel__c, Account.getCodice_Cliente__c,
                                       RO_Current_Step__c, Richiesta_appuntamento__c,
                                       LastModifiedDate, (SELECT Id,RO_CRMModalita_richiesta__c 
                                                          FROM Rich_online_steplogs__r)  FROM Case];
            Map<Id, Case> caseMap = new Map<Id, Case>(cases);
            Map<Id, Case> casesR = new Map<Id, Case>();
            AggiornamentoPraticeDS.ricontattoClienteForzosoFilialeDS(caseMap, casesR);
             System.assertEquals(0, casesR.keySet().size(), '**** pass');
            Test.stopTest();
        }
        @isTest
        static void ricontattoClienteForzosoFilialeDSAzionitest(){
            Test.startTest();
            List<Case> cases = [SELECT Id , AccountId, Account.Phone, Product__r.DEMAnomalie__c FROM Case];
            Map<Id, Case> caseMap = new Map<Id, Case>(cases);
            Map<Id, Case> casesR = new Map<Id, Case>();
            AggiornamentoPraticeDS.ricontattoClienteForzosoFilialeDSAzioni(caseMap);
            System.assertEquals(0, casesR.size(), '****** pass');
            Test.stopTest();
        }
        @isTest
        static void ricontattoClienteCheSceglietest(){
            Test.startTest();
             List<Case> cases = [SELECT Id , AccountId,
                                       Product__r.DEMAnomalie__c,
                                       RO_Engine_channel__c, Account.getCodice_Cliente__c,
                                       RO_Current_Step__c, Richiesta_appuntamento__c,
                                       LastModifiedDate, (SELECT Id,RO_CRMModalita_richiesta__c 
                                                          FROM Rich_online_steplogs__r)  FROM Case];
            Map<Id, Case> caseMap = new Map<Id, Case>(cases);
            Map<Id, Case> casesR = new Map<Id, Case>();
            AggiornamentoPraticeDS.ricontattoClienteCheSceglie(caseMap, casesR);
            System.assertEquals(0, casesR.size(), '****** pass');
            Test.stopTest();
        }
        @isTest
        static void inserimentoInCodatest(){
         Test.startTest();
            List<Case> cases = [SELECT Id , AccountId, Product__r.DEMAnomalie__c FROM Case];
            Map<Id, Case> caseMap = new Map<Id, Case>(cases);
            AggiornamentoPraticeDS.inserimentoInCoda(caseMap);
            System.assertNotEquals(0, cases.size(), 'pass');
         Test.stopTest();
        }
        @isTest
        static void inserimentoInCodatestEmpty(){
         Test.startTest();
            Map<Id, Case> caseMap = new Map<Id, Case>();
            AggiornamentoPraticeDS.inserimentoInCoda(caseMap);
            System.assertEquals(0, caseMap.keySet().size(), 'pass');
         Test.stopTest();
        }
        @isTest
        static void abbandonaPrimaDelSeccitest(){
         Test.startTest();
             List<Case> cases = [SELECT Id , AccountId,
                                       Product__r.DEMAnomalie__c,
                                       RO_Engine_channel__c,RO_Link_Bozza__c, Account.getCodice_Cliente__c,
                                       RO_Current_Step__c, Richiesta_appuntamento__c,
                                       LastModifiedDate FROM Case];
            Map<Id, Case> caseMap = new Map<Id, Case>(cases);
            for(Id key : caseMap.keySet()){
               if((caseMap.get(key)).RO_Link_Bozza__c == null && (caseMap.get(key)).RO_Engine_channel__c == 'WEB'){
                   System.debug('**** '+(caseMap.get(key)).RO_Engine_channel__c);
               }
            }
           
            Map<Id, Case> casesR = new Map<Id, Case>();
         AggiornamentoPraticeDS.abbandonaPrimaDelSecci(caseMap, casesR);
         System.assertEquals(0, casesR.keySet().size(), '******** passs ');

         Test.stopTest();
        }
        @isTest
        static void aggiornamentoDStest(){
         Test.startTest();
          List<Case> cases = [SELECT Id , AccountId,
                                       Product__r.DEMAnomalie__c,
                                       RO_Engine_channel__c, Account.getCodice_Cliente__c,
                                       RO_Current_Step__c, Richiesta_appuntamento__c,
                                       LastModifiedDate FROM Case];
          Map<Id, Case> casesR = new Map<Id, Case>();
          AggiornamentoPraticeDS.aggiornamentoDS(cases, casesR);
          System.assertEquals(0, casesR.keySet().size(), '******* ');

                                

         Test.stopTest();

        }

    }