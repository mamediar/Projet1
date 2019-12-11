public class CompassUtils {

    public static final String GESTIONE_TASK_FAX_TYPE_F1 = 'Fax Controllo';
    public static final String GESTIONE_TASK_FAX_TYPE_F2 = 'Fax Controverifica';
    public static final String GESTIONE_TASK_FAX_TYPE_F3 = 'Fax Postcontroverifica';
    
    
    public static List<ContentVersion> copyFiles(String destId, List<ContentVersion> attachs){
        List<ContentVersion> tempAttachs = new List<ContentVersion>();
        if(!attachs.isEmpty() && String.isNotBlank(destId)){
            for(ContentVersion cv : attachs){
                ContentVersion tempAttach = cv.clone(false,true,false,false);
                tempAttachs.add(tempAttach);
            }
            insert tempAttachs;
        }
        return tempAttachs;
    }
    
    public static Id fileNewInstance(String pageName,String objID,String fileName,String fileExtension){
        ContentVersion attachment = new ContentVersion();
        attachment.ContentLocation = 'S';
        attachment.PathOnClient = fileName.toLowerCase().replace(' ', '_') + '.' + fileExtension;
        attachment.Title = fileName;
        attachment.VersionData = generaFile(pageName, objID);
        insert attachment;
        return attachment.Id;
    }
      public static Id fileNewInstance(String pageName,Map<String,String> mapParameters,String fileName,String fileExtension){
        ContentVersion attachment = new ContentVersion();
        attachment.ContentLocation = 'S';
        attachment.PathOnClient = fileName.toLowerCase().replace(' ', '_') + '.' + fileExtension;
        attachment.Title = fileName;
        attachment.VersionData = generaFile(pageName, mapParameters);
        insert attachment;
        return attachment.Id;
    }
    
    
    


    public static Id fileNewInstance(String fileContents,String fileName,String fileExtension){
        ContentVersion attachment = new ContentVersion();
        attachment.ContentLocation = 'S';
        attachment.PathOnClient = fileName.toLowerCase().replace(' ', '_') + '.' + fileExtension;
        attachment.Title = fileName;
        attachment.VersionData = Blob.valueOf(fileContents);
        insert attachment;
        return attachment.Id;
    }
    
    public static Id createFile(String fileContents,String fileName,String fileExtension,String destinationId){
        ContentVersion attachment = new ContentVersion();
        attachment.ContentLocation = 'S';
        attachment.PathOnClient = fileName.toLowerCase().replace(' ', '_') + '.' + fileExtension;
        attachment.Title = fileName;
        attachment.VersionData = Blob.valueOf(fileContents); 

        insert attachment;
        
        ContentDistribution cd = new ContentDistribution();
        cd.name = attachment.Title;
        cd.RelatedRecordId = destinationId;
        cd.ContentVersionId = attachment.id;
        cd.PreferencesAllowOriginalDownload = true;
        cd.PreferencesAllowPDFDownload = false;
        cd.PreferencesAllowViewInBrowser = true;
        cd.PreferencesNotifyOnVisit = false;
        cd.PreferencesNotifyRndtnComplete = false;
        
        insert cd;
        
        return attachment.Id;
    }
    
    public static Id createFile(Blob fileContents,String fileName,String fileExtension,String destinationId){
        ContentVersion attachment = new ContentVersion();
        attachment.ContentLocation = 'S';
        attachment.PathOnClient = fileName.toLowerCase().replace(' ', '_') + '.' + fileExtension;
        attachment.Title = fileName;
        attachment.VersionData = fileContents; 
        
        insert attachment;
        
        ContentDistribution cd = new ContentDistribution();
        cd.name = attachment.Title;
        cd.RelatedRecordId = destinationId;
        cd.ContentVersionId = attachment.id;
        cd.PreferencesAllowOriginalDownload = true;
        cd.PreferencesAllowPDFDownload = false;
        cd.PreferencesAllowViewInBrowser = true;
        cd.PreferencesNotifyOnVisit = false;
        cd.PreferencesNotifyRndtnComplete = false;
        
        insert cd;
        
        return attachment.Id;
    }
    
    public static Boolean attachFile(Id fileId, Id destinationId){
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: fileId].ContentDocumentId;
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = destinationId;
        cDe.ShareType = 'I';
        cDe.Visibility = 'AllUsers';
        insert cDe;
        return true;
    }
    public static Boolean attachFileMultiObject(Id fileId, List<Id> destinationsId)
    {
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: fileId].ContentDocumentId;
        List<ContentDocumentLink> cDe = new List<ContentDocumentLink>();
        for(Id idObj: destinationsId)
        {
           cDe.add
           (
           		new ContentDocumentLink(ContentDocumentId = conDoc,
                                       	LinkedEntityId = idObj,
                                        ShareType = 'I',
                                        Visibility = 'AllUsers'
                                       )
           ) ;
        }
        insert cDe;
        return true;
    }
    
    public static Boolean attachFile(Id fileId, Id destinationId, String shareType){
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: fileId].ContentDocumentId;
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = destinationId;
        cDe.ShareType = shareType;
        cDe.Visibility = 'AllUsers';
        insert cDe;
        return true;
    }    
    
    public static List<ContentDocument> getAttachments(String recordId){
         List<ContentDocument> DocumentList = new List<ContentDocument>();  
         Set<Id> documentIds = new Set<Id>();  
         List<ContentDocumentLink> cdl=[select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId=:recordId];  
         for(ContentDocumentLink cdLink:cdl){  
           documentIds.add(cdLink.ContentDocumentId);  
         }      
         return [select Id,Title,FileType,ContentSize,Description,CreatedDate from ContentDocument where id IN: documentIds AND FileType!=:'SNOTE']; 
       
    }    
    
    public static Blob generaFile(String vfpName, String objID){
        if(String.isNotBlank(vfpName)){
            PageReference pg = new PageReference(vfpName);
            pg.getParameters().put('Id', objID);
            Blob blb = Test.isRunningTest() ? Blob.valueOf('TEST') : pg.getContent();
            return blb;
        }
        return null;
    }
    
     public static Blob generaFile(String vfpName, Map<String,String> mapParameter){
        if(String.isNotBlank(vfpName)){
            PageReference pg = new PageReference(vfpName);
            For(String key : mapParameter.keySet())
            {
                pg.getParameters().put(key, mapParameter.get(key));
			}
            
            
            
            Blob blb = Test.isRunningTest() ? Blob.valueOf('TEST') : pg.getContent();
            return blb;
        }
        return null;
    }
    
    public static Boolean isThereAttach(String Id){
        Boolean res = false;
        String query = 'SELECT COUNT() ' +
            'FROM ContentDocumentLink ' +
            'WHERE LinkedEntityId = \'' + String.escapeSingleQuotes(Id) + '\'';
        Integer cDs = Database.countQuery(query);
        //System.debug('ContentDocuments count: '+cDs);
        res = cDs > 0;
        return res;
    }
    
    
    public static Integer numberOfAttach(String recordId){
        List<ContentDocumentLink> cdl=[select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId=:recordId];
        return cdl.size();
    }    
    

    public static String getReportUrl(String fileId){
        return [SELECT Id, DistributionPublicUrl FROM ContentDistribution WHERE ContentVersionId = :fileId][0].DistributionPublicUrl;
    } 

}