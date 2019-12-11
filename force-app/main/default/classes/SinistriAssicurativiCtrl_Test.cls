@isTest
public class SinistriAssicurativiCtrl_Test {
	
    private static Sinistro_Assicurativo__c insertSinistro() {
       
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
       
        insert c;
       
        Sinistro_Assicurativo__c sx = new Sinistro_Assicurativo__c();
        sx.Luogo_Elaborazione__c ='pippo' ;
        sx.Saldo_Residuo__c ='pippo';
        sx.Rata__c='pippo';
        sx.Decorrenza__c=System.today();
        sx.Polizza__c='pippo';
       // sx.Nominativo_Assicurato__c='pippo';
        sx.Importo_Indennizzato__c='pippo';
        sx.Data_Elaborazione__c=System.today();
//        sx.Numero_Contratto__c='pippo';
      //begin modifica 02 rimapping campi
      //
        //sx.Nome__c='pippo';
        //sx.Cognome__c='pippo';
        //
        // end modifica 02 agosto rimapping campi
        // 
        sx.Data_Inizio_Copertura__c=System.today();
   //     sx.Data_Fine_Copertura__c=System.today().addMonths(12);
    //    sx.Numero_Pratica__c='1234';
      //  sx.AccountId__c = a.id;
        sx.Data_Sinistro__c = date.today();
        // Tipo_Pratica__c, Data_Sinistro__c, Tipologia_Sinistro__c,Stato_Sinistro__c, Esito__c, Anomalia__c 
        sx.CaseId__c = c.Id;
        insert sx;
        return sx;
    }

    @isTest
    public static void getLetteraPreconvalidaTest(){
        Sinistro_Assicurativo__c sx = insertSinistro();
        Document doc = new Document(Name='DocComapps', developerName = 'Compass_Logo',FolderId = UserInfo.getUserId());
        insert doc;
        ApexPages.currentPage().getParameters().put('parDisp','E');
        ApexPages.currentPage().getParameters().put('pratica','12334');
        ApexPages.currentPage().getParameters().put('stato','all');
        Test.startTest();
        SinistriAssicurativiCtrl sinistriCtrl = new SinistriAssicurativiCtrl();
        sinistriCtrl.getLetteraPreconvalida(sx.id);
        Test.stopTest();
        System.assertNotEquals(null, sinistriCtrl.titlePreconvalida);
    }

    @isTest
    public static void ricercaTest(){
        Sinistro_Assicurativo__c sx = insertSinistro();
 //       sx.CaseId__c.Status = 'Sospeso';
   //     sx.CaseId__c.Tipo_Pratica__c = 'CA';
        sx.Data_Sinistro__c = Date.today();
        sx.Tipologia_Sinistro__c = 'DC';
        sx.Esito__c='OK';
        sx.Anomalia__c=''; 
        update sx;
        Test.startTest();
        String esito = SinistriAssicurativiCtrl.ricerca('all',1234);
        System.assertNotEquals(null, esito);
        esito = SinistriAssicurativiCtrl.ricerca('openLast15',1234);
        System.assertNotEquals(null, esito);
        esito = SinistriAssicurativiCtrl.ricerca('closedLast15',1234);
        System.assertNotEquals(null, esito);
        esito = SinistriAssicurativiCtrl.ricerca('openClosedLast15',1234);
        System.assertNotEquals(null, esito);
        esito = SinistriAssicurativiCtrl.ricerca('allOpen',1234);
        System.assertNotEquals(null, esito);
        esito = SinistriAssicurativiCtrl.ricerca('allClosed',1234);
        System.assertNotEquals(null, esito);
        Test.stopTest();
    }


