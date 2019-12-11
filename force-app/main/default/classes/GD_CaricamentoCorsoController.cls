/**
* Class: CaricamentoContoller
* @description: apex class contains implements method of Caricamento
* @date:30/07/2019
* @author:Mady COLY
* */
public with sharing  class GD_CaricamentoCorsoController {
    /**
* @description: List Aggiungi al corso
* @date::30/07/2019
* @author:Mady COLY
* @return: Response|Map<String,Object>
*/
    @AuraEnabled
    public static Map<String,Object> getAllAggiungiCorso() {
        List<IVASS_Dealer_Courses__c> records;
        Map<String,Object> response=new Map<String,Object>();
        response.put('error',false);
        try {
            
            records =[ SELECT Id, Name FROM IVASS_Dealer_Courses__c ];
            response.put('data',records);
            
        } catch(Exception e){
            response.put('error',true);
           System.debug('message :'+e.getMessage());
        }
        System.debug('data : '+response);
        return response;
    }
    /**
* @description: List Tipologia al corso
* @date::31/07/2019
* @author:Mady COLY
* @return: Response|Map<String,Object>
*/
    @AuraEnabled
    public static Map<String,Object> getAllTipologiaCorso() {
        List<IVASS_Dealer_courses_type__c> records;
        Map<String,Object> response=new Map<String,Object>();
        response.put('error',false);
        try {
            
            records = [ SELECT Id,Type_Course_Name__c FROM IVASS_Dealer_courses_type__c ];
            response.put('data',records);
        } catch(Exception e){
            response.put('error',true);
           System.debug('message :'+e.getMessage());
        }
        System.debug('data : '+response);
        return response;
    }
    
    /**
* @description: List IVASS_Dealer_Courses__c 
* @date::31/07/2019
* @author:Mady COLY
* @return: Response|Map<String,Object>
*/
    @AuraEnabled
    public static Map<String,Object> getAllDealerCourses() {
        List<IVASS_Dealer_Courses__c> records;
        Map<String,Object> response=new Map<String,Object>();
        response.put('error',false);
        try {
            
            records = [ SELECT Id,Name,Codice_Assofin__c,Descrizione_Corso__c ,Tipo_Corso__r.Type_Course_Name__c,Anno_di_Riferimento__c FROM IVASS_Dealer_Courses__c];
            response.put('data',records);
            
        } catch(Exception e){
            response.put('error',true);
           System.debug('message :'+e.getMessage());
        }
        System.debug('data in getAllDealerCourses : '+response);
        return response;
    }
    
    @AuraEnabled
    public static Id getQueueIVASS()
    {
           return [ SELECT Id, Name,DeveloperName 
                    FROM GROUP
                    WHERE Type = 'Queue' AND DeveloperName = 'Q999' ].Id;
    }
    
    @AuraEnabled
    public static Id processData(String fileData,List<String> fields, IVASS_Dealer_Courses__c dealerCorso) {
        System.debug('dealerCorso : '+ dealerCorso);
        System.debug('dealerCorsoID : '+ dealerCorso.Id);
        System.debug('after dealerCorsoID ');
        
        try {
            
            upsert dealerCorso;
            
        }catch(DMLException e){
            System.debug('exception'+e.getMessage());   
            System.debug('exception'+e.getCause());   
            System.debug('exception'+e.getLineNumber());   
            System.debug('exception'+e.getStackTraceString());   
        }
        System.debug('dealerCorso after insert : '+dealerCorso);
        System.debug('before  jobID: ');
        /*Caricamento = new GD_CaricamentoCorsoReadFileCSVBatch(fileData, fields, dealerCorso);
ID jobID = System.enqueueJob(Caricamento);*/
        GD_Dealer_Isvap_Courses_Upload batchCoursesUpload = new GD_Dealer_Isvap_Courses_Upload(fileData,dealerCorso);
        Id batchId = Database.executeBatch(batchCoursesUpload);
        AsyncApexJob jobInfo = [SELECT Status,NumberOfErrors FROM AsyncApexJob WHERE Id=:batchId];
        System.debug('jobInfo : '+jobInfo);
        return batchId;
    }
    
    @AuraEnabled
    public static Map<String,Object>  isCompleted(Id jobID){
        Map<String,Object> response=new Map<String,Object>();
        response.put('error',false);
        try{
            System.debug('is completed : '+jobID);
            AsyncApexJob jobInfo = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email,  ExtendedStatus FROM AsyncApexJob WHERE Id=:jobID];
            response.put('jobInfo',jobInfo);
            response.put('listInError',null);
            System.debug('jobInfo : '+jobInfo);
        } catch(Exception e){
            response.put('error',true);
           System.debug('message :'+e.getMessage());
        }
        return response; 
    }
        
    @AuraEnabled
    public static Map<String,Object> getDealers(List<String> dealerList) {
        System.debug('dealerList : '+ dealerList);
        Map<String,Object> response=new Map<String,Object>();
        List<Account> dealers = new List<Account>();
        response.put('error',false);
        try{
            dealers = [SELECT Id , Name, OCS_External_Id__c FROM Account WHERE RecordType.Name = 'Dealer' AND  OCS_External_Id__c IN : dealerList];
            response.put('data',dealers);
            System.debug('dealers : '+dealers);
        } catch(Exception e){
            response.put('error',true);
           System.debug('message :'+e.getMessage());
        }
        return response; 
    }
    
    @AuraEnabled
    public static  List<IVASS_Dealer_courses_attachments__c> researchDealerCoursesAttachments(String codiceReferente) {
         List<IVASS_Dealer_courses_attachments__c> myAttachmentsObject = new  List<IVASS_Dealer_courses_attachments__c>();
        try{
            System.debug('codiceReferente : '+codiceReferente);
            myAttachmentsObject = [SELECT Id, Name, Codice_Referente__c, Anno_di_riferimento__c, Link_Documento__c, Note_Outsourcer__c, Status__c, External_Id__c, 
                                    (SELECT ContentDocumentId, ContentDocument.Title FROM ContentDocumentLinks)
                                    FROM IVASS_Dealer_courses_attachments__c WHERE Codice_Referente__c=:codiceReferente];
            System.debug('data : '+myAttachmentsObject);
        } catch(Exception e){
           System.debug('message :'+e.getMessage());
           return new List<IVASS_Dealer_courses_attachments__c>();
        }
        return myAttachmentsObject; 
    }
    
}