@isTest
public  class RecuperaDatiPostvenditaTest {
    @TestSetup
    static void makeData(){
        String response = '{ "resultCode":0,"resultMessage":"OK","pratiche":[{"numPratica":"800000329783","codCliente":"9529124","tipoPratica":"CP", "dataCaricamento":"20190722","codStatoPratica":"50","codAttributoPratica":""}]}';    
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,
                            Test_Response__c= response ,
                            Test_Request__c = 'testRequest',
                            Mock__c = false, 
                            User__c = 'CDSLF00',
                            Password__c = 'P00FLSDC' ,
                            Name ='ocs.recuperaDatiPostvendita',
                            EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');                               
        insert test2;  
        System.debug(' ************** test2 '+test2);   
        String response2 = '{"resultCode": 0,"resultMessage": "Ok","recuperaInfoInserimentoBloccoResponse": {"dataInserimento": "20130327","oraInserimento": "10193924"}}';
    ApiRest__c apiRest = new ApiRest__c(Method__c = 'POST' ,
                                        Test_Response__c= response2 ,
                                        Test_Request__c = 'testRequest',
                                        Mock__c = false, 
                                        User__c = 'CDSLF00',
                                        Password__c = 'P00FLSDC' ,
                                        Name ='recuperaInfoInserimentoBlocco',
                                        EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
    insert apiRest;  

    List<Case> cases = new List<Case>{
        new Case(),
        new Case()
     };
     insert cases;
    }
    @IsTest
    static void invoketest(){
        Test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname ='ocs.recuperaDatiPostvendita';
        Test.setMock(HttpCalloutMock.class, UMR);
        RecuperaDatiPostvenditaResponse response = RecuperaDatiPostvenditaService.buildRecuperaDatiPostvenditaRequest('', 'true','CO', '3675519',
                                                                                    '', '','', '', '', '', '', '', '', '');
        System.debug(' *******************  response ***' + response);                                                                                                                      
        Test.stopTest();
    }
    @isTest
    static void validateRequesttest(){
    Test.startTest();
    RecuperaDatiPostvenditaRequest request = new RecuperaDatiPostvenditaRequest();
    request.companyType.put('value', '');
    Boolean b = RecuperaDatiPostvenditaService.validateRequest(request);
    System.debug('errrrrrrrrrroor '+RecuperaDatiPostvenditaService.errors);
    System.assert(RecuperaDatiPostvenditaService.errors.size() >  0);
    Test.stopTest();
    }

   @isTest
    static void validateResponsetest(){
        Test.startTest();
        String jsonString = '{"resultCode":0,"resultMessage":"","pratiche":[{"numPratica":"800000329783","codCliente":"9529124",\n'+
        ' "abi":"0","cab":"0","numConto":"", "iban":"","statoPratica":"90","tipoPagamento":"BP","prodotto":"4D","filiale":"223",\n'+
        '"dataEstinzione":"","tipoPratica":"CO","dataCaricamento":833925626454,"pan":"","convenzionato":"212217", "puntoVendita":"0",\n'+
        '"venditore":"0","agente":"7085406", "subAgente":"272166","flagRecupero":"N","classifRecupero":null, "societa":"Linea",\n'+
         ' "elencoCoobbligati":null,"codStatoPratica":"90", "codAttributoPratica":"","desStatoPratica":"Estinta","desAttributoPratica":"",\n'+
         ' "codRecuperatore":"","desRecuperatore":"","canale":""}],"cliente":[{"cognome":"UTMOBZE","codCliente":"9529151","nome":"LERRIO",\n'+
        ' "dataNascita":"0", "luogoNascita":"", "provNascita":"","sesso":"M","codFiscale":"","piva":"","indirizzo":"VIA ROMA 4","cap":"16149",\n'+
        ' "localita":"GENOVA", "provincia":"GE", "paeseEstero":"086", "email":"", "tipoDocumento":"", "numDocumento":"","ufficioRilascio":"",\n'+
	    '"luogoRilascio":"", "provRilascio":"","dataRilascio":"0", "denominazioneAzienda":"UTMOBZE LERRIO","formaGiuridica":"", "tipoAnagrafica":"P",\n'+
		'"dataScadenza":"0","telefonoCasa":"010 475464","telCellulare":"","tipoRapporto":"","dataDepennamento":"0","ndg":"0"}]}';
        RecuperaDatiPostvenditaResponse response = (RecuperaDatiPostvenditaResponse) JSON.deserializeStrict(jsonString, RecuperaDatiPostvenditaResponse.class);
        Boolean b = RecuperaDatiPostvenditaService.validateResponse(response);
        System.debug(' ************* Boolean b*********  '+ RecuperaDatiPostvenditaService.errors);
        System.debug(' ************* Boolean b*********  '+b);
        System.debug(' *********** response '+response.pratiche[0].elencoCoobbligati);
        System.debug(' *********** response '+response.pratiche[0].Filiale );
        System.debug(' *********** response '+response.pratiche[0].flagRecupero );
        System.debug(' *********** response '+response.pratiche[0].Iban );
        System.debug(' *********** response '+response.pratiche[0].numConto );
        System.debug(' *********** response '+response.pratiche[0].numPratica );
        System.debug(' *********** response '+response.pratiche[0].Pan );
        System.debug(' *********** response '+response.pratiche[0].Prodotto );
        System.debug(' *********** response '+response.pratiche[0].societa );
        System.debug(' *********** response '+response.pratiche[0].statoPratica );
        System.debug(' *********** response '+response.pratiche[0].subAgente );
        System.debug(' *********** response '+response.pratiche[0].tipoPratica );
        System.debug(' *********** response '+response.pratiche[0].venditore );
        System.debug(' *********** response '+response.pratiche[0].desStatoPratica );
        System.debug(' *********** response '+response.pratiche[0].codCliente );
        System.debug(' *********** response '+response.pratiche[0].abi );
        System.debug(' *********** response '+response.pratiche[0].cab );
        System.debug(' *************** response **** '+response.pratiche[0].tipoPratica );
        System.debug(' *************** response **** '+response.pratiche[0].convenzionato);
        System.debug(' *************** response **** '+response.pratiche[0].puntoVendita);
        System.debug(' *************** response **** '+response.pratiche[0].agente);
        System.debug(' *************** response **** '+response.pratiche[0].classifRecupero);

        System.debug(' *************** response **** '+response.pratiche[0].codStatoPratica);
        System.debug(' *************** response **** '+response.pratiche[0].codAttributoPratica);
        System.debug(' *************** response **** '+response.pratiche[0].desAttributoPratica);
        System.debug(' *************** response **** '+response.pratiche[0].codRecuperatore);

        System.debug(' *************** response **** '+response.pratiche[0].dataEstinzione);
        System.debug(' *************** response **** '+response.pratiche[0].canale);
     
        System.debug(' *************** response **** '+response.pratiche[0].dataCaricamento);
        System.debug(' *************** response **** '+response.pratiche[0].desRecuperatore);
        System.debug(' *************** response **** '+response.pratiche[0].tipoPagamento);

        System.debug(' *************** response **** '+response.cliente[0].codCliente);
         System.debug(' *************** response **** '+response.cliente[0].codFiscale);
          System.debug(' *************** response **** '+response.cliente[0].cognome);
           System.debug(' *************** response **** '+response.cliente[0].dataDepennamento);
            System.debug(' *************** response **** '+response.cliente[0].dataNascita);
             System.debug(' *************** response **** '+response.cliente[0].dataRilascio);
              System.debug(' *************** response **** '+response.cliente[0].denominazioneAzienda);
               System.debug(' *************** response **** '+response.cliente[0].dataScadenza);
                System.debug(' *************** response **** '+response.cliente[0].email);
                 System.debug(' *************** response **** '+response.cliente[0].formaGiuridica);
                  System.debug(' *************** response **** '+response.cliente[0].indirizzo);
                   System.debug(' *************** response **** '+response.cliente[0].localita);
                    System.debug(' *************** response **** '+response.cliente[0].luogoNascita);
                     System.debug(' *************** response **** '+response.cliente[0].luogoRilascio);
                      System.debug(' *************** response **** '+response.cliente[0].nome);
                      System.debug(' *************** response **** '+response.cliente[0].provNascita);
                       System.debug(' *************** response **** '+response.cliente[0].sesso);
                        System.debug(' *************** response **** '+response.cliente[0].piva);
                        System.debug(' *************** response **** '+response.cliente[0].cap);
                        System.debug(' *************** response **** '+response.cliente[0].provincia);
                        System.debug(' *************** response **** '+response.cliente[0].paeseEstero);
                        System.debug(' *************** response **** '+response.cliente[0].tipoDocumento);
                        System.debug(' *************** response **** '+response.cliente[0].numDocumento);
                        System.debug(' *************** response **** '+response.cliente[0].ufficioRilascio);
                        System.debug(' *************** response **** '+response.cliente[0].provRilascio);
                        System.debug(' *************** response **** '+response.cliente[0].tipoAnagrafica);
                        System.debug(' *************** response **** '+response.cliente[0].telCellulare);
                        System.debug(' *************** response **** '+response.cliente[0].telefonoCasa);
                        System.debug(' *************** response **** '+response.cliente[0].tipoRapporto);
                        System.debug(' *************** response **** '+response.cliente[0].ndg);
        Test.stopTest();

    }
    @isTest
    static void buildFiltroPraticatest(){
        Test.startTest();
        GestioneRichiestaOnline1Cnt.ProductObject p1 =   new GestioneRichiestaOnline1Cnt.ProductObject();
        p1.prodotto = 'CA';
        GestioneRichiestaOnline1Cnt.ProductObject p2 =   new GestioneRichiestaOnline1Cnt.ProductObject();
        p2.prodotto = 'CP';
        GestioneRichiestaOnline1Cnt.ProductObject p3 =   new GestioneRichiestaOnline1Cnt.ProductObject();
        p3.prodotto = 'CO';
        List<GestioneRichiestaOnline1Cnt.ProductObject> listp = new List<GestioneRichiestaOnline1Cnt.ProductObject>{
        p1,
        p2,
        p3
        };
        String filtroPratica = RecuperaDatiPostvenditaService.buildFiltroPratica(listp);
        System.debug('************** test **** '+ filtroPratica);

        Test.stopTest();

    }
    
    @isTest
    static void checkRecuperaDatiPostvenditaNulltest(){
        Test.startTest();
         List<RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO> pratiche = new List<RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO>();
         RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO returnValue = RecuperaDatiPostvenditaService.checkRecuperaDatiPostvendita(pratiche);
         System.debug('********** returnValue '+returnValue);
         System.assertEquals(null, returnValue, 'pass');
        Test.stopTest();
    }
     @isTest
     static void  checkRecuperaDatiPostvenditatest(){
      Test.startTest();
      List<RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO> pratiche = new List<RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO>();
      RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO p1 = new RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO();
      p1.dataCaricamento ='20190612';
      p1.desStatoPratica ='stato';

      RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO p2 = new RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO();
      p2.dataCaricamento ='20190726';
      p2.desStatoPratica ='stato';
      pratiche.add(p1); pratiche.add(p2);
      RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO returnValue = RecuperaDatiPostvenditaService.checkRecuperaDatiPostvendita(pratiche);
      System.debug(' ************* returnValue ********* '+returnValue.dataCaricamento);
      System.assertEquals('20190726', returnValue.dataCaricamento, '**** pass ***');
      Test.stopTest();
    }
    @isTest
    static void checkRecuperaDatiPostvenditaCANull(){
        Test.startTest();
        RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO pratiche = new RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO();
         Map<String, Object> returnValuMap = new Map<String, Object>();
         RecuperaDatiPostvenditaService.checkRecuperaDatiPostvenditaCA(pratiche, returnValuMap);
         System.debug('******** returnValue ******** '+returnValuMap);
         System.assertEquals(0, returnValuMap.keySet().size(), 'pass');
        Test.stopTest();
    }
    @isTest
    static void checkRecuperaDatiPostvenditaCAtest(){
        String response = '{"recuperaMovimentiAutorizzazioniViaggiantiResponse": {\n'+
                          '"recuperaMovViaggiantiResponse": {"elencoMovimenti": [{"tipoMov":"F", "importo":"100","dataOperazione":"20180512"}]},"recuperaAutViaggiantiResponse": {"elencoAutorizzazioni": []}}}';
                       
        ApiRest__c api = new ApiRest__c(Method__c = 'POST' ,
                                            Test_Response__c= response ,
                                            Test_Request__c = 'testRequest',
                                                Mock__c = false, 
                                                User__c = 'CDSLF00',
                                                Password__c = 'P00FLSDC' ,
                                                Name ='ocs.recuperaMovAutViaggianti',
                                                EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');  

            insert api;

      /*      String response2 = '{"resultCode": 0,"resultMessage": "Ok","recuperaElencoMovimentiResponse": {"movimenti": [{ "dataValuta": "20180131","dataRegistrazione": "20180108","dataAcquisto": "20180103","causale": "10","importo": "1275"}]}}';
        ApiRest__c apiRest = new ApiRest__c(Method__c = 'POST' ,
                                            Test_Response__c= response2 ,
                                            Test_Request__c = 'testRequest',
                                            Mock__c = false, 
                                            User__c = 'CDSLF00',
                                            Password__c = 'P00FLSDC' ,
                                            Name ='recuperaElencoMovimenti',
                                            EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert apiRest;   */
            Test.startTest();
            ApiRest__c apiObj = ApiRest__c.getValues('ocs.recuperaMovAutViaggianti');
            System.debug('******* api test mthode '+apiObj);

            RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO pratiche = new RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO();
            Map<String, Object> returnValuMap = new Map<String, Object>();
            pratiche.tipoPratica='CA';
            UtilityMockResponse umR = new UtilityMockResponse();
            umR.apiname ='ocs.recuperaMovAutViaggianti';
            Test.setMock(HttpCalloutMock.class, umR);
               
        /**   UtilityMockResponse umRelencoM = new UtilityMockResponse();
            umRelencoM.apiname ='recuperaElencoMovimenti';
            Test.setMock(HttpCalloutMock.class, umRelencoM); */
            
            RecuperaDatiPostvenditaService.checkRecuperaDatiPostvenditaCA(pratiche, returnValuMap);
            System.debug(' ************ returnValue '+returnValuMap);
            System.debug('retunrMap ********** '+RecuperaDatiPostvenditaService.returnValuMap.get('autorizzazioni'));
            System.debug('retunrMap ********** '+RecuperaDatiPostvenditaService.returnValuMap.get('movimenti'));
            System.assertEquals(null, RecuperaDatiPostvenditaService.returnValuMap.get('movimenti'), 'pass');
            Test.stopTest();
    }
    @isTest
    static void checkRecuperaDatiPostvenditaCPNull(){
        Test.startTest();
        RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO p2 = new RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO();
        Map<String, Object> returnValuMap = new Map<String, Object>();
        RecuperaDatiPostvenditaService.checkRecuperaDatiPostvenditaCP(p2, returnValuMap);
        System.debug('******** returnValue ******** '+returnValuMap);
        System.assertEquals(0, returnValuMap.keySet().size(), 'pass');
        Test.stopTest();
    }
    @isTest
    static void checkRecuperaDatiPostvenditaCPNotnull(){
        String response = '{"resultCode": 0,"resultMessage": "Ok","recuperaMovimentiCpayResponse": {"elenco": [{"importo": "210000","dataCompetenza": "20160628","segno": "A",\n'+
                ' "dataFattura": "0", "progressivoFattura": "0"}]}}';
            
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,
                                        Test_Response__c= response ,
                                        Test_Request__c = 'testRequest',
                                        Mock__c = false, 
                                        User__c = 'CDSLF00',
                                        Password__c = 'P00FLSDC' ,
                                        Name ='recuperaMovimentiCpay',
                                        EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');  

        insert test2;
       Test.startTest();
       RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO pratiche = new RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO();
        Map<String, Object> returnValuMap = new Map<String, Object>();
        pratiche.tipoPratica='CP';
        UtilityMockResponse umR = new UtilityMockResponse();
        umR.apiname ='recuperaMovimentiCpay';
        Test.setMock(HttpCalloutMock.class, umR);
        RecuperaDatiPostvenditaService.checkRecuperaDatiPostvenditaCP(pratiche, returnValuMap);
        Test.stopTest();
    }
     
     @isTest
     static void checkRecuperaDatiPostvenditaCONull(){
        Test.startTest();
        RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO p2 = new RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO();
        Map<String, Object> returnValuMap = new Map<String, Object>();
        RecuperaDatiPostvenditaService.checkRecuperaDatiPostvenditaCO(p2, returnValuMap);
        System.debug('******** returnValue ******** '+returnValuMap);
        System.assertEquals(0, returnValuMap.keySet().size(), 'pass');
        Test.stopTest();
    }
    @isTest
     static void checkRecuperaDatiPostvenditaCONotNull(){
        String response = '{"resultCode": 0,"resultMessage": "Ok","cogetecv1Response": {"mftcoecoOCCURS": [{"mftcoecoELEMENTO": [{"mftcoecoSALDO": 0,"mftcoecoDATASCADENZA": "20180215","mftcoecoIMPORTO": 53530,"mftcoecoIMPORTOS": "","mftcoecoNUMERORATA": "1"}]}]}}';
        ApiRest__c apiRest = new ApiRest__c(Method__c = 'POST',
                                        Test_Response__c= response,
                                        Test_Request__c = 'testRequest',
                                        Mock__c = false, 
                                        User__c = 'CDSLF00',
                                        Password__c = 'P00FLSDC' ,
                                        Name ='OCS_COGETEC_V1',
                                        EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert apiRest;  
        Test.startTest();
        UtilityMockResponse UTM = new UtilityMockResponse();
        UTM.apiname ='OCS_COGETEC_V1';
        Test.setMock(HttpCalloutMock.class, UTM);
        RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO pratiche = new RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO();
        pratiche.tipoPratica ='CO';
        Map<String, Object> returnValuMap = new Map<String, Object>();
        RecuperaDatiPostvenditaService.checkRecuperaDatiPostvenditaCO(pratiche, returnValuMap);
        System.debug('******** returnValue ******** '+returnValuMap.keySet().size());
     System.debug('**** ******* returnValueMap '+(RecuperaDatiPostvenditaService.returnValuMap).get('mftcoecoElemento') );
      // System.assertEquals(1, returnValuMap.keySet().size(), 'pass');
        Test.stopTest();
    }
    @isTest
    static void checkPraticheIsValidetest(){
        Test.startTest();
        RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO pratiche = new RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO();
        pratiche.tipoPratica='CA';
        pratiche.codStatoPratica = '50';
        pratiche.codAttributoPratica= '';
        Boolean b = RecuperaDatiPostvenditaService.checkPraticheIsValide(pratiche);
        System.debug('*********** b'+b);
        System.assertEquals(true, b,'OK');
        Test.stopTest();
    }

      @isTest
    static void checkPraticheIsValideCFtest(){
        Test.startTest();
        RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO pratiche = new RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO();
        pratiche.tipoPratica='CA';
        pratiche.codStatoPratica = '30';
        pratiche.codAttributoPratica= 'CF';
        Boolean b = RecuperaDatiPostvenditaService.checkPraticheIsValide(pratiche);
        System.debug('*********** b'+b);
        System.assertEquals(true, b,'OK');
        Test.stopTest();
    }
    @isTest
    static void checkPraticheIsValideRTtest(){
        Test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname ='recuperaInfoInserimentoBlocco';
        Test.setMock(HttpCalloutMock.class, UMR);

        RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO pratiche = new RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO();
        pratiche.tipoPratica='CA';
        pratiche.codStatoPratica = '30';
        pratiche.codAttributoPratica= 'AN';
        Boolean b = RecuperaDatiPostvenditaService.checkPraticheIsValide(pratiche);
        System.debug('*********** b'+b);
        System.assertEquals(false, b,'OK');
        Test.stopTest();
    }
     @isTest
    static void checkPraticheIsValideRBtest(){
        Test.startTest();
        RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO pratiche = new RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO();
        pratiche.tipoPratica='CA';
        pratiche.codStatoPratica = '60';
        pratiche.codAttributoPratica= 'RB';
        Boolean b = RecuperaDatiPostvenditaService.checkPraticheIsValide(pratiche);
        System.debug('*********** b'+b);
        System.assertEquals(true, b,'OK');
        Test.stopTest();
    }
     @isTest
    static void checkPraticheIsValideCPtest(){
        Test.startTest();
        RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO pratiche = new RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO();
        pratiche.tipoPratica='CP';
        pratiche.codStatoPratica = '50';
        pratiche.codAttributoPratica= '';
        Boolean b = RecuperaDatiPostvenditaService.checkStatoAttributo50Blank(pratiche.codStatoPratica, pratiche.codAttributoPratica);
        System.debug('*********** b'+b);
        System.assertEquals(true, b,'OK');
        Test.stopTest();
    }
     @isTest
    static void checkPraticheIsValideCOtest(){
        Test.startTest();
        RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO pratiche = new RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO();
        pratiche.tipoPratica='C0';
        pratiche.codStatoPratica = '40';
        pratiche.codAttributoPratica= '';
        Boolean b = RecuperaDatiPostvenditaService.checkStatoAttributo40Blank(pratiche.codStatoPratica, pratiche.codAttributoPratica);
        System.debug('*********** b'+b);
        System.assertEquals(true, b,'OK');
        Test.stopTest();
    }
    @isTest
    static void recuperaDatiPostvenditaControltest(){
    Case c = [SELECT Id FROM Case LIMIT 1];
    GestioneRichiestaOnline1Cnt.QuestionManagement qm = new GestioneRichiestaOnline1Cnt.QuestionManagement();


    List<GestioneRichiestaOnline1Cnt.ProductObject> prodoList = new List<GestioneRichiestaOnline1Cnt.ProductObject>();
    GestioneRichiestaOnline1Cnt.ProductObject p1 = new GestioneRichiestaOnline1Cnt.ProductObject();
    p1.prodotto ='CA';
    GestioneRichiestaOnline1Cnt.ProductObject p2 = new GestioneRichiestaOnline1Cnt.ProductObject();
    p2.prodotto ='C0';
    prodoList.add(p1);    prodoList.add(p2);
    qm.products = prodoList;
    Test.startTest();
    UtilityMockResponse UMR = new UtilityMockResponse();
    UMR.apiname ='ocs.recuperaDatiPostvendita';
    Test.setMock(HttpCalloutMock.class, UMR);

    Map<String, Object> returnValue = RecuperaDatiPostvenditaService.recuperaDatiPostvenditaControl(c.Id, qm);
    System.debug(' ********* returnValue isPraticaOK '+ returnValue.get('isPraticaOK'));
    System.debug(' ********* returnValue '+ returnValue);
    Test.stopTest();

    }
}