@isTest
public class ApiUtilsTest { 
    
    public class ApiUtilsCustomMockResponse implements HttpCalloutMock{
        public HTTPResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            String urlId = req.getEndpoint();
            String apiname='ocs.'+((OCSRequest)JSON.deserialize(req.getBody(),OCSRequest.class)).serviceId;
            res.setHeader('Content-Type', 'application/json');
            ApiRest__c ar = [select Test_Request__c, Test_Response__c from Apirest__c where endpoint__c = :urlId and name = :apiname LIMIT 1];
            system.debug(ar);
            System.assert(ar!= null, 'No rows for endpoint ' + urlId );
            System.assert(ar.Test_response__c != null, 'Missing response on test static resource.'); 
            res.setStatusCode(-900);
            res.setBody(ar.Test_Response__c);         
            return res;
        }
    }
    
    
    @isTest 
    public static void testCallApiDueParametri() {
        
        String response = '{"resultCode":0,"resultMessage":"Ok","pratiche":[{"numPratica":"800000329783","codCliente":"9529124"}],"cliente":[{"cognome":"UTMOBZE","codCliente":"9529151","nome":"LERRIO"';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDatiPostvendita',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test1;
        
        test.startTest();
        OCSRecuperaDatiPostvenditaRequest req = new OCSRecuperaDatiPostvenditaRequest(); 
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.recuperaDatiPostvendita';
        Test.setMock(HttpCalloutMock.class,UMR);
        ApiUtils.callApi('ocs.recuperaDatiPostvendita', req);
    } 
    
    @isTest 
    public static void testCallApiTreParametriMockFalse() {
        
        String response = '{"resultCode":0,"resultMessage":"Ok","pratiche":[{"numPratica":"800000329783","codCliente":"9529124"}],"cliente":[{"cognome":"UTMOBZE","codCliente":"9529151","nome":"LERRIO"';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDatiPostvendita',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test1;
        
        test.startTest();
        OCSRecuperaDatiPostvenditaRequest req = new OCSRecuperaDatiPostvenditaRequest(); 
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.recuperaDatiPostvendita';
        Test.setMock(HttpCalloutMock.class,UMR);
        ApiUtils.callApi('ocs.recuperaDatiPostvendita', req, OCSRecuperaDatiPostVenditaResponse.class);
    } 
    
    @isTest
    public static void testGetMockResponse() {
        ApiUtils.getMockResponse('ocs.recuperaDatiPostvendita');
    }
    
}