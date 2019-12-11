public class SFAPraticheIrregAllegatiGDVController {
    
   @AuraEnabled 
   public static Files getFiles(string recordId){  
     List<ContentDocument> DocumentList = new List<ContentDocument>();  
     Set<Id> documentIds = new Set<Id>();  
     List<ContentDocumentLink> cdl=[select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId=:recordId];  
     for(ContentDocumentLink cdLink:cdl){  
       documentIds.add(cdLink.ContentDocumentId);  
     }      
     DocumentList = [select Id,Title,FileType,ContentSize,Description,CreatedDate from ContentDocument where id IN: documentIds AND FileType!=:'SNOTE'];  
     
     SFA_PraticaIrregolare__c pratica = [SELECT Id, DataInserimento__c,NumeroAllegati__c FROM SFA_PraticaIrregolare__c 
                                        WHERE Id=:recordId];
     Files filesDaRestituire=new Files();  
     List <ContentDocument> filesNuovi = new List <ContentDocument> ();
     List <ContentDocument> filesVecchi = new List <ContentDocument> ();
     for (ContentDocument file:DocumentList){       
         if (pratica.DataInserimento__c<file.CreatedDate){
             filesNuovi.add(file);                    
         } else {
             filesVecchi.add(file);  
         } 
     }
     filesDaRestituire.nuovi=filesNuovi;
     filesDaRestituire.vecchi=filesVecchi;        
           
     return filesDaRestituire;  
   }  
    
   @AuraEnabled  
   public static Files UpdateFiles(string documentId, string recordId){   
     ContentDocument cd = [select id,Description from ContentDocument where Id=:documentId]; 
     cd.Description = 'GDV';
     try{  
       update cd;  
     }  
     catch(DMLException e){  
       system.debug('Exception has occurred! ' +e.getMessage());  
     }  
     List<ContentDocument> DocumentList = new List<ContentDocument>();  
     Set<Id> documentIds = new Set<Id>();  
     List<ContentDocumentLink> cdl=[select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId=:recordId];  
     for(ContentDocumentLink cdLink:cdl){  
       documentIds.add(cdLink.ContentDocumentId);  
     }      
     DocumentList = [select Id,Title,FileType,ContentSize,Description,CreatedDate from ContentDocument where id IN: documentIds AND FileType!=:'SNOTE']; 
       
     SFA_PraticaIrregolare__c pratica = [SELECT Id, DataInserimento__c,NumeroAllegati__c FROM SFA_PraticaIrregolare__c 
                                        WHERE Id=:recordId];
     pratica.NumeroAllegati__c=DocumentList.size();
     try{
        update pratica;                
     }
     catch (Exception ex) {
        system.debug('Exception has occurred! ' +ex.getMessage());  
     }
     Files filesDaRestituire=new Files();  
     List <ContentDocument> filesNuovi = new List <ContentDocument> ();
     List <ContentDocument> filesVecchi = new List <ContentDocument> ();
     for (ContentDocument file:DocumentList){       
         if (pratica.DataInserimento__c<file.CreatedDate){
             filesNuovi.add(file);                    
         } else {
             filesVecchi.add(file);  
         } 
     }
     filesDaRestituire.nuovi=filesNuovi;
     filesDaRestituire.vecchi=filesVecchi;     
           
     return filesDaRestituire;  
   }  
    
    @AuraEnabled
    public static Files eliminaFilePassato(Id documentId, String recordId)
    {   
        ContentDocument cd = [select id,Description from ContentDocument where Id=:documentId]; 
        try{
            delete cd;                
        }
        catch (Exception ex) {
            system.debug('Exception has occurred! ' +ex.getMessage());  
        }
        List<ContentDocument> DocumentList = new List<ContentDocument>();  
        Set<Id> documentIds = new Set<Id>();  
        List<ContentDocumentLink> cdl=[select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId=:recordId];  
        for(ContentDocumentLink cdLink:cdl){  
            documentIds.add(cdLink.ContentDocumentId);  
        }      
        DocumentList = [select Id,Title,FileType,ContentSize,Description,CreatedDate from ContentDocument where id IN: documentIds AND FileType!=:'SNOTE'];  

        SFA_PraticaIrregolare__c pratica = [SELECT Id, DataInserimento__c,NumeroAllegati__c FROM SFA_PraticaIrregolare__c 
                                        WHERE Id=:recordId];
        pratica.NumeroAllegati__c=DocumentList.size();
        try{
            update pratica;                
        }
        catch (Exception ex) {
            system.debug('Exception has occurred! ' +ex.getMessage());  
        }
        Files filesDaRestituire=new Files();  
        List <ContentDocument> filesNuovi = new List <ContentDocument> ();
        List <ContentDocument> filesVecchi = new List <ContentDocument> ();
        for (ContentDocument file:DocumentList){       
            if (pratica.DataInserimento__c<file.CreatedDate){
                filesNuovi.add(file);                    
            } else {
                filesVecchi.add(file);  
            } 
        }
        filesDaRestituire.nuovi=filesNuovi;
        filesDaRestituire.vecchi=filesVecchi;         
        return filesDaRestituire;       
        
    }    
    
    public class Files {
        @AuraEnabled
        public List<ContentDocument> vecchi;  
        @AuraEnabled
        public List<ContentDocument> nuovi;
    } 
    
    
 }