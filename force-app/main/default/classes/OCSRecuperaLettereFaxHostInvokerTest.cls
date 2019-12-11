@isTest
public class OCSRecuperaLettereFaxHostInvokerTest {
    
    @isTest
    public static void testInvokerTreParametri() {
        
        String responseApi = '{ "resultCode": 0, "resultMessage": "Ok", "recuperaLettereFaxHostResponseDTO": { "elencoLettere": [{"procedura": "CO"}]}}';
        
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
        OCSRecuperaLettereFaxHostInvoker.recuperaLettereFaxHost('', '', '11781111');
        System.debug('ELENCOLETTERE:::>  ' + OCSRecuperaLettereFaxHostInvoker.recuperaLettereFaxHost('', '', '11781111').recuperaLettereFaxHostResponseDTO.elencoLettere);
        test.stopTest();
    }
    
    @isTest 
    public static void testInvokerQuattroParametri() {
        
        String responseApi = '{ "resultCode": 0, "resultMessage": "Ok", "recuperaLettereFaxHostResponseDTO": { "elencoLettere": [{"procedura": "CO"}]}}';
        
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
        Datetime tryDate = Datetime.newInstanceGmt(19, 2, 26, 11, 30, 30);
        OCSRecuperaLettereFaxHostInvoker.recuperaLettereFaxHost('', '', '11781111',tryDate);
        System.debug('ELENCOLETTERE:::>  ' + OCSRecuperaLettereFaxHostInvoker.recuperaLettereFaxHost('', '', '11781111'));
        test.stopTest();
    }
    
    
}