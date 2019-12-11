public with sharing class GD_RicercaPerNominativo {

/**
 * @description: search By Name
 * @date: 09/08/2019
 * @author: 
 * @params: String searchText
 * @return: Map<String,Object>
 */

@AuraEnabled
public static Map<String,object> searchByName(String searchText){
	Map<String, Object> response = new Map<String, Object>();
    List<IVASS_Dealer_courses_Iscritti__c> results ;
	IVASS_Dealer_courses_Iscritti__c recordToUpdate = new IVASS_Dealer_courses_Iscritti__c ();
    List<String> status;
	response.put('error',false);
	try {
        if (!IVASS_Dealer_courses_Iscritti__c.sObjectType.getDescribe().isAccessible()) {
		throw new AuraHandledException('Non hai accesso per l\'aggiornamento');
	    }else{
            results = [SELECT Id, Dealer__r.OCS_External_Id__c, Referente__c, Codice_Intermediario__c, Ragione_Sociale__c, Codice_Fiscale__c, Data_Iscrizione__c, Stato_Corso__c, 
			Note__c, Corso__c, Regione__c, Cognome__c, Nome__c, Name, Note_x_Outsourcer__c, Dealer__c, Corso__r.Codice_Assofin__c, Corso__r.Name, Corso__r.Attivo__c, 
			Invio_all_Outsourcer__c, Utenza__c, Password__c, Email_Referente__c    
                FROM IVASS_Dealer_courses_Iscritti__c WHERE Name=:searchText ];
            response.put('results', results);
			List<IVASS_Dealer_courses__c> courses = [SELECT Id, Name FROM IVASS_Dealer_Courses__c];
            response.put('courses', courses);
			/* status = getAllStatus();
            response.put('status', status); */
        }
        
	} catch (Exception e) {
		response.put('error',true);
		response.put('message',e.getMessage());
		response.put('cause',e.getCause());
		System.debug('message debug: '+e.getMessage());
		System.debug('Cause debug: '+e.getCause());
	}
	return response;
}


/**
 * @description: get Stato PickList Values Into List
 * @date: 09/08/2019
 * @author: 
 * @params: String searchText
 * @return: Map<String,Object>
 */

@AuraEnabled
public static List<String> getAllStatus(){
       List<String> pickListValuesList= new List<String>();
		Schema.DescribeFieldResult fieldResult = IVASS_Dealer_courses_Iscritti__c.Stato_Corso__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			pickListValuesList.add(pickListVal.getLabel());
		}     
		return pickListValuesList;
}

/**
 * @description: update  dealer_Isvap
 * @date: 02/08/2019
 * @author: 
 * @params: List<sObject> data
 * @return: Map<String,Object>
 */

@AuraEnabled
public static Map<String,object> updateStato(List<IVASS_Dealer_courses_Iscritti__c> data){
	Map<String, Object> response = new Map<String, Object>();
	response.put('error',false);
	if (!IVASS_Dealer_courses_Iscritti__c.sObjectType.getDescribe().isUpdateable()) {
			throw new AuraHandledException('Non hai accesso');
    }else{
            List<String> pickListValuesList= getAllStatus();
            if(pickListValuesList.contains(data[0].Stato_Corso__c)){
                update data;
                response.put('data',data);
            }else{
                response.put('error',true);
				response.put('message','Questo stato non esiste nel sistema');
            }
    }
	return response;
}

/**
 * @description: update  dealer_Isvap
 * @date: 21/10/2019
 * @author: 
 * @params: List<sObject> data
 * @return: Map<String,Object>
 */

@AuraEnabled
public static Map<String,object> salvaNote(List<IVASS_Dealer_courses_Iscritti__c> data){
	Map<String, Object> response = new Map<String, Object>();
	response.put('error',false);
	if (!IVASS_Dealer_courses_Iscritti__c.sObjectType.getDescribe().isUpdateable()) {
			throw new AuraHandledException('Non hai accesso');
    }else{
		try {
        update data;
		response.put('data',data);
		} catch (Exception e) {
			response.put('error',true);
			response.put('message',e.getMessage());
			response.put('cause',e.getCause());
			System.debug('message debug: '+e.getMessage());
			System.debug('Cause debug: '+e.getCause());
		}
    }
	return response;
}


/**
 * @description: delete  IVASS_Dealer_courses_Iscritti__c
 * @date: 22/10/2019
 * @author: 
 * @params: IVASS_Dealer_courses_Iscritti__c iscritto
 * @return: Map<String,Object>
 */

@AuraEnabled
public static Map<String,object> eliminaIscritto(IVASS_Dealer_courses_Iscritti__c iscritto){
	Map<String, Object> response = new Map<String, Object>();
	response.put('error',false);
	if (!IVASS_Dealer_courses_Iscritti__c.sObjectType.getDescribe().isUpdateable()) {
			throw new AuraHandledException('Non hai accesso');
    }else{
		try {
        delete iscritto;
		} catch (Exception e) {
			response.put('error',true);
			response.put('message',e.getMessage());
			response.put('cause',e.getCause());
			System.debug('message debug: '+e.getMessage());
			System.debug('Cause debug: '+e.getCause());
		}
    }
	return response;
}

/**
 * @description: update  IVASS_Dealer_courses_Iscritti__c
 * @date: 22/10/2019
 * @author: 
 * @params: IVASS_Dealer_courses_Iscritti__c iscritto
 * @return: Map<String,Object>
 */

@AuraEnabled
public static Map<String,object> updateIscritto(IVASS_Dealer_courses_Iscritti__c iscritto){
	Map<String, Object> response = new Map<String, Object>();
	response.put('error',false);
	if (!IVASS_Dealer_courses_Iscritti__c.sObjectType.getDescribe().isUpdateable()) {
			throw new AuraHandledException('Non hai accesso');
    }else{
		try {
			update iscritto;
			response.put('data',iscritto);
		} catch (Exception e) {
			response.put('error',true);
			response.put('message',e.getMessage());
			response.put('cause',e.getCause());
			System.debug('message debug: '+e.getMessage());
			System.debug('Cause debug: '+e.getCause());
		}
    }
	return response;
}

}