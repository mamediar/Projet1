@isTest
public  class RecuperaStatiAttributiPrtRequestTest {
         @isTest   static void testRequest(){
               Test.startTest();
               String jsonString = '{"serviceId" : "recuperaStatiAttributiPrt","companyType" : { "value" : "COMPASS"},"recuperaStatiAttributiPrtRequest" : {"elencoPratiche" : [ {"tipoPratica" : "CA","numPratica" : "33190097388","statoPratica" : null,"attributoPratica" : null,"canale" : null} ]}}';

               RecuperaStatiAttributiPrtRequest rest = (RecuperaStatiAttributiPrtRequest) JSON.deserializeStrict(jsonString, RecuperaStatiAttributiPrtRequest.class);

               System.debug(rest.serviceId);
      

               Test.stopTest();
     }

}