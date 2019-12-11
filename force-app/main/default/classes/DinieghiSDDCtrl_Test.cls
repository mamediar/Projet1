@istest
public with sharing class DinieghiSDDCtrl_Test {


    private static void insertVarie(){

        ApiRest__c rest4 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal',Name ='ocs.variazioneTelefonoBanca',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
        insert rest4;
        ApiRest__c rest1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal',Name ='ocs.gestioneNote',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
        insert rest1;
        ApiRest__c rest2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal',Name ='ocs.variazioneDatiPagamento',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
//        ApiRest__c rest2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='[{"AS400Status":"OK","AS400Errore":null}]',Test_Request__c = 'testRequest',Mock__c = true,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal',Name ='ocs.variazioneDatiPagamento',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
        insert rest2;
        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert uti;



    }

    private static testmethod void test1() {
        insertVarie();


        Account acc = new Account();
        acc.FirstName = 'TESTFABIO';
        acc.LastName = 'TESTGIULIANI';
        acc.Codice_Fiscale__c = 'RTUMRN89C02R800Q';
        acc.Codice_Fiscale__pc = 'RTUMRN89C02R800Q';
        acc.OCS_External_Id__c = '123456';
        insert acc;

/*        Contact con = new Contact();
        con.FirstName = 'TEST FABIO';
        con.LastName = 'TEST GIULIANI';
        con.AccountId = acc.Id;
        insert con;*/


        Id queueId = [SELECT Id FROM Group WHERE DeveloperName =:DinieghiSDDCtrl.QUEUE_DINIEGHI LIMIT 1].Id;
        Id rType = [SELECT Id FROM RecordType WHERE Name ='Dinieghi SDD Verifiche Filiale' LIMIT 1].Id;

        Case caso = new Case();
        caso.Subject = 'Diniego';
        caso.Status = 'New';
        caso.NumeroPratica__c ='2342342';
        caso.ownerId=queueId;
        caso.RecordTypeId = rType;
        insert caso;   

		Mandati_SDD__c man = new Mandati_SDD__c();        
        man.Caseid__c = caso.Id; 
        man.PraticaNum__c = '';
        man.Progressivo__c = '';
        man.ProgreMan__c = '';
        man.Codice_Cliente__c = acc.Id; 
        man.Ragione_Sociale_Cliente__c = ''; 
        man.Intestatario_cc__c = '';
        man.Ragione_Sociale_Intest_cc__c = ''; 
        man.Modalita_Pagamento__c = '';
        man.Gruppo__c = '';
        man.Denominazione_Banca__c = ''; 
        man.Abi__c = '01000';
        man.Cab__c = '01001';
        man.ContoCorrente__c = ''; 
        man.Iban__c = '';
        man.Motivo_Diniego__c = ''; 
        man.Accettato__c = '';
        man.Stato_Mandato__c = '';
        man.Stato_Pratica__c = '';
        man.Attrib_Pratica__c = ''; 
        man.Data_Inserimento__c = Date.valueOf('2019-10-16');
        man.Data_Invio__c = null;
        man.Data_Rientro__c = null;
        man.Filiale__c = '241';
        man.Convenzionato__c = ''; 
        man.Telefono_Banca__c = '011560456';
        man.Mandato__c = 'MNDTCO000020696972D18042019H191444';
        man.Provenienza__c = '';
        man.Numero_Tentativi__c = null; 
        man.Ultimo_Contatto__c = '';
        man.Note_Banca__c = '';
        man.Azioni_Interne__c = '';
        man.Mandato_SDD_OCS__c = '';
        man.Tipo_Messaggio__c = '';
        
        insert man;

		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respVTB = new List<String>();
        List<String> respGNR = new List<String>();
        List<String> respVDP = new List<String>();
        
//        respVTB.add('{"resultCode":0,"resultMessage":"Ok","OCSVariazioneTelefonoBancaResponse":[{"as400Status":"OK","as400Errore":null}]}');
        respVTB.add('{"resultCode":0,"resultMessage":"Ok","variazioneTelefoniResponse":{"as400Status":"OK","as400Errore":null}}');
        respGNR.add('{"resultCode":0,"resultMessage":"Ok","OCSGestioneNoteResponse":[{"as400Status":"OK","as400Errore":null}]}');

        serviceIdResponseMap.put('variazioneTelefonoBanca', respVTB);
        serviceIdResponseMap.put('gestioneNote', respGNR);
        serviceIdResponseMap.put('variazioneDatiPagamento', respVDP);

        
        UtilityMockResponse UMR = new UtilityMockResponse(); 
         
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));

        Id idProfile = [SELECT Id FROM Profile WHERE Name = 'BackOffice'].Id;

        User us = new User();
        us.FirstName = 'TestNome';
        us.LastName = 'TestCognome';
        us.ProfileId = idProfile;
        us.Username = 'testFabio@test.com';
        us.Email = 'test@test.com';
        us.Alias = 'TEST';
        us.TimeZoneSidKey = 'Europe/Rome';
        us.LocaleSidKey = 'en_US';
        us.EmailEncodingKey = 'UTF-8'; 
        us.LanguageLocaleKey = 'en_US';
        us.DefaultQueueId__c = '241';
        
        insert us;

        XCS_Disposition__c dis = new XCS_Disposition__c();
        dis.Name = 'TEST';
        dis.External_Id__c = 'DP3492';
        insert dis;

        XCS_Disposition__c dis2 = new XCS_Disposition__c();
        dis2.Name = 'TEST2';
        dis2.External_Id__c = 'DP3505';
        insert dis2;

        Test.startTest();

