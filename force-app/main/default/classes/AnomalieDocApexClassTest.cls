@isTest
public with sharing class AnomalieDocApexClassTest {
   
 @TestSetup
 static void makeData(){
  List<Case> cases = new List<Case>{
      new Case(NumeroPratica__c='10000008',RO_Vecchio_Cellulare__c='773739676'),
      new Case(NumeroPratica__c='100')
  };
  insert cases;
  XCS_CompassParameters__c cp = new XCS_CompassParameters__c(Name='Number_of_hours', Execution_Anomalie_Batch_Time__c=2);
  insert cp;
 }
 

  @isTest
  static void anomalieDoc(){
    Case c = new  Case(NumeroPratica__c='100000088',RO_Vecchio_Cellulare__c='773739676');
    insert c;
    System.debug('**** created Date  before '+c.CreatedDate);
    Datetime dt = Datetime.now();
    Datetime d = dt.addHours(2);
    System.debug('***** datetime now '+d);
    List<Case> cases = [SELECT Id,CreatedDate FROM Case];
    Test.setCreatedDate(c.Id, d);
    Test.setCreatedDate(cases[0].Id, d);
    System.debug('**** created Date '+c.CreatedDate);
    XCS_CompassParameters__c cp =  XCS_CompassParameters__c.getValues('Number_of_hours');
    cp.Number_of_hours__c = 4;
    update cp;
    Test.startTest();
    Case cr = [SELECT Id, CreatedDate FROM Case WHERE NumeroPratica__c ='100000088' ] ;
    System.debug('******** cr'+cr.CreatedDate + ' id'+cr.Id);
      
    RestRequest req = new RestRequest();
    RestResponse response = new RestResponse();
    req.requestURI='/services/apexrest/AnomalieDoc';
    req.httpMethod='POST';
    String rqbody = '{"codOcsPratica" : "100000088","tipoProdotto" : "CO","anomalieDocDettagliDTO" : {"item" : [\n'+
                  '{"codDoc" : "CAR","codMacroDoc" : "IDE", "desAnomaliaCliente" : "wvwvw","desAnomaliaOperatore" : "wxxx","desDoc" : "Carta di identit&#xE0;",\n'+
                  ' "desMacroDoc" : "Doc. identit&#xE0;","fRistampaContratto" : "N","codAnomalia" :"44145","dataAnomalia": "20190603"\n'+
                  '},{ "codDoc" : "PAS","codMacroDoc" : "IDE","desAnomaliaCliente" : "wvwvw","desAnomaliaOperatore" : "wxxx","desDoc" : "Codice Fiscale",\n'+
                  ' "desMacroDoc" : "Codice fiscale richiedente","fRistampaContratto" : "N","codAnomalia" :"441sc", "dataAnomalia": "20190301"}]}}';
    req.requestBody = Blob.valueOf(rqbody);
    RestContext.request= req;
    RestContext.response = response;
    AnomalieDocApexClass.AnomalieDocResponse resp =  AnomalieDocApexClass.anomalieDoc();
    // System.assertEquals(1, resp.resultCode, 'pass');
    // System.debug(resp);
    Test.stopTest();
  }

  @isTest
  static void anomalieDocException(){
    RestRequest req = new RestRequest();
    RestResponse response = new RestResponse();
    req.requestURI='/services/apexrest/AnomalieDoc';
    req.httpMethod='POST';
    String rqbody = '{"codOcsPratica" : "100008","tipoProdotto" : "CO","anomalieDocDettagliDTO" : {"item" : [\n'+
                  '{"codDoc" : "CAR","codMacroDoc" : "IDE", "desAnomaliaCliente" : "wvwvw","desAnomaliaOperatore" : "wxxx","desDoc" : "Carta di identit&#xE0;",\n'+
                  ' "desMacroDoc" : "Doc. identit&#xE0;","fRistampaContratto" : "N","codAnomalia" :"44145","dataAnomalia": "20190603"\n'+
                  '},{ "codDoc" : "PAS","codMacroDoc" : "IDE","desAnomaliaCliente" : "wvwvw","desAnomaliaOperatore" : "wxxx","desDoc" : "Codice Fiscale",\n'+
                  ' "desMacroDoc" : "Codice fiscale richiedente","fRistampaContratto" : "N","codAnomalia" :"441sc", "dataAnomalia": "20190301"}]}}';
    req.requestBody = Blob.valueOf(rqbody);
    RestContext.request= req;
    RestContext.response = response;
    AnomalieDocApexClass.AnomalieDocResponse resp =  AnomalieDocApexClass.anomalieDoc();
    //   System.debug(resp);
    System.assertEquals(1, resp.resultCode, '*  pass ');
  }

  @isTest
  static void anomalieDocExceptionDeseri(){
    RestRequest req = new RestRequest();
    RestResponse response = new RestResponse();
    req.requestURI='/services/apexrest/AnomalieDoc';
    req.httpMethod='POST';
    String rqbody = '{"codOcsPratica" : "100008","tipoProdotto" : "CO","anomalieDocDettagliDTO" : {"item" : [\n'+
                  '{"codDoc" : "CAR","codMacroDocxx" : "IDE", "desAnomaliaCliente" : "wvwvw","desAnomaliaOperatore" : "wxxx","desDoc" : "Carta di identit&#xE0;",\n'+
                  ' "desMacroDoc" : "Doc. identit&#xE0;","fRistampaContratto" : "N","codAnomalia" :"44145","dataAnomalia": "20190603"\n'+
                  '},{ "codDoc" : "PAS","codMacroDoc" : "IDE","desAnomaliaCliente" : "wvwvw","desAnomaliaOperatore" : "wxxx","desDoc" : "Codice Fiscale",\n'+
                  ' "desMacroDoc" : "Codice fiscale richiedente","fRistampaContratto" : "N","codAnomalia" :"441sc", "dataAnomalia": "20190301"}]}}';
    req.requestBody = Blob.valueOf(rqbody);
    RestContext.request= req;
    RestContext.response = response;
    AnomalieDocApexClass.AnomalieDocResponse resp =  AnomalieDocApexClass.anomalieDoc();
    System.assertEquals(1, resp.resultCode, '*  pass ');
    // System.debug(resp);
  }

  @isTest
  static void anomalieDocPut(){
    RestRequest req = new RestRequest();
    RestResponse response = new RestResponse();
    req.requestURI='/services/apexrest/AnomalieDoc';
    req.httpMethod='PUT';
    String rqbody = '{"codOcsPratica" : "10000008","tipoProdotto" : "CO","anomalieDocDettagliDTO" : {"item" : [\n'+
                  '{"codDoc" : "CAR","codMacroDoc" : "IDE", "desAnomaliaCliente" : "wvwvw","desAnomaliaOperatore" : "wxxx","desDoc" : "Carta di identit&#xE0;",\n'+
                  ' "desMacroDoc" : "Doc. identit&#xE0;","fRistampaContratto" : "N","codAnomalia" :"44145","dataAnomalia": "20190603"\n'+
                  '},{ "codDoc" : "PAS","codMacroDoc" : "IDE","desAnomaliaCliente" : "wvwvw","desAnomaliaOperatore" : "wxxx","desDoc" : "Codice Fiscale",\n'+
                  ' "desMacroDoc" : "Codice fiscale richiedente","fRistampaContratto" : "N","codAnomalia" :"441sc", "dataAnomalia": "20190301"}]}}';
    req.requestBody = Blob.valueOf(rqbody);
    RestContext.request= req;
    RestContext.response = response;
    AnomalieDocApexClass.AnomalieDocResponse resp =  AnomalieDocApexClass.updateAnomalieDoc();
    System.assertEquals(0, resp.resultCode, '*  pass ');
    // System.debug(resp);
  }
}