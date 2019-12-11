public without sharing class CRMReclamiGestioneCorrispondenzaCtrl {

    @AuraEnabled
    public static List<Note> getNote(Id caseId){

        List<Note> noteAttachList = new List<Note>();

        List<ContentDocumentLink> noteRetrieved = [
            SELECT Id,ContentDocumentId,ContentDocument.FileType,IsDeleted,LinkedEntityId,ShareType,Visibility 
            FROM ContentDocumentLink
            WHERE LinkedEntityId =: caseId 
            AND  ContentDocument.FileType = 'SNOTE'
        ];
        system.debug('MS_CRMReclamiGestioneCorrispondenzaCtrl noteRetrieved: '+noteRetrieved);

        if(!noteRetrieved.isEmpty()){

            List<Id> noteIdList = new List<Id>();

            for(ContentDocumentLink cdl : noteRetrieved){
                noteIdList.add(cdl.ContentDocumentId);
            }
            
            List<ContentVersion> noteContentRetrieved = [
                SELECT Id, Title, FileType, Description, VersionNumber, ContentDocumentId, VersionData, CreatedDate, CreatedById, CreatedBy.Name  
                FROM ContentVersion WHERE ContentDocumentId IN :noteIdList AND IsLatest = true order by createddate desc
            ];
            system.debug('MS_CRMReclamiGestioneCorrispondenzaCtrl noteContentRetrieved: '+noteContentRetrieved);

            if(!noteContentRetrieved.isEmpty()){

                for(ContentVersion lv : noteContentRetrieved){
                    Note att = new Note();
                    att.Body = (lv.VersionData).toString();
                    att.CreatedDate  = lv.CreatedDate;
                    att.Title = lv.CreatedBy.Name;
                    att.CreatedById = lv.CreatedById;
                    att.ParentId = lv.ContentDocumentId;
                    
                    noteAttachList.add(att);
                }   
            }
        }

        return noteAttachList;

    }

    @AuraEnabled
    public static List<Attachment> getFileNote(Id caseId){

        List<Attachment> attachList = new List<Attachment>();

        List<ContentDocumentLink> allRetrieved = [
            SELECT Id,ContentDocumentId,ContentDocument.FileType,IsDeleted,LinkedEntityId,ShareType,Visibility 
            FROM ContentDocumentLink
            WHERE LinkedEntityId =: caseId 
        ];
        List<String> lS = new List<String>();
  //      List<Id> noteIdList = new List<Id>();
        List<ContentDocumentLink> noteRetrieved = new List<ContentDocumentLink>();
   /*     List<ContentDocumentLink> noteRetrieved = [
            SELECT Id,ContentDocumentId,ContentDocument.FileType,IsDeleted,LinkedEntityId,ShareType,Visibility 
            FROM ContentDocumentLink
            WHERE LinkedEntityId =: caseId 
            AND  ContentDocument.FileType = 'SNOTE'
        ];*/
        For(ContentDocumentLink ca : allRetrieved){
            if(ca.ContentDocument.FileType == 'SNOTE'){
                noteRetrieved.add(ca);
            }
            lS.add(ca.ContentDocumentId);
        }

        system.debug('MS_CRMReclamiGestioneCorrispondenzaCtrl noteRetrieved: '+noteRetrieved);

        if(!noteRetrieved.isEmpty()){

            List<Id> noteIdList = new List<Id>();

            for(ContentDocumentLink cdl : noteRetrieved){
                noteIdList.add(cdl.ContentDocumentId);
            }
            
            List<ContentVersion> fileNoteRetrieved = [
                SELECT Id, Title, FileType, Description, VersionNumber, ContentDocumentId, VersionData, CreatedDate  
                FROM ContentVersion WHERE ContentDocumentId IN :lS AND Description IN :noteIdList AND IsLatest = true
            ];
            system.debug('MS_CRMReclamiGestioneCorrispondenzaCtrl fileNoteRetrieved: '+fileNoteRetrieved);

            if(!fileNoteRetrieved.isEmpty()){

                for(ContentVersion lv : fileNoteRetrieved){
                    Attachment att = new Attachment();
                    att.Body = lv.VersionData;
                    att.ContentType = String.valueOf(lv.CreatedDate);
                    att.Description = String.valueOf(lv.ContentDocumentId) + '=' + XCSReclamiUtils.getUrlForDownloadFile(lv.ContentDocumentId);
                    att.Name = lv.Title;
                    att.ParentId = lv.Description;
                    
                    attachList.add(att);
                }   
            }
        }

        return attachList;

    }

    @AuraEnabled
    public static void insertNote(Id caseId, String testo){

        List<Case> caseList = [SELECT Id, AccountId, Account.OCS_External_Id__c, Note__c, NumeroPratica__c, Numero_Reclamo__c, Tipo_Pratica__c FROM Case WHERE Id =: caseId]; 

        if(!caseList.isEmpty()){
            XCSReclamiUtils.creaCorrispondenza(caseList.get(0), testo, new List<Attachment>());
        }

    }

}