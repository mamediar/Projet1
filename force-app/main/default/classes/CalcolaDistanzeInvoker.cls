public with sharing class CalcolaDistanzeInvoker {
	
	public static CalcolaDistanzeResponse invoke(CalcolaDistanzeRequest request){
        return (CalcolaDistanzeResponse)ApiUtils.callApi('ocs.calcolaDistanze',request,CalcolaDistanzeResponse.class); 
    }

}