//        System.runAs(us){
            try {
                DinieghiSDDCtrl din = new DinieghiSDDctrl();

                Map<String,List<Mandati_SDD__c>> mapMan = DinieghiSDDCtrl.getCases(us.Id, 'BackOffice',null);
                Map<String,List<Mandati_SDD__c>> mapMan2 = DinieghiSDDCtrl.getCases(us.Id, 'Branch Employee','F241');
                
                List<User> lUser = DinieghiSDDCtrl.getUserRole();

                Map<String,String> mMap = DinieghiSDDCtrl.getUserMap();

                List<ContentNote> lConN = DinieghiSDDCtrl.getNotes(caso.Id);
                
                List<Account> lAcc = DinieghiSDDCtrl.getAccounts(man.Id);
                
                //String lcon = DinieghiSDDCtrl.getContacts(man.Id);
                
                //Boolean bRia = DinieghiSDDCtrl.getRiassegna(man.Id, us.Id);
                
                List<Account> lAccF = DinieghiSDDCtrl.getFiliale('F'+ man.Filiale__c);
                
                Boolean bAggNum = DinieghiSDDCtrl.upgradeTelNumber(man.abi__c, man.cab__c, '011560457', man.Id);

                Boolean bupgMandato = DinieghiSDDCtrl.upgradeMandaTO('','variatoAbi','testnota',man.id,man.Data_Inserimento__c,'Banca','',true);            

                //List<ContentDocumentLink> cdl = DinieghiSDDCtrl.finishUploadFile('',cDoc.id,'');

                List<ContentDocumentLink> cdl = DinieghiSDDCtrl.getFile('');

                String vd = DinieghiSDDCtrl.valDisposition(dis.Id);


            } 
            catch (System.AsyncException ex) {
            }
        Test.stopTest();
    }   

