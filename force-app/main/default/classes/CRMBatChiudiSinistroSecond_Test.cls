@isTest
public with sharing class CRMBatChiudiSinistroSecond_Test {
 

    private static void insertVarie(){

        XCS_Disposition__c xcsD = new XCS_Disposition__c();
        xcsD.External_Id__c = 'DP2563';
        insert xcsD;

        XCS_Disposition__c xcsD2 = new XCS_Disposition__c();
        xcsD2.External_Id__c = 'DP2547';
        insert xcsD2;

        XCS_Disposition__c xcsD3 = new XCS_Disposition__c();
        xcsD3.External_Id__c = 'DP2546';
        insert xcsD3;

        XCS_Disposition__c xcsD4 = new XCS_Disposition__c();
        xcsD4.External_Id__c = 'DP2549';
        insert xcsD4;


        XCS_Template__c xcsT = new XCS_Template__c();
        xcsT.Name = 'CRMBatChiudiSinistro_EsitoConScarti';
        xcsT.Body__c = 'BODY TEST';
        insert xcsT;

        XCS_Template__c xcsT2 = new XCS_Template__c();
        xcsT2.Name = 'CRMBatChiudiSinistro_EsitoSenzaScarti';
        xcsT2.Body__c = 'BODY TEST';
        insert xcsT2;
        
        XCS_CompassParameters__c xcsCP = new XCS_CompassParameters__c();
        xcsCP.Name = 'AdminInserisciSinistro';
        xcsCP.Value__c = 'fabio.giuliani@lynxspa.com';
        insert xcsCP;

        XCS_CompassParameters__c xcsCP2 = new XCS_CompassParameters__c();
        xcsCP2.Name = 'emailChiudiSinistro';
        xcsCP2.Value__c = 'fabio.giuliani@lynxspa.com';
        insert xcsCP2;

        ApiRest__c rest = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal',Name ='ocs.recuperaPraticheAssicurate',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
        insert rest;
        ApiRest__c rest2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal',Name ='ocs.recuperaDataApprovazione',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
        insert rest2;
        ApiRest__c rest3 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal',Name ='ocs.recuperaDatiPostvendita',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
        insert rest3;
        ApiRest__c rest4 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal',Name ='ocs.chiusuraSinistro',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
        insert rest4;
        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert uti;

    }

    private static testmethod void testAlico1False() { // ALICO
        
        insertVarie();

        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '123456';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.flagUltimoIndennizzo__c = 'S';
        csXLS.Garanzia__c = 'RO';
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Pagato__c = 0.0;
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'Chiuso con indennizzo';
        csXLS.Tipo__c = 'ALICO';
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '123456';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
		sin.Anomalia__c = '';
        sin.Assicurazione__c = '';
        sin.Caseid__c = cas.Id;
        sin.Compagnia__c = 'Compass';
        sin.Data_Sinistro__c = Date.valueOf('2017-06-04');
        sin.Esito__c = '';
        sin.Flag_err__c = false;
        sin.Flag_Esito__c = '';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '20';
        sin.isRead__c = false;
        sin.Tipologia_Sinistro__c = 'RO';
        sin.Ultimo_Indennizzo__c = 'N';      
        insert sin;
        
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"RO","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"RO", "numPratica":"123456","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"RO","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

        
        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroSecond(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }

   private static testmethod void testAlico2False() {
        
        insertVarie();
        
        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '123456';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.flagUltimoIndennizzo__c = '';
        csXLS.Garanzia__c = 'IPT';
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Pagato__c = 0.0;
        csXLS.riga__c = '5';
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'Respinto';
        csXLS.Tipo__c = 'ALICO';
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '123456';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
        sin.Caseid__c = cas.Id;
        sin.Compagnia__c = 'Compass';
        sin.Data_Sinistro__c = Date.valueOf('2017-06-04');
        sin.Esito__c = '';
        sin.Flag_err__c = false;
        sin.Flag_Esito__c = 'R';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '20';
        sin.isRead__c = false;
        sin.Tipologia_Sinistro__c = 'IPT';
        sin.Ultimo_Indennizzo__c = '';      
        insert sin;
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"IPT","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"IPT", "numPratica":"123456","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"MG","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroSecond(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }
   private static testmethod void testAlico3False() {
        
       insertVarie();

        
        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '123456';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.flagUltimoIndennizzo__c = 'S';
        csXLS.Garanzia__c = 'DC';
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Pagato__c = 0.0;
        csXLS.riga__c = '5';
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'Senza Seguito';
        csXLS.Tipo__c = 'ALICO';
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '123456';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
        sin.Caseid__c = cas.Id;
        sin.Compagnia__c = 'Compass';
        sin.Data_Sinistro__c = Date.valueOf('2017-06-04');
        sin.Esito__c = 'CON INDENNIZZO';
        sin.Flag_err__c = false;
        sin.Flag_Esito__c = 'C';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '';
        sin.isRead__c = false;
        sin.Tipologia_Sinistro__c = 'DC';
        sin.Ultimo_Indennizzo__c = '';      
        insert sin;
        
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"DC","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"DC", "numPratica":"123456","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"MG","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroSecond(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }
    private static testmethod void testAlicoFalse4() {
        
        insertVarie();
        
        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '123456';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.flagUltimoIndennizzo__c = 'S';
        csXLS.Garanzia__c = 'MG';
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Pagato__c = 0.0;
        csXLS.riga__c = '5';
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'Senza Seguito';
        csXLS.Tipo__c = 'ALICO';
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '123456';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
        sin.Caseid__c = cas.Id;
        sin.Compagnia__c = 'Compass';
        sin.Data_Sinistro__c = Date.valueOf('2017-06-04');
        sin.Esito__c = '';
        sin.Flag_err__c = false;
        sin.Flag_Esito__c = '';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '25';
        sin.isRead__c = false;
        sin.Tipologia_Sinistro__c = 'MG';
        sin.Ultimo_Indennizzo__c = '';      
        insert sin;
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"ITP","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"ITP", "numPratica":"12345","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"MG","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroSecond(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }

    private static testmethod void testAlico5False() {
        
        insertVarie();
        
        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza testo lungo per if diversa';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '123456';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.flagUltimoIndennizzo__c = 'N';
        csXLS.Garanzia__c = 'ITT';
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Pagato__c = 0.0;
        csXLS.riga__c = '5';
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'Senza Seguito';
        csXLS.Tipo__c = 'ALICO';
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '123456';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
        sin.Caseid__c = cas.Id;
        sin.Compagnia__c = 'Compass';
        sin.Data_Sinistro__c = Date.valueOf('2017-06-04');
        sin.Esito__c = '';
        sin.Flag_err__c = false;
        sin.Flag_Esito__c = '';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '25';
        sin.isRead__c = false;
        sin.Tipologia_Sinistro__c = 'ITT';
        sin.Ultimo_Indennizzo__c = 'N';      
        insert sin;
        
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"DC","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"DC", "numPratica":"12345","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"MG","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroSecond(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }

    private static testmethod void testAlico6False() {
        
        insertVarie();
        
        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '123456';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.flagUltimoIndennizzo__c = 'N';
        csXLS.Garanzia__c = 'PII';
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Pagato__c = 0.0;
        csXLS.riga__c = '5';
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'Senza Seguito';
        csXLS.Tipo__c = 'ALICO';
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '123456';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
        sin.Caseid__c = cas.Id;
        sin.Compagnia__c = 'Compass';
        sin.Data_Sinistro__c = Date.valueOf('2017-06-04');
        sin.Esito__c = '';
        sin.Flag_err__c = false;
        sin.Flag_Esito__c = '';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '25';
        sin.isRead__c = false;
        sin.Tipologia_Sinistro__c = 'PII';
        sin.Ultimo_Indennizzo__c = 'N';      
        insert sin;
        
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"DC","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"DC", "numPratica":"12345","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"MG","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroSecond(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }






    private static testmethod void testCardif1False() { // ALICO
        
        insertVarie();

        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '123456';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.flagUltimoIndennizzo__c = 'S';
        csXLS.Garanzia__c = 'RO';
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Pagato__c = 0.0;
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'CLO';
        csXLS.Tipo__c = 'CARDIF';
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '123456';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
        sin.Caseid__c = cas.Id;
        sin.Compagnia__c = 'Compass';
        sin.Data_Sinistro__c = Date.valueOf('2017-06-04');
        sin.Esito__c = '';
        sin.Flag_err__c = false;
        sin.Flag_Esito__c = '';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '20';
        sin.isRead__c = false;
        sin.Tipologia_Sinistro__c = 'RO';
        sin.Ultimo_Indennizzo__c = '';      
        insert sin;
        
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"RO","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"RO", "numPratica":"123456","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"RO","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

        
        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroSecond(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }

   private static testmethod void testCardif2false() {
        
        insertVarie();
        
        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza ed allungato per test dei 49';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '123456';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.flagUltimoIndennizzo__c = 'N';
        csXLS.Garanzia__c = 'IPT';
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Pagato__c = 0.0;
        csXLS.riga__c = '5';
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'PEC';
        csXLS.Tipo__c = 'CARDIF';
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '123456';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
        sin.Caseid__c = cas.Id;
        sin.Compagnia__c = 'Compass';
        sin.Data_Sinistro__c = Date.valueOf('2017-06-04');
        sin.Esito__c = '';
        sin.Flag_err__c = false;
        sin.Flag_Esito__c = 'R';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '20';
        sin.isRead__c = false;
        sin.Tipologia_Sinistro__c = 'IPT';
        sin.Ultimo_Indennizzo__c = '';      
        insert sin;
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"IPT","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"IPT", "numPratica":"123456","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"MG","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroSecond(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }
   private static testmethod void testCardif3False() {
        
       insertVarie();

        
        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '123456';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.flagUltimoIndennizzo__c = 'S';
        csXLS.Garanzia__c = 'DC';
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Pagato__c = 0.0;
        csXLS.riga__c = '5';
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'REF';
        csXLS.Tipo__c = 'CARDIF';
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '123456';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
        sin.Caseid__c = cas.Id;
        sin.Compagnia__c = 'Compass';
        sin.Data_Sinistro__c = Date.valueOf('2017-06-04');
        sin.Esito__c = 'CON INDENNIZZO';
        sin.Flag_err__c = false;
        sin.Flag_Esito__c = 'C';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '';
        sin.isRead__c = false;
        sin.Tipologia_Sinistro__c = 'DC';
        sin.Ultimo_Indennizzo__c = '';      
        insert sin;
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"DC","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"DC", "numPratica":"123456","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"MG","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroSecond(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }
    private static testmethod void testCardif4false() {
        
        insertVarie();
        
        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '123456';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.flagUltimoIndennizzo__c = 'S';
        csXLS.Garanzia__c = 'MG';
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Pagato__c = 0.0;
        csXLS.riga__c = '5';
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'Senza Seguito';
        csXLS.Tipo__c = 'CARDIF';
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '123456';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
        sin.Caseid__c = cas.Id;
        sin.Compagnia__c = 'Compass';
        sin.Data_Sinistro__c = Date.valueOf('2017-06-04');
        sin.Esito__c = '';
        sin.Flag_err__c = false;
        sin.Flag_Esito__c = '';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '25';
        sin.isRead__c = false;
        sin.Tipologia_Sinistro__c = 'MG';
        sin.Ultimo_Indennizzo__c = '';      
        insert sin;
        
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"ITP","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"ITP", "numPratica":"12345","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"MG","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroSecond(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }

    private static testmethod void testCardif5false() {
        
        insertVarie();
        
        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '123456';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.flagUltimoIndennizzo__c = 'S';
        csXLS.Garanzia__c = 'ITT';
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Pagato__c = 0.0;
        csXLS.riga__c = '5';
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'Senza Seguito';
        csXLS.Tipo__c = 'CARDIF';
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '123456';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
        sin.Caseid__c = cas.Id;
        sin.Compagnia__c = 'Compass';
        sin.Data_Sinistro__c = Date.valueOf('2017-06-04');
        sin.Esito__c = '';
        sin.Flag_err__c = false;
        sin.Flag_Esito__c = '';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '25';
        sin.isRead__c = false;
        sin.Tipologia_Sinistro__c = 'ITT';
        sin.Ultimo_Indennizzo__c = '';      
        insert sin;
        
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"DC","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"DC", "numPratica":"123456","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"MG","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroSecond(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }
    private static testmethod void testCardif6False() {
        
        insertVarie();
        
        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza porto i caratteri a piu di 50 per test';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '123456';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.flagUltimoIndennizzo__c = 'N';
        csXLS.Garanzia__c = 'PII';
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Pagato__c = 0.0;
        csXLS.riga__c = '5';
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'Senza Seguito';
        csXLS.Tipo__c = 'CARDIF';
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '123456';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
        sin.Caseid__c = cas.Id;
        sin.Compagnia__c = 'COMPASS';
        sin.Data_Sinistro__c = Date.valueOf('2017-06-04');
        sin.Esito__c = '';
        sin.Flag_err__c = false;
        sin.Flag_Esito__c = '';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '25';
        sin.isRead__c = false;
        sin.Tipologia_Sinistro__c = 'PII';
        sin.Ultimo_Indennizzo__c = 'N';      
        insert sin;
        
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"DC","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"DC", "numPratica":"123456","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"MG","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroSecond(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }


// TEST CON ERR = TRUE

    private static testmethod void testAlico1True() { // ALICO
        
        insertVarie();

        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '123456';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.flagUltimoIndennizzo__c = 'S';
        csXLS.Garanzia__c = 'RO';
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Pagato__c = 0.0;
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'Chiuso con indennizzo';
        csXLS.Tipo__c = 'ALICO';
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '123456';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
		sin.Anomalia__c = '';
        sin.Assicurazione__c = '';
        sin.Caseid__c = cas.Id;
        sin.Compagnia__c = 'Compass';
        sin.Data_Sinistro__c = Date.valueOf('2017-06-04');
        sin.Esito__c = '';
        sin.Flag_err__c = true;
        sin.Flag_Esito__c = '';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '20';
        sin.isRead__c = false;
        sin.Tipologia_Sinistro__c = 'RO';
        sin.Ultimo_Indennizzo__c = 'N';      
        insert sin;
        
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"RO","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"RO", "numPratica":"123456","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"RO","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

        
        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroSecond(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }

   private static testmethod void testAlico2True() {
        
        insertVarie();
        
        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '123456';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.flagUltimoIndennizzo__c = '';
        csXLS.Garanzia__c = 'IPT';
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Pagato__c = 0.0;
        csXLS.riga__c = '5';
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'Respinto';
        csXLS.Tipo__c = 'ALICO';
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '123456';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
        sin.Caseid__c = cas.Id;
        sin.Compagnia__c = 'Compass';
        sin.Data_Sinistro__c = Date.valueOf('2017-06-04');
        sin.Esito__c = '';
        sin.Flag_err__c = true;
        sin.Flag_Esito__c = 'R';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '20';
        sin.isRead__c = false;
        sin.Tipologia_Sinistro__c = 'IPT';
        sin.Ultimo_Indennizzo__c = '';      
        insert sin;
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"IPT","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"IPT", "numPratica":"123456","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"MG","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroSecond(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }
   private static testmethod void testAlico3True() {
        
       insertVarie();

        
        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '123456';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.flagUltimoIndennizzo__c = 'S';
        csXLS.Garanzia__c = 'DC';
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Pagato__c = 0.0;
        csXLS.riga__c = '5';
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'Senza Seguito';
        csXLS.Tipo__c = 'ALICO';
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '123456';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
        sin.Caseid__c = cas.Id;
        sin.Compagnia__c = 'Compass';
        sin.Data_Sinistro__c = Date.valueOf('2017-06-04');
        sin.Esito__c = 'CON INDENNIZZO';
        sin.Flag_err__c = true;
        sin.Flag_Esito__c = 'C';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '';
        sin.isRead__c = false;
        sin.Tipologia_Sinistro__c = 'DC';
        sin.Ultimo_Indennizzo__c = '';      
        insert sin;
        
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"DC","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"DC", "numPratica":"123456","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"MG","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroSecond(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }
    private static testmethod void testAlico4True() {
        
        insertVarie();
        
        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '123456';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.flagUltimoIndennizzo__c = 'S';
        csXLS.Garanzia__c = 'MG';
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Pagato__c = 0.0;
        csXLS.riga__c = '5';
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'Senza Seguito';
        csXLS.Tipo__c = 'ALICO';
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '123456';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
        sin.Caseid__c = cas.Id;
        sin.Compagnia__c = 'Compass';
        sin.Data_Sinistro__c = Date.valueOf('2017-06-04');
        sin.Esito__c = '';
        sin.Flag_err__c = true;
        sin.Flag_Esito__c = '';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '25';
        sin.isRead__c = false;
        sin.Tipologia_Sinistro__c = 'MG';
        sin.Ultimo_Indennizzo__c = '';      
        insert sin;
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"ITP","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"ITP", "numPratica":"12345","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"MG","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroSecond(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }

    private static testmethod void testAlico5True() {
        
        insertVarie();
        
        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza testo lungo per if diversa';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '123456';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.flagUltimoIndennizzo__c = 'N';
        csXLS.Garanzia__c = 'ITT';
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Pagato__c = 0.0;
        csXLS.riga__c = '5';
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'Senza Seguito';
        csXLS.Tipo__c = 'ALICO';
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '123456';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
        sin.Caseid__c = cas.Id;
        sin.Compagnia__c = 'Compass';
        sin.Data_Sinistro__c = Date.valueOf('2017-06-04');
        sin.Esito__c = '';
        sin.Flag_err__c = true;
        sin.Flag_Esito__c = '';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '25';
        sin.isRead__c = false;
        sin.Tipologia_Sinistro__c = 'ITT';
        sin.Ultimo_Indennizzo__c = 'N';      
        insert sin;
        
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"DC","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"DC", "numPratica":"12345","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"MG","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroSecond(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }

    private static testmethod void testAlico6True() {
        
        insertVarie();
        
        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '123456';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.flagUltimoIndennizzo__c = 'N';
        csXLS.Garanzia__c = 'PII';
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Pagato__c = 0.0;
        csXLS.riga__c = '5';
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'Senza Seguito';
        csXLS.Tipo__c = 'ALICO';
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '123456';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
        sin.Caseid__c = cas.Id;
        sin.Compagnia__c = 'Compass';
        sin.Data_Sinistro__c = Date.valueOf('2017-06-04');
        sin.Esito__c = '';
        sin.Flag_err__c = true;
        sin.Flag_Esito__c = '';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '25';
        sin.isRead__c = false;
        sin.Tipologia_Sinistro__c = 'PII';
        sin.Ultimo_Indennizzo__c = 'N';      
        insert sin;
        
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"DC","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"DC", "numPratica":"12345","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"MG","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroSecond(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }



    private static testmethod void testCardif1True() { // ALICO
        
        insertVarie();

        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '123456';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.flagUltimoIndennizzo__c = 'S';
        csXLS.Garanzia__c = 'RO';
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Pagato__c = 0.0;
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'CLO';
        csXLS.Tipo__c = 'CARDIF';
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '123456';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
        sin.Caseid__c = cas.Id;
        sin.Compagnia__c = 'Compass';
        sin.Data_Sinistro__c = Date.valueOf('2017-06-04');
        sin.Esito__c = '';
        sin.Flag_err__c = true;
        sin.Flag_Esito__c = '';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '20';
        sin.isRead__c = false;
        sin.Tipologia_Sinistro__c = 'RO';
        sin.Ultimo_Indennizzo__c = '';      
        insert sin;
        
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"RO","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"RO", "numPratica":"123456","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"RO","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

        
        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroSecond(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }

   private static testmethod void testCardif2True() {
        
        insertVarie();
        
        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza ed allungato per test dei 49';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '123456';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.flagUltimoIndennizzo__c = 'N';
        csXLS.Garanzia__c = 'IPT';
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Pagato__c = 0.0;
        csXLS.riga__c = '5';
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'PEC';
        csXLS.Tipo__c = 'CARDIF';
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '123456';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
        sin.Caseid__c = cas.Id;
        sin.Compagnia__c = 'Compass';
        sin.Data_Sinistro__c = Date.valueOf('2017-06-04');
        sin.Esito__c = '';
        sin.Flag_err__c = true;
        sin.Flag_Esito__c = 'R';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '20';
        sin.isRead__c = false;
        sin.Tipologia_Sinistro__c = 'IPT';
        sin.Ultimo_Indennizzo__c = '';      
        insert sin;
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"IPT","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"IPT", "numPratica":"123456","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"MG","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroSecond(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }
   private static testmethod void testCardif3True() {
        
       insertVarie();

        
        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '123456';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.flagUltimoIndennizzo__c = 'S';
        csXLS.Garanzia__c = 'DC';
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Pagato__c = 0.0;
        csXLS.riga__c = '5';
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'REF';
        csXLS.Tipo__c = 'CARDIF';
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '123456';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
        sin.Caseid__c = cas.Id;
        sin.Compagnia__c = 'Compass';
        sin.Data_Sinistro__c = Date.valueOf('2017-06-04');
        sin.Esito__c = 'CON INDENNIZZO';
        sin.Flag_err__c = true;
        sin.Flag_Esito__c = 'C';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '';
        sin.isRead__c = false;
        sin.Tipologia_Sinistro__c = 'DC';
        sin.Ultimo_Indennizzo__c = '';      
        insert sin;
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"DC","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"DC", "numPratica":"123456","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"MG","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroSecond(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }
    private static testmethod void testCardif4true() {
        
        insertVarie();
        
        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '123456';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.flagUltimoIndennizzo__c = 'S';
        csXLS.Garanzia__c = 'MG';
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Pagato__c = 0.0;
        csXLS.riga__c = '5';
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'Senza Seguito';
        csXLS.Tipo__c = 'CARDIF';
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '123456';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
        sin.Caseid__c = cas.Id;
        sin.Compagnia__c = 'Compass';
        sin.Data_Sinistro__c = Date.valueOf('2017-06-04');
        sin.Esito__c = '';
        sin.Flag_err__c = true;
        sin.Flag_Esito__c = '';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '25';
        sin.isRead__c = false;
        sin.Tipologia_Sinistro__c = 'MG';
        sin.Ultimo_Indennizzo__c = '';      
        insert sin;
        
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"ITP","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"ITP", "numPratica":"12345","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"MG","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroSecond(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }

    private static testmethod void testCardif5true() {
        
        insertVarie();
        
        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '123456';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.flagUltimoIndennizzo__c = 'S';
        csXLS.Garanzia__c = 'ITT';
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Pagato__c = 0.0;
        csXLS.riga__c = '5';
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'Senza Seguito';
        csXLS.Tipo__c = 'CARDIF';
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '123456';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
        sin.Caseid__c = cas.Id;
        sin.Compagnia__c = 'Compass';
        sin.Data_Sinistro__c = Date.valueOf('2017-06-04');
        sin.Esito__c = '';
        sin.Flag_err__c = true;
        sin.Flag_Esito__c = '';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '25';
        sin.isRead__c = false;
        sin.Tipologia_Sinistro__c = 'ITT';
        sin.Ultimo_Indennizzo__c = '';      
        insert sin;
        
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"DC","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"DC", "numPratica":"123456","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"MG","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroSecond(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }
    private static testmethod void testCardif6True() {
        
        insertVarie();
        
        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza porto i caratteri a piu di 50 per test';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '123456';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.flagUltimoIndennizzo__c = 'N';
        csXLS.Garanzia__c = 'PII';
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Pagato__c = 0.0;
        csXLS.riga__c = '5';
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'Senza Seguito';
        csXLS.Tipo__c = 'CARDIF';
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '123456';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
        sin.Caseid__c = cas.Id;
        sin.Compagnia__c = 'COMPASS';
        sin.Data_Sinistro__c = Date.valueOf('2017-06-04');
        sin.Esito__c = '';
        sin.Flag_err__c = true;
        sin.Flag_Esito__c = '';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '25';
        sin.isRead__c = false;
        sin.Tipologia_Sinistro__c = 'PII';
        sin.Ultimo_Indennizzo__c = 'N';      
        insert sin;
        
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"DC","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"DC", "numPratica":"123456","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"MG","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroSecond(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }


}