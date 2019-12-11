//----------------------------------------------------------------------
//-- - Class Name   : ApiUtils2 
//-- - Autor        : Fabio Giuliani(Lynx)
//-- - Date         : 02/05/2019
//-- - Description  : Classe per la gestione delle chiamate REST
//-- - Version      : 1.0
//-- - NOTE         : Il nome nell'intestazione viene lasciato come ApiUtils2
//                      per ricordare che è stata modificata
//----------------------------------------------------------------------

public class ApiUtils {
    // Deprecato. Utilizzare il metodo con 3 parametri per Compass e quello con 4 per Futuro.
    public static String callApi(String nomeApi, Object request){
        system.debug('-------------------------------------------------------');
        system.debug('-- - Class Name: ApiUtils -- - Method Name: callApi con 2 parametri   '); 
        system.debug('-- - Var Name: nomeApi     Value: ' + nomeApi); 
        system.debug('-- - Var Name: request     Value: ' + request); 
        system.debug('-------------------------------------------------------'); 

        String response = '';
        
        ApiRest__c apiObj = ApiRest__c.getValues(nomeApi);
        system.debug('-- - debug prova 1 '+apiObj);
        system.debug('-- - debug ref__c '+apiObj.Ref__c);
        ApiUtil__c apiUti = ApiUtil__c.getvalues(apiObj.Ref__c);
        system.debug('-- - debug prova 2 '+apiUti);
          
        HTTP h = new HTTP();
        HTTPRequest req = new HTTPRequest();

//        req.setEndpoint(apiObj.Endpoint__c);
        req.setEndpoint(apiUti.Endpoint__c);
        req.setHeader('Content-Type', 'application/json');
//        if(!String.isEmpty(apiObj.user__c) && !String.isEmpty(apiObj.password__c)){
        if(!String.isEmpty(apiUti.user__c) && !String.isEmpty(apiUti.password__c)){
//            Blob headerValue = Blob.valueOf(apiObj.user__c + ':' + apiObj.password__c);
            Blob headerValue = Blob.valueOf(apiUti.user__c + ':' + apiUti.password__c);
            String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
            System.debug('--authorizationHeader: '+authorizationHeader);
            req.setHeader('Authorization', authorizationHeader);
        }
        if(request != null){
            req.setBody(JSON.serialize(request));
            System.debug('REQUEST BODY TEST' + req.getBody());
        }

        req.setMethod(apiObj.method__c);
        system.debug(req);
        if(!apiObj.mock__c){
            HTTPResponse resp = h.send(req);
            System.debug(resp.getBody() + '-------' + resp.getStatus() + '-----------' + resp.getStatusCode());
            //TODO controllo da fare su statuscode
            if(resp.getStatusCode() == 200){ 
                response = resp.getBody(); 
            }else{
                System.debug('Si è verificato un errore nella chiamata nell API ' + nomeApi);
            }
        }else{ 
            response = getMockResponse(apiObj.Name);
        }
        return response;
    }
    
    
    public static APIResponse callApi(APIRequest request, Type respClass, String company ){
        return callApi('ocs.variazioneTelefoni',request,respClass,company);
    }
    
    /*
    public static APIResponse callApi(String nomeApi, Object request, Type respClass){
        return callApi(nomeApi,request,respClass,'C');
    }*/
    
