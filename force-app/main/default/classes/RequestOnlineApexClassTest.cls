/**
    * @Author Madicke BALDE
    * @description  class test for WS RequestOnlineApexClassTest
    * @date 
    * @File name : RequestOnlineApexClassTest
   */

  @isTest
  public  class RequestOnlineApexClassTest {
      
       // create data for test
      @TestSetup
      static void makeData(){
        // Create Account data
        List<Account> listAccount = new List<Account>{
            new Account (LastName='xxxx', Codice_Cliente__c='54874',   Codice_Fiscale__c ='GHDESXWZD'),
            new Account (LastName='Sana', Codice_Cliente__c='54412587', PersonEmail='dicke@gmail.com', OCS_External_Id__c='54412587', Codice_Fiscale__c ='GHDESXWZDSDE')
        };
        insert listAccount;
        // create Product2 data
        Product2 produit = new Product2(Name='P1', ProductCode='145', Family='PP_ONLINE_COMPASS_DS');
        Product2 produit1 = new Product2(Name='P2', ProductCode='125', Family='PP_ONLINE_PARTNER_DS');
        Product2 produit2 = new Product2(Name='P3', ProductCode='126', Family='PF_ECOMMERCE_STANDARD');
        List<Product2> productListr = new List<Product2>{
            new Product2(Name='P1', ProductCode='145', Family='PP_ONLINE_COMPASS_DS'),
            new Product2(Name='P2', ProductCode='125', Family='PP_ONLINE_PARTNER_DS'),
            new Product2(Name='P3', ProductCode='126', Family='PF_ECOMMERCE_STANDARD')
        };

        insert productListr;
      //  cerate data Case
      List<Case> v1 = new List<Case>{
            new Case (RO_Link_Bozza__c='link', Codice_Cliente__c='54412587', Status='On Hold', AccountId= listAccount[0].Id, Product__c = produit.Id ),
            new Case ( RO_Link_Bozza__c= 'test', Codice_Cliente__c='544587'),
            new Case (Codice_Cliente__c ='5425')
        };
      insert v1;    
      }

    @isTest
      static void executeTest(){
          Product2 p = [SELECT Id, ProductCode, Family FROM Product2 Where ProductCode='125'];
            Account acc = [SELECT Id, Codice_Cliente__c, Codice_Fiscale__c FROM Account  Where Codice_Cliente__c='54412587'];
        //  Case c = [SELECT Id, Codice_Cliente__c, Status, AccountId, Product__c  FROM Case LIMIT 1];
          Case c  = new Case ( Codice_Cliente__c='54412587', Status='On Hold', AccountId= acc.Id, Product__c = p.Id );
          //RO_Link_Bozza__c='link'
          insert c;
          Test.startTest();
          String jsonRequest = '{"codProdottoCRM":"1;125","idCRM":"548264", "email" :"dicke@gmails.com", "idAnagOcs":"54412587", "cognome":"PERERO", "nome":"DIA Mansour", "step": "Step 1 - Light Form" }';
          Blob req = Blob.valueOf(jsonRequest);
        String resp =   RequestOnlineApexClass.execute(req);
        System.debug('response json '+ resp);
          Test.stopTest();
      }

      @isTest
      static void  CreaAggiornaRichiestaOnlinetest(){

        Test.startTest();
    /*  String jsonRequest = '{"codProdottoCRM":"1;145","idAnagOcs":"1425ABB","cognome":"PERERO","step": "Step 1 - Light Form",\n'+
  ' "linkBozza" : "likk1", "modalitaFirma" : "modalita","modalitaRichiesta":"","codiceFiscale":"BFDBLRBT",\n'+
  '"utmMedium":"","utmDate":"20190606","utmCampaign":" ","utmContent":" ","utmSource":" ","enginePricing":"2",\n'+
  ' "nome":"John","flagFea":0,"consensoPrivacy2":"","consensoPrivacy3":"","consensoPrivacy4":"","mail":"dicke@gmail.com","recapitoTel":"",\n'+
  ' "professione":"","utmTerm":"","utmHistory":"","idPartnerOcs":"","idCarrello":"","codOcsPratica":"","idCRM":"",\n'+
  '"engineChannel":"","inputMotore":"","ouputMotore":""}'; */

     // String jsonRequest = '{"codProdottoCRM":"1;125","idCRM":"548264", "mail" :"dicke@gmails.com", "idAnagOcs":"54412587", "cognome":"PERERO", "nome":"DIA Mansour", "step": "Step 1 - Light Form" }';
      String jsonRequest = '{"canale":null, "codUteIns":null,"codUteUltimaVar":null,"codiceFiscale":"NFNSMN76T47G283V","cognome":"InfantolinoTest",\n'+
' "consensoPrivacy":"S","consensoPrivacy2":"S","consensoPrivacy3":"S","consensoPrivacy4":"S","dataFineValid":null,"dataIns":null,\n'+
'"dataUltimaVar":null,"datiProdotti":[{"codOcsPratica":"21171817","codProdottoCRM":"1;145","flagFea":null,"incidentIdCRM":"48113923",\n'+
' "opIdCRM":null,"tipoProdotto":"PP"}],"docsUploaded":"CAR;;;;CF;;DRED;;;;;",\n'+
' "email":"ffff@fff.com","engine_channel":"W","engine_pricing":"A","id":null,"idAnagCRM":"7563711","idAnagOcs":"4360169","idCarrello":null,\n'+
' "idPartnerOcs":null,"linkBozza":"https://richiesta.compass.it/ds-webapp/draft/cmp/676ae3cd-1c61-42e9-8853-03b06ad06618","modalitaFirma":null,\n'+
' "modalitaRichiesta":"ONLINE","nome":"Simona","operatore":null,"professione":"2","recapitoTel":"3281095783","stato":null,"step":"Ripresa - Tracking",\n'+
' "utm_Campaign":"","utm_Content":"","utm_Date":"","utm_History":"","utm_Mediacode":"4035","utm_Medium":"","utm_Source":"","utm_Term":""}';
        RestRequest req = new RestRequest();
        RestResponse response = new RestResponse();
        req.requestURI='/services/apexrest/CreaProspect';
        req.requestBody = Blob.valueOf(jsonRequest);
      
        req.httpMethod='POST';
        RestContext.request= req;
        RestContext.response = response;
        RequestOnlineApexClass.CreaAggiornaRichiestaOnline();
        System.debug('******* response '+response);
        Test.stopTest();

      }
      @isTest
      static void CreaAggiornaRichiestaOnlinetestException(){
        Test.startTest();
            String jsonRequest = '{"canale":null, "codUteIns":null,"codUteUltimaVar":null,"codiceFiscale":"NFNSMN76T47G283V","cognome":"InfantolinoTest",\n'+
            ' "consensoPrivacy":"S","consensoPrivacy2":"S","consensoPrivacy3":"S","consensoPrivacy4":"S","dataFineValid":null,"dataIns":null,\n'+
            '"dataUltimaVar":null,"datiProdotti":[{"codOcsPratica":"21171817","codProdottoCRM":"1;148","flagFea":null,"incidentIdCRM":"48113923",\n'+
            ' "opIdCRM":null,"tipoProdotto":"PP"}],"docsUploaded":"CAR;;;;CF;;DRED;;;;;",\n'+
            ' "email":"ffff@fff.com","engine_channel":"W","engine_pricing":"A","id":null,"idAnagCRM":"7563711","idAnagOcs":"4360169","idCarrello":null,\n'+
            ' "idPartnerOcs":null,"linkBozza":"https://richiesta.compass.it/ds-webapp/draft/cmp/676ae3cd-1c61-42e9-8853-03b06ad06618","modalitaFirma":null,\n'+
            ' "modalitaRichiesta":"ONLINE","nome":"Simona","operatore":null,"professione":"2","recapitoTel":"3281095783","stato":null,"step":"Ripresa - Tracking",\n'+
            ' "utm_Campaign":"","utm_Content":"","utm_Date":"","utm_History":"","utm_Mediacode":"4035","utm_Medium":"","utm_Source":"","utm_Term":""}';
            RestRequest req = new RestRequest();
            RestResponse response = new RestResponse();
            req.requestURI='/services/apexrest/CreaProspect';
            req.requestBody = Blob.valueOf(jsonRequest);

            req.httpMethod='POST';
            RestContext.request= req;
            RestContext.response = response;
            RequestOnlineApexClass.CreaAggiornaRichiestaOnline();
            System.debug('******* response '+response);
        Test.stopTest();
      }
  }