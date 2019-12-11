public with sharing class GD_Dealer_Isvap_Update_Assofin {

/**
 * @description: update  dealer_Isvap
 * @date: 02/08/2019
 * @author: 
 * @params: List<sObject> data
 * @return: Map<String,Object>
 */

@AuraEnabled
public static Map<String,object> updateSobject(List<IVASS_Dealer_courses_Iscritti__c> data){
	Map<String, Object> response = new Map<String, Object>();
    List<IVASS_Dealer_courses_Iscritti__c> listToUpdate = new List<IVASS_Dealer_courses_Iscritti__c>();
	IVASS_Dealer_courses_Iscritti__c recordToUpdate = new IVASS_Dealer_courses_Iscritti__c ();
    response.put('error',false);
		System.debug('message debug data >: '+data);
	try {
        /* for(IVASS_Dealer_courses_Iscritti__c itemData : data) {
            recordToUpdate = processUpdate(itemData);
            if(recordToUpdate.Id !=null){
                listToUpdate.add(recordToUpdate);       
            }
        } */
        listToUpdate = processUpdate(data);
        if (!IVASS_Dealer_courses_Iscritti__c.sObjectType.getDescribe().isUpdateable()) {
		throw new AuraHandledException('Non hai accesso per l\'aggiornamento');
	    }else{
            if(listToUpdate.size() > 0){
                update listToUpdate;
                response.put('message','Salvataggio effettuato, ' + listToUpdate.size()+' aggiornato');
            }else{
                response.put('message','Nessun record da aggiornare');
            }
        response.put('updatedRows', listToUpdate.size());
		response.put('data',listToUpdate);
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
 * @description: Get record from IVASS_Dealer_courses_Iscritti__c
 * @date: 02/08/2019
 * @author: 
 * @params: List<sObject> data
 * @return: Map<String,Object>
 */
private static List<IVASS_Dealer_courses_Iscritti__c> processUpdate(List<IVASS_Dealer_courses_Iscritti__c> data){
    system.debug('06_11_2019 data->'+data);
    /* if (!IVASS_Dealer_courses_Iscritti__c.sObjectType.getDescribe().isAccessible()) {
		throw new AuraHandledException('Non hai accesso');
	} */
    List<IVASS_Dealer_courses_Iscritti__c> listToUpdate = new List<IVASS_Dealer_courses_Iscritti__c>();
    List<String> codiceFiscales = new List<String>();
    List<String> corses = new List<String>();
    for(IVASS_Dealer_courses_Iscritti__c item: data) {
        codiceFiscales.add(item.Codice_Fiscale__c);
        corses.add(item.Nome_Corso__c);
    }
	IVASS_Dealer_courses_Iscritti__c recordToUpdate = new IVASS_Dealer_courses_Iscritti__c ();
    List<IVASS_Dealer_courses_Iscritti__c> records = [SELECT Id, Corso__c, Area__c, Codice_Fiscale__c, Codice_Intermediario__c, Cognome__c, Data_Iscrizione__c, Dealer__c, Esito_Outsourcer__c, Filiale__c, 
        Nome__c, Note__c, Note_x_Outsourcer__c, Ragione_Sociale__c, Referente__c, Regione__c, Stato_Corso__c, Invio_all_Outsourcer__c, Dipendenza__c,Name, Corso__r.Name,  
        descrizione__c, Stato__c, Esito_Globale__c, Data_Fine__c, Data_Globale__c, Utenza__c, Password__c, Note_Presidio__c, Email_Referente__c, Anno_di_Riferimento__c,
         Nome_Dealer__c, Nome_Corso__c, Corso__r.Codice_Assofin__c FROM IVASS_Dealer_courses_Iscritti__c WHERE  Corso__r.Name IN:corses AND Codice_Fiscale__c IN:codiceFiscales ];
     
    
	System.debug('records Where in >> '+records);
    /* List<IVASS_Dealer_courses_Iscritti__c> record = [SELECT Id, Codice_Intermediario__c, Ragione_Sociale__c, Codice_Fiscale__c, Data_Iscrizione__c, Stato_Corso__c, Note__c, Corso__c, Regione__c, Cognome__c, Nome__c, Name, Note_x_Outsourcer__c, Dealer__c, Corso__r.Codice_Assofin__c 
        FROM IVASS_Dealer_courses_Iscritti__c WHERE (Corso__r.Codice_Assofin__c=:data.Corso__c OR Corso__r.Codice_Assofin__c=:data.Corso__r.Codice_Assofin__c) AND Codice_Fiscale__c=:data.Codice_Fiscale__c ];
     */

     for(IVASS_Dealer_courses_Iscritti__c record : records) {
        for(IVASS_Dealer_courses_Iscritti__c item : data) {
            if ((record.Corso__r.Name == item.Nome_Corso__c ) && (record.Codice_Fiscale__c == item.Codice_Fiscale__c) ) {
                recordToUpdate = mergeRecords(item, record, 'IVASS_Dealer_courses_Iscritti__c');
                listToUpdate.add(recordToUpdate);
            }
        }
    }
    /* if(record.size() > 0){
        recordToUpdate = mergeRecords(data, record[0], 'IVASS_Dealer_courses_Iscritti__c');
    } */
	return listToUpdate;
}


/**
 * @description: Merge record from CSV file and IVASS_Dealer_courses_Iscritti__c object
 * @date: 02/08/2019
 * @author: 
 * @params: updatedRecord, currentRecord | IVASS_Dealer_courses_Iscritti__c
 * @return: IVASS_Dealer_courses_Iscritti__c mergedRecord 
 */
private static Set<String> fieldsToExclude = new Set<String>{'OwnerId'};
public static IVASS_Dealer_courses_Iscritti__c mergeRecords(IVASS_Dealer_courses_Iscritti__c updatedRecord, IVASS_Dealer_courses_Iscritti__c currentRecord, String sObjectName){
  SObjectType objToken = Schema.getGlobalDescribe().get(sObjectName);
  DescribeSObjectResult objDef = objToken.getDescribe();
  Map<String, SObjectField> fields = objDef.fields.getMap();
  Type classType = Type.forName(sObjectName);
  IVASS_Dealer_courses_Iscritti__c mergedRecord = (IVASS_Dealer_courses_Iscritti__c)JSON.deserialize('{}', classType);
  for (String field : fields.keySet()){
    if (!fieldsToExclude.contains(fields.get(field).getDescribe().getName()) && (fields.get(field).getDescribe().isUpdateable() || fields.get(field).getDescribe().isCreateable())){
        if (updatedRecord.get(field)!=null){
            mergedRecord.put(field, updatedRecord.get(field));
        } else if (currentRecord.get(field)!=null){
            mergedRecord.put(field, currentRecord.get(field));
        }
    }
  }
  mergedRecord.Id = currentRecord.Id;
  return mergedRecord;
}

}