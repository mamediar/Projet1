public class GD_AttachToIscrittiOutsourcer {
    
    
     @AuraEnabled  
    public static List<ContentDocument> getFiles(string recordId){ 
        // TO avoid following exception 
        // System.QueryException: Implementation restriction: ContentDocumentLink requires
        // a filter by a single Id on ContentDocumentId or LinkedEntityId using the equals operator or 
        // multiple Id's using the IN operator.
        // We have to add sigle record id into set or list to make SOQL query call
        Set<Id> recordIds=new Set<Id>{recordId};
        Set<Id> documentIds = new Set<Id>(); 
        List<ContentDocumentLink> cdl=[SELECT id,LinkedEntityId,ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN:recordIds];  
        for(ContentDocumentLink cdLink:cdl){  
            documentIds.add(cdLink.ContentDocumentId);  
        }      
        return [SELECT Id,Title,FileType FROM ContentDocument WHERE id IN: documentIds];  
    } 
    @AuraEnabled
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType , 
                                 IVASS_Dealer_courses_attachments__c AttachmentIscritto ) 
    { 
        /*
        IVASS_Dealer_courses_attachments__c AttachmentIVassObject = new IVASS_Dealer_courses_attachments__c();
        AttachmentIVassObject.Codice_Referente__c                 = 'CodRef';
        AttachmentIVassObject.Anno_di_riferimento__c              = AnnoRif;//'2018';
        AttachmentIVassObject.Note_Outsourcer__c                  = NoteOutsourcer;//'Note__';*/
        system.debug('AttachmentIscritto->'+AttachmentIscritto);
        List<IVASS_Dealer_courses_Iscritti__c> ListIscritti = [SELECT Id,Name
                                                               FROM IVASS_Dealer_courses_Iscritti__c
                                                               WHERE Id =: parentId];
        
        AttachmentIscritto.Iscritto__c                         = parentId;
        AttachmentIscritto.Codice_Referente__c                 = ListIscritti[0].Name;
        upsert AttachmentIscritto;
        system.debug('base64Data->>>>>> '+base64Data);
        //String bs64 = base64Data.remove('%');
                base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        ContentVersion contentVersion = new ContentVersion(
            versionData = EncodingUtil.base64Decode(base64Data),
            title = fileName,
            pathOnClient =  '/' + fileName,
            FirstPublishLocationId = AttachmentIscritto.Id);
        insert contentVersion; 
        system.debug('contentVersion-->'+contentVersion);
        /* 
         * Get ContentDownloadURL and set it to Link_Documento__c
         * Upsert the Attachment
         */
        String linkDown = setLinkDocumento(contentVersion.Id, AttachmentIscritto);
        system.debug('link to Download  >>> '+linkDown);
        return contentVersion.Id;
    }
    
     @AuraEnabled
    public static ContentVersion saveFile(Id idParent, String strFileName, String base64Data) {
        // Decoding base64Data
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        // inserting file
        ContentVersion cv = new ContentVersion();
        cv.Title = strFileName;
        cv.PathOnClient = '/' + strFileName;
        cv.FirstPublishLocationId = idParent;
        cv.VersionData = EncodingUtil.base64Decode(base64Data);
        cv.IsMajorVersion = true;
        Insert cv;
        return cv;
    }

    @AuraEnabled
    public static Id saveTheChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId , 
                                  IVASS_Dealer_courses_attachments__c AttachmentIscritto) { 
        if (fileId == '') {
            system.debug('28_10_2019 saveTheChunk --1--');
            fileId = saveTheFile(parentId, fileName, base64Data, contentType, AttachmentIscritto );
        } else {
            appendToFile(fileId, base64Data);
            system.debug('28_10_2019 saveTheChunk --2--');
        }
        return Id.valueOf(fileId);
    }

    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        ContentVersion contentVersion = [
            SELECT Id, versionData
            FROM ContentVersion
            WHERE Id = :fileId
        ];
        String existingBody = EncodingUtil.base64Encode(contentVersion.versionData);
        contentVersion.versionData = EncodingUtil.base64Decode(existingBody + base64Data); 
        update contentVersion;   
    }
    
    
    @AuraEnabled
    public static void processData( String fileData,
                                    IVASS_Dealer_courses_attachments__c AttachmentIscritto ) {
        System.debug('AttachmentIscritto : '+ AttachmentIscritto);
        System.debug('fileData : '+ fileData);
        System.debug('after dealerCorsoID ');
        
        try {
            
            upsert AttachmentIscritto;
            
        }catch(DMLException e){
            System.debug('exception'+e.getMessage());   
            System.debug('exception'+e.getCause());   
            System.debug('exception'+e.getLineNumber());   
            System.debug('exception'+e.getStackTraceString());   
        }
       
    }
    

 /**
 * @description: Save|find ContentDistribution record by ContentVersionId, set Link_Documento__c and return ContentDownloadURL
 * @date: 01/10/2019
 * @author: Khadim R Ndeye
 * @params: ID contentVersionId, IVASS_Dealer_courses_attachments__c AttachmentIscritto
 * @return: String | ContentDownloadURL
 */
public Static String setLinkDocumento(ID contentVersionId, IVASS_Dealer_courses_attachments__c AttachmentIscritto){
ContentVersion cv = [SELECT ID , Title, ContentDocumentID from ContentVersion where ID= :contentVersionId];

List<ContentDistribution> cdList = [select ID,DistributionPublicUrl ,ContentDownloadURL  from ContentDistribution where ContentVersionId= :cv.Id and ContentDocumentId=:cv.ContentDocumentId ];
        if(cdList.size()>0){
            return cdList.get(0).ContentDownloadUrl;
        }else{
            ContentDistribution newItem = new ContentDistribution();
            newItem.Name = cv.Title;
            newItem.ContentVersionId = cv.Id;
            newItem.PreferencesAllowViewInBrowser= true;
            newItem.PreferencesLinkLatestVersion=true;
            newItem.PreferencesNotifyOnVisit=false;
            newItem.PreferencesPasswordRequired=false;
            newItem.PreferencesAllowOriginalDownload= true;
            Insert NewItem;
            newItem = [SELECT ID, DistributionPublicUrl, ContentDownloadURL from ContentDistribution where ID= :newItem.Id];
            AttachmentIscritto.Link_Documento__c = newItem.ContentDownloadURL;
            upsert AttachmentIscritto;
            return newItem.ContentDownloadURL;
        }
}
}