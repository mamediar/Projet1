public with sharing class AppuntamentoListaFilialiService{

    public AppuntamentoListaFilialiResponse buildAppuntamentoListaFiliali( String  societa,String  utenteEsterno,String  utenteInterno, String prodotoName){
          
       AppuntamentoListaFilialiResponse response;
       AppuntamentoListaFilialiRequest request = new AppuntamentoListaFilialiRequest();
      
        String q = societa+','+utenteEsterno+','+utenteInterno+',italia';
        String prodotto = prodotoName;
        AppuntamentoListaFilialiRequest req = new AppuntamentoListaFilialiRequest(q,prodotto);
        req.serviceId = 'locator' ;
        req.companyType.put('value', 'COMPASS');
     /*  request.societa = societa;
       request.utenteEsterno = utenteEsterno;
       request.utenteInterno = utenteInterno;  */
       response = invoker(req);
       return response; 
    }

    public AppuntamentoListaFilialiResponse invoker(AppuntamentoListaFilialiRequest request){
       // AppuntamentoListaFilialiResponse response;
        //String jsonString= OCSApiUtils.getMockResponse('filialeResponse');
       // System.debug('jsonString '+jsonString);
      //  if(jsonString!=null){
         // response = (AppuntamentoListaFilialiResponse) JSON.deserializeStrict(jsonString, AppuntamentoListaFilialiResponse.class);
         return (AppuntamentoListaFilialiResponse) OCSApiUtils.callApi('locator', request, AppuntamentoListaFilialiResponse.class);
   //  }
       // return response;
    }
    public Boolean validteRequest(AppuntamentoListaFilialiRequest request){
        Boolean hasErrors = false;
        if( String.isBlank(request.serviceId)){
            hasErrors = true;
        }
        if(String.isBlank(request.companyType.get('value'))){
            hasErrors = true;
        }
    
        return hasErrors;
    }
    public Boolean validteResponse(AppuntamentoListaFilialiResponse response){
        Boolean validResponse;

        return validResponse;
    }
}