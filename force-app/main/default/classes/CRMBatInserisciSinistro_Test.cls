@isTest
public with sharing class CRMBatInserisciSinistro_Test {

    
    private static testmethod void test1() {
        
        XCS_Template__c xcsT = new XCS_Template__c();
        xcsT.Name = 'CRMBatInserisciSinistro_EsitoOK';
        xcsT.Body__c = 'BODY TEST';
        insert xcsT;

        XCS_Template__c xcsT2 = new XCS_Template__c();
        xcsT2.Name = 'CRMBatInserisciSinistro_EsitoKO';
        xcsT2.Body__c = 'BODY TEST';
        insert xcsT2;
        
        XCS_CompassParameters__c xcsCP = new XCS_CompassParameters__c();
        xcsCP.Name = 'AdminInserisciSinistro';
        xcsCP.Value__c = 'fabio.giuliani@lynxspa.com';
        insert xcsCP;

        Account a = new Account();
        a.firstname='LEO';
        a.lastname = 'GULLOTTA';
        a.Codice_Fiscale__c  = 'RTUMRN89C02R800Q';
        a.Codice_Fiscale__pc = 'RTUMRN89C02R800Q';
        a.OCS_External_Id__c = '123456';
        insert a;
        
        Case c = new Case();
        // c.Subject = 
        c.NumeroPratica__c = '1234';
        c.AccountId = a.Id;
        c.Status = 'Sospeso';
        insert c;
        
        Sinistro_Assicurativo__c sx = new Sinistro_Assicurativo__c();
        sx.Luogo_Elaborazione__c ='TEST' ;
        sx.Saldo_Residuo__c ='TEST';
        sx.Rata__c='TEST';
        sx.Decorrenza__c=System.today();
        sx.Polizza__c='TEST';
        sx.Importo_Indennizzato__c='TEST';
        sx.Data_Elaborazione__c=Date.valueOf('2019-06-02');
        sx.Data_Inizio_Copertura__c=Date.valueOf('2019-06-02');
        sx.Data_Sinistro__c = Date.valueOf('2019-06-02');
        sx.Tipologia_Sinistro__c = 'RO';
        sx.CaseId__c = c.Id;
        sx.Coda__c = '107';
        sx.RecordTypeId = '0120Q000000D4JN';
        sx.Flag_err__c=false;
        insert sx;


		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> responses= new List<String>();
        
        responses.add('{"resultCode":0,"resultMessage":"Ok","datiAperturaSinistroResponse":{"compagnia":"ALICO","opzionePagamento":null,"tipoPratica":"CO","luogoElab":"Roma","dataElab":"10-01-2019","numPratica":"1234","polizza":"CL","dataErogazione":"01-12-2018","nominativoAssicurato":"NASS","tipoSinistro":"RO","dataSinistro":"02-06-2019","saldoResiduo":"0.0","dataPrimoUtilizzo":"10-12-2018","contraente":null,"dataNascita":"01-01-1980","codFiscale":null,"codCliente":null,"professione":null,"Pan":null,"dataSottoscrizione":"20-11-2018","durata":null,"dataScadenza":"01-01-2020","finanziato":null,"dataResiduoAl":null,"ggScadenzaRata":null,"tan":null,"taeg":null,"dataRichiesta":null,"dataValidita":null,"fido":null,"pianoAmmortamento":null,"rata":null,"scarti":[{"desScarto":""}]}}');

        serviceIdResponseMap.put('aperturaSinistro', responses);
//        String response = '{"resultCode":0,"resultMessage":"Ok","datiAperturaSinistroResponse":{"compagnia":"ALICO","tipoPratica":"CO","luogoElab":"ROMA","numPratica":"1234","dataSinistro":"2019-06-02"}}';
        ApiRest__c rest = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal',Name ='ocs.aperturaSinistro',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
        insert rest;
        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert uti;
        
        UtilityMockResponse UMR = new UtilityMockResponse();

        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatInserisciSinistro(), 10);
        } catch (System.AsyncException ex) {
        }
        Test.stopTest();
       
    }
    
    private static testmethod void test2() {
        
        XCS_Template__c xcsT = new XCS_Template__c();
        xcsT.Name = 'CRMBatInserisciSinistro_EsitoOK';
        xcsT.Body__c = 'BODY TEST';
        insert xcsT;

        XCS_Template__c xcsT2 = new XCS_Template__c();
        xcsT2.Name = 'CRMBatInserisciSinistro_EsitoKO';
        xcsT2.Body__c = 'BODY TEST';
        insert xcsT2;
        
        XCS_CompassParameters__c xcsCP = new XCS_CompassParameters__c();
        xcsCP.Name = 'AdminInserisciSinistro';
        xcsCP.Value__c = 'fabio.giuliani@lynxspa.com';
        insert xcsCP;

        Account a2 = new Account();
        a2.firstname='LEO2';
        a2.lastname = 'GULLOTTA2';
        a2.Codice_Fiscale__c  = 'RTUMRN89C02R8002';
        a2.Codice_Fiscale__pc = 'RTUMRN89C02R8002';
        a2.OCS_External_Id__c = '1234567';
        insert a2;
        
        Case c2 = new Case();
        // c.Subject = 
        c2.NumeroPratica__c = '12345';
        c2.AccountId = a2.Id;
        c2.Status = 'Sospeso';
        insert c2;
        
        Sinistro_Assicurativo__c sx2 = new Sinistro_Assicurativo__c();
        sx2.Luogo_Elaborazione__c ='TEST' ;
        sx2.Saldo_Residuo__c ='TEST';
        sx2.Rata__c='TEST';
        sx2.Decorrenza__c=System.today();
        sx2.Polizza__c='TEST';
        sx2.Importo_Indennizzato__c='TEST';
        sx2.Data_Elaborazione__c=Date.valueOf('2019-06-02');
        sx2.Data_Inizio_Copertura__c=Date.valueOf('2019-06-02');
        sx2.Data_Sinistro__c = Date.valueOf('2019-06-02');
        sx2.Tipologia_Sinistro__c = 'RO';
        sx2.CaseId__c = c2.Id;
        sx2.Coda__c = '107';
        sx2.RecordTypeId = '0120Q000000D4JN';
        sx2.Flag_err__c=true;
        insert sx2;

		
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> responses= new List<String>();
        
        responses.add('{"resultCode":0,"resultMessage":"Ok","datiAperturaSinistroResponse":{"compagnia":"ALICO","opzionePagamento":null,"tipoPratica":"CO","luogoElab":"Roma","dataElab":"10-01-2019","numPratica":"12345","polizza":"CL","dataErogazione":"01-12-2018","nominativoAssicurato":"NASS","tipoSinistro":"RO","dataSinistro":"02-06-2019","saldoResiduo":"0.0","dataPrimoUtilizzo":"10-12-2018","contraente":null,"dataNascita":"01-01-1980","codFiscale":null,"codCliente":null,"professione":null,"Pan":null,"dataSottoscrizione":"20-11-2018","durata":null,"dataScadenza":"01-01-2020","finanziato":null,"dataResiduoAl":null,"ggScadenzaRata":null,"tan":null,"taeg":null,"dataRichiesta":null,"dataValidita":null,"fido":null,"pianoAmmortamento":null,"rata":null, "scarti":[{"desScarto":""}]}}');

        serviceIdResponseMap.put('aperturaSinistro', responses);
        String response = '{"resultCode":0,"resultMessage":"Ok","datiAperturaSinistroResponse":{"compagnia":"ALICO","tipoPratica":"CO","luogoElab":"ROMA","numPratica":"12345","dataSinistro":"2019-06-02"}}';
        ApiRest__c rest = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal',Name ='ocs.aperturaSinistro',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
        insert rest;
        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert uti;
        
        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatInserisciSinistro(), 10);
        } catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }    
    
}