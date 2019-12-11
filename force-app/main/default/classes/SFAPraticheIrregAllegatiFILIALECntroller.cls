public class SFAPraticheIrregAllegatiFILIALECntroller {

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
         if (pratica.DataInserimento__c>file.CreatedDate || file.Description=='GDV' ){
             filesVecchi.add(file);                    
         } else {
             filesNuovi.add(file);  
         } 
     }
     filesDaRestituire.nuovi=filesNuovi;
     filesDaRestituire.vecchi=filesVecchi;        
           
     return filesDaRestituire;  
   }  
   @AuraEnabled  
   public static Files UpdateFiles(string documentId, string recordId){   
       ContentDocument cd = [select id,Description from ContentDocument where Id=:documentId]; 
       User u = [select firstname, lastname, DefaultQueueId__c from user where id=:userinfo.getuserid()][0]; 
       List<Account> filialeUser = [SELECT id, Name, OCS_External_Id__c, RecordType.Name, BusinessEmail__c 
                                    FROM Account WHERE RecordType.Name = 'Branch' AND OCS_External_Id__c = :u.DefaultQueueId__c];         
       if (string.isEmpty(u.DefaultQueueId__c) || filialeUser.size()<1){
           cd.Description =u.firstname+' '+u.lastname;
       } else {
           cd.Description =filialeUser[0].Name;
       }       
       
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
         if (pratica.DataInserimento__c>file.CreatedDate || file.Description=='GDV' ){
             filesVecchi.add(file);                    
         } else {
             filesNuovi.add(file);  
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


    @AuraEnabled
    public static Boolean disabilitaBottoneElimina(String recordId) {
        Boolean disabilita=true;  
        Date today=Date.today();
        SFA_PraticaIrregolare__c pratica=[SELECT Id,Status__c,DataTermineLavoro__c,RiscontroFinale__c FROM SFA_PraticaIrregolare__c WHERE Id = :recordId];
        if ((pratica.Status__c == 'Pratica - da Gestire') && (pratica.RiscontroFinale__c!='INF' && pratica.RiscontroFinale__c!='POS' && pratica.RiscontroFinale__c!='RIC') && today<pratica.DataTermineLavoro__c) {
                disabilita=false;   
        }
        return disabilita;          
    }      
      @AuraEnabled
      public static Boolean verificaSeFileCaricabile(String recordId) {
        Boolean disabilita=true;
        Date today=Date.today();
          System.debug('recordId a0G0Q0000022ctOUAQ:: '+recordId);
        SFA_PraticaIrregolare__c pratica=[SELECT Id, Status__c, DataTermineLavoro__c,RiscontroFinale__c FROM SFA_PraticaIrregolare__c WHERE Id = :recordId];      
		System.debug('recordId pratica:: '+pratica);
          if ((pratica.RiscontroFinale__c=='POS' || pratica.RiscontroFinale__c=='INF' || ((pratica.Status__c == 'Pratica - da Gestire' || pratica.Status__c == 'Pratica - Richiesta Maggiori Informazioni') && pratica.RiscontroFinale__c != 'RIC'))&& today<pratica.DataTermineLavoro__c){  
          disabilita=false;  
          System.debug('disabilita1'+disabilita);    
          }
        System.debug('disabilita'+disabilita);
        return disabilita; 
      } 
   
    public class Files {
        @AuraEnabled
        public List<ContentDocument> vecchi;  
        @AuraEnabled
        public List<ContentDocument> nuovi;
    }     


}