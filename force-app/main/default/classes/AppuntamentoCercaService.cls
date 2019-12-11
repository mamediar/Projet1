public with sharing class AppuntamentoCercaService {

    public AppuntamentoCercaResponse buildAppuntamentoCerca( String  societa,String  utenteEsterno,String  utenteInterno, String  codiceFiscale){
          
       AppuntamentoCercaResponse response;
       AppuntamentoCercaRequest request = new AppuntamentoCercaRequest();
       request.serviceId = 'service' ;
       request.companyType.put('value', 'COMPASS');
       request.societa = societa;
       request.utenteEsterno = utenteEsterno;
       request.utenteInterno = utenteInterno;
       request.codiceFiscale = codiceFiscale;
       response = invoker(request);
       return response; 
    }

     public AppuntamentoCercaResponse invoker(AppuntamentoCercaRequest request){
        AppuntamentoCercaResponse response;
        String jsonString= OCSApiUtils.getMockResponse('appuntamentoCercaResponse');
         if(jsonString!=null){
             response = (AppuntamentoCercaResponse) JSON.deserializeStrict(jsonString, AppuntamentoCercaResponse.class);
        	// return (AppuntamentoCercaResponse) OCSApiUtils.callApi('nomService', request, AppuntamentoCercaResponse.class);
         }
        return response;
    }
    
    public List<Event> getListAppuntamento(AppuntamentoCercaRequest request){
        List<Event> events= new List<Event>();
        /*events=[select id,Customer__r.ResidenceProvince__c,Customer__r.Telefono_Cellulare__c,Customer__r.Codice_Fiscale__c,
                		Customer__r.LastName, Customer__r.PersonMailingCity,Customer__r.Data_Nascita__c, Customer__r.PersonEmail,
                		Customer__r.PersonMailingAddress,Customer__r.Luogo_Nascita__pc,Customer__r.,
						Customer__r., Customer__r.FirstName, Customer__r., Customer__r.FirstName,
						Customer__r.,  Customer__r.Provincia_Nascita__pc,  Customer__r.Sesso__pc,
						Desk__r.Branch__c from Event ];*/
        
        return events;
    }
    
}