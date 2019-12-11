@isTest
public class OCSRecuperaFasciaTassoCrifInvokerTest {

    @TestSetup
    static void setup(){   
        if(([SELECT Id FROM User WHERE Username = 'test@compass.com.test']).size()==0){
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User utenteAdmin = new User(
                FirstName= 'Test',
                LastName= 'Test',
                Username= 'test@compass.com.test',
                Email= 'test@lynxspa.com',
                Alias= 'test',
                TimeZoneSidKey= 'Europe/Rome',
                LocaleSidKey= 'it_IT',
                EmailEncodingKey= 'ISO-8859-1',
                ProfileId= p.Id,
                LanguageLocaleKey= 'en_US'
            );
            insert utenteAdmin;
        }
    }
    
    @isTest
    static void callGetFasciaTassoCrifTest(){
        User u = [SELECT Id FROM User WHERE LastName = 'Test'];
        String response = '{"resultCode":0,"resultMessage":"Ok","recuperaFasciaTassoCrifResponse":{"codFasciaTasso":"P","as400Errore":"","as400Status":"OK"}}';
        ApiRest__c testCall = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaFasciaTassoCrif',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/recuperaFasciaTassoCrif');      
        insert testCall;
        OCSRecuperaFasciaTassoCrifResponse myResponse;
        Test.startTest();
		System.runAs(u) { 
            UtilityMockResponse UMR = new UtilityMockResponse();
            UMR.apiname='ocs.recuperaFasciaTassoCrif'; 
            Test.setMock(HttpCalloutMock.class,UMR);
            myResponse = OCSRecuperaFasciaTassoCrifInvoker.callGetFasciaTassoCrif('000000');
        }
		Test.stopTest();
        System.assertEquals('P',myResponse.recuperaFasciaTassoCrifResponse.codFasciaTasso);
        System.assertEquals('OK',myResponse.recuperaFasciaTassoCrifResponse.as400Status);
        System.assertEquals('',myResponse.recuperaFasciaTassoCrifResponse.as400Errore);
    }
    
}