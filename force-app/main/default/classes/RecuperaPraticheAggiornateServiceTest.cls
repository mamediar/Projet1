@isTest
private class RecuperaPraticheAggiornateServiceTest {
    

    @TestSetup
    static void makeData(){
    }
    
    @isTest
    static void validateRequestTest(){
        Test.startTest();
        RecuperaPraticheAggiornateRequest req = new RecuperaPraticheAggiornateRequest();
        System.debug(req.serviceId);
        req.serviceId ='';
        req.companyType.put('value', '');
        Boolean b = RecuperaPraticheAggiornateService.validateRequest(req);
        System.assertEquals(false, b, 'pass');
        Test.stopTest();
    }
    @isTest
    static void validateResponsetest(){
        String jsonResponse = '{"resultCode": 1,"resultMessage": "Ok"}';
        RecuperaPraticheAggiornateResponse response = (RecuperaPraticheAggiornateResponse) JSON.deserializeStrict(jsonResponse, RecuperaPraticheAggiornateResponse.class);
        Test.startTest();
       // System.debug(' response recu  elenco'+response.recuperaPraticheAggiornateResponse.elenco);
        System.debug('********* response '+response);
         Boolean b = RecuperaPraticheAggiornateService.ValidateResponse(response);
         System.assertEquals(false, b, '**** passe ***** ');
         Test.stopTest();
    }
   
   @isTest
    static void ValideResponseElenco(){
      String jsonResponse=  '{"resultCode": 0,"resultMessage": "Ok","recuperaPraticheAggiornateResponse": {"elenco": []}}';
        RecuperaPraticheAggiornateResponse response = (RecuperaPraticheAggiornateResponse) JSON.deserializeStrict(jsonResponse, RecuperaPraticheAggiornateResponse.class);
        Test.startTest();
       // System.debug(' response recu  elenco'+response.recuperaPraticheAggiornateResponse.elenco);
         System.debug('********* response '+response);
         Boolean b = RecuperaPraticheAggiornateService.ValidateResponse(response);
         System.assertEquals(false, b, '**** passe ***** ');
         Test.stopTest();
    }
    @isTest
    static void getDatatest(){
       Test.startTest();
       List<RecuperaPraticheAggiornateResponse.RecuperaPraticheAggiornateResp> result = new List<RecuperaPraticheAggiornateResponse.RecuperaPraticheAggiornateResp>();
       RecuperaPraticheAggiornateResponse.RecuperaPraticheAggiornateResp r1 = new RecuperaPraticheAggiornateResponse.RecuperaPraticheAggiornateResp();
       r1.numPratica ='1222';
       r1.statoAttuale = '20';
       r1.attributoAttuale = 'RT';
       result.add(r1);
       Map<String, RecuperaPraticheAggiornateService.ResponseWrapper> res = RecuperaPraticheAggiornateService.getData(result);
       

       Test.stopTest();
    }

}