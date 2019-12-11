@isTest
public class GestioneFaxLettereInviateControllerTest {
    
    @isTest
    public static void testGetComunicazioni() { 
        
        //Testato con i dati della MOCK RESPONSE
        //
        Profile p = [SELECT Id FROM Profile WHERE Name='Call Center'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName='standt123123223@f.com');
        System.runAs(u) {
            
            
            
            String responseApi = '{ "resultCode": 0, "resultMessage": "Ok", "recuperaLettereFaxHostResponseDTO": { "elencoLettere": [{ "procedura" : "CO"}]}}';
            
            ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,
                                              Test_Response__c= responseApi,
                                              Test_Request__c = 'testRequest',
                                              Mock__c = false,
                                              User__c = 'CDSLF00',
                                              Password__c = 'P00FLSDC' ,
                                              Name ='ocs.recuperaLettereFaxHost',
                                              EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
            insert test1;
            
            test.startTest();
            UtilityMockResponse UMR = new UtilityMockResponse();
            UMR.apiname='ocs.recuperaLettereFaxHost';
            Test.setMock(HttpCalloutMock.class,UMR);
            GestioneFaxLettereInviateController.getComunicazioni(' ', ' ', '11781111');
            test.stopTest();
            
        }
    }
    
}