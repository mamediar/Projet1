@isTest
public class SFATargheMancantiControllerTest {
    
    @isTest
    public static void insertFileTest(){
        string data = '2001-04-05'; 
        
        SFATargheMancantiController.insertFile('testo','titolo','txt',data);
        //Test eccezione
        SFATargheMancantiController.insertFile('','','',''); 
    }
    
    @isTest
    public static void createCasesTest(){
        
        Date data = date.today();     
        ContentVersion file = new ContentVersion();
        file.Title = 'Test';
        file.ContentUrl = 's';
        insert file;
        
        SFATargheMancantiController.createCases(file.id,data);     
    }
    
    @isTest
    public static void checkLoadingStatusTest(){
        
        //per la condizione else
        SFATargheMancantiController.checkLoadingStatus();
                
        Case c = new Case();
        c.ActivityType__c = 'SFA_TARMANPARENT';
        insert c;
        
        SFATargheMancantiController.checkLoadingStatus();
    }
    
}