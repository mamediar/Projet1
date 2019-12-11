@isTest
public class XCSNoteUtilsTest {
    @isTest 
    static void testPostANote(){
        Case c=new Case();
        insert c;
        
        XCSNoteUtils.postANote(c.Id,'Test','test');
    }
    
        @isTest 
        static void TestpostaNoteInContentDocument(){
        Case ca=new Case();
        insert ca;
        
        XCSNoteUtils.postaNoteInContentDocument(ca.Id,'Test','test');
        XCSNoteUtils.getAllNotesByContentDocument(ca.id);
    }
}