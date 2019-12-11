@isTest
public class OCSRecuperaDelinquencyInvokerTest {

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
    static void callGetDelinquencyWithParamsTest(){
        User u = [SELECT Id FROM User WHERE LastName = 'Test'];
        String response = '{"resultCode":0,"resultMessage":"Ok","recuperaDelinquencyResponse":{"currentDelinquencyCliente":"0","maxDelinquencyCliente":"2","elencoPratiche":[{"tipoPratica":"CA","numPratica":"4239596","currentDelinquency":"0","maxDelinquency":"0"}]}}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDelinquency',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
        insert test1;
        OCSRecuperaDelinquencyResponse.recuperaDelinquencyResponse datiDelinquency;
        Test.startTest();
		System.runAs(u) {
            UtilityMockResponse UMR = new UtilityMockResponse();
            UMR.apiname='ocs.recuperaDelinquency';
            Test.setMock(HttpCalloutMock.class,UMR);
            OCSRecuperaDelinquencyResponse myResponse = OCSRecuperaDelinquencyInvoker.callGetDelinquency('8180824247');
            datiDelinquency = myResponse.recuperaDelinquencyResponse; 
        }
		Test.stopTest();
        System.assertEquals(1,datiDelinquency.elencoPratiche.size());
        System.assertEquals('4239596',datiDelinquency.elencoPratiche[0].numPratica);
        System.assertEquals('0', datiDelinquency.currentDelinquencyCliente);
        System.assertEquals('2', datiDelinquency.maxDelinquencyCliente);
        System.assertEquals('CA', datiDelinquency.elencoPratiche[0].tipoPratica);
        System.assertEquals('0', datiDelinquency.elencoPratiche[0].currentDelinquency);
        System.assertEquals('0', datiDelinquency.elencoPratiche[0].maxDelinquency);
    }

    @isTest
    static void callGetDelinquencyTest(){
        User u = [SELECT Id FROM User WHERE LastName = 'Test'];
        String response = '{"resultCode":0,"resultMessage":"Ok","recuperaDelinquencyResponse":{"currentDelinquencyCliente":"0","maxDelinquencyCliente":"2","elencoPratiche":[{"tipoPratica":"CA","numPratica":"4239596","currentDelinquency":"0","maxDelinquency":"0"}]}}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDelinquency',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
        insert test1;
        OCSRecuperaDelinquencyResponse.recuperaDelinquencyResponse datiDelinquency;
        Test.startTest();
		System.runAs(u) {
            UtilityMockResponse UMR = new UtilityMockResponse();
            UMR.apiname='ocs.recuperaDelinquency';
            Test.setMock(HttpCalloutMock.class,UMR);
            OCSRecuperaDelinquencyResponse myResponse = OCSRecuperaDelinquencyInvoker.callGetDelinquency('8180824247', 'CA', '4239596');
            datiDelinquency = myResponse.recuperaDelinquencyResponse; 
        }
		Test.stopTest();
        System.assertEquals(1,datiDelinquency.elencoPratiche.size());
        System.assertEquals('4239596',datiDelinquency.elencoPratiche[0].numPratica);
    }


}