    @isTest
    public static void inserisciSinistroWSTest() {
        
        XCS_Categoria__c cat = new XCS_Categoria__c();
        cat.External_Id__c = SinistriAssicurativiCtrl.CATEGORIA_CASE_SINISTRO;
        insert cat;      
        String response = '{"resultCode":0,"resultMessage":"Ok","datiAperturaSinistroResponse":{"compagnia":"201812compagnia05","tipoPratica":"tipoPratica","luogoElab":"ROMA","numPratica":"1234"}}';//,"polizza":"polizza","nominativoAssicurato":"nominativoAssicurato","tipoSinistro":"tipoSinistro","dataSinistro":"'+String.valueOf(date.today())+'","saldoResiduo":"1234","rata":"122","dataPrimoUtilizzo","'+String.valueOf(date.today())+'","contraente":"contraente","pan":"pan","pianoAmmortamento":"pianoAmmortamento"}}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c=response,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Ref__c='CompassInternal', Name ='ocs.aperturaSinistro',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
       	ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert test1;
        insert uti;
        UtilityMockResponse UMR = new UtilityMockResponse(); 
        UMR.apiname='ocs.aperturaSinistro';
        Test.setMock(HttpCalloutMock.class,UMR);
        Test.startTest();
        Integer esito = SinistriAssicurativiCtrl.inserisciSinistroWS('Assicurazione','823423','CO','12-04-1980','DC','Gullotta','Leo','note',String.valueOf(date.today()),'Roma','RTUMRN89C02R800Q','noteAss','1-1-2018','12-12-2020');
        SinistriAssicurativiCtrl.convertStringToDate2('20190925');
        Test.stopTest();
        System.assertEquals(0, esito);

    }

    @isTest
    public static void inserisciSinistroWSTest2() {
        
        XCS_Categoria__c cat = new XCS_Categoria__c();
        cat.External_Id__c = SinistriAssicurativiCtrl.CATEGORIA_CASE_SINISTRO;
        insert cat;      
        String response = '{"resultCode":0,"resultMessage":"Ok","datiAperturaSinistroResponse":{"compagnia":"201812compagnia05","tipoPratica":"tipoPratica","luogoElab":"ROMA","numPratica":"1234"}}';//,"polizza":"polizza","nominativoAssicurato":"nominativoAssicurato","tipoSinistro":"tipoSinistro","dataSinistro":"'+String.valueOf(date.today())+'","saldoResiduo":"1234","rata":"122","dataPrimoUtilizzo","'+String.valueOf(date.today())+'","contraente":"contraente","pan":"pan","pianoAmmortamento":"pianoAmmortamento"}}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c=response,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Ref__c='CompassInternal', Name ='ocs.aperturaSinistro',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
       	ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert test1;
        insert uti;
        UtilityMockResponse UMR = new UtilityMockResponse(); 
        UMR.apiname='ocs.aperturaSinistro';
        Test.setMock(HttpCalloutMock.class,UMR);
        Test.startTest();
        Integer esito = SinistriAssicurativiCtrl.inserisciSinistroWS('Assicurazione','823423','CO','12-04-1980','DC','Gullotta','Leo','note',String.valueOf(date.today()),'Roma','RTUMRN89C02R800Q','noteAss','','');
        SinistriAssicurativiCtrl.convertStringToDate2('20190925');
        Test.stopTest();
        System.assertEquals(0, esito);

    }

