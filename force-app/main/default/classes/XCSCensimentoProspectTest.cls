@IsTest
public class XCSCensimentoProspectTest {

    private static String personRecordTypeId = RecordTypeUtil.getPersonRecordType();

    @isTest 
    public static void test1() {
        
        ApiRest__c apiRest = new ApiRest__c (
            Name = 'ocs.creaProspect',
            EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute', 
            Method__c = 'POST', 
            Mock__c = false, 
            Password__c = 'P00FLSDC',
            Ref__c = 'CompassInternal', 
            User__c = 'CDSLF00'
        );
        insert apiRest;

        ApiUtil__c apiUti = new ApiUtil__c(
            Name = 'CompassInternal', 
            EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute', 
            Password__c = 'P00FLSDC', 
            Ref__c = 'CompassInternal', 
            User__c = 'CDSLF00'
        );
        insert apiUti;
        
        test.startTest();

        Account acc1 = new Account(
            RecordTypeID = personRecordTypeId,
            FirstName = 'Test',
            LastName = 'TEST',
            PersonEmail = 'mail1@mail.com'
        );

        Account acc2 = new Account(
            RecordTypeID = personRecordTypeId,
            FirstName = 'Test2',
            LastName = 'TEST2',
            OCS_External_Id__c = '1234',
            PersonEmail = 'mail2@mail.com'
        );

        Test.setMock(HttpCalloutMock.class, new OCSCreaProspectInvokerHttpCalloutMock());

        final Map<Account,Account> accountMap = new Map<Account,Account>();
        accountMap.put(acc1, acc1);
        accountMap.put(acc2, acc2);

        XCSCensimentoProspect.censisci(accountMap);

        System.assertEquals(2, accountMap.values().size());
        
        System.debug('Acc1: ' + acc1);
        System.debug('Acc2: ' + acc2);
        System.assertEquals('C18732176', acc1.OCS_External_id__c);
        System.assertEquals('P', acc1.Status__pc);
        System.assertEquals('1234', acc2.OCS_External_id__c);
    }

    public class OCSCreaProspectInvokerHttpCalloutMock implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest request) {
            // Create a fake response
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"resultCode": 0,"resultMessage": "Ok","datiCreaProspectResponse": {"codiceAnagrafico": "18732176","flagAnagraficaEsistente": "S","as400Status": "","as400Errore": ""}}');
            response.setStatusCode(200);
            return response; 
        }
    }

}