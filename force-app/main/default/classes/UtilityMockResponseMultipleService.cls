/**
 * @File Name          : UtilityMockResponseMultipleService.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 23/10/2019, 15:30:31
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    23/10/2019   Federico Negro     Initial Version
**/
@isTest
public class UtilityMockResponseMultipleService implements HttpCalloutMock
{
	public List<String> apinameList;
	public Map<String,Integer> statusCodeMap;
	public Exception exceptionObj = null;
	Map<String,List<String>> serviceIdResponseMap=null;
	Map<String,Integer> mapCounter=new Map<String,Integer>();
    
	public UtilityMockResponseMultipleService(Map<String,List<String>> serviceIdResponseMap){
		this.serviceIdResponseMap = serviceIdResponseMap;
		for(String key : serviceIdResponseMap.keySet()) 	mapCounter.put(key,0);
		
	} 
	public UtilityMockResponseMultipleService(Map<String,List<String>> serviceIdResponseMap, Map<String,Integer> statusCodeMap){
		this.serviceIdResponseMap = serviceIdResponseMap;
		this.statusCodeMap = statusCodeMap;
	} 

	public UtilityMockResponseMultipleService(String apinameList){
		this.apinameList = new List<String>{apinameList};
	} 
	public UtilityMockResponseMultipleService(List<String> apinameList){
		this.apinameList = apinameList;
	} 
	public UtilityMockResponseMultipleService(List<String> apinameList,Map<String,Integer> statusCodeMap){
		this.apinameList = apinameList;
		this.statusCodeMap = statusCodeMap;
	} 
    public HTTPResponse respond (HTTPRequest req)
    {
		String serviceId='';
        if(exceptionObj != null)
        {
            throw exceptionObj;
        }
        HttpResponse res = new HttpResponse();
        String urlId = req.getEndpoint();     
		res.setHeader('Content-Type', 'application/json');
		ApiRest__c ar;
        System.debug('### serviceIdResponseMap : '+serviceIdResponseMap);
		if(serviceIdResponseMap==null){
			System.debug('### API NAME LIST : '+apinameList);
            System.debug('### URL ID : '+urlId);
            System.debug('### REQ BODY : '+req.getBody());
        	ar = [select Name, Test_Request__c, Test_Response__c from Apirest__c where endpoint__c = :urlId and name = :apinameList LIMIT 1];
            System.debug('### query: '+ar);
        	res.setStatusCode(statusCodeMap != null && statusCodeMap.containsKey(ar.Name) ? statusCodeMap.get(ar.Name): 200);
		}
		else {			
			OCSRequest ocsReq=(OCSRequest) JSON.deserialize(req.getBody(), OCSRequest.class);
			serviceId=ocsReq.serviceId;			
			res.setStatusCode(statusCodeMap != null && statusCodeMap.containsKey(serviceId) ? statusCodeMap.get(serviceId): 200);
			mapCounter.put(serviceId,mapCounter.get(serviceId)+1);
		}
        system.debug('***MRMS_serviceId :'+ serviceId);
        system.debug('***MRMS_mapCounter :'+ mapCounter.get(serviceId));
        //system.debug('***MRMS_serviceIdResponseMap.size :'+ serviceIdResponseMap.get(serviceId).size());
		String body=(serviceIdResponseMap!=null) ? serviceIdResponseMap.get(serviceId)[mapCounter.get(serviceId)-1]:ar.Test_Response__c ;
	
        res.setBody(body);         
        
        return res;  
    }
}