// }
    private static testmethod void test2() {
        insertVarie();
        Account acc = new Account();
        acc.FirstName = 'TESTFABIO';
        acc.LastName = 'TESTGIULIANI';
        acc.Codice_Fiscale__c = 'RTUMRN89C02R800Q';
        acc.Codice_Fiscale__pc = 'RTUMRN89C02R800Q';
        acc.OCS_External_Id__c = '123456';
        insert acc;

        Id queueId = [SELECT Id FROM Group WHERE DeveloperName =:DinieghiSDDCtrl.QUEUE_DINIEGHI LIMIT 1].Id;
        Id rType = [SELECT Id FROM RecordType WHERE Name ='Dinieghi SDD Verifiche Filiale' LIMIT 1].Id;

        Case caso = new Case();
        caso.Subject = 'Diniego';
        caso.Status = 'New';
        caso.NumeroPratica__c ='2342342';
        caso.ownerId=queueId;
        caso.RecordTypeId = rType;

        insert caso;   

		Mandati_SDD__c man = new Mandati_SDD__c();        
        man.Caseid__c = caso.Id; 
        man.PraticaNum__c = '';
        man.Progressivo__c = '';
        man.ProgreMan__c = '';
        man.Codice_Cliente__c = acc.Id; 
        man.Ragione_Sociale_Cliente__c = ''; 
        man.Intestatario_cc__c = '';
        man.Ragione_Sociale_Intest_cc__c = ''; 
        man.Modalita_Pagamento__c = '';
        man.Gruppo__c = '';
        man.Denominazione_Banca__c = ''; 
        man.Abi__c = '01000';
        man.Cab__c = '01001';
        man.ContoCorrente__c = ''; 
        man.Iban__c = '';
        man.Motivo_Diniego__c = ''; 
        man.Accettato__c = '';
        man.Stato_Mandato__c = '';
        man.Stato_Pratica__c = '';
        man.Attrib_Pratica__c = ''; 
        man.Data_Inserimento__c = Date.valueOf('2019-10-16');
        man.Data_Invio__c = null;
        man.Data_Rientro__c = null;
        man.Filiale__c = '241';
        man.Convenzionato__c = ''; 
        man.Telefono_Banca__c = '011560456';
        man.Mandato__c = 'MNDTCO000020696972D18042019H191444';
        man.Provenienza__c = '';
        man.Numero_Tentativi__c = null; 
        man.Ultimo_Contatto__c = '';
        man.Note_Banca__c = '';
        man.Azioni_Interne__c = '';
        man.Mandato_SDD_OCS__c = '';
        man.Tipo_Messaggio__c = '';
        
        insert man;

		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respVTB = new List<String>();
        List<String> respGNR = new List<String>();
        List<String> respVDP = new List<String>();
        
//        respVTB.add('{"resultCode":0,"resultMessage":"Ok","OCSVariazioneTelefonoBancaResponse":[{"as400Status":"OK","as400Errore":null}]}');
        respVTB.add('{"resultCode":0,"resultMessage":"Ok","OCSVariazioneTelefonoBancaResponse.VariazioneTelefonoBancaResponseDTO":[{"as400Status":"OK","as400Errore":null}]}');
        respGNR.add('{"resultCode":0,"resultMessage":"Ok","OCSGestioneNoteResponse":[{"as400Status":"OK","as400Errore":null}]}');
        respVDP.add('{"resultCode":0,"resultMessage":"Ok","variazioneDatiPagamentoResponse":{"AS400Status":"OK","AS400Errore":null}}');

        serviceIdResponseMap.put('variazioneTelefonoBanca', respVTB);
        serviceIdResponseMap.put('gestioneNote', respGNR);
        serviceIdResponseMap.put('variazioneDatiPagamento', respVDP);

        
        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));

        Id idProfile = [SELECT Id FROM Profile WHERE Name = 'BackOffice'].Id;

        User us = new User();
        us.FirstName = 'TestNome';
        us.LastName = 'TestCognome';
        us.ProfileId = idProfile;
        us.Username = 'testFabio@test.com';
        us.Email = 'test@test.com';
        us.Alias = 'TEST';
        us.TimeZoneSidKey = 'Europe/Rome';
        us.LocaleSidKey = 'en_US';
        us.EmailEncodingKey = 'UTF-8'; 
        us.LanguageLocaleKey = 'en_US';
        us.DefaultQueueId__c = '241';
        
        insert us;

        XCS_Disposition__c dis = new XCS_Disposition__c();
        dis.Name = 'TEST';
        dis.External_Id__c = 'DP3492';
        insert dis;

        XCS_Disposition__c dis2 = new XCS_Disposition__c();
        dis2.Name = 'TEST2';
        dis2.External_Id__c = 'DP3505';
        insert dis2;

        Test.startTest();

//        System.runAs(us){
            try {
                
                Boolean bupgMandato2 = DinieghiSDDCtrl.upgradeMandaTO('','chiuVarBP','testnota',man.id,man.Data_Inserimento__c,'Banca','',true);            

            } 
            catch (System.AsyncException ex) {
            }

