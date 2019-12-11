@isTest
public with sharing class CRMBatChiudiSinistroFirst_Test {
 
    
    private static testmethod void test1() {
        
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
        
        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXlS.Atto_correttezza__c = '';       
        csXLS.Beneficiario__c = '';
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza';
        csXLS.CauseDiSinistro__c = '';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.CodiceProdotto__c = '';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '123456';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.Created__c = null;
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Data_ricezione_reclamo__c = null;
        csXLS.Data_ricezione_ultimi_doc__c = null;
        csXLS.Data_rifiuto__c = null;
        csXLS.Data_ultima_richiesta__c = null;
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.desScartoXLS__c = null;
        csXLS.Diff__c = null;
        csXLS.doc_Completa__c = null; 
        csXLS.flagUltimoIndennizzo__c = 'S';
        csXLS.Garanzia__c = 'RO';
        csXLS.GroupID__c = null;
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Note__c = null;
        csXLS.Pagato__c = 0.0;
        csXLS.riga__c = '5';
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'Senza Seguito';
        csXLS.Tipo__c = 'ALICO';
        csXLS.updated__c = null;
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '123456';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
		sin.Anomalia__c = '';
        sin.Assicurazione__c = '';
        sin.Caseid__c = cas.Id;
        sin.Coda__c = '';
        sin.Compagnia__c = '';
        sin.Data_Apertura__c = null;
        sin.Data_Chiusura__c = null;
        sin.Data_Elaborazione__c = null;
        sin.Data_Erogazione__c = null;
        sin.Data_Fine_Copertura__c = null;
        sin.Data_Inizio_Copertura__c = null;
        sin.Data_Primo_Utilizzo__c = null;
        sin.Data_Sinistro__c = Date.valueOf('2017-06-04');
        sin.Decorrenza__c = null;
        sin.Esito__c = '';
        sin.Flag_err__c = false;
        sin.Flag_Esito__c = '';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '';
        sin.isRead__c = false;
        sin.Luogo_Elaborazione__c = '';
        sin.Note_Assicurazione__c = '';
        sin.Note__c = '';
        sin.Piano_Ammortamento__c = '';
        sin.Polizza__c = '';
        sin.Rata__c = '';
        sin.Saldo_Residuo__c = '';
        sin.Tipologia_Sinistro__c = 'RO';
        sin.Ultimo_Indennizzo__c = '';      
        insert sin;
        
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respRDA= new List<String>();
        List<String> respRDP= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"RO","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respRDA.add('{"resultCode":0,"resultMessage":"Ok","recuperaDataApprovazioneResponse":{"dataApprovazione":"20061116"}}');
//        respRDP.add('{"resultCode":0,"resultMessage":"Ok","pratiche":[{"numPratica":"1234","codCliente":null,"abi":null,"cab":null,"numConto":null,"iban":null,"statoPratica":null,"tipoPagamento":null,"prodotto":null,"filiale":null,"dataEstinzione":null,"tipoPratica":null,"dataCaricamento":null,"pan":null,"convenzionato":null,"puntoVendita":null,"venditore":null,"agente":null,"subAgente":null,"flagRecupero":null,"classiRecupero":null,"societa":null,"elencoCoobbligati":null,"codStatoPratica":null,"codAttributoPratica":null,"desStatoPratica":null,"desAttributoPratica":null,"codRecuperatore":null,"desRecuperatore":null,"canale":null}],"cliente":[{"cognome":"GIULIANI","codCliente":"55281774","nome":"FABIO", "dataNascita":"19690318", "luogoNascita":"ROMA", "provNascita":"RM", "sesso":"M", "codFiscale":null, "piva":null, "indirizzo":"VIALE ETIOPIA", "cap":"00199", "localita":"ROMA", "provincia":"RM", "paeseEstero":null, "email":null, "tipoDocumento":"", "numDocumento":"","ufficioRilascio":""}]}');
//        respRDP.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaDatiPostvenditaResponse":{"pratiche":[{"numPratica":"1234","codCliente":null,"abi":null,"cab":null,"numConto":null,"iban":null,"statoPratica":null,"tipoPagamento":null,"prodotto":null,"filiale":null,"dataEstinzione":null,"tipoPratica":null,"dataCaricamento":null,"pan":null,"convenzionato":null,"puntoVendita":null,"venditore":null,"agente":null,"subAgente":null,"flagRecupero":null,"classiRecupero":null,"societa":null,"elencoCoobbligati":null,"codStatoPratica":null,"codAttributoPratica":null,"desStatoPratica":null,"desAttributoPratica":null,"codRecuperatore":null,"desRecuperatore":null,"canale":null}],"cliente":[{"cognome":"GIULIANI","codCliente":"55281774","nome":"FABIO", "dataNascita":"19690318", "luogoNascita":"ROMA", "provNascita":"RM", "sesso":"M", "codFiscale":null, "piva":null, "indirizzo":"VIALE ETIOPIA", "cap":"00199", "localita":"ROMA", "provincia":"RM", "paeseEstero":null, "email":null, "tipoDocumento":"", "numDocumento":"","ufficioRilascio":""}}]}');
        respRDP.add('{"resultCode":0,"resultMessage":"Ok", "pratiche":[{"numPratica":"1234","codCliente":null,"abi":null,"cab":null,"numConto":null,"iban":null,"statoPratica":null,"tipoPagamento":null,"prodotto":null,"filiale":null,"dataEstinzione":null,"tipoPratica":null,"dataCaricamento":null,"pan":null,"convenzionato":null,"puntoVendita":null,"venditore":null,"agente":null,"subAgente":null,"flagRecupero":null,"classiRecupero":null,"societa":null,"elencoCoobbligati":null,"codStatoPratica":null,"codAttributoPratica":null,"desStatoPratica":null,"desAttributoPratica":null,"codRecuperatore":null,"desRecuperatore":null,"canale":null}],"cliente":[{"cognome":"GIULIANI","codCliente":"55281774","nome":"FABIO", "dataNascita":"19690318", "luogoNascita":"ROMA", "provNascita":"RM", "sesso":"M", "codFiscale":null, "piva":null, "indirizzo":"VIALE ETIOPIA", "cap":"00199", "localita":"ROMA", "provincia":"RM", "paeseEstero":null, "email":null, "tipoDocumento":"", "numDocumento":"","ufficioRilascio":""}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"CO", numPratica":"12345","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"MG","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('recuperaDataApprovazione', respRDA);
        serviceIdResponseMap.put('recuperaDatiPostvendita', respRDP);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

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
        
        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroFirst(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }
    
   private static testmethod void test2() {
        
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
        
        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXlS.Atto_correttezza__c = '';       
        csXLS.Beneficiario__c = '';
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza';
        csXLS.CauseDiSinistro__c = '';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.CodiceProdotto__c = '';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '1234';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.Created__c = null;
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Data_ricezione_reclamo__c = null;
        csXLS.Data_ricezione_ultimi_doc__c = null;
        csXLS.Data_rifiuto__c = null;
        csXLS.Data_ultima_richiesta__c = null;
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.desScartoXLS__c = null;
        csXLS.Diff__c = null;
        csXLS.doc_Completa__c = null; 
        csXLS.flagUltimoIndennizzo__c = 'S';
        csXLS.Garanzia__c = 'RO';
        csXLS.GroupID__c = null;
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Note__c = null;
        csXLS.Pagato__c = 0.0;
        csXLS.riga__c = '5';
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'Senza Seguito';
        csXLS.Tipo__c = 'ALICO';
        csXLS.updated__c = null;
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '12345';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
		sin.Anomalia__c = '';
        sin.Assicurazione__c = '';
        sin.Caseid__c = cas.Id;
        sin.Coda__c = '';
        sin.Compagnia__c = '';
        sin.Data_Apertura__c = null;
        sin.Data_Chiusura__c = null;
        sin.Data_Elaborazione__c = null;
        sin.Data_Erogazione__c = null;
        sin.Data_Fine_Copertura__c = null;
        sin.Data_Inizio_Copertura__c = null;
        sin.Data_Primo_Utilizzo__c = null;
        sin.Data_Sinistro__c = null;
        sin.Decorrenza__c = null;
        sin.Esito__c = '';
        sin.Flag_err__c = false;
        sin.Flag_Esito__c = '';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '';
        sin.isRead__c = false;
        sin.Luogo_Elaborazione__c = '';
        sin.Note_Assicurazione__c = '';
        sin.Note__c = '';
        sin.Piano_Ammortamento__c = '';
        sin.Polizza__c = '';
        sin.Rata__c = '';
        sin.Saldo_Residuo__c = '';
        sin.Tipologia_Sinistro__c = '';
        sin.Ultimo_Indennizzo__c = '';      
        insert sin;
        
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respRDA= new List<String>();
        List<String> respRDP= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"RO","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respRDA.add('{"resultCode":0,"resultMessage":"Ok","recuperaDataApprovazioneResponse":{"dataApprovazione":"20061116"}}');
//        respRDP.add('{"resultCode":0,"resultMessage":"Ok","pratiche":[{"numPratica":"1234","codCliente":null,"abi":null,"cab":null,"numConto":null,"iban":null,"statoPratica":null,"tipoPagamento":null,"prodotto":null,"filiale":null,"dataEstinzione":null,"tipoPratica":null,"dataCaricamento":null,"pan":null,"convenzionato":null,"puntoVendita":null,"venditore":null,"agente":null,"subAgente":null,"flagRecupero":null,"classiRecupero":null,"societa":null,"elencoCoobbligati":null,"codStatoPratica":null,"codAttributoPratica":null,"desStatoPratica":null,"desAttributoPratica":null,"codRecuperatore":null,"desRecuperatore":null,"canale":null}],"cliente":[{"cognome":"GIULIANI","codCliente":"55281774","nome":"FABIO", "dataNascita":"19690318", "luogoNascita":"ROMA", "provNascita":"RM", "sesso":"M", "codFiscale":null, "piva":null, "indirizzo":"VIALE ETIOPIA", "cap":"00199", "localita":"ROMA", "provincia":"RM", "paeseEstero":null, "email":null, "tipoDocumento":"", "numDocumento":"","ufficioRilascio":""}]}');
//        respRDP.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaDatiPostvenditaResponse":{"pratiche":[{"numPratica":"1234","codCliente":null,"abi":null,"cab":null,"numConto":null,"iban":null,"statoPratica":null,"tipoPagamento":null,"prodotto":null,"filiale":null,"dataEstinzione":null,"tipoPratica":null,"dataCaricamento":null,"pan":null,"convenzionato":null,"puntoVendita":null,"venditore":null,"agente":null,"subAgente":null,"flagRecupero":null,"classiRecupero":null,"societa":null,"elencoCoobbligati":null,"codStatoPratica":null,"codAttributoPratica":null,"desStatoPratica":null,"desAttributoPratica":null,"codRecuperatore":null,"desRecuperatore":null,"canale":null}],"cliente":[{"cognome":"GIULIANI","codCliente":"55281774","nome":"FABIO", "dataNascita":"19690318", "luogoNascita":"ROMA", "provNascita":"RM", "sesso":"M", "codFiscale":null, "piva":null, "indirizzo":"VIALE ETIOPIA", "cap":"00199", "localita":"ROMA", "provincia":"RM", "paeseEstero":null, "email":null, "tipoDocumento":"", "numDocumento":"","ufficioRilascio":""}}]}');
        respRDP.add('{"resultCode":0,"resultMessage":"Ok", "pratiche":[{"numPratica":"1234","codCliente":null,"abi":null,"cab":null,"numConto":null,"iban":null,"statoPratica":null,"tipoPagamento":null,"prodotto":null,"filiale":null,"dataEstinzione":null,"tipoPratica":null,"dataCaricamento":null,"pan":null,"convenzionato":null,"puntoVendita":null,"venditore":null,"agente":null,"subAgente":null,"flagRecupero":null,"classiRecupero":null,"societa":null,"elencoCoobbligati":null,"codStatoPratica":null,"codAttributoPratica":null,"desStatoPratica":null,"desAttributoPratica":null,"codRecuperatore":null,"desRecuperatore":null,"canale":null}],"cliente":[{"cognome":"GIULIANI","codCliente":"55281774","nome":"FABIO", "dataNascita":"19690318", "luogoNascita":"ROMA", "provNascita":"RM", "sesso":"M", "codFiscale":null, "piva":null, "indirizzo":"VIALE ETIOPIA", "cap":"00199", "localita":"ROMA", "provincia":"RM", "paeseEstero":null, "email":null, "tipoDocumento":"", "numDocumento":"","ufficioRilascio":""}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"CO", numPratica":"12345","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"MG","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('recuperaDataApprovazione', respRDA);
        serviceIdResponseMap.put('recuperaDatiPostvendita', respRDP);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

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
        
        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroFirst(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }
   private static testmethod void test3() {
        
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
        
        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXlS.Atto_correttezza__c = '';       
        csXLS.Beneficiario__c = '';
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza';
        csXLS.CauseDiSinistro__c = '';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.CodiceProdotto__c = '';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '1234';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.Created__c = null;
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Data_ricezione_reclamo__c = null;
        csXLS.Data_ricezione_ultimi_doc__c = null;
        csXLS.Data_rifiuto__c = null;
        csXLS.Data_ultima_richiesta__c = null;
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.desScartoXLS__c = null;
        csXLS.Diff__c = null;
        csXLS.doc_Completa__c = null; 
        csXLS.flagUltimoIndennizzo__c = 'S';
        csXLS.Garanzia__c = 'RO';
        csXLS.GroupID__c = null;
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Note__c = null;
        csXLS.Pagato__c = 0.0;
        csXLS.riga__c = '5';
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'Senza Seguito';
        csXLS.Tipo__c = 'CARDIF';
        csXLS.updated__c = null;
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '123456';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
		sin.Anomalia__c = '';
        sin.Assicurazione__c = '';
        sin.Caseid__c = cas.Id;
        sin.Coda__c = '';
        sin.Compagnia__c = '';
        sin.Data_Apertura__c = null;
        sin.Data_Chiusura__c = null;
        sin.Data_Elaborazione__c = null;
        sin.Data_Erogazione__c = null;
        sin.Data_Fine_Copertura__c = null;
        sin.Data_Inizio_Copertura__c = null;
        sin.Data_Primo_Utilizzo__c = null;
        sin.Data_Sinistro__c = Date.valueOf('2017-06-04');
        sin.Decorrenza__c = null;
        sin.Esito__c = '';
        sin.Flag_err__c = false;
        sin.Flag_Esito__c = '';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '';
        sin.isRead__c = false;
        sin.Luogo_Elaborazione__c = '';
        sin.Note_Assicurazione__c = '';
        sin.Note__c = '';
        sin.Piano_Ammortamento__c = '';
        sin.Polizza__c = '';
        sin.Rata__c = '';
        sin.Saldo_Residuo__c = '';
        sin.Tipologia_Sinistro__c = 'RO';
        sin.Ultimo_Indennizzo__c = '';      
        insert sin;
        
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respRDA= new List<String>();
        List<String> respRDP= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"RO","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respRDA.add('{"resultCode":0,"resultMessage":"Ok","recuperaDataApprovazioneResponse":{"dataApprovazione":"20061116"}}');
//        respRDP.add('{"resultCode":0,"resultMessage":"Ok","pratiche":[{"numPratica":"1234","codCliente":null,"abi":null,"cab":null,"numConto":null,"iban":null,"statoPratica":null,"tipoPagamento":null,"prodotto":null,"filiale":null,"dataEstinzione":null,"tipoPratica":null,"dataCaricamento":null,"pan":null,"convenzionato":null,"puntoVendita":null,"venditore":null,"agente":null,"subAgente":null,"flagRecupero":null,"classiRecupero":null,"societa":null,"elencoCoobbligati":null,"codStatoPratica":null,"codAttributoPratica":null,"desStatoPratica":null,"desAttributoPratica":null,"codRecuperatore":null,"desRecuperatore":null,"canale":null}],"cliente":[{"cognome":"GIULIANI","codCliente":"55281774","nome":"FABIO", "dataNascita":"19690318", "luogoNascita":"ROMA", "provNascita":"RM", "sesso":"M", "codFiscale":null, "piva":null, "indirizzo":"VIALE ETIOPIA", "cap":"00199", "localita":"ROMA", "provincia":"RM", "paeseEstero":null, "email":null, "tipoDocumento":"", "numDocumento":"","ufficioRilascio":""}]}');
//        respRDP.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaDatiPostvenditaResponse":{"pratiche":[{"numPratica":"1234","codCliente":null,"abi":null,"cab":null,"numConto":null,"iban":null,"statoPratica":null,"tipoPagamento":null,"prodotto":null,"filiale":null,"dataEstinzione":null,"tipoPratica":null,"dataCaricamento":null,"pan":null,"convenzionato":null,"puntoVendita":null,"venditore":null,"agente":null,"subAgente":null,"flagRecupero":null,"classiRecupero":null,"societa":null,"elencoCoobbligati":null,"codStatoPratica":null,"codAttributoPratica":null,"desStatoPratica":null,"desAttributoPratica":null,"codRecuperatore":null,"desRecuperatore":null,"canale":null}],"cliente":[{"cognome":"GIULIANI","codCliente":"55281774","nome":"FABIO", "dataNascita":"19690318", "luogoNascita":"ROMA", "provNascita":"RM", "sesso":"M", "codFiscale":null, "piva":null, "indirizzo":"VIALE ETIOPIA", "cap":"00199", "localita":"ROMA", "provincia":"RM", "paeseEstero":null, "email":null, "tipoDocumento":"", "numDocumento":"","ufficioRilascio":""}}]}');
        respRDP.add('{"resultCode":0,"resultMessage":"Ok", "pratiche":[{"numPratica":"1234","codCliente":null,"abi":null,"cab":null,"numConto":null,"iban":null,"statoPratica":null,"tipoPagamento":null,"prodotto":null,"filiale":null,"dataEstinzione":null,"tipoPratica":null,"dataCaricamento":null,"pan":null,"convenzionato":null,"puntoVendita":null,"venditore":null,"agente":null,"subAgente":null,"flagRecupero":null,"classiRecupero":null,"societa":null,"elencoCoobbligati":null,"codStatoPratica":null,"codAttributoPratica":null,"desStatoPratica":null,"desAttributoPratica":null,"codRecuperatore":null,"desRecuperatore":null,"canale":null}],"cliente":[{"cognome":"GIULIANI","codCliente":"55281774","nome":"FABIO", "dataNascita":"19690318", "luogoNascita":"ROMA", "provNascita":"RM", "sesso":"M", "codFiscale":null, "piva":null, "indirizzo":"VIALE ETIOPIA", "cap":"00199", "localita":"ROMA", "provincia":"RM", "paeseEstero":null, "email":null, "tipoDocumento":"", "numDocumento":"","ufficioRilascio":""}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"CO", numPratica":"12345","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"MG","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('recuperaDataApprovazione', respRDA);
        serviceIdResponseMap.put('recuperaDatiPostvendita', respRDP);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

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
        
        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroFirst(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }
    private static testmethod void test4() {
        
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
        
        Chiusura_Sinistri_XLS__c csXLS = new Chiusura_Sinistri_XLS__c();
        csXlS.Atto_correttezza__c = '';       
        csXLS.Beneficiario__c = '';
        csXLS.CausaRifiuto__c = 'RO non coperto in polizza';
        csXLS.CauseDiSinistro__c = '';
        csXLS.CodiceGaranzia__c = 'COMPASS2085';
        csXLS.CodiceProdotto__c = '';
        csXLS.Cognome__c = 'GIULIANI';
        csXLS.Contraente__c = 'Compass';
        csXLS.Contratto__c = '123456';
        csXLS.Convenzione__c = 'CL/11/040';
        csXLS.Created__c = null;
        csXLS.DataCaricamento__c = Date.valueOf('2017-10-16'); 
        csXLS.DataDefinizione__c = Date.valueOf('2019-05-06');
        csXLS.DataDenuncia__c = Date.valueOf('2017-10-13');
        csXLS.DataEvento__c = Date.valueOf('2017-06-04');
        csXLS.DataNascita__c = Date.valueOf('1969-03-18');
        csXLS.DataPerv__c = Date.valueOf('2017-10-13');
        csXLS.Data_ricezione_reclamo__c = null;
        csXLS.Data_ricezione_ultimi_doc__c = null;
        csXLS.Data_rifiuto__c = null;
        csXLS.Data_ultima_richiesta__c = null;
        csXLS.Decorrenza_Copertura_Assicurativa__c = Date.valueOf('2015-09-18'); 
        csXLS.descScartoOCS__c = 'OK';
        csXLS.desScartoXLS__c = null;
        csXLS.Diff__c = null;
        csXLS.doc_Completa__c = null; 
        csXLS.flagUltimoIndennizzo__c = 'S';
        csXLS.Garanzia__c = 'RO';
        csXLS.GroupID__c = null;
        csXLS.id__c = '103379';
        csXLS.Incaricato__c = 'FABIO VITIELLO'; 
        csXLS.list_id__c = '701';
        csXLS.Nome__c = 'FABIO';
        csXLS.Note__c = null;
        csXLS.Pagato__c = 0.0;
        csXLS.riga__c = '5';
        csXLS.Sinistro__c = '2017/0408/0004926';
        csXLS.statoRecord__c = 2;
        csXLS.Status__c = 'Senza Seguito';
        csXLS.Tipo__c = 'CARDIF';
        csXLS.updated__c = null;
        insert csXLS;

        Case cas = New case();
        cas.NumeroPratica__c = '12345';
        insert cas;

        Sinistro_Assicurativo__c sin = new Sinistro_Assicurativo__c();
		sin.Anomalia__c = '';
        sin.Assicurazione__c = '';
        sin.Caseid__c = cas.Id;
        sin.Coda__c = '';
        sin.Compagnia__c = '';
        sin.Data_Apertura__c = null;
        sin.Data_Chiusura__c = null;
        sin.Data_Elaborazione__c = null;
        sin.Data_Erogazione__c = null;
        sin.Data_Fine_Copertura__c = null;
        sin.Data_Inizio_Copertura__c = null;
        sin.Data_Primo_Utilizzo__c = null;
        sin.Data_Sinistro__c = Date.valueOf('2017-06-04');
        sin.Decorrenza__c = null;
        sin.Esito__c = '';
        sin.Flag_err__c = false;
        sin.Flag_Esito__c = '';
        sin.hasAttachment__c = false;
        sin.Importo_Indennizzato__c = '';
        sin.isRead__c = false;
        sin.Luogo_Elaborazione__c = '';
        sin.Note_Assicurazione__c = '';
        sin.Note__c = '';
        sin.Piano_Ammortamento__c = '';
        sin.Polizza__c = '';
        sin.Rata__c = '';
        sin.Saldo_Residuo__c = '';
        sin.Tipologia_Sinistro__c = 'RO';
        sin.Ultimo_Indennizzo__c = '';      
        insert sin;
        
        
		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRPA= new List<String>();
        List<String> respRDA= new List<String>();
        List<String> respRDP= new List<String>();
        List<String> respCHI= new List<String>();
        
        respRPA.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaPraticheAssicurateResponse":[{"filiale":"","numPratica":123456,"tipoPratica":"RO","statoPratica":null,"bloccoPratica":null,"emettitore":null,"dataRichiesta":null,"assicurazione":null,"noteAssicurazione":null,"datainizioCopertura":null,"dataFineCopertura":null,"cognome":"giuliani","nome":"fabio","denominazione":"TEST","dataNascita":"18031969","luogoNascita":"Roma","codCliente":"1234","scaduto":"NO"}]}');
        respRDA.add('{"resultCode":0,"resultMessage":"Ok","recuperaDataApprovazioneResponse":{"dataApprovazione":"20061116"}}');
//        respRDP.add('{"resultCode":0,"resultMessage":"Ok","pratiche":[{"numPratica":"1234","codCliente":null,"abi":null,"cab":null,"numConto":null,"iban":null,"statoPratica":null,"tipoPagamento":null,"prodotto":null,"filiale":null,"dataEstinzione":null,"tipoPratica":null,"dataCaricamento":null,"pan":null,"convenzionato":null,"puntoVendita":null,"venditore":null,"agente":null,"subAgente":null,"flagRecupero":null,"classiRecupero":null,"societa":null,"elencoCoobbligati":null,"codStatoPratica":null,"codAttributoPratica":null,"desStatoPratica":null,"desAttributoPratica":null,"codRecuperatore":null,"desRecuperatore":null,"canale":null}],"cliente":[{"cognome":"GIULIANI","codCliente":"55281774","nome":"FABIO", "dataNascita":"19690318", "luogoNascita":"ROMA", "provNascita":"RM", "sesso":"M", "codFiscale":null, "piva":null, "indirizzo":"VIALE ETIOPIA", "cap":"00199", "localita":"ROMA", "provincia":"RM", "paeseEstero":null, "email":null, "tipoDocumento":"", "numDocumento":"","ufficioRilascio":""}]}');
//        respRDP.add('{"resultCode":0,"resultMessage":"Ok","OCSRecuperaDatiPostvenditaResponse":{"pratiche":[{"numPratica":"1234","codCliente":null,"abi":null,"cab":null,"numConto":null,"iban":null,"statoPratica":null,"tipoPagamento":null,"prodotto":null,"filiale":null,"dataEstinzione":null,"tipoPratica":null,"dataCaricamento":null,"pan":null,"convenzionato":null,"puntoVendita":null,"venditore":null,"agente":null,"subAgente":null,"flagRecupero":null,"classiRecupero":null,"societa":null,"elencoCoobbligati":null,"codStatoPratica":null,"codAttributoPratica":null,"desStatoPratica":null,"desAttributoPratica":null,"codRecuperatore":null,"desRecuperatore":null,"canale":null}],"cliente":[{"cognome":"GIULIANI","codCliente":"55281774","nome":"FABIO", "dataNascita":"19690318", "luogoNascita":"ROMA", "provNascita":"RM", "sesso":"M", "codFiscale":null, "piva":null, "indirizzo":"VIALE ETIOPIA", "cap":"00199", "localita":"ROMA", "provincia":"RM", "paeseEstero":null, "email":null, "tipoDocumento":"", "numDocumento":"","ufficioRilascio":""}}]}');
        respRDP.add('{"resultCode":0,"resultMessage":"Ok", "pratiche":[{"numPratica":"1234","codCliente":null,"abi":null,"cab":null,"numConto":null,"iban":null,"statoPratica":null,"tipoPagamento":null,"prodotto":null,"filiale":null,"dataEstinzione":null,"tipoPratica":null,"dataCaricamento":null,"pan":null,"convenzionato":null,"puntoVendita":null,"venditore":null,"agente":null,"subAgente":null,"flagRecupero":null,"classiRecupero":null,"societa":null,"elencoCoobbligati":null,"codStatoPratica":null,"codAttributoPratica":null,"desStatoPratica":null,"desAttributoPratica":null,"codRecuperatore":null,"desRecuperatore":null,"canale":null}],"cliente":[{"cognome":"GIULIANI","codCliente":"55281774","nome":"FABIO", "dataNascita":"19690318", "luogoNascita":"ROMA", "provNascita":"RM", "sesso":"M", "codFiscale":null, "piva":null, "indirizzo":"VIALE ETIOPIA", "cap":"00199", "localita":"ROMA", "provincia":"RM", "paeseEstero":null, "email":null, "tipoDocumento":"", "numDocumento":"","ufficioRilascio":""}]}');
        respCHI.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"CO", numPratica":"12345","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"MG","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaPraticheAssicurate', respRPA);
        serviceIdResponseMap.put('recuperaDataApprovazione', respRDA);
        serviceIdResponseMap.put('recuperaDatiPostvendita', respRDP);
        serviceIdResponseMap.put('chiusuraSinistro', respCHI);

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
        
        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        Test.startTest();
        try {
            database.executebatch(new  CRMBatChiudiSinistroFirst(), 10);
        } 
        catch (System.AsyncException ex) {
        }
        Test.stopTest();
        
    }


}