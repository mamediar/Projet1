public  class OCSApiUtils {

    
    
    // Utilizzare il metodo con 4 parametri, company da impostare a F per Futuro, C per Compass.
    //DA CHIARIRE: in realtà non sembrano esserci servizi con stesso id tra Compass e Futuro
    public static APIResponse callApi(String nomeApi, APIRequest request, Type respClass){
        return callApi(nomeApi,request,respClass,'C');
    }

// company da impostare a F per Futuro, C per Compass
    public static APIResponse callApi(String nomeApi, APIRequest request, Type respClass, String company){
        ApiRest__c apiObj = ApiRest__c.getValues(company.equals('C')?nomeApi:nomeApi+'.futuro');
       
        System.debug('************ ApiRest__c'+apiObj);
        if(company.equals('F')){
            ((OCSRequest)request).companyType.put('value','FUTURO');
        }
        System.debug('############## requete '+request);
        HTTP h = new HTTP();
        HTTPRequest req = new HTTPRequest();
        System.debug('************ HTTPRequest'+req);
        req.setTimeout(XCSCompassConstants.TIMEOUT);
        req.setHeader('Content-Type', 'application/json');
        System.debug('###################  paasword ' +apiObj.password__c );
         System.debug('###################  user  ' +apiObj.user__c );
        if(!String.isEmpty(apiObj.user__c) && !String.isEmpty(apiObj.password__c)){
            Blob headerValue = Blob.valueOf(apiObj.user__c + ':' + apiObj.password__c);
            String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
            
        	req.setHeader('Authorization', authorizationHeader);                        
            System.debug('--authorizationHeader: '+authorizationHeader);            
        }
        if(request != null){
            if (apiObj.method__c == 'GET') {
                Map<String, String> parametri = request.getParametri();
                System.debug('#################  endpoint__c '+apiObj.endpoint__c);
                System.debug('#################  parametri '+parametri);
                String fullUrl = request.getFullUrl(parametri, apiObj.endpoint__c);
                req.setEndpoint(fullUrl);
                System.debug('Full endPoint: ' + fullUrl);
            }
            else {
                 System.debug('********** POST Methode*****: '+req.getBody());
                req.setEndpoint(apiObj.endpoint__c);
                req.setBody(JSON.serialize(request));
                System.debug('Api Request: '+req.getBody());
            }
            
        }
        req.setMethod(apiObj.method__c);
		APIResponse res=(APIResponse)respClass.newInstance();
        Map<String, CompassSerializer> serializerMap = new Map<String, CompassSerializer>();
        System.debug('##############################  test test test '+ res);
        serializerMap.put('application/json', new CompassJSONSerializer());
        serializerMap.put('text/xml', new XMLSerializerGenerique());
        System.debug('***** requete '+req);
         System.debug('***** xxxxxxxxxxxxxxxxxxxxxxxxxx apiObj.mock__c '+apiObj.mock__c);
       // apiObj.mock__c = false; 
        if(!apiObj.mock__c){
            try{
                System.debug('***** requete '+req);
                HTTPResponse resp = h.send(req);
            	//TODO controllo da fare su statuscode
            	System.debug('API Response: '+resp);
                System.debug('API Response body xxx : '+resp.getBody());
                System.debug('############ resp.getHeader '+resp.getHeader('Content-Type'));
                 System.debug('############ resp.getHeader  respClass '+respClass);
                res = (APIResponse) (serializerMap.get(resp.getHeader('Content-Type'))).deserialize(resp, respClass);
            	res.status=resp.getStatus();
            	res.statusCode=resp.getStatusCode();
            }
            catch(Exception e){
                res.statusCode=-900;
            	res.status=e.getMessage();
                System.debug('################  res.status'+res.status);
            }
        }else{ 
            System.debug('*************** else apiObj.mock__c '+apiObj.mock__c);
            res=(APIResponse)JSON.deserialize(getMockResponse(apiObj.Name),respClass);
            res.statusCode=200;
            res.status='OK';
        }
        return res; 
    }
    
    public static String getMockResponse( String key )
    { 
         StaticResource sr = [SELECT Id, body, NamespacePrefix,SystemModstamp FROM StaticResource WHERE Name = 'MockResponse' LIMIT 1];
        if ( sr == null ) return null;
        
        String prefix = sr.NamespacePrefix;
        System.debug('******** prefix '+prefix);
        if( String.isEmpty(prefix) ) {
            prefix = '';
        } else {
            prefix += '__';
        }
        String srPath = '/resource/' + sr.SystemModstamp.getTime() + '/' + prefix + 'MockResponse/response/' + key + '.json';
        System.debug('******** srPath '+srPath);
          PageReference pg;
        try {
             pg = new PageReference( srPath );
             String res_json_body = pg.getContent().toString();
        //     System.debug('********** contenuuuuuuu '+res_json_body);
            
        } catch (Exception e) {
            System.debug('************ '+e.getMessage());
        }
        
        if(Test.isRunningTest() )
           return  null;
           // return null;
          String body = pg.getContent().toString();
           System.debug('************* content xxx  '+body); 
     
           return body;
    }
    
}