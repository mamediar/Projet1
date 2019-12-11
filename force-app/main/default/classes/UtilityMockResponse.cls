public class UtilityMockResponse implements HttpCalloutMock
{
	public String apiname;
    public HTTPResponse respond (HTTPRequest req)
    {
        HttpResponse res = new HttpResponse(); 
        String urlId = req.getEndpoint();     
    	//System.assert(urlId != null, 'API endpoint missing.');
		res.setHeader('Content-Type', 'application/json');
        System.debug('APINAME:::::::::::::> ' + apiname);
        ApiRest__c ar = [select Test_Request__c, Test_Response__c from Apirest__c where endpoint__c = :urlId and name = :apiname LIMIT 1];
     	system.debug(ar);
      	System.assert(ar!= null, 'No rows for endpoint ' + urlId );
        System.assert(ar.Test_response__c != null, 'Missing response on test static resource.'); 
       // System.assertEquals(ar.Test_Request__c, req.getBody());
        res.setStatusCode(200);
        res.setBody(ar.Test_Response__c);         
        
        return res;  
    }
}