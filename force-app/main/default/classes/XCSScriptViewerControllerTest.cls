@isTest
public class XCSScriptViewerControllerTest {
    @testSetup 
    static void setup()
    {
        Case c = new Case();
        c.Subject = 'TestCase';
        c.ActivityType__c = 'CRM_GDS';
        Insert c;    
        
        XCS_Script__c script = new XCS_Script__c();
        script.Text__c = 'TESTO DI PROVA A SCRIVERE';
        script.CaseActivityType__c = 'CRM_GDS';
        insert script;
    }
    @isTest
    static void returnText()
    {
        String caseid = [Select Id from Case Where Subject ='TestCase'].Id ;
        
        System.assert(XCSScriptViewerController.getScript(caseid).equals('TESTO DI PROVA A SCRIVERE'));
    }
}