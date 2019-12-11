@isTest
public class OCSrecuperaTimbratureZucchettiTest {
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
    static void callRecuperaTimbratureZucchettiTest(){
        User u = [SELECT Id FROM User WHERE LastName = 'Test'];
        String response = '{"resultCode":0,"resultMessage":"Ok","recuperaTimbratureZucchettiResponse":{"elencoTimbrature":[{"giorno":"2017-11-06","ora":"09:25","verso":"x","ordinamento":"xx"}]}}';
        ApiRest__c testCall = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaTimbratureZucchetti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/recuperaTimbratureZucchetti');
        insert testCall;
        OCSrecuperaTimbratureZucchettiResponse.recuperaTimbratureZucchettiResponse timbratureZucchetti;
        Test.startTest();
		System.runAs(u) {
            UtilityMockResponse UMR = new UtilityMockResponse();
            UMR.apiname='ocs.recuperaTimbratureZucchetti'; 
            Test.setMock(HttpCalloutMock.class,UMR);
            OCSrecuperaTimbratureZucchettiResponse myResponse = OCSrecuperaTimbratureZucchettiInvoker.callrecuperaTimbratureZucchetti('x','x',Date.today());
            System.debug(myResponse);
            timbratureZucchetti = myResponse.recuperaTimbratureZucchettiResponse; 
        }
		Test.stopTest();
        System.assertEquals('x',timbratureZucchetti.elencoTimbrature[0].verso);
        System.assertEquals('xx',timbratureZucchetti.elencoTimbrature[0].ordinamento);
        System.assertEquals('2017-11-06',timbratureZucchetti.elencoTimbrature[0].giorno);
        System.assertEquals(Time.newInstance(8, 25, 0, 0),timbratureZucchetti.elencoTimbrature[0].ora);
    }
}