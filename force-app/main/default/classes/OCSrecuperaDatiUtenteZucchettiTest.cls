@isTest
public class OCSrecuperaDatiUtenteZucchettiTest {
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
    static void callRecuperaDatiUtenteZucchettiTest(){
        User u = [SELECT Id FROM User WHERE LastName = 'Test'];
        String response = '{"resultCode":0,"resultMessage":"Ok","recuperaDatiUtenteZucchettiResponse":{"codFiscale":"x","idCompany":"xx","idEmploy":"xxx","username":"xxxx","tipoAuto":"A","modelloAuto":"FairladyZ"}}';
        ApiRest__c testCall = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDatiUtenteZucchetti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/recuperaDatiUtenteZucchetti');
        insert testCall;
        OCSrecuperaDatiUtenteZucchettiResponse.recuperaDatiUtenteZucchettiResponse datiZucchetti;
        Test.startTest();
		System.runAs(u) { 
            UtilityMockResponse UMR = new UtilityMockResponse();
            UMR.apiname='ocs.recuperaDatiUtenteZucchetti'; 
            Test.setMock(HttpCalloutMock.class,UMR);
            OCSrecuperaDatiUtenteZucchettiResponse myResponse = OCSrecuperaDatiUtenteZucchettiInvoker.callRecuperaDatiUtenteZucchetti('CU1518');
            System.debug(myResponse);
            datiZucchetti = myResponse.recuperaDatiUtenteZucchettiResponse; 
        }
		Test.stopTest();
        System.assertEquals('x',datiZucchetti.codFiscale);
        System.assertEquals('xx',datiZucchetti.idCompany);
        System.assertEquals('xxx',datiZucchetti.idEmploy);
        System.assertEquals('xxxx',datiZucchetti.username);
        System.assertEquals('A',datiZucchetti.tipoAuto);
        System.assertEquals('FairladyZ',datiZucchetti.modelloAuto);
    }
}