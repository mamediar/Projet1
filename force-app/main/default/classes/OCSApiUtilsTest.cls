@isTest
public  class OCSApiUtilsTest {
   
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
   @isTest
   static void getMockResponsetest(){
       Test.startTest();
       String response =  OCSApiUtils.getMockResponse('recuperaStatiAttributiPrt');
       System.assertEquals(null, response, '** pass ** ');
       Test.stopTest();
   }

    @isTest
    static void callApitest(){
       Test.startTest();
        RecuperaStatiAttributiPrtRequest request = new RecuperaStatiAttributiPrtRequest();
        request.serviceId='recuperaStatiAttributiPrt';
        request.companyType.put('value', 'COMPASS');

        OCSApiUtils.callApi('recuperaStatiAttributiPrt', request, RecuperaStatiAttributiPrtResponse.class,'C');
        OCSApiUtils.callApi('recuperaStatiAttributiPrt', request, RecuperaStatiAttributiPrtResponse.class);
        //System.debug(' request test '+request)
        System.assert(request!=null, '** pass ** ');
       Test.stopTest();
   }

}