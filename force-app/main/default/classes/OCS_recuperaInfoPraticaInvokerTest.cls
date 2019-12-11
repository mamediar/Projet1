@isTest
public class OCS_recuperaInfoPraticaInvokerTest {
      @isTest
    public static void test() {
        
       
        String responseInfoPratica ='{"resultMessage":"Ok","resultCode":0,"recuperaInfoPraticaResponse":{"telaio":"","targa":"EP770GD ","prodotto":"1U","marcaModello":"AF A29","descrizioneBene":"GIULIETTA","annoMeseImmatricolazione":"20121001"}}'; 
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c=responseInfoPratica ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaInfoPratica',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test2;     
        
        
        OCS_recuperaInfoPraticaRequest re = new  OCS_recuperaInfoPraticaRequest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.recuperaInfoPratica';
        Test.setMock(HttpCalloutMock.class,UMR);
    
        OCS_recuperaInfoPraticaInvoker.callAggiornaDati(re);
        OCS_recuperaInfoPraticaInvoker.callAggiornaDati('800000329783');
        
        
    }
    

}