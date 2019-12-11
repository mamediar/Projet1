public with sharing class GD_ElencoAttestatoRicevuto {
/**
 * @description: search Multiple
 * @date: 27/08/2019
 * @author: Aminata GUEYE
 * @params: String searchText
 * @return: Map<String,Object>
 */


@AuraEnabled
    public static List<IVASS_Dealer_courses_Iscritti__c> fetchElenco(IVASS_Dealer_courses_Iscritti__c dci, String codOcs) {
        
       list<sobject> records;
       string condition = ''; 
        string query ='';
        try{
       if(String.isNotEmpty(codOcs) || codOcs !=''){
           condition+= ' And Name LIKE \'%'+codOcs+'%\'';
       }
       if(String.isNotEmpty(dci.Ragione_Sociale__c)){
       condition+= ' And Ragione_Sociale__c LIKE \'%'+dci.Ragione_Sociale__c +'%\'';
       }
       if(String.isNotEmpty(dci.Name)){
           condition+= ' And Name LIKE \'%'+dci.Name+'%\'';
       }
	   if(String.isNotEmpty(dci.Cognome__c)){
           condition+= ' And Cognome__c LIKE \'%'+dci.Cognome__c+'%\'';
       }
	   if(String.isNotEmpty(dci.Nome__c)){
           condition+= ' And Nome__c LIKE \'%'+dci.Nome__c+'%\'';
       }
        
        //query = 'SELECT Id,Name,Nome__c,Cognome__c,Ragione_Sociale__c,Codice_Intermediario__c,Dealer__r.OCS_External_Id__c FROM IVASS_Dealer_courses_Iscritti__c where id!=null'+ condition ;
        query = 'SELECT Id, Dealer__r.OCS_External_Id__c, Codice_Intermediario__c, Ragione_Sociale__c, Codice_Fiscale__c, Data_Iscrizione__c, Stato_Corso__c, Note__c, '+
            'Corso__c, Regione__c, Cognome__c, Nome__c, Nome_Dealer__c, Name, Note_x_Outsourcer__c, Dealer__c, Corso__r.Codice_Assofin__c, Corso__r.Name, Corso__r.Descrizione_Corso__c FROM IVASS_Dealer_courses_Iscritti__c where id!=null'+ condition ;
        }catch(Exception e){
            System.debug('Message : '+e.getMessage());
            System.debug('Cause : '+e.getCause());
            System.debug('Line : '+e.getLineNumber());
        }
       system.debug(query);
       records = Database.query(query);
       return records;
   }
   @AuraEnabled
    public static  Map<String,object> dettagliAttestato(String codiceReferente) {
        Map<String, Object> response = new Map<String, Object>();
        response.put('error',false);
        try {
            List <IVASS_Dealer_courses_attachments__c> attachments =  [SELECT Id, Name, Codice_Referente__c, Anno_di_riferimento__c, Link_Documento__c, Note_Outsourcer__c, Status__c, External_Id__c, 
            (SELECT ContentDocumentId, ContentDocument.Title FROM ContentDocumentLinks)
            FROM IVASS_Dealer_courses_attachments__c WHERE Codice_Referente__c=:codiceReferente];
            response.put('attachments', attachments);
            List<IVASS_Dealer_courses_Iscritti__c> courses = [SELECT Id, Dealer__r.OCS_External_Id__c, Codice_Intermediario__c, Ragione_Sociale__c, Codice_Fiscale__c, Data_Iscrizione__c, Stato_Corso__c, Note__c, 
            Corso__c, Regione__c, Cognome__c, Nome__c, Name, Note_x_Outsourcer__c, Dealer__c, Corso__r.Codice_Assofin__c, Corso__r.Name, Corso__r.Descrizione_Corso__c 
                FROM IVASS_Dealer_courses_Iscritti__c WHERE Name=:codiceReferente ];
            response.put('courses', courses);
            List<String> pickListValuesList= new List<String>();
            Schema.DescribeFieldResult fieldResult = IVASS_Dealer_courses_Iscritti__c.Stato_Corso__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple){
                pickListValuesList.add(pickListVal.getLabel());
            }     
            response.put('pickListValuesList', pickListValuesList);

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
    * @description: update  dealer_Isvap
    * @date: 02/08/2019
    * @author: 
    * @params: List<sObject> data
    * @return: Map<String,Object>
    */

    @AuraEnabled
    public static List <IVASS_Dealer_courses_attachments__c> updateAttachmentStatus(List <IVASS_Dealer_courses_attachments__c> attachments){
        List <IVASS_Dealer_courses_attachments__c> newAttachments = new List <IVASS_Dealer_courses_attachments__c> ();
        if (!IVASS_Dealer_courses_attachments__c.sObjectType.getDescribe().isUpdateable()) {
            throw new AuraHandledException('Non hai accesso');
        }else{
            update attachments;
            newAttachments =  [SELECT Id, Name, Codice_Referente__c, Anno_di_riferimento__c, Link_Documento__c, Note_Outsourcer__c, Status__c, External_Id__c, 
            (SELECT ContentDocumentId, ContentDocument.Title FROM ContentDocumentLinks)
            FROM IVASS_Dealer_courses_attachments__c WHERE Codice_Referente__c=:attachments[0].Codice_Referente__c];
        }
        return newAttachments;
    }
    
    @AuraEnabled
    public static IVASS_Dealer_courses_Iscritti__c updateIscrittoIvass(IVASS_Dealer_courses_Iscritti__c iscritto){
        if (!IVASS_Dealer_courses_Iscritti__c.sObjectType.getDescribe().isUpdateable()) {
            throw new AuraHandledException('Non hai accesso');
        }else{
            update iscritto;
        }
        return iscritto;
    }

}