//        }

        Test.stopTest();

    }   

    private static testmethod void test3() {
        insertVarie();
        Account acc = new Account();
        acc.FirstName = 'TESTFABIO';
        acc.LastName = 'TESTGIULIANI';
        acc.Codice_Fiscale__c = 'RTUMRN89C02R800Q';
        acc.Codice_Fiscale__pc = 'RTUMRN89C02R800Q';
        acc.OCS_External_Id__c = '123456';
        insert acc;

        Id queueId = [SELECT Id FROM Group WHERE DeveloperName =:DinieghiSDDCtrl.QUEUE_DINIEGHI LIMIT 1].Id;
        Id rType = [SELECT Id FROM RecordType WHERE Name ='Dinieghi SDD Verifiche Filiale' LIMIT 1].Id;

        Case caso = new Case();
        caso.Subject = 'Diniego';
        caso.Status = 'New';
        caso.NumeroPratica__c ='2342342';
        caso.ownerId=queueId;
        caso.RecordTypeId = rType;

        insert caso;   

		Mandati_SDD__c man = new Mandati_SDD__c();        
        man.Caseid__c = caso.Id; 
        man.PraticaNum__c = '';
        man.Progressivo__c = '';
        man.ProgreMan__c = '';
        man.Codice_Cliente__c = acc.Id; 
        man.Ragione_Sociale_Cliente__c = ''; 
        man.Intestatario_cc__c = '';
        man.Ragione_Sociale_Intest_cc__c = ''; 
        man.Modalita_Pagamento__c = '';
        man.Gruppo__c = '';
        man.Denominazione_Banca__c = ''; 
        man.Abi__c = '01000';
        man.Cab__c = '01001';
        man.ContoCorrente__c = ''; 
        man.Iban__c = '';
        man.Motivo_Diniego__c = ''; 
        man.Accettato__c = '';
        man.Stato_Mandato__c = '';
        man.Stato_Pratica__c = '';
        man.Attrib_Pratica__c = ''; 
        man.Data_Inserimento__c = Date.valueOf('2019-10-16');
        man.Data_Invio__c = null;
        man.Data_Rientro__c = null;
        man.Filiale__c = '241';
        man.Convenzionato__c = ''; 
        man.Telefono_Banca__c = '011560456';
        man.Mandato__c = 'MNDTCO000020696972D18042019H191444';
        man.Provenienza__c = '';
        man.Numero_Tentativi__c = null; 
        man.Ultimo_Contatto__c = '';
        man.Note_Banca__c = '';
        man.Azioni_Interne__c = '';
        man.Mandato_SDD_OCS__c = '';
        man.Tipo_Messaggio__c = '';
        
        insert man;

		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respVTB = new List<String>();
        List<String> respGNR = new List<String>();
        List<String> respVDP = new List<String>();
        
//        respVTB.add('{"resultCode":0,"resultMessage":"Ok","OCSVariazioneTelefonoBancaResponse":[{"as400Status":"OK","as400Errore":null}]}');
        respVTB.add('{"resultCode":0,"resultMessage":"Ok","OCSVariazioneTelefonoBancaResponse.VariazioneTelefonoBancaResponseDTO":[{"as400Status":"OK","as400Errore":null}]}');
        respGNR.add('{"resultCode":0,"resultMessage":"Ok","OCSGestioneNoteResponse":[{"as400Status":"OK","as400Errore":null}]}');
        respVDP.add('{"resultCode":0,"resultMessage":"Ok","variazioneDatiPagamentoResponse":{"AS400Status":"OK","AS400Errore":null}}');

        serviceIdResponseMap.put('variazioneTelefonoBanca', respVTB);
        serviceIdResponseMap.put('gestioneNote', respGNR);
        serviceIdResponseMap.put('variazioneDatiPagamento', respVDP);

        
        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));

        Id idProfile = [SELECT Id FROM Profile WHERE Name = 'BackOffice'].Id;

        User us = new User();
        us.FirstName = 'TestNome';
        us.LastName = 'TestCognome';
        us.ProfileId = idProfile;
        us.Username = 'testFabio@test.com';
        us.Email = 'test@test.com';
        us.Alias = 'TEST';
        us.TimeZoneSidKey = 'Europe/Rome';
        us.LocaleSidKey = 'en_US';
        us.EmailEncodingKey = 'UTF-8'; 
        us.LanguageLocaleKey = 'en_US';
        us.DefaultQueueId__c = '241';
        
        insert us;

        XCS_Disposition__c dis = new XCS_Disposition__c();
        dis.Name = 'TEST';
        dis.External_Id__c = 'DP3491';
        insert dis;

        Test.startTest();

//        System.runAs(us){
            try {
                
                Boolean bupgMandato2 = DinieghiSDDCtrl.upgradeMandaTO('','risolto','testnota',man.id,man.Data_Inserimento__c,'Banca','',false);

            } 
            catch (System.AsyncException ex) {
            }

