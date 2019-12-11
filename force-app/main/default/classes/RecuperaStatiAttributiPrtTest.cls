@isTest
public  class RecuperaStatiAttributiPrtTest {
   
   
  @TestSetup
  static void makeData(){
          String response = '{"resultCode": 0,"resultMessage": "Ok","recuperaStatiAttributiPrtResponse": {  "elencoPratiche": [{"tipoPratica": "CA","numPratica": "33190097388","statoPratica": "60","attrbutoPratica": "RT","canale": "MAE"}]}}';
          ApiRest__c apiRest = new ApiRest__c(Method__c = 'POST' ,
                                             Test_Response__c= response ,
                                             Test_Request__c = 'testRequest',
                                              Mock__c = false, 
                                              User__c = 'CDSLF00',
                                              Password__c = 'P00FLSDC' ,
                                              Name ='recuperaStatiAttributiPrt',
                                              EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
          insert apiRest;  
          System.debug(apiRest);
  }

     @isTest   static void testInvoke(){
             
      
                String jsonString = '{"serviceId" : "recuperaStatiAttributiPrt","companyType" : { "value" : "COMPASS"},"recuperaStatiAttributiPrtRequest" : {"elencoPratiche" : [ {"tipoPratica" : "CA","numPratica" : "33190097388","statoPratica" : null,"attributoPratica" : null,"canale" : null} ]}}';
                ApiRest__c apiObj = ApiRest__c.getValues('recuperaStatiAttributiPrt');
                System.debug(' ************** apiObj recuperaStatiAttributiPrt ' +apiObj);
                RecuperaStatiAttributiPrtRequest req = (RecuperaStatiAttributiPrtRequest) JSON.deserializeStrict(jsonString, RecuperaStatiAttributiPrtRequest.class);
                Test.startTest();
                RecuperaStatiAttributiPrtRequest request = new RecuperaStatiAttributiPrtRequest();
                request.serviceId='recuperaStatiAttributiPrt';
                request.companyType.put('value', 'COMPASS');
                List<RecuperaStatiAttributiPrtRequest.RecuperaStatiAttributiPrtReq> elenco = new List<RecuperaStatiAttributiPrtRequest.RecuperaStatiAttributiPrtReq>{
                  new RecuperaStatiAttributiPrtRequest.RecuperaStatiAttributiPrtReq('tipo','stato','xx','att','canal')
                };
                request.recuperaStatiAttributiPrtRequest.elencoPratiche = elenco;
                UtilityMockResponse umr = new UtilityMockResponse();
                umr.apiname ='recuperaStatiAttributiPrt';
                Test.setMock(HttpCalloutMock.class, umr);
                RecuperaStatiAttributiPrtResponse res = Invoker.invoke(request);
                System.debug(' *******************  tipoPratica ***' + res.recuperaStatiAttributiPrtResponse.elencoPratiche[0].tipoPratica); 
                System.debug(' *******************  tipoPratica ***' + res.recuperaStatiAttributiPrtResponse.elencoPratiche[0].attributoPratica);    
                System.debug(' *******************  tipoPratica ***' + res.recuperaStatiAttributiPrtResponse.elencoPratiche[0].canale); 
                System.debug(' *******************  tipoPratica ***' + res.recuperaStatiAttributiPrtResponse.elencoPratiche[0].statoPratica);    
                System.debug(' *******************  tipoPratica ***' + res.recuperaStatiAttributiPrtResponse.elencoPratiche[0].numPratica);  
               // System.assertEquals('tipo',res.recuperaStatiAttributiPrtResponse.elencoPratiche[0].tipoPratica, '**** msg ** ');                                                                                                              
               
               

               Test.stopTest();
     }

    
}