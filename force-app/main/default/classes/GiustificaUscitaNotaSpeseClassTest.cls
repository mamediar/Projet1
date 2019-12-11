@isTest
private class GiustificaUscitaNotaSpeseClassTest {
	
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

		if(([SELECT Id FROM Account WHERE OCS_External_Id__c = 'F00-TEST']).size()==0){
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Branch').getRecordTypeId();
            
            Account Venezia= new Account(
                Name= 'VENEZIA', 
                OCS_External_Id__c = 'F00-TEST',
                RecordTypeId = recordTypeId,
                Type = 'FIL',
                ShippingCity ='VENEZIA'
            );
            insert Venezia;
        }

        if(([SELECT Id FROM Zone__c WHERE Name= 'Venezia']).size()==0){
            Zone__c zona = new Zone__c(
                Name= 'Venezia'
            );
            zona.Branch__r  = new Account(OCS_External_Id__c= 'F00-TEST');
            insert zona;
        }

        if([SELECT Id FROM SFA_NotaSpese__c WHERE ManagerApprovazione__r.Alias ='test'].size()==0){
            Account theAccount=[SELECT Id FROM Account WHERE OCS_External_id__c = 'F00-TEST'];
            User utenteMaster = [SELECT Id FROM User WHERE LastName = 'Test'];
            SFA_NotaSpese__c ns=new SFA_NotaSpese__c(
                Date__c=Date.today(),
                Time__c='AM',
                Branch__c=theAccount.Id,
                Status__c='Approvata',
                User__c=utenteMaster.Id,
                Tratta__c='test',
                OraInizioUscita__c=Time.newInstance(14, 30, 2, 20),
                OraFineUscita__c=Time.newInstance(15, 30, 2, 20),
                KmInizioUscita__c=1.00,
                KmFineUscita__c=2.00,
                TargaVeicolo__c='11TEST11',
                DataApprovazione__c=Date.today(),
                Note__c='test',
                KmRifornimento__c=2.00,
                LuogoRifornimento__c='test',
                ImportoRifornimento__c=1.00,
                ManagerApprovazione__c=utenteMaster.Id
            );
            insert ns;
        }

		//dealer
		if(([SELECT Id FROM Account WHERE OCS_External_Id__c = '00DEALER']).size()==0){
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Dealer').getRecordTypeId();
            
            Account dealer = new Account(
                Name = 'Dealer', 
                OCS_External_Id__c = '00DEALER',
                RecordTypeId = recordTypeId,
				Vat_Code__c = '0000000000',
                ShippingStreet = 'dealer street',
                ShippingCity = 'DEALCITY'
            );
            insert dealer;
        }

        if(([SELECT Id FROM SFA_Slot__c]).size()==0){
            User utenteMaster = [SELECT Id FROM User WHERE LastName = 'Test'];
            Account theAccount=[SELECT Id FROM Account WHERE OCS_External_id__c = 'F00-TEST'];
            SFA_Slot__c testSlot= new SFA_Slot__c(
                Type__c = 'B',
                Status__c = 'Valido',
                Date__c = Date.today(),
                Time__c = 'AM',
                User__c = utenteMaster.Id
            );
            testSlot.Branch__c = theAccount.Id;
            insert testSlot;
        }