//        }

        Test.stopTest();

    }   

    private static testmethod void test4() {
        insertVarie();
        Account acc = new Account();
        acc.FirstName = 'TESTFABIO';
        acc.LastName = 'TESTGIULIANI';
        acc.Codice_Fiscale__c = 'RTUMRN89C02R800Q';
        acc.Codice_Fiscale__pc = 'RTUMRN89C02R800Q';
        acc.OCS_External_Id__c = '123456';
        insert acc;

        Id queueId = [SELECT Id FROM Group WHERE DeveloperName =:DinieghiSDDCtrl.QUEUE_DINIEGHI LIMIT 1].Id;
        Id rType = [SELECT Id FROM RecordType WHERE Name ='Dinieghi SDD Verifiche Filiale' LIMIT 1].Id;

        Case caso = new Case();
        caso.Subject = 'Diniego';
        caso.Status = 'New';
        caso.NumeroPratica__c ='2342342';
        caso.ownerId=queueId;
        caso.RecordTypeId = rType;

        insert caso;   

		Mandati_SDD__c man = new Mandati_SDD__c();        
        man.Caseid__c = caso.Id; 
        man.PraticaNum__c = '';
        man.Progressivo__c = '';
        man.ProgreMan__c = '';
        man.Codice_Cliente__c = acc.Id; 
        man.Ragione_Sociale_Cliente__c = ''; 
        man.Intestatario_cc__c = '';
        man.Ragione_Sociale_Intest_cc__c = ''; 
        man.Modalita_Pagamento__c = '';
        man.Gruppo__c = '';
        man.Denominazione_Banca__c = ''; 
        man.Abi__c = '01000';
        man.Cab__c = '01001';
        man.ContoCorrente__c = ''; 
        man.Iban__c = '';
        man.Motivo_Diniego__c = ''; 
        man.Accettato__c = '';
        man.Stato_Mandato__c = '';
        man.Stato_Pratica__c = '';
        man.Attrib_Pratica__c = ''; 
        man.Data_Inserimento__c = Date.valueOf('2019-10-16');
        man.Data_Invio__c = null;
        man.Data_Rientro__c = null;
        man.Filiale__c = '241';
        man.Convenzionato__c = ''; 
        man.Telefono_Banca__c = '011560456';
        man.Mandato__c = 'MNDTCO000020696972D18042019H191444';
        man.Provenienza__c = '';
        man.Numero_Tentativi__c = null; 
        man.Ultimo_Contatto__c = '';
        man.Note_Banca__c = '';
        man.Azioni_Interne__c = '';
        man.Mandato_SDD_OCS__c = '';
        man.Tipo_Messaggio__c = '';
        
        insert man;

		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respVTB = new List<String>();
        List<String> respGNR = new List<String>();
        List<String> respVDP = new List<String>();
        
//        respVTB.add('{"resultCode":0,"resultMessage":"Ok","OCSVariazioneTelefonoBancaResponse":[{"as400Status":"OK","as400Errore":null}]}');
        respVTB.add('{"resultCode":0,"resultMessage":"Ok","OCSVariazioneTelefonoBancaResponse.VariazioneTelefonoBancaResponseDTO":[{"as400Status":"OK","as400Errore":null}]}');
        respGNR.add('{"resultCode":0,"resultMessage":"Ok","OCSGestioneNoteResponse":[{"as400Status":"OK","as400Errore":null}]}');
        respVDP.add('{"resultCode":0,"resultMessage":"Ok","variazioneDatiPagamentoResponse":{"AS400Status":"OK","AS400Errore":null}}');

        serviceIdResponseMap.put('variazioneTelefonoBanca', respVTB);
        serviceIdResponseMap.put('gestioneNote', respGNR);
        serviceIdResponseMap.put('variazioneDatiPagamento', respVDP);

        
        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));

        Id idProfile = [SELECT Id FROM Profile WHERE Name = 'BackOffice'].Id;

        User us = new User();
        us.FirstName = 'TestNome';
        us.LastName = 'TestCognome';
        us.ProfileId = idProfile;
        us.Username = 'testFabio@test.com';
        us.Email = 'test@test.com';
        us.Alias = 'TEST';
        us.TimeZoneSidKey = 'Europe/Rome';
        us.LocaleSidKey = 'en_US';
        us.EmailEncodingKey = 'UTF-8'; 
        us.LanguageLocaleKey = 'en_US';
        us.DefaultQueueId__c = '241';
        
        insert us;

        XCS_Disposition__c dis = new XCS_Disposition__c();
        dis.Name = 'TEST';
        dis.External_Id__c = 'DP3502';
        insert dis;

        Test.startTest();

//        System.runAs(us){
            try {
                
                Boolean bupgMandato2 = DinieghiSDDCtrl.upgradeMandaTO('','nonRisolto','testnota',man.id,man.Data_Inserimento__c,'Banca','',false);

            } 
            catch (System.AsyncException ex) {
            }

//        }

        Test.stopTest();

    }   





}