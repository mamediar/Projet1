/*
*@Author Madicke BALDE  
*@description service class for web service RecuperaPraticheAggiornate
*
*/
public class RecuperaPraticheAggiornateService {
    
    public static List<RecuperaPraticheAggiornateError> errors = new List<RecuperaPraticheAggiornateError>();
  
    /*
    *@Author Madicke BALDE  
    *@description Validate field Request
    *@param req:  RecuperaPraticheAggiornateRequest
    *@return Boolean
    */
    public static Boolean validateRequest(RecuperaPraticheAggiornateRequest req){
        Boolean hasError = false;
                if(req.serviceId == null || String.isBlank(req.serviceId)) {
                     hasError = true;          
                     errors.add(new RecuperaPraticheAggiornateError('Invalid ! Can\' t be empty serviceId ',
                                                               'RecuperaPraticheAggiornateRequest')); }
                                                                
                if(req.companyType.get('value') == null || String.isBlank(req.companyType.get('value')) ){
                                hasError = true;
                                errors.add(new RecuperaPraticheAggiornateError('Invalid ! Can\' t be empty  companyType',
                                                                                'RecuperaPraticheAggiornateRequest' )); }
               
                if(String.isBlank(req.recuperaPraticheAggiornateRequest.filtroPartner)){
                                hasError = true;
                                errors.add(new RecuperaPraticheAggiornateError('Invalid ! Can\' t be empty filtroPartner ',
                                                                            'RecuperaPraticheAggiornateRequest' )); }                                  
                if(String.isBlank(req.recuperaPraticheAggiornateRequest.oraInizio)){
                                 hasError = true;
                                 errors.add(new RecuperaPraticheAggiornateError('Invalid ! Can\' t be empty  oraInizio',
                                                                                'RecuperaPraticheAggiornateRequest')); }                                         
                if(String.isBlank(req.recuperaPraticheAggiornateRequest.dataInizio)){
                                 hasError = true;
                                 errors.add(new RecuperaPraticheAggiornateError('Invalid ! Can\' t be empty  dataInizio',
                                                                               'RecuperaPraticheAggiornateRequest')); }                                 
                  return !hasError;
    }
    /*
    *@Author Madicke BALDE  
    *@description Validate field Response
    *@param response : RecuperaPraticheAggiornateResponse
    *@return Boolean
    */
    public static Boolean ValidateResponse (RecuperaPraticheAggiornateResponse response){
                Boolean hasError = false;
               System.debug('************* response '+ response);
                      if(response.resultCode != 0 ){
                            hasError = true;
                            errors.add(new RecuperaPraticheAggiornateError ('Response invalid', 'RecuperaPraticheAggiornateResponse')); }
                      
                if(response.recuperaPraticheAggiornateResponse == null ){
                            hasError = true;
                            errors.add(new RecuperaPraticheAggiornateError ('No records Retrieved ', 'RecuperaPraticheAggiornateResponse'));
                            }
                if(response.recuperaPraticheAggiornateResponse != null){
                    if(response.recuperaPraticheAggiornateResponse.elenco == null || response.recuperaPraticheAggiornateResponse.elenco.size() == 0){
                       hasError = true;
                       errors.add(new RecuperaPraticheAggiornateError ('No records Retrieved elenco ', 'RecuperaPraticheAggiornateResponse'));
                    }
                }
                
                    
                return !hasError;
    }
    
    /*
    *@Author Madicke BALDE  
    *@description create Map Map<numpratica, ResponseWrapper>
    *@param result List<RecuperaPraticheAggiornateResponse.RecuperaPraticheAggiornateResp>
    *@return  Map<String, ResponseWrapper>
    */
    public static Map<String, ResponseWrapper> getData(List<RecuperaPraticheAggiornateResponse.RecuperaPraticheAggiornateResp> result){
            Map<String, ResponseWrapper> mapData = new Map<String, ResponseWrapper>();
                for(RecuperaPraticheAggiornateResponse.RecuperaPraticheAggiornateResp recupera : result){
                        if(!mapData.containsKey(recupera.numPratica)){
                                    mapData.put(recupera.numPratica, new ResponseWrapper(recupera.statoAttuale, recupera.attributoAttuale)); }     
                    }
                return mapData;
    }

    /*
    *@Author Madicke BALDE
    *@description Wrapper Class
    */
    public class ResponseWrapper {
        public String statoAttuale {get;set;}
        public String attributoAttuale {get;set;}
        public  ResponseWrapper(String statoAttuale, String attributoAttuale){
            this.statoAttuale = statoAttuale;
            this.attributoAttuale = attributoAttuale;
        }
    }
    /*
    *@Author Madicke BALDE
    *@description retrieve case list contain NumeroPratica__c
    *@param  List<RecuperaPraticheAggiornateResponse.recuperaPraticheAggiornateResp> : response form web service RecuperaPraticheAggiornate
    *@return Map<String, Object>
    */
    public static Map<String, Object>  gestitoResponse ( List<RecuperaPraticheAggiornateResponse.recuperaPraticheAggiornateResp> resultats){
      Map<String, Object> returnValues = new Map<String, Object>();
       returnValues.put('error', false);
       try {
           System.debug('************* gestitoResponse '+resultats);
                Map<String , ResponseWrapper> mp = getData(resultats);
                 System.debug('*************** getData '+ mp);
                List<Case> list_Cases = [SELECT Id, stato_ocs__c, Status, NumeroPratica__c FROM Case WHERE NumeroPratica__c IN: mp.keySet()];
                System.debug('*************** list_Cases '+ list_Cases);
                for(Case c : list_Cases ){
                        ResponseWrapper resp = mp.get(c.NumeroPratica__c);
                        c.stato_ocs__c = resp.statoAttuale + resp.attributoAttuale; 
                   }
               
                  CaseService.updateCase(list_Cases);
                  returnValues.put('cases', list_Cases);
       }
         catch (Exception e) {
                returnValues.put('error', true);
                System.debug('********* error Message gestitoResponse '+ e.getMessage());
       }
       return returnValues;
     
    }
}