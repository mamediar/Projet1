@isTest
public class CalcolaDistanzeInvokerTest {

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
        
        String response = '{"resultCode":0,"resultMessage":"Ok","calcolaDistanzeResponse":{"esitoCalcolo":"OK","distanzaTotale":"47222","elencoParziali":[{"partenza":"Via Caldera","arrivo":"Piazzetta Enrico Cuccia","distanza":"8609"}]}}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.calcolaDistanze',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute/calcolaDistanze');      
        insert test1;
        CalcolaDistanzeRequest request = new CalcolaDistanzeRequest();
        CalcolaDistanzeResponse myResponse;
        
        Test.startTest();
		System.runAs(u) {
            UtilityMockResponse UMR = new UtilityMockResponse();
            UMR.apiname='ocs.calcolaDistanze';
            Test.setMock(HttpCalloutMock.class,UMR);
                       
			request.calcolaDistanzeRequest = new CalcolaDistanzeRequest.CalcolaDistanzeRequestInner();
			request.calcolaDistanzeRequest.indirizzoFiliale = 'Via Caldera 21 Milano';
			request.calcolaDistanzeRequest.elencoIndirizziIntermedi = new List<String>{'Piazzale loreto 1 Milano','Piazzetta cuccia 1 Milano','Via Siusi 7 Milano'};

            
            myResponse = CalcolaDistanzeInvoker.invoke(request);
        }
		Test.stopTest();

        System.assertEquals('OK',myResponse.calcolaDistanzeResponse.esitoCalcolo);
        System.assertEquals('47222',myResponse.calcolaDistanzeResponse.distanzaTotale);
        System.assertEquals('Via Caldera',myResponse.calcolaDistanzeResponse.elencoParziali[0].partenza);
        System.assertEquals('Piazzetta Enrico Cuccia',myResponse.calcolaDistanzeResponse.elencoParziali[0].arrivo);
        System.assertEquals('8609',myResponse.calcolaDistanzeResponse.elencoParziali[0].distanza);
        
    }
    
}