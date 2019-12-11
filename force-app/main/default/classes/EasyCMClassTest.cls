@isTest
public class EasyCMClassTest {

    @TestSetup
    static void setup(){   
        if(([SELECT Id FROM User WHERE DefaultQueueId__c = 'F00-TEST']).size()==0){
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User utenteMaster = new User(
                FirstName= 'Test',
                LastName= 'Test',
                Username= 'test@compass.com.test',
                Email= 'test@lynxspa.com',
                Alias= 'test',
                TimeZoneSidKey= 'Europe/Rome',
                LocaleSidKey= 'it_IT',
                EmailEncodingKey= 'ISO-8859-1',
                ProfileId= p.Id,
                LanguageLocaleKey= 'en_US',
                DefaultQueueId__c= 'F00-TEST'
            );
            insert utenteMaster;
        } 
        if(([SELECT Id FROM Account WHERE OCS_External_Id__c = 'C000']).size()==0){
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();
            Account theAccount= new Account(
                LastName = 'test',
				OCS_External_id__c = 'C000',
				FirstName = 'test',
				Data_Nascita__c = Date.today(),
				Luogo_Nascita__pc = 'test',
				Provincia_Nascita__pc = 'test',
				Sesso__pc = 'M',
				Codice_Fiscale__pc = 'tsttst',
				Partita_IVA__pc = 'test',
				PersonMailingStreet = 'test',
				PersonMailingPostalCode = '00010',
				PersonMailingCity = 'test',
				PersonMailingCountry = 'test',
				PersonEmail = 'test@test.com',
				Data_Rilascio__pc = Date.today(),
				Data_Scadenza__pc = Date.today(),
				Telefono_Casa__c = '001234500',
				Telefono_Cellulare__c = '3300123',
				Fax = '3300123',
				Ma_Opt_In__pc = true,
				Privacy_SMS__pc = true,
				Data_Depennamento__c = Date.today(),
				InvestFlag__pc = true,
				Qualitydetectionflag__pc = true,
				Interncommoffer__pc = true,
				Privacy_Profilazione__pc = true,
				Extcommoffer__pc = true,
				OtherService__pc = true,
            	RecordTypeId = recordTypeId);
            insert theAccount;
        }
        if(([SELECT Id FROM Case]).size()==0){
            Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Inbound_Call').getRecordTypeId();
            Account acc = [SELECT Id FROM Account WHERE FirstName = 'test'];
            Case theCase= new Case(
                RecordTypeId = recordTypeId
            );
            theCase.AccountId = acc.Id;
            
            Case theCase2 = new Case(
                Subject = 'IO',
                Esito__c = 'TEST',
                Description = '{"ocsCode" : "229370","telephoneNumber" : "334 3355026","esitoSurvey" : "ok"}',
                RecordTypeId = recordTypeId
            );

            Case theCase3 = new Case(
                Subject = 'TESTEMPTY',
                Esito__c = 'TESTEMPTY',
                Description = '',
                RecordTypeId = recordTypeId
            );
            Case theCase4 = new Case(
                Subject = 'TESTNOTVALIDJSON',
                Esito__c = 'TESTNOTVALIDJSON',
                Description = 'notValidJson',
                RecordTypeId = recordTypeId
            );
            Case theCase5 = new Case(
                Subject = 'EMPTYCODE',
                Esito__c = 'EMPTYCODE',
                Description = '{"ocsCode" : "","telephoneNumber" : "334 3355026","esitoSurvey" : "ok"}',
                RecordTypeId = recordTypeId
            );
            insert new List<Case>{theCase,theCase2,theCase3,theCase4,theCase5};
        }
        if(([SELECT Id FROM Account_Retention__c]).size()==0){
            Account acc = [SELECT Id FROM Account WHERE FirstName = 'test'];
            Account_Retention__c accRet= new Account_Retention__c(
                Esito__c = 'YES',
            	Customer__c = acc.Id);
            insert accRet;
        }
    }
    
