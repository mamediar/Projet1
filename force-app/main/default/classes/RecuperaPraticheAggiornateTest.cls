@isTest 
public class RecuperaPraticheAggiornateTest {

    @TestSetup
    static void makeData(){
        String response = '{"resultCode": 0,"resultMessage": "Ok","recuperaPraticheAggiornateResponse": {"elenco": [{"numPratica": "18866725","statoAttuale": "20","attributoAttuale": "RT","dataUltimoAggiornamento": "20180525","oraUltimoAggiornamento": "22552902"}]}}';
         ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,
                                           Test_Response__c= response ,
                                           Test_Request__c = 'testRequest',
                                            Mock__c = false, 
                                            User__c = 'CDSLF00',
                                            Password__c = 'P00FLSDC' ,
                                            Name ='recuperaPraticheAggiornate',
                                            EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
         
           insert test2;  
           System.debug(' ************** test2 '+test2);

    }
    @isTest static void testInvoker(){
        
        Test.startTest();
        
  /* String jsonString = '{"serviceId" : "recuperaPraticheAggiornate", "companyType" : {"value" : "COMPASS"},"recuperaPraticheAggiornateRequest" : {"dataInizio" : "20180516","oraInizio" : "000000","filtroPartner" : "DS"}}';
   RecuperaPraticheAggiornateRequest requete = (RecuperaPraticheAggiornateRequest) JSON.deserializeStrict(jsonString, RecuperaPraticheAggiornateRequest.class); */
  
    UtilityMockResponse UMR = new UtilityMockResponse();
    UMR.apiname='recuperaPraticheAggiornate';
    Test.setMock(HttpCalloutMock.class,UMR);
      RecuperaPraticheAggiornateResponse response = RecuperaPraticheAggiornateInvoker.build_recuperaPraticheAggiornateRequest('20180516', '000000', 'DS');
      System.debug('********** response invoker '+ response);
      System.debug('********** response statusCode '+ response.resultCode);
      System.debug('********** response statusCode '+ response.recuperaPraticheAggiornateResponse.elenco);
      System.debug('***************** size '+response.recuperaPraticheAggiornateResponse.elenco.size());
      System.assert(response.recuperaPraticheAggiornateResponse.elenco.size()  > 0);
       System.assertEquals( response.recuperaPraticheAggiornateResponse.elenco[0].numPratica,'18866725');
     System.assertEquals(response.recuperaPraticheAggiornateResponse.elenco[0].statoAttuale,'20' );
      System.assertEquals(response.recuperaPraticheAggiornateResponse.elenco[0].attributoAttuale,'RT');
    Test.stopTest();
    
        
    }
    

}