    @isTest
    public static void getPianoAmmortamentoECTest() {
        Sinistro_Assicurativo__c sx = insertSinistro();
        sx.Piano_Ammortamento__c = '270,80 166,19 104,61 11.351,29 14.352,40 | | 002 28/02/2019 270,80 167,70 103,10 11.183,59 14.081,60 | | 003 30/03/2019 270,80 169,22 101,58 11.014,37 13.810,80 | | 004 30/07/2023 270,80 170,76 100,04 10.843,61 13.540,00 | | 005 30/08/2023 270,80 172,31 98,49 10.671,30 13.269,20 | | 006 30/06/2019 270,80 173,87 96,93 10.497,43 12.998,40 | | 007 30/07/2019 270,80 175,45 95,35 10.321,98 12.727,60 | | 008 30/08/2019 270,80 177,05 93,75 10.144,93 12.456,80 | | 009 30/09/2019 270,80 178,65 92,15 9.966,28 12.186,00 | | 010 30/10/2019 270,80 180,28 90,52 9.786,00 11.915,20 | | 011 30/11/2019 270,80 181,91 88,89 9.604,09 11.644,40 | | 012 30/12/2019 270,80 183,57 87,23 9.420,52 11.373,60 | | 013 30/01/2020 270,80 185,23 85,57 9.235,29 11.102,80 | | 014 29/02/2020 270,80 186,92 83,88 9.048,37 10.832,00 | | 015 30/03/2020 270,80 188,61 82,19 8.859,76 10.561,20 | | 016 30/04/2020 270,80 190,33 80,47 8.669,43 10.290,40 | | 017 30/05/2020 270,80 192,06 78,74 8.477,37 10.019,60 | | 018 30/06/2020 270,80 193,80 77,00 8.283,57 9.748,80 | | 019 30/07/2020 270,80 195,56 75,24 8.088,01 9.478,00 | | 020 30/08/2020 270,80 197,34 73,46 7.890,67 9.207,20 | | 021 30/09/2020 270,80 199,13 71,67 7.691,54 8.936,40 | | 022 30/10/2020 270,80 200,94 69,86 7.490,60 8.665,60 | | 023 30/11/2020 270,80 202,76 68,04 7.287,84 8.394,80 | | 024 30/12/2020 270,80 204,60 66,20 7.083,24 8.124,00 | | 025 30/01/2021 270,80 206,46 64,34 6.876,78 7.853,20 | | 026 28/02/2021 270,80 208,34 62,46 6.668,44 7.582,40 | | 027 30/03/2021 270,80 210,23 60,57 6.458,21 7.311,60 | |';
        sx.Piano_Ammortamento__c += '028 30/04/2021 270,80 212,14 58,66 6.246,07 7.040,80 | | 029 30/05/2021 270,80 214,07 56,73 6.032,00 6.770,00 | | 030 30/06/2021 270,80 216,01 54,79 5.815,99 6.499,20 | | 031 30/07/2021 270,80 217,97 52,83 5.598,02 6.228,40 | | 032 30/08/2021 270,80 219,95 50,85 5.378,07 5.957,60 | | 033 30/09/2021 270,80 221,95 48,85 5.156,12 5.686,80 | | 034 30/10/2021 270,80 223,97 46,83 4.932,15 5.416,00 | | 035 30/11/2021 270,80 226,00 44,80 4.706,15 5.145,20 | | 036 30/12/2021 270,80 228,05 42,75 4.478,10 4.874,40 | | 037 30/01/2022 270,80 230,13 40,67 4.247,97 4.603,60 | | 038 28/02/2022 270,80 232,22 38,58 4.015,75 4.332,80 | | 039 30/03/2022 270,80 234,33 36,47 3.781,42 4.062,00 | | 040 30/04/2022 270,80 236,45 34,35 3.544,97 3.791,20 | | 041 30/05/2022 270,80 238,60 32,20 3.306,37 3.520,40 | | 042 30/06/2022 270,80 240,77 30,03 3.065,60 3.249,60 | | 043 30/07/2022 270,80 242,96 27,84 2.822,64 2.978,80 | | 044 30/08/2022 270,80 245,16 25,64 2.577,48 2.708,00 | | 045 30/09/2022 270,80 247,39 23,41 2.330,09 2.437,20 | | 046 30/10/2022 270,80 249,64 21,16 2.080,45 2.166,40 | | 047 30/11/2022 270,80 251,90 18,90 1.828,55 1.895,60 | | 048 30/12/2022 270,80 254,19 16,61 1.574,36 1.624,80 | | Rat Scadenza Imp.rata Capitale Interessi Cap.Residuo Deb.Residuo | ________________________________________________________________________________ | DEMO ** - COMPASS BANCPiano ammortamento pratica n. 20061357 Pag. 2 | | Cliente....: 13815185 SAAEMA DOKICA data 08/07/2019 | | Rat Scadenza Imp.rata Capitale Interessi Cap.Residuo Deb.Residuo | | ___ __________ __________ __________ ___________ ___________ ___________ | | ';
        sx.Piano_Ammortamento__c += '049 30/01/2023 270,80 256,50 14,30 1.317,86 1.354,00 | | 050 28/02/2023 270,80 258,83 11,97 1.059,03 1.083,20 | | 051 30/03/2023 270,80 261,18 9,62 797,85 812,40 | | 052 30/04/2023 270,80 263,55 7,25 534,30 541,60 | | 053 30/05/2023 270,80 265,95 4,85 268,35 270,80 | | 054 30/06/2023 270,80 268,35 2,45 | ________________________________________________________________________________ | Finanziato: 11.517,48 Interessi: 3.105,72 Montante: 14.623,20 |'; 
        update sx;
        Test.startTest();
        SinistriAssicurativiCtrl ctrl = new SinistriAssicurativiCtrl();
        ctrl.getPianoAmmortamentoEC(sx.id);
        Test.stopTest();
        System.assertEquals('Piano_Ammortamento', ctrl.title);
 
    }