        if([SELECT Id FROM SFA_PianificaAttivita__c].size()==0){
            SFA_Slot__c slot=[SELECT Id FROM SFA_Slot__c where Status__c='Valido'];
            Account theAccount=[SELECT Id FROM Account WHERE OCS_External_id__c = '00DEALER'];
            SFA_NotaSpese__c ns=[SELECT Id FROM SFA_NotaSpese__c WHERE ManagerApprovazione__r.Alias ='test'];
            SFA_PianificaAttivita__c pa=new SFA_PianificaAttivita__c(
                Dealer__c=theAccount.Id,
                SFA_Nota_Spese__c=ns.Id,
                SFA_Slot__c=slot.Id
            );
            insert pa;
        }
    }	

	@isTest 
	static void initApexTest() {
		SFA_NotaSpese__c noteSpese=[SELECT Id, Branch__r.ShippingStreet, Branch__r.ShippingCity, TipoAuto__c FROM SFA_NotaSpese__c WHERE ManagerApprovazione__r.Alias ='test'];
		User utenteMaster = [SELECT Id FROM User WHERE LastName = 'Test'];
        String response = '{"resultCode":0,"resultMessage":"Ok","calcolaDistanzeResponse":{"esitoCalcolo":"OK","distanzaTotale":"47222","elencoParziali":[{"partenza":"Via Caldera","arrivo":"Piazzetta Enrico Cuccia","distanza":"8609"}]}}';
		String response1 = '{"resultCode":0,"resultMessage":"Ok","recuperaDatiUtenteZucchettiResponse":{"codFiscale":"PSCMHL79M19A662C","idCompany":"000551","idEmploy":"0001518","username":"CU1518","tipoAuto":"A","modelloAuto":"N108"}}'; 
        String response2 = '{"resultCode":0,"resultMessage":"Ok","recuperaTimbratureZucchettiResponse":{"elencoTimbrature":[{"giorno":"2017-11-06","ora":"09:25","verso":"x","ordinamento":"xx"}]}}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.calcolaDistanze',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/calcolaDistanze');      
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response1,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDatiUtenteZucchetti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/recuperaDatiUtenteZucchetti');
        ApiRest__c test3 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaTimbratureZucchetti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/recuperaTimbratureZucchetti');
        insert new List<ApiRest__c>{test1,test2,test3};
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.calcolaDistanze','ocs.recuperaDatiUtenteZucchetti','ocs.recuperaTimbratureZucchetti'});
        Test.setMock(HttpCalloutMock.class,UMR);
		GiustificaUscitaNotaSpeseClass.InitWrapper iw;
		Test.startTest();
		System.runAs(utenteMaster) {
			iw=GiustificaUscitaNotaSpeseClass.initApex(noteSpese, Date.today());
		}
		Test.stopTest();

		System.assertEquals(47.22,iw.kmPercorsi);
		System.assertEquals('PSCMHL79M19A662C',iw.datiUtenteZucchetti.codFiscale);
		System.assertEquals('xx',iw.timbratureList[0].ordinamento);
		System.assertEquals('Auto Filiale',iw.autoPicklist[0].get('label'));
		System.assertEquals('test',iw.currentUser.Alias);
		System.assertEquals(1,iw.dealerList.size());
	}

    @isTest 
	static void initApexTestExceptionDatiZucchettiTest() {
		SFA_NotaSpese__c noteSpese=[SELECT Id, Branch__r.ShippingStreet, Branch__r.ShippingCity, TipoAuto__c FROM SFA_NotaSpese__c WHERE ManagerApprovazione__r.Alias ='test'];
		User utenteMaster = [SELECT Id,Alias FROM User WHERE LastName = 'Test'];
        String response = '{"resultCode":0,"resultMessage":"Ok","calcolaDistanzeResponse":{"esitoCalcolo":"OK","distanzaTotale":"47222","elencoParziali":[{"partenza":"Via Caldera","arrivo":"Piazzetta Enrico Cuccia","distanza":"8609"}]}}';
		String response1 = '{"resultCode":0,"resultMessage":"Ok"}'; 
        String response2 = '{"resultCode":0,"resultMessage":"Ok","recuperaTimbratureZucchettiResponse":{"elencoTimbrature":[{"giorno":"2017-11-06","ora":"09:25","verso":"x","ordinamento":"xx"}]}}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.calcolaDistanze',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/calcolaDistanze');      
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response1,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDatiUtenteZucchetti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/recuperaDatiUtenteZucchetti');
        ApiRest__c test3 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaTimbratureZucchetti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/recuperaTimbratureZucchetti');
        insert new List<ApiRest__c>{test1,test2,test3};
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.calcolaDistanze','ocs.recuperaDatiUtenteZucchetti','ocs.recuperaTimbratureZucchetti'});
        Test.setMock(HttpCalloutMock.class,UMR);
        Test.startTest();
		GiustificaUscitaNotaSpeseClass.InitWrapper iw;
        String errorString;
		System.runAs(utenteMaster) {
            try{
                iw=GiustificaUscitaNotaSpeseClass.initApex(noteSpese, Date.today());
            }catch(AuraHandledException error){
                errorString = error.getMessage();  
            }
		}
		Test.stopTest();
        System.assertEquals('utente non trovato',errorString);   
	}

    @isTest 
	static void initApexTestExceptionTimbratureTest() {
		SFA_NotaSpese__c noteSpese=[SELECT Id, Branch__r.ShippingStreet, Branch__r.ShippingCity, TipoAuto__c FROM SFA_NotaSpese__c WHERE ManagerApprovazione__r.Alias ='test'];
		User utenteMaster = [SELECT Id,Alias FROM User WHERE LastName = 'Test'];
        String response = '{"resultCode":0,"resultMessage":"Ok","calcolaDistanzeResponse":{"esitoCalcolo":"OK","distanzaTotale":"47222","elencoParziali":[{"partenza":"Via Caldera","arrivo":"Piazzetta Enrico Cuccia","distanza":"8609"}]}}';
		String response1 = '{"resultCode":0,"resultMessage":"Ok","recuperaDatiUtenteZucchettiResponse":{"codFiscale":"PSCMHL79M19A662C","idCompany":"000551","idEmploy":"0001518","username":"CU1518","tipoAuto":"A","modelloAuto":"N108"}}'; 
        String response2 = '{"resultCode":0,"resultMessage":"Ok"}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.calcolaDistanze',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/calcolaDistanze');      
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response1,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDatiUtenteZucchetti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/recuperaDatiUtenteZucchetti');
        ApiRest__c test3 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaTimbratureZucchetti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/recuperaTimbratureZucchetti');
        insert new List<ApiRest__c>{test1,test2,test3};
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.calcolaDistanze','ocs.recuperaDatiUtenteZucchetti','ocs.recuperaTimbratureZucchetti'});
        Test.setMock(HttpCalloutMock.class,UMR);
        Test.startTest();
		GiustificaUscitaNotaSpeseClass.InitWrapper iw;
        String errorString;
		System.runAs(utenteMaster) {
            try{
                iw=GiustificaUscitaNotaSpeseClass.initApex(noteSpese, Date.today());
            }catch(AuraHandledException error){
                errorString = error.getMessage();  
            }
		}
		Test.stopTest();
        System.assertEquals('utente non trovato',errorString);   
	}
	
	@isTest 
	static void sendNotaSpese1Test() {
		SFA_NotaSpese__c noteSpese=[SELECT Id,Tratta__c,TargaVeicolo__c, Branch__r.ShippingStreet, Branch__r.ShippingCity, Branch__r.ShippingPostalCode, TipoAuto__c, Date__c, OraInizioUscita__c, OraFineUscita__c FROM SFA_NotaSpese__c WHERE ManagerApprovazione__r.Alias ='test'];
        noteSpese.TipoAuto__c='A';
		User utenteMaster = [SELECT Id FROM User WHERE LastName = 'Test'];
        String response = '{"resultCode":0,"resultMessage":"Ok","calcolaDistanzeResponse":{"esitoCalcolo":"OK","distanzaTotale":"47222","elencoParziali":[{"partenza":"Via Caldera","arrivo":"Piazzetta Enrico Cuccia","distanza":"8609"}]}}';
		String response1 = '{"resultCode":0,"resultMessage":"Ok","recuperaDatiUtenteZucchettiResponse":{"codFiscale":"PSCMHL79M19A662C","idCompany":"000551","idEmploy":"0001518","username":"CU1518","tipoAuto":"A","modelloAuto":"N108"}}'; 
        String response2 = '{"resultCode":0,"resultMessage":"Ok","recuperaTimbratureZucchettiResponse":{"elencoTimbrature":[{"giorno":"2017-11-06","ora":"09:25","verso":"x","ordinamento":"xx"}]}}';
        String response3 = '{"resultCode":20,"resultMessage":"Service creaNotaSpeseZucchetti is unavailable."}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.calcolaDistanze',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/calcolaDistanze');      
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response1,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDatiUtenteZucchetti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/recuperaDatiUtenteZucchetti');
        ApiRest__c test3 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaTimbratureZucchetti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/recuperaTimbratureZucchetti');
        ApiRest__c test4 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response3 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.creaNotaSpeseZucchetti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert new List<ApiRest__c>{test1,test2,test3,test4};
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.calcolaDistanze','ocs.recuperaDatiUtenteZucchetti','ocs.recuperaTimbratureZucchetti', 'ocs.creaNotaSpeseZucchetti'});
        Test.setMock(HttpCalloutMock.class,UMR);
		Test.startTest(); // viene inserito prima delle callout perchè eseguendo lo start test resetta il governor limits ed è possibile eseguire le dml per inserire le response
		GiustificaUscitaNotaSpeseClass.InitWrapper iw=GiustificaUscitaNotaSpeseClass.initApex(noteSpese, Date.today());
        String theWrapper=(String)JSON.serialize(Iw);
		String result;
		System.runAs(utenteMaster) {
			result=GiustificaUscitaNotaSpeseClass.sendNotaSpese(noteSpese,theWrapper);
		}
		Test.stopTest();
        System.assertEquals('20',result);
	}

    @isTest 
	static void sendNotaSpese2Test() {
		SFA_NotaSpese__c noteSpese=[SELECT Id,Tratta__c,TargaVeicolo__c, Branch__r.ShippingStreet, Branch__r.ShippingCity, Branch__r.ShippingPostalCode, TipoAuto__c, Date__c, OraInizioUscita__c, OraFineUscita__c FROM SFA_NotaSpese__c WHERE ManagerApprovazione__r.Alias ='test'];
        noteSpese.Branch__r.ShippingStreet='aaaa';
        noteSpese.TipoAuto__c='P';
		User utenteMaster = [SELECT Id FROM User WHERE LastName = 'Test'];
        String response = '{"resultCode":0,"resultMessage":"Ok","calcolaDistanzeResponse":{"esitoCalcolo":"OK","distanzaTotale":"47222","elencoParziali":[{"partenza":"Via Caldera","arrivo":"Piazzetta Enrico Cuccia","distanza":"8609"}]}}';
		String response1 = '{"resultCode":0,"resultMessage":"Ok","recuperaDatiUtenteZucchettiResponse":{"codFiscale":"PSCMHL79M19A662C","idCompany":"000551","idEmploy":"0001518","username":"CU1518","tipoAuto":"A","modelloAuto":"N108"}}'; 
        String response2 = '{"resultCode":0,"resultMessage":"Ok","recuperaTimbratureZucchettiResponse":{"elencoTimbrature":[{"giorno":"2017-11-06","ora":"09:25","verso":"x","ordinamento":"xx"}]}}';
        String response3 = '{"resultCode":20,"resultMessage":"Service creaNotaSpeseZucchetti is unavailable."}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.calcolaDistanze',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/calcolaDistanze');      
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response1,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDatiUtenteZucchetti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/recuperaDatiUtenteZucchetti');
        ApiRest__c test3 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaTimbratureZucchetti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/recuperaTimbratureZucchetti');
        ApiRest__c test4 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response3 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.creaNotaSpeseZucchetti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert new List<ApiRest__c>{test1,test2,test3,test4};
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.calcolaDistanze','ocs.recuperaDatiUtenteZucchetti','ocs.recuperaTimbratureZucchetti', 'ocs.creaNotaSpeseZucchetti'});
        Test.setMock(HttpCalloutMock.class,UMR);
		Test.startTest();
		GiustificaUscitaNotaSpeseClass.InitWrapper iw=GiustificaUscitaNotaSpeseClass.initApex(noteSpese, Date.today());
		String theWrapper=(String)JSON.serialize(Iw);
		String result;
		
		System.runAs(utenteMaster) {
			result=GiustificaUscitaNotaSpeseClass.sendNotaSpese(noteSpese,theWrapper);
		}
		Test.stopTest();
        System.assertEquals('20',result);
	}

    @isTest 
	static void sendNotaSpese3Test() {
		SFA_NotaSpese__c noteSpese=[SELECT Id,Tratta__c,TargaVeicolo__c, Branch__r.ShippingStreet, Branch__r.ShippingCity, Branch__r.ShippingPostalCode, TipoAuto__c, Date__c, OraInizioUscita__c, OraFineUscita__c FROM SFA_NotaSpese__c WHERE ManagerApprovazione__r.Alias ='test'];
        noteSpese.Branch__r.ShippingStreet='aaaa';
        noteSpese.TipoAuto__c='F';
		User utenteMaster = [SELECT Id FROM User WHERE LastName = 'Test'];
        String response = '{"resultCode":0,"resultMessage":"Ok","calcolaDistanzeResponse":{"esitoCalcolo":"OK","distanzaTotale":"47222","elencoParziali":[{"partenza":"Via Caldera","arrivo":"Piazzetta Enrico Cuccia","distanza":"8609"}]}}';
		String response1 = '{"resultCode":0,"resultMessage":"Ok","recuperaDatiUtenteZucchettiResponse":{"codFiscale":"PSCMHL79M19A662C","idCompany":"000551","idEmploy":"0001518","username":"CU1518","tipoAuto":"A","modelloAuto":"N108"}}'; 
        String response2 = '{"resultCode":0,"resultMessage":"Ok","recuperaTimbratureZucchettiResponse":{"elencoTimbrature":[{"giorno":"2017-11-06","ora":"09:25","verso":"x","ordinamento":"xx"}]}}';
        String response3 = '{"resultCode":20,"resultMessage":"Service creaNotaSpeseZucchetti is unavailable."}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.calcolaDistanze',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/calcolaDistanze');      
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response1,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDatiUtenteZucchetti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/recuperaDatiUtenteZucchetti');
        ApiRest__c test3 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response2,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaTimbratureZucchetti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/recuperaTimbratureZucchetti');
        ApiRest__c test4 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response3 ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.creaNotaSpeseZucchetti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert new List<ApiRest__c>{test1,test2,test3,test4};
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(new List<String>{'ocs.calcolaDistanze','ocs.recuperaDatiUtenteZucchetti','ocs.recuperaTimbratureZucchetti', 'ocs.creaNotaSpeseZucchetti'});
        Test.setMock(HttpCalloutMock.class,UMR);
		Test.startTest();
		GiustificaUscitaNotaSpeseClass.InitWrapper iw=GiustificaUscitaNotaSpeseClass.initApex(noteSpese, Date.today());
		String theWrapper=(String)JSON.serialize(Iw);
		String result;
		
		System.runAs(utenteMaster) {
			result=GiustificaUscitaNotaSpeseClass.sendNotaSpese(noteSpese,theWrapper);
		}
		Test.stopTest();
        System.assertEquals('20',result);
	}
	
}