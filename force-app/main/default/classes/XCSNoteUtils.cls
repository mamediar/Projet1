public class XCSNoteUtils {
    
    Public static FINAL String SYSTEM_NOTE_TITLE = 'Nota di Sistema';
    Public static FINAL String USER_NOTE_TITLE = 'Nota Utente';
      
    public static ContentNote createCaseNote(String title,String textNote) {
        
        ContentNote objNote = new ContentNote();
        objNote.Title = title;
        objNote.Content = Blob.valueOf(textNote.escapeXML());
        return objNote;
    }
    
    public static ContentDocumentLink createDocumentLink(String strNoteID, String strCaseID) {
        
        ContentDocumentLink objLink = new ContentDocumentLink();
        objLink.ContentDocumentId = strNoteID;
        objLink.LinkedEntityId = strCaseID;
        objLink.ShareType = 'I'; 
        objLink.Visibility = 'AllUsers';
        return objLink;
    }
    
    public static List<ContentNote> instanceContentNoteList(String title,String body,integer counter){
        list<ContentNote> contentNoteList = new List<ContentNote>();
        for(integer i = 0; i < counter ; i++){
           contentNoteList.add(new ContentNote(
           		Title = title,
               	Content=Blob.valueOf(body.escapeXML())
           ));
        }
        return contentNoteList;
    }
    // viene passata una mappa che tiene come chiave l'id del sbject e come valore la nota da inserire e viene inserita in modo massivo
    public static void insertObjectsNotes(Map<String,wrapNoteTitle> mapSObjectNote){
        Map<String,ContentNote> mapObjectContentNote = new Map<String,ContentNote>();
        List<ContentDocumentLink> lContentDocumentLink = new List<ContentDocumentLink>();
        for(String key : mapSObjectNote.keySet())
        {
         	mapObjectContentNote.put(key,new ContentNote(Title = mapSObjectNote.get(key).title,content = Blob.valueOf(mapSObjectNote.get(key).body.escapeXML())));   
        }
        if(mapObjectContentNote.size() > 0){
            insert mapObjectContentNote.values();
            For(String key : mapObjectContentNote.keySet())
            {
                lContentDocumentLink.add(new ContentDocumentLink(
                    ShareType='I',
                    Visibility='AllUsers',
                    LinkedEntityId = key,
                    ContentDocumentId = mapObjectContentNote.get(key).id
                ));                         
            }
            Insert lContentDocumentLink;
        }
        else
        {
            System.debug('Note Non Trovate');
        }
    }
    
    public static void insertObjectNote(List<SObjectNote> listOBJNote){
        List<ContentDocumentLink> lContentDocumentLink = new List<ContentDocumentLink>();
        For(SObjectNote sb : listOBJNote){
            lContentDocumentLink.add(new ContentDocumentLink(
                ShareType='I',
                Visibility='AllUsers',
                LinkedEntityId = sb.sObjectId,
                ContentDocumentId = sb.noteId
            )
                                    );
        }
    }
    
    public static ContentNote postANote(String recordId,String title,String body){
        System.debug('DP recordId: '+recordId);
        ContentNote res=new ContentNote();
        res.Title=title;
        res.Content=Blob.valueOf(body.escapeXML());
        insert res;
        
        ContentDocumentLink link=new ContentDocumentLink();
        link.ContentDocumentId=res.id;
        link.LinkedEntityId=recordId;
        link.ShareType='I'; 
        link.Visibility='AllUsers';
        insert link;
        
        return res;
    }
    
    public static ContentDocument postaNoteInContentDocument(String recordId,String title,String body){
        ContentNote note=new ContentNote();
        note.Title=title;
        //note.Content=Blob.valueOf(body.escapeHtml4());
        insert note;
        
        ContentDocumentLink link=new ContentDocumentLink();
        link.ContentDocumentId=note.id;
        link.LinkedEntityId=recordId;
        link.ShareType='I'; 
        link.Visibility='AllUsers';
        insert link;
        
        
        ContentDocument res = [select Id,Title,FileType,ContentSize,Description,CreatedDate from ContentDocument where id=:note.id];  
        res.Description=body;
        update res;        
        
        return res;
        
    }    
     
    public static List<ContentDocument> getAllNotesByContentDocument(String recordId){
        List<ContentDocumentLink> CDLs = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
        List <Id> CDIdList = new List <Id> ();
        for (ContentDocumentLink nextCDL : CDLs) {
            CDIdList.add(nextCDL.ContentDocumentId); }        
        List<ContentDocument> res = [SELECT Id, Title, CreatedDate, Description FROM ContentDocument WHERE Id IN :CDIdList AND FileType=:'SNOTE' ORDER BY CreatedDate DESC];          
		System.debug('res'+res);
        return res; 
    }       

    public static List<ContentNote> getAllNotes(String recordId){
        List<ContentDocumentLink> CDLs = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
        List <Id> CDIdList = new List <Id> ();
        for (ContentDocumentLink nextCDL : CDLs) {
            CDIdList.add(nextCDL.ContentDocumentId); }        
        List<ContentNote> res = [SELECT Id, Title, CreatedDate, CreatedById, CreatedBy.Alias, CreatedBy.DefaultQueueId__c, CreatedBy.Name, Content, TextPreview FROM ContentNote WHERE Id IN :CDIdList AND FileType=:'SNOTE' ORDER BY CreatedDate DESC];          
		System.debug('res'+res);
        return res; 
    }   

    //recupera le note associate ad un record filtrandole per il titolo
    public static List<ContentNote> getAllNotes(String recordId, String titleFilter){   
        List<ContentDocumentLink> CDLs = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
        List <Id> CDIdList = new List <Id> ();
        for (ContentDocumentLink nextCDL : CDLs) {
            CDIdList.add(nextCDL.ContentDocumentId); }        
        List<ContentNote> res = [SELECT Id, Title, CreatedDate, CreatedById, CreatedBy.Alias, CreatedBy.Name, CreatedBy.DefaultQueueId__c, Content, TextPreview 
                                 FROM ContentNote WHERE Id IN :CDIdList AND FileType=:'SNOTE' AND Title=:titleFilter ORDER BY CreatedDate DESC];          
		System.debug('res'+res);
        return res; 
    } 
    
    //recupera le note associate ad un record filtrandole in base a un intervallo di tempo
    public static List<ContentNote> getAllNotes(String recordId, DateTime startDateTime, DateTime endDateTime){
        List<ContentDocumentLink> CDLs = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
        List <Id> CDIdList = new List <Id> ();
        for (ContentDocumentLink nextCDL : CDLs) {
            CDIdList.add(nextCDL.ContentDocumentId); }        
        List<ContentNote> res = [SELECT Id, Title, CreatedDate, CreatedById, CreatedBy.Alias, CreatedBy.Name, CreatedBy.DefaultQueueId__c, Content, TextPreview 
                                 FROM ContentNote WHERE Id IN :CDIdList AND FileType=:'SNOTE' AND (CreatedDate>=:startDateTime AND CreatedDate<=:endDateTime) ORDER BY CreatedDate DESC];          
		System.debug('res'+res);
        return res; 
    }   
    
    //recupera le note associate ad un record filtrandole a partire da una certa data
    public static List<ContentNote> getAllNotes(String recordId, DateTime startDateTime){
        List<ContentDocumentLink> CDLs = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
        List <Id> CDIdList = new List <Id> ();
        for (ContentDocumentLink nextCDL : CDLs) {
            CDIdList.add(nextCDL.ContentDocumentId); }        
        List<ContentNote> res = [SELECT Id, Title, CreatedDate, CreatedById, CreatedBy.Alias, CreatedBy.Name, CreatedBy.DefaultQueueId__c, Content, TextPreview 
                                 FROM ContentNote WHERE Id IN :CDIdList AND FileType=:'SNOTE' AND CreatedDate>=:startDateTime ORDER BY CreatedDate DESC];          
		System.debug('res'+res);
        return res; 
    }     

    public static Integer getNoteCount(String parentId) {
        Integer noteCount = [SELECT Count() FROM ContentDocumentLink WHERE LinkedEntityId =:parentId];
        return noteCount == null ? 0 : noteCount;
    }
    
    public class wrapNoteTitle{
        String title;
        String body;
        public wrapNoteTitle(String title,String body){
            this.title = title;
            this.body = body;
        }
    }

    public class SObjectNote{
        String sObjectId;
        String noteId;
        public SObjectNote(String sObjectId,String noteId){
            this.sObjectId = sObjectId;
            this.noteId = noteId;
        }
    }
}