    // Utilizzare il metodo con 4 parametri, company da impostare a F per Futuro, C per Compass.
    //DA CHIARIRE: in realtà non sembrano esserci servizi con stesso id tra Compass e Futuro
    public static APIResponse callApi(String nomeApi, APIRequest request, Type respClass){
        return callApi(nomeApi,request,respClass,'C');
    }

// company da impostare a F per Futuro, C per Compass
    public static APIResponse callApi(String nomeApi, APIRequest request, Type respClass, String company){
        system.debug('-------------------------------------------------------');
        system.debug('-- - Class Name: ApiUtils2 -- - Method Name: callApi   '); 
        system.debug('-- - Var Name: nomeApi     Value: ' + nomeApi); 
        system.debug('-- - Var Name: request     Value: ' + request); 
        system.debug('-- - Var Name: respClass   Value: ' + respClass); 
        system.debug('-- - Var Name: company     Value: ' + company); 
        
// LASCIO COMUNQUE LA CHIAMATA AL CUSTOM SETTING PER PRENDERE IL VALORE DEL METODO    FG    
        ApiRest__c apiObj = ApiRest__c.getValues(company.equals('C')?nomeApi:nomeApi+'.futuro');
        
        ApiUtil__c apiUti = ApiUtil__c.getvalues(apiObj.Ref__c);
                                                 
        if (company.equals('F')){ // ESEGUO QUERY DIVERSE IN BASE ALLA TIPOLOGIA DELLA COMPANY Compass FG
            ((OCSRequest)request).companyType.put('value','FUTURO');
        }
        
        system.debug('-------------------------------------------------------');
        system.debug('-- - Class Name: ApiUtils2 -- - Method Name: callApi   '); 
        system.debug('-- - Var Name: EndPoint__c     Value: ' + apiUti.EndPoint__c); 
        system.debug('-- - Var Name: User__c         Value: ' + apiUti.User__c); 
        system.debug('-- - Var Name: Pwd__c          Value: ' + apiUti.Password__c); 

        HTTP h = new HTTP();
        HTTPRequest req = new HTTPRequest();
        req.setTimeOut(120000);
        req.setHeader('Content-Type', 'application/json');
//        if(!String.isEmpty(apiObj.user__c) && !String.isEmpty(apiObj.password__c)){
//            Blob headerValue = Blob.valueOf(apiObj.user__c + ':' + apiObj.password__c);
//            USO I VALORI CHE MI PRENDO DAL CUSTOM OBJECT NUOVO
        if(!String.isEmpty(apiUti.user__c) && !String.isEmpty(apiUti.Password__c)){
            Blob headerValue = Blob.valueOf(apiUti.user__c + ':' + apiUti.Password__c);
            String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
            
            req.setHeader('Authorization', authorizationHeader);                        
            System.debug('--authorizationHeader: '+authorizationHeader);            
        }
        if(request != null){
            if (apiObj.method__c == 'GET') {
                Map<String, String> parametri = request.getParametri();
                String fullUrl = request.getFullUrl(parametri, apiUti.endpoint__c);// USO VALORE CUSTOM OBJECT NUOVO
                req.setEndpoint(fullUrl);
                System.debug('Full endPoint: ' + fullUrl);
            }
            else {
                req.setEndpoint(apiUti.endpoint__c);
                req.setBody(JSON.serialize(request));
                System.debug('Api Request: '+req.getBody());
            }
            
        }
        req.setMethod(apiObj.method__c);
        APIResponse res=(APIResponse)respClass.newInstance();
        Map<String, CompassSerializer> serializerMap = new Map<String, CompassSerializer>();
        serializerMap.put('application/json', new CompassJSONSerializer());
        serializerMap.put('text/xml', new CompassXMLSerializer());
        if(!apiObj.mock__c){
        //   try{ 
                system.debug('-----------------------------------------------------------------');
                system.debug(req.toString());
                system.debug(req);
                HTTPResponse resp = h.send(req);
                //TODO controllo da fare su statuscode
                System.debug('API Response: '+resp);
                System.debug('API Response body: '+resp.getBody());
                res = (APIResponse) (serializerMap.get(resp.getHeader('Content-Type'))).deserialize(resp, respClass);
                res.status=resp.getStatus();
                res.statusCode=resp.getStatusCode();
         /*    }
           catch(Exception e){ 
                system.debug(e);
                res.statusCode=-900;
                res.status=e.getMessage();
            }*/
        
        }
        else{ 
            res=(APIResponse)JSON.deserialize(getMockResponse(apiObj.Name),respClass);
            res.statusCode=200;
            res.status='OK';
        }
        return res; 
    }
    
    public static String getMockResponse( String key )
    { 
        system.debug('---------------------------------------------------------------');
        system.debug('-- - Class Name: ApiUtils2 -- - Method Name: getMockResponse   '); 

        StaticResource sr = [SELECT Id,NamespacePrefix,SystemModstamp FROM StaticResource WHERE Name = 'MockResponse' LIMIT 1];
        
        system.debug('RISULTATO STATIC RESOURCE ----> '+sr);
        
        if ( sr == null ) return null;
        
        String prefix = sr.NamespacePrefix;
        if( String.isEmpty(prefix) ) {
            prefix = '';
        } else {
            prefix += '__';
        }

        String srPath = '/resource/' + sr.SystemModstamp.getTime() + '/' + prefix + 'MockResponse/response/' + key + '.json';
        PageReference pg = new PageReference( srPath );
      
       if ( Test.isRunningTest() )
            return null;
        
        String body = pg.getContent().toString();
        
        system.debug('(**) Mocked Response: ' + body );
        
        return body;
    }


    // funzione per restituire la response in XML per un servizio REST 
   // quando content Type è 'application/XML', in JSON quando content Type 
   // è 'application/JSON'
   public static RestResponse  serializeResponse(RestResponse restResponse, RestRequest restRequest, Object obj){
        String contentType = restRequest.headers.get('Content-Type') ;
        restResponse.statusCode = 200;
        XMLSerializer xmlserializer = new XMLSerializer();
        // setto la response in XML
        String body =  '<response>'+xmlserializer.serialize(obj)+'</response>';
        // se la request è un JSON, la response diventa un JSON
        if(contentType!=null && contentType.toUpperCase().contains('JSON')){
            body = xmlserializer.XMLToJSON(body);
        }
        restResponse.responseBody = Blob.valueOf(body);
        System.debug('restResponse.responseBody:'+restResponse.responseBody);
        return restResponse;
   }    

}