public with sharing class NotaSpeseZucchettiInvoker {
	
	public static NotaSpeseZucchettiResponse invoke(NotaSpeseZucchettiRequest request){
        return (NotaSpeseZucchettiResponse)ApiUtils.callApi('ocs.creaNotaSpeseZucchetti',request,NotaSpeseZucchettiResponse.class); 
    }
    
}