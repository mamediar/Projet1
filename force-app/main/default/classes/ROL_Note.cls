//----------------------------------------------------------------------
//-- - Author       : Sana Badji
//-- - Date         : 08/11/2019
//-- - Class  : ROL_Note
//----------------------------------------------------------------------
public with sharing class ROL_Note {
    
    public static FeedItem  createFeeditem(String title, String body, String idCase){
        Case caseObj =getIdCase(idCase);
        ID caseId=caseObj.Id;
        System.debug('caseObj_Id '+caseObj.Id);
        FeedItem feeditem = new FeedItem();
        feeditem.ParentId = caseId;
        feeditem.Body =body;
        feeditem.Title =title;
        try {
            insert feeditem;
            System.debug('FeedItem Created Successfully '+feeditem);
            ContentDocumentLink clnk = new ContentDocumentLink();
            clnk.ContentDocumentId = feeditem.Id;
            System.debug('ContentDocumentLink Created Successfully '+clnk);
        } catch (Exception e) {
             System.debug('error insert note '+e.getMessage()+' '+e.getStackTraceString()+' '+e.getLineNumber());
        }
        return feeditem;         
    }

    public static Case getIdCase(String idCase){
        List<String> errorFields = new List<String>(); 
        Case caseObj;
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','CRM_RichiestaOnline');
        try {  
        caseObj = [SELECT Id FROM Case WHERE Id = : idCase AND  RecordTypeId= :recordType ];
        }catch (System.QueryException e) {
        caseObj=null;
        System.debug('************* Id not exit   '+e.getMessage());
        }
        return caseObj;
    }
}