   @isTest
    public static void finishUploadFileTest() {
        Sinistro_Assicurativo__c sx = insertSinistro();


        Account acct = new Account(Name='TEST_ACCT');
        insert acct;
        
        XCS_Categoria__c xcs = new XCS_Categoria__c();
        xcs.Name = 'TEST';
        xcs.External_Id__c = '2234';
        insert xcs;
        
        
        ContentVersion contentVersion = new ContentVersion(
          Title = 'Penguins',
          PathOnClient = 'Penguins.jpg',
          VersionData = Blob.valueOf('Test Content'),
          IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = acct.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
		XCS_Disposition__c disp = new XCS_Disposition__c(name='Sinistri Assicurativi', External_Id__c='2234');
        
        String idSinistroResult = SinistriAssicurativiCtrl.finishUploadFile(sx.Id,documents[0].Id);
       System.assertNotEquals(null, idSinistroResult);
      
    }


    @isTest
    public static void recuperaAnagraficaWSTest(){
        String response = '{"resultCode":0,"resultMessage":"Ok","elencoPratiche":[]}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c=response,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Ref__c='CompassInternal', Name ='ocs.recuperaPraticheAssicurate',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
       	ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert test1;
        insert uti;
        UtilityMockResponse UMR = new UtilityMockResponse(); 
        UMR.apiname='ocs.recuperaPraticheAssicurate';       
        String result = null;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,UMR);
        result = SinistriAssicurativiCtrl.recuperaAnagraficaWS('nome','cognome', '12-12-2010','DTRUWE87C03Y890W','1212',
                                            '2312323', 'srl', 'pan');
        System.assertEquals('[]',result);
        Test.stopTest();
    }   
    
     @isTest
    public static void testInnerClass(){
        SinistriAssicurativiCtrl.Sinistro sx = new  SinistriAssicurativiCtrl.Sinistro('id', 'nominativo', 'numeroPratica','String tipoPratica', 'String dataSinistro','String tipoSinistro', 'String statoSinistro', 'String esito', 'String anomalie',System.today());
        SinistriAssicurativiCtrl.Sinistro sx2 = new  SinistriAssicurativiCtrl.Sinistro('id', 'nominativo', 'numeroPratica','String tipoPratica', 'String dataSinistro','String tipoSinistro', 'String statoSinistro', 'String esito', 'String anomalie',System.today()+1);
    	sx.toString();
        List<SinistriAssicurativiCtrl.Sinistro> lista = new  List<SinistriAssicurativiCtrl.Sinistro>();
        lista.add(sx);
        lista.add(sx2);
        lista.sort();
    }
 
}