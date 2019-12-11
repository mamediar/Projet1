@isTest
public class GestioneEmailPrevalorizzazioneCampiTest {
    
    @isTest
    public static void onInitDefaultsTest(){

        For(Integer i = 1; i <= 10; i++){
            Group g = new Group();
            g.name = 'qx' + i;
            g.type = 'Queue';
            g.DeveloperName = 'qx' + i;
            insert g;
        }
           
        //carico le configurazioni dell ' oggetto CRM_QueueMailFaxConfig
        test.loadData(CRM_QueueMailFaxConfig__c.sObjectType, 'CRM_QueueMailFaxConfigTest');
        
        //preparo il Case e l'EmailMessage 
        Case c = new Case();
        c.origin = 'Email';       
        RecordType r = [Select id from RecordType where DeveloperName = 'CRM_Gestione_Email'];
        c.recordTypeId = r.id;
        insert c;
        
        EmailMessage e = new EmailMessage();
        e.toAddress = 'emailprovasales@gmail.com';
        e.ParentId = c.id;      
        insert e;
        
        
        GestioneEmailPrevalorizzazioneCampi gpc = new GestioneEmailPrevalorizzazioneCampi();
        
        //Creo la quick Action di tipo Case.SendEmail con punto di partenza il Case
        String defaultsAsJSON = '[{"targetSObject":{"attributes":{"type":"EmailMessage"},"TextBody":"",'
            + '"FromName":"Test","FromAddress":"test@example.com","HtmlBody":"<html><body></body></html>","BccAddress":"test@example.com",'
            + '"CcAddress":"","ToAddress":"emailprovasales@gmail.com","Subject":"Testing"},"contextId":"'+ c.id + '","actionType":"Email",'
            + '"actionName":"Case.SendEmail","fromAddressList":["servizioClienti@compass.it"]}]';
        List<QuickAction.SendEmailQuickActionDefaults> defaultsSettings = 
            (List<QuickAction.SendEmailQuickActionDefaults>)JSON.deserialize(defaultsAsJSON, List<QuickAction.SendEmailQuickActionDefaults>.class);
        
        gpc.onInitDefaults(defaultsSettings);
        
        //creo la quick Action di tipo EmailMessage._Reply con punto di partenza l'EmailMessage
        String defaultsAsJSONEmail = '[{"targetSObject":{"attributes":{"type":"EmailMessage"},"TextBody":"",'
            + '"FromName":"Test","FromAddress":"test@example.com","HtmlBody":"<html><body></body></html>","BccAddress":"test@example.com",'
            + '"CcAddress":"","ToAddress":"emailprovasales@gmail.com","Subject":"Testing"},"contextId":"'+ e.id + '","actionType":"Email",'
            + '"actionName":"EmailMessage._Reply","fromAddressList":["servizioClienti@compass.it"]}]';
        List<QuickAction.SendEmailQuickActionDefaults> defaultsSettingsEmail = 
            (List<QuickAction.SendEmailQuickActionDefaults>)JSON.deserialize(defaultsAsJSONEmail, List<QuickAction.SendEmailQuickActionDefaults>.class);
        
        gpc.onInitDefaults(defaultsSettingsEmail);
        
        //creo la quick Action di tipo EmailMessage._ReplyAll con punto di partenza l'EmailMessage
        String defaultsAsJSONEmailAll = '[{"targetSObject":{"attributes":{"type":"EmailMessage"},"TextBody":"",'
            + '"FromName":"Test","FromAddress":"test@example.com","HtmlBody":"<html><body></body></html>","BccAddress":"test@example.com",'
            + '"CcAddress":"","ToAddress":"emailprovasales@gmail.com","Subject":"Testing"},"contextId":"'+ e.id + '","actionType":"Email",'
            + '"actionName":"EmailMessage._ReplyAll","fromAddressList":["servizioClienti@compass.it"]}]';
        List<QuickAction.SendEmailQuickActionDefaults> defaultsSettingsEmailAll = 
            (List<QuickAction.SendEmailQuickActionDefaults>)JSON.deserialize(defaultsAsJSONEmailAll, List<QuickAction.SendEmailQuickActionDefaults>.class);
        
        gpc.onInitDefaults(defaultsSettingsEmailAll);   
        
    }
}