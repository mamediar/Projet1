@isTest
public class TestContentNote4Site {
    @isTest
    public static void createNote(){
        FObject objCase=new FObject('Case',1);
        objCase.setDefinition('RecordTypeId','static value(CRM_Reclami)');
        objCase.insertRecords(true);
        
        Case c=[select id,ownerid,owner.name from case];
              
        
        User u=[select id from user where username='compass_site@r1dev-compass--r1dev.cs109.force.com.dev3'];
        //User u=[select id from user where username='maurizio.colombo@lynxspa.com.dev3'];
        //
        insert new CaseShare(caseId=c.id,userOrGroupId=u.id,caseAccessLevel='Edit' );
        System.runAs(u){
            FeedItem post = new FeedItem();
post.Body = 'HelloThere';
post.ParentId = c.id;
post.Title = 'FileName';
post.NetworkScope='AllNetworks';
post.Visibility='AllUsers';
insert post;

            
            /****
            ContentNote nota = new ContentNote();
            nota.Title = 'Corrispondenza';
            String body='CIAO';
            nota.Content = Blob.valueOf(body.escapeHTML4());
            
            insert nota;
            ***/
        }
        /***
        List<ContentNote> lstNote=[select id,TextPreview,createddate from ContentNote];
        System.debug('SIZE '+lstNote.size());
        ContentNote nota=lstNote[0];
        System.debug('QUERY NOTA '+nota.id+' '+nota.TextPreview+' CREATED '+nota.createddate);
        System.assert([select id from ContentNote].size()>0);
***/
        FeedItem nota=[select id,title,body,createddate from FeedItem];
        System.debug('QUERY FEED '+nota.id+' '+nota.body+' CREATED '+nota.createddate);
        System.assert([select id from FeedItem].size()>0);        
    }

}