    @isTest static void initApexTest() {
        User u = [SELECT Id FROM User WHERE LastName = 'Test'];
        EasyCMClass.InitWrapper Wr;
        String response1 = '{"resultCode":0,"resultMessage":"Ok","status":"Ok","pratiche":[{"numPratica":"800000329783","codCliente":"000"}],"cliente":[{"cognome":"UTMOBZE","codCliente":"000","nome":"LERRIO","dataNascita":"19901010"}]}';
        String response2 = '{"resultCode":0,"resultMessage":"Ok","recuperaRetentionCarteResponse":{"elencoCarte":[{"numCarta":"1100003236","statoCarta":"50","bloccoCarta":"","prodottoCarta":"13","esitoRetention":"OK","valoreRetention":"Basso","prodottoAttribuito":"LE_tan"}]}}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response1 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.schedaCliente',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/schedaCliente');      
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaRetentionCarte',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaRetentionCarte');      
        insert new List<ApiRest__c>{test1,test2};
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.schedaCliente','ocs.recuperaRetentionCarte'});
        Test.setMock(HttpCalloutMock.class,UMR);
        
        Test.startTest();
		System.runAs(u) {
           	Case theCase = [SELECT Id FROM Case WHERE Subject = 'IO'];
            Wr = EasyCMClass.initApex(theCase.Id);
		}
		Test.stopTest();
        System.assertEquals('C000',Wr.account.OCS_External_id__c);
        System.assertEquals(Date.today(),Wr.storicoChiamate.ultimaChiamata); 
        System.assertEquals(9,Wr.privacyList.size()); 
        System.assertEquals('000',Wr.datiCliente.codCliente); 
        System.assertEquals(1,Wr.praticheList.size()); 
        System.assertEquals('800000329783',Wr.praticheList[0].numPratica); 
        System.assertEquals('YES',Wr.datiCommerciali.retention);   
        System.assertEquals('OK',Wr.datiCommerciali.retentionCarte);
        System.assertEquals(Date.newInstance(1990,10,10),Wr.Account.Data_Nascita__c);
	}

    @isTest static void initApexEmptyClienteTest() {
        User u = [SELECT Id FROM User WHERE LastName = 'Test'];
        EasyCMClass.InitWrapper Wr;
        String response1 = '{"resultCode":0,"resultMessage":"Ok","status":"Ok","pratiche":[{"numPratica":"800000329783","codCliente":"000"}],"cliente":[]}';
        String response2 = '{"resultCode":0,"resultMessage":"Ok","recuperaRetentionCarteResponse":{"elencoCarte":[{"numCarta":"1100003236","statoCarta":"50","bloccoCarta":"","prodottoCarta":"13","esitoRetention":"OK","valoreRetention":"Basso","prodottoAttribuito":"LE_tan"}]}}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response1 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.schedaCliente',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/schedaCliente');      
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaRetentionCarte',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaRetentionCarte');      
        insert new List<ApiRest__c>{test1,test2};
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.schedaCliente','ocs.recuperaRetentionCarte'});
        Test.setMock(HttpCalloutMock.class,UMR);
        
        Test.startTest();
		System.runAs(u) {
           	Case theCase = [SELECT Id FROM Case WHERE Subject = 'IO'];
            Wr = EasyCMClass.initApex(theCase.Id);
		}
		Test.stopTest();
        /*System.assertEquals(Date.today(),Wr.storicoChiamate.ultimaChiamata); 
        System.assertEquals(9,Wr.privacyList.size()); 
        System.assertEquals('000',Wr.datiCliente.codCliente); 
        System.assertEquals(1,Wr.praticheList.size()); 
        System.assertEquals('800000329783',Wr.praticheList[0].numPratica); 
        System.assertEquals('YES',Wr.datiCommerciali.retention);   
        System.assertEquals('OK',Wr.datiCommerciali.retentionCarte);*/
        System.assertEquals('334 3355026', Wr.telephoneNumber);
	}

        @isTest static void initApexEmptyMessageTest() {
        User u = [SELECT Id FROM User WHERE LastName = 'Test'];
        EasyCMClass.InitWrapper Wr;
        String response1 = '{"resultCode":0,"resultMessage":"Ok","status":"Ok","pratiche":[{"numPratica":"800000329783","codCliente":"000"}],"cliente":[]}';
        String response2 = '{"resultCode":0,"resultMessage":"Ok","recuperaRetentionCarteResponse":{"elencoCarte":[{"numCarta":"1100003236","statoCarta":"50","bloccoCarta":"","prodottoCarta":"13","esitoRetention":"OK","valoreRetention":"Basso","prodottoAttribuito":"LE_tan"}]}}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response1 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.schedaCliente',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/schedaCliente');      
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaRetentionCarte',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaRetentionCarte');      
        insert new List<ApiRest__c>{test1,test2};
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.schedaCliente','ocs.recuperaRetentionCarte'});
        Test.setMock(HttpCalloutMock.class,UMR);
        
        Test.startTest();
        String error;
		System.runAs(u) {
           	Case theCase = [SELECT Id, Description FROM Case WHERE Subject = 'TESTEMPTY'];
            try {
                Wr = EasyCMClass.initApex(theCase.Id);
            } catch (Exception e) {
                
                error=e.getMessage();
            }
		}
		Test.stopTest();
        System.assertEquals('campo di input non valorizzato', error);
	}

    @isTest static void initApexNotValidJsonMessageTest() {
        User u = [SELECT Id FROM User WHERE LastName = 'Test'];
        EasyCMClass.InitWrapper Wr;
        String response1 = '{"resultCode":0,"resultMessage":"Ok","status":"Ok","pratiche":[{"numPratica":"800000329783","codCliente":"000"}],"cliente":[]}';
        String response2 = '{"resultCode":0,"resultMessage":"Ok","recuperaRetentionCarteResponse":{"elencoCarte":[{"numCarta":"1100003236","statoCarta":"50","bloccoCarta":"","prodottoCarta":"13","esitoRetention":"OK","valoreRetention":"Basso","prodottoAttribuito":"LE_tan"}]}}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response1 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.schedaCliente',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/schedaCliente');      
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaRetentionCarte',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaRetentionCarte');      
        insert new List<ApiRest__c>{test1,test2};
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.schedaCliente','ocs.recuperaRetentionCarte'});
        Test.setMock(HttpCalloutMock.class,UMR);
        
        Test.startTest();
        String error;
		System.runAs(u) {
           	Case theCase = [SELECT Id, Description FROM Case WHERE Subject = 'TESTNOTVALIDJSON'];
            try {
                Wr = EasyCMClass.initApex(theCase.Id);
            } catch (Exception e) {
                error=e.getMessage();
            }
		}
		Test.stopTest();
        System.assertEquals('campo di input non valido', error);
	}
    
    @isTest static void initApexTelephoneTest() {
        User u = [SELECT Id FROM User WHERE LastName = 'Test'];
        EasyCMClass.InitWrapper Wr;
        Account theAccount;
        String response1 = '{"resultCode":0,"resultMessage":"Ok","status":"Ok","pratiche":[{"numPratica":"800000329783","codCliente":"000"}]}';
        String response2 = '{"resultCode":0,"resultMessage":"Ok","recuperaRetentionCarteResponse":{"elencoCarte":[{"numCarta":"1100003236","statoCarta":"50","bloccoCarta":"","prodottoCarta":"13","esitoRetention":"OK","valoreRetention":"Basso","prodottoAttribuito":"LE_tan"}]}}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response1 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.schedaCliente',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/schedaCliente');      
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaRetentionCarte',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaRetentionCarte');      
        insert new List<ApiRest__c>{test1,test2};
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.schedaCliente','ocs.recuperaRetentionCarte'});
        Test.setMock(HttpCalloutMock.class,UMR);
        
        Test.startTest();
		System.runAs(u) {
            theAccount = [SELECT Id,Name,Denominazione_Azienda__c,Forma_Giuridica__c,Tipo_Anagrafica__pc,Tipo_Rapporto__c,Luogo_Rilascio__pc,Provincia_Rilascio__pc,Tipo_Documento__pc,Ufficio_Rilascio__c,Numero_Documento__pc,LastName,OCS_External_id__c,FirstName,Data_Nascita__c,Luogo_Nascita__pc,Provincia_Nascita__pc,Sesso__pc,Codice_Fiscale__pc,Partita_IVA__pc,PersonMailingStreet,PersonMailingPostalCode,PersonMailingCity,PersonMailingCountry,PersonEmail,Data_Rilascio__pc,Data_Scadenza__pc,Telefono_Casa__c,Telefono_Cellulare__c,Fax,Ma_Opt_In__pc,Privacy_SMS__pc,Data_Depennamento__c,InvestFlag__pc,Qualitydetectionflag__pc,Interncommoffer__pc,Privacy_Profilazione__pc,Extcommoffer__pc,OtherService__pc FROM Account WHERE OCS_External_id__c = 'C000'];
            theAccount.OCS_External_Id__c = '';
           	Case theCase = [SELECT Id FROM Case WHERE Subject = 'EMPTYCODE'];
            Wr = EasyCMClass.initApex(theCase.Id);
		}
		Test.stopTest();
        System.assertEquals('334 3355026',Wr.telephoneNumber);
	}
    
    @isTest static void initFromAccountTest() {
        User u = [SELECT Id FROM User WHERE LastName = 'Test'];
        EasyCMClass.InitWrapper Wr;
        Account theAccount;
        String response1 = '{"resultCode":0,"resultMessage":"Ok","status":"Ok","pratiche":[{"numPratica":"800000329783","codCliente":"000"}],"cliente":[{"cognome":"UTMOBZE","codCliente":"000","nome":"LERRIO"}]}';
        String response2 = '{"resultCode":0,"resultMessage":"Ok","recuperaRetentionCarteResponse":{"elencoCarte":[{"numCarta":"1100003236","statoCarta":"50","bloccoCarta":"","prodottoCarta":"13","esitoRetention":"OK","valoreRetention":"Basso","prodottoAttribuito":"LE_tan"}]}}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response1 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.schedaCliente',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/schedaCliente');      
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaRetentionCarte',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaRetentionCarte');      
        insert new List<ApiRest__c>{test1,test2};
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.schedaCliente','ocs.recuperaRetentionCarte'});
        Test.setMock(HttpCalloutMock.class,UMR);
        
        Test.startTest();
		System.runAs(u) {
           	theAccount = [SELECT Id,Name,Denominazione_Azienda__c,Forma_Giuridica__c,Tipo_Anagrafica__pc,Tipo_Rapporto__c,Luogo_Rilascio__pc,Provincia_Rilascio__pc,Tipo_Documento__pc,Ufficio_Rilascio__c,Numero_Documento__pc,LastName,OCS_External_id__c,FirstName,Data_Nascita__c,Luogo_Nascita__pc,Provincia_Nascita__pc,Sesso__pc,Codice_Fiscale__pc,Partita_IVA__pc,PersonMailingStreet,PersonMailingPostalCode,PersonMailingCity,PersonMailingCountry,PersonEmail,Data_Rilascio__pc,Data_Scadenza__pc,Telefono_Casa__c,Telefono_Cellulare__c,Fax,Ma_Opt_In__pc,Privacy_SMS__pc,Data_Depennamento__c,InvestFlag__pc,Qualitydetectionflag__pc,Interncommoffer__pc,Privacy_Profilazione__pc,Extcommoffer__pc,OtherService__pc FROM Account WHERE OCS_External_id__c = 'C000'];
            Case theCase = [SELECT Id FROM Case WHERE Subject = 'IO'];
            Wr = EasyCMClass.initFromAccount(theCase.Id,theAccount);
		}
		Test.stopTest();
        System.assertEquals('C000',Wr.account.OCS_External_id__c);
        System.assertEquals(Date.today(),Wr.storicoChiamate.ultimaChiamata); 
        System.assertEquals(9,Wr.privacyList.size()); 
        System.assertEquals('000',Wr.datiCliente.codCliente); 
        System.assertEquals(1,Wr.praticheList.size()); 
        System.assertEquals('800000329783',Wr.praticheList[0].numPratica); 
        System.assertEquals('YES',Wr.datiCommerciali.retention);   
        System.assertEquals('OK',Wr.datiCommerciali.retentionCarte);
	}
    
    @isTest static void initFromAccountTestOCSblank() {
        User u = [SELECT Id FROM User WHERE LastName = 'Test'];
        EasyCMClass.InitWrapper Wr;
        Account theAccount;
        String response1 = '{"resultCode":0,"resultMessage":"Ok","status":"Ok","pratiche":[{"numPratica":"800000329783","codCliente":"000"}],"cliente":[{"cognome":"UTMOBZE","codCliente":"000","nome":"LERRIO"}]}';
        String response2 = '{"resultCode":0,"resultMessage":"Ok","recuperaRetentionCarteResponse":{"elencoCarte":[{"numCarta":"1100003236","statoCarta":"50","bloccoCarta":"","prodottoCarta":"13","esitoRetention":"OK","valoreRetention":"Basso","prodottoAttribuito":"LE_tan"}]}}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response1 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.schedaCliente',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/schedaCliente');      
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaRetentionCarte',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaRetentionCarte');      
        insert new List<ApiRest__c>{test1,test2};
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.schedaCliente','ocs.recuperaRetentionCarte'});
        Test.setMock(HttpCalloutMock.class,UMR);
        
        Test.startTest();
		System.runAs(u) {
           	theAccount = [SELECT Id,Name,Denominazione_Azienda__c,Forma_Giuridica__c,Tipo_Anagrafica__pc,Tipo_Rapporto__c,Luogo_Rilascio__pc,Provincia_Rilascio__pc,Tipo_Documento__pc,Ufficio_Rilascio__c,Numero_Documento__pc,LastName,OCS_External_id__c,FirstName,Data_Nascita__c,Luogo_Nascita__pc,Provincia_Nascita__pc,Sesso__pc,Codice_Fiscale__pc,Partita_IVA__pc,PersonMailingStreet,PersonMailingPostalCode,PersonMailingCity,PersonMailingCountry,PersonEmail,Data_Rilascio__pc,Data_Scadenza__pc,Telefono_Casa__c,Telefono_Cellulare__c,Fax,Ma_Opt_In__pc,Privacy_SMS__pc,Data_Depennamento__c,InvestFlag__pc,Qualitydetectionflag__pc,Interncommoffer__pc,Privacy_Profilazione__pc,Extcommoffer__pc,OtherService__pc FROM Account WHERE OCS_External_id__c = 'C000'];
            theAccount.OCS_External_Id__c = '';
            Case theCase = [SELECT Id FROM Case WHERE Subject = 'IO'];
            Wr = EasyCMClass.initFromAccount(theCase.Id,theAccount);
		}
		Test.stopTest();
        System.assertEquals('',Wr.account.OCS_External_id__c);
        System.assertEquals(Date.today(),Wr.storicoChiamate.ultimaChiamata); 
        System.assertEquals(9,Wr.privacyList.size()); 
        System.assertEquals('',Wr.datiCliente.codCliente); 
        System.assertEquals(null,Wr.praticheList); 
        System.assertEquals(null,Wr.datiCommerciali);
	}
    
    @isTest static void initFromAccountTestStatusError() {
        User u = [SELECT Id FROM User WHERE LastName = 'Test'];
        EasyCMClass.InitWrapper Wr;
        Account theAccount;
        String response1 = '{"resultCode":0,"resultMessage":"Ok","status":"Ok","pratiche":[{"numPratica":"800000329783","codCliente":"000"}],"cliente":[{"cognome":"UTMOBZE","codCliente":"000","nome":"LERRIO"}]}';
        String response2 = '{"resultCode":0,"resultMessage":"Ok","recuperaRetentionCarteResponse":{"elencoCarte":[{"numCarta":"1100003236","statoCarta":"50","bloccoCarta":"","prodottoCarta":"13","esitoRetention":"OK","valoreRetention":"Basso","prodottoAttribuito":"LE_tan"}]}}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response1 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.schedaCliente',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/schedaCliente');      
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaRetentionCarte',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaRetentionCarte');      
        insert new List<ApiRest__c>{test1,test2};
        Map<String,Integer> myMap = new Map<String,Integer>();
        myMap.put('ocs.schedaCliente',500);
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.schedaCliente','ocs.recuperaRetentionCarte'},myMap);
        Test.setMock(HttpCalloutMock.class,UMR);
        
        Test.startTest();
		System.runAs(u) {
           	theAccount = [SELECT Id,Name,Denominazione_Azienda__c,Forma_Giuridica__c,Tipo_Anagrafica__pc,Tipo_Rapporto__c,Luogo_Rilascio__pc,Provincia_Rilascio__pc,Tipo_Documento__pc,Ufficio_Rilascio__c,Numero_Documento__pc,LastName,OCS_External_id__c,FirstName,Data_Nascita__c,Luogo_Nascita__pc,Provincia_Nascita__pc,Sesso__pc,Codice_Fiscale__pc,Partita_IVA__pc,PersonMailingStreet,PersonMailingPostalCode,PersonMailingCity,PersonMailingCountry,PersonEmail,Data_Rilascio__pc,Data_Scadenza__pc,Telefono_Casa__c,Telefono_Cellulare__c,Fax,Ma_Opt_In__pc,Privacy_SMS__pc,Data_Depennamento__c,InvestFlag__pc,Qualitydetectionflag__pc,Interncommoffer__pc,Privacy_Profilazione__pc,Extcommoffer__pc,OtherService__pc FROM Account WHERE OCS_External_id__c = 'C000'];
            Case theCase = [SELECT Id FROM Case WHERE Subject = 'IO'];
            Wr = EasyCMClass.initFromAccount(theCase.Id,theAccount);
		}
		Test.stopTest();
        System.assertEquals('C000',Wr.account.OCS_External_id__c);
        System.assertEquals(Date.today(),Wr.storicoChiamate.ultimaChiamata); 
        System.assertEquals(9,Wr.privacyList.size()); 
        System.assertEquals('',Wr.datiCliente.codCliente); 
        System.assertEquals(null,Wr.praticheList); 
        System.assertEquals(null,Wr.datiCommerciali);
	}
    
     @isTest static void updateAccountEmailTest() {
        User u = [SELECT Id FROM User WHERE LastName = 'Test'];
        Account theAccount;
       	
       	Test.startTest();
		System.runAs(u) {
           	theAccount = [SELECT Id,Denominazione_Azienda__c,Forma_Giuridica__c,Tipo_Anagrafica__pc,Tipo_Rapporto__c,Luogo_Rilascio__pc,Provincia_Rilascio__pc,Tipo_Documento__pc,Ufficio_Rilascio__c,Numero_Documento__pc,LastName,OCS_External_id__c,FirstName,Data_Nascita__c,Luogo_Nascita__pc,Provincia_Nascita__pc,Sesso__pc,Codice_Fiscale__pc,Partita_IVA__pc,PersonMailingStreet,PersonMailingPostalCode,PersonMailingCity,PersonMailingCountry,PersonEmail,Data_Rilascio__pc,Data_Scadenza__pc,Telefono_Casa__c,Telefono_Cellulare__c,Fax,Ma_Opt_In__pc,Privacy_SMS__pc,Data_Depennamento__c,InvestFlag__pc,Qualitydetectionflag__pc,Interncommoffer__pc,Privacy_Profilazione__pc,Extcommoffer__pc,OtherService__pc FROM Account WHERE OCS_External_id__c = 'C000'];
        	EasyCMClass.updateAccountEmail(theAccount,'newmail@it.it');   
		}
		Test.stopTest();
        Account newMail = [SELECT PersonEmail FROM Account WHERE OCS_External_id__c = 'C000'];
        System.assertEquals('newmail@it.it',newMail.PersonEmail);
        
	}
    
    @isTest static void getFidoWrapperTest() {
        User u = [SELECT Id FROM User WHERE LastName = 'Test'];
        VerificaFidoUtilClass.CheckFidoWrapper FidoWr;
       	OCSSchedaClienteResponse.PSVDatiPraticaDTO thePratica = new OCSSchedaClienteResponse.PSVDatiPraticaDTO();  
        thePratica.numPratica='800000329783';
        thePratica.codCliente='000';
        
        String response1 = '{"resultCode":0,"resultMessage":"Ok","datiCartaDatiFinanziariResponse":{"numeroPratica":"800000329783","filiale":"","emettitore":"1","dispTotale":"500000", "fidoTotale":"0","as400Status":"OK"}}';
		String response2 = '{"resultCode":0,"resultMessage":"Ok","recuperaDelinquencyResponse":{"currentDelinquencyCliente":"0","maxDelinquencyCliente":"0","elencoPratiche":[{"tipoPratica":"CA","numPratica":"800000329783","currentDelinquency":"0","maxDelinquency":"0"}]}}';
        String response3 = '{"resultCode":0,"resultMessage":"Ok","recuperaFasciaTassoCrifResponse":{"codFasciaTasso":"P","as400Errore":"","as400Status":"OK"}}';
        String response4 = '{"resultCode":0,"resultMessage":"Ok","recuperaSaldoClienteResponse":{"elencoPratiche":[{"numPratica":"800000329783","tipoPratica":"CA","saldo":"50000","stato":"70","attributo":"XZ","scaduto":"1","finanziato":"500000"}]}}';

		ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response1 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.cartaDatiFinanziari',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/cartaDatiFinanziari');
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDelinquency',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaDelinquency');
        ApiRest__c test3 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response3 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaFasciaTassoCrif',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaFasciaTassoCrif');
        ApiRest__c test4 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response4 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaSaldoCliente',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/recuperaSaldoCliente');
        insert new List<ApiRest__c>{test1,test2,test3,test4};
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.cartaDatiFinanziari','ocs.recuperaDelinquency','ocs.recuperaFasciaTassoCrif','ocs.recuperaSaldoCliente'});
        Test.setMock(HttpCalloutMock.class,UMR);
        
        Test.startTest();
		System.runAs(u) {
            FidoWr = EasyCMClass.getFidoWrapper(thePratica);
		}
		Test.stopTest();
        //System.assertEquals('5000.0€',FidoWr.disponibilita);
        System.assertEquals(5000.0,FidoWr.disponibilita);
	}
}