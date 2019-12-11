//----------------------------------------------------------------------
//-- - Author       : Sana Badji
//-- - Date         : 08/11/2019
//-- - Class  : ROL_FeedItem
//----------------------------------------------------------------------
public with sharing class ROL_FeedItem {
    
    public static FeedItem  createFeeditem(String title, String body, Id idCase){
        FeedItem feeditem = new FeedItem();
        feeditem.ParentId = idCase;
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
}