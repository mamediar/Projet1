@isTest
public class NotaSpeseZucchettiInvokerTest {

    @TestSetup
    static void setup(){   
        if(([SELECT Id FROM User WHERE Username = 'test@compass.com.test']).size()==0){
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User utenteAdmin = new User(
                FirstName= 'TestAdmin',
                LastName= 'TestAdmin',
                Username= 'testadmin@compass.com.test',
                Email= 'testadmin@lynxspa.com',
                Alias= 'testad',
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
    static void invokeTest() {
        User u = [SELECT Id FROM User WHERE LastName = 'TestAdmin']; 
        
        String response = '{"resultCode":20,"resultMessage":"Service creaNotaSpeseZucchetti is unavailable."}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.creaNotaSpeseZucchetti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test1;
        NotaSpeseZucchettiRequest request = new NotaSpeseZucchettiRequest();
        NotaSpeseZucchettiResponse myResponse;
        
        Test.startTest();
		System.runAs(u) {
            UtilityMockResponse UMR = new UtilityMockResponse();
            UMR.apiname='ocs.creaNotaSpeseZucchetti';
            Test.setMock(HttpCalloutMock.class,UMR);
           
            request.codiceUtente = 'CU6654';
			request.panno = '2018.0';
			request.pmese = '2.0';
			request.ptiporimb = '1.0';
			request.pdistanza = '50.0';
            request.pcodestrdl = '';
			request.pcodestsub = '';
			request.pcodfiscale = '';
			request.pidstateini = '';
			request.pidcityini = '';
			request.pdataini = '';
			request.poraini = '';
			request.pidstatefin = '';
			request.pidcityfin = '';
			request.pdatafin = '';
			request.porafin = '';
			request.pmotitr = '';
			request.pdefore = '';
			request.pannotazioni = '';
			request.pitinerario = '';
			request.ptipoauto = '';
			request.pmodauto = '';
			request.pantarga = '';
			request.pnotekm = '';
            
            myResponse = NotaSpeseZucchettiInvoker.invoke(request);
        }
		Test.stopTest();

        System.assertEquals('20',myResponse.resultCode);
        System.assertEquals('Service creaNotaSpeseZucchetti is unavailable.',myResponse.resultMessage);
    }
    
}