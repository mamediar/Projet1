@isTest
public class OCSGestioneNoteInvokerTest {
    
    
    @isTest
    static void test(){
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='{"resultCode":0,"resultMessage":"Ok",OCSGestioneNoteResponse":{"as400Status":"Ok","as400Errore":""}}',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.gestioneNote',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test1;
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.gestioneNote';
        Test.setMock(HttpCalloutMock.class,UMR);
        OCSGestioneNoteResponse note = OCSGestioneNoteInvoker.gestioneNote('','','66161310104','CA','A','P','vendita');
        OCSGestioneNoteInvoker.filtraNote('','','343434','','', '', 'okkk');
        test.stopTest();
    }
    
    
    
}