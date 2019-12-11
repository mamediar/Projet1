@isTest 
public class RoutingEmailFaxTest {
    
    @testSetup
    public static void setup(){
        
        Group g1 = new Group();
        g1.Name = 'qx1';
        g1.type = 'Queue';
        g1.DeveloperName = 'qx1';
        insert g1;
        
        Group g2 = new Group();        
        g2.Name = 'qx2';
        g2.type = 'Queue';
        g2.DeveloperName = 'qx2';
        insert g2;
        
        Group g3 = new Group();
        g3.Name = 'qx3';
        g3.type = 'Queue';
        g3.DeveloperName = 'qx3';
        insert g3;
        
        Group g4 = new Group();
        g4.Name = 'qx4';
        g4.type = 'Queue';
        g4.DeveloperName = 'qx4';
        insert g4;
        
        Group g5 = new Group();
        g5.Name = 'qx5';
        g5.type = 'Queue';
        g5.DeveloperName = 'qx5';
        insert g5;
        
        Group g6 = new Group();
        g6.Name = 'qx6';
        g6.type = 'Queue';
        g6.DeveloperName = 'qx6';
        insert g6;
        
        Group g7 = new Group();
        g7.Name = 'qx7';
        g7.type = 'Queue';
        g7.DeveloperName = 'qx7';
        insert g7;
        
        Group g8 = new Group();
        g8.Name = 'qx8';
        g8.type = 'Queue';
        g8.DeveloperName = 'qx8';
        insert g8;
        
        Group g9 = new Group();
        g9.Name = 'qx9';
        g9.type = 'Queue';
        g9.DeveloperName = 'qx9';
        insert g9;
        
        Group g10 = new Group();
        g10.Name = 'qx10';
        g10.type = 'Queue';
        g10.DeveloperName = 'qx10';
        insert g10;
        
        test.loadData(CRM_QueueMailFaxConfig__c.sObjectType, 'CRM_QueueMailFaxConfigTest');
        List<Case> caseToTest = test.loadData(Case.sObjectType, 'CaseRoutingTest');
        
        System.debug('i casi del test PRIMA sono ' +  caseToTest[0].RecordType.developerName);
        RecordType r = [select id, developerName from recordType where developerName = 'CRM_Gestione_Email'];
        Group g = [Select id from Group where DeveloperName = 'Q501'];
        System.debug('recordTypeid = ' + r.id);
        for(Case t : caseToTest){
            t.recordTypeid = r.id;
            t.ownerId = g.id;
        }
        
        update caseToTest;
        System.debug('i casi del test DOPO sono ' +  caseToTest[0].RecordType.developerName);                       
        
        System.runAs(new User(Id=UserInfo.getUserId())){
            QueueSobject mappingObject1 = new QueueSobject(QueueId = g1.Id, SobjectType = 'Case');
            insert mappingObject1;
            QueueSobject mappingObject2 = new QueueSobject(QueueId = g2.Id, SobjectType = 'Case');
            insert mappingObject2;
            QueueSobject mappingObject3 = new QueueSobject(QueueId = g3.Id, SobjectType = 'Case');
            insert mappingObject3;
            QueueSobject mappingObject4 = new QueueSobject(QueueId = g4.Id, SobjectType = 'Case');
            insert mappingObject4;
            
            QueueSobject mappingObject5 = new QueueSobject(QueueId = g5.Id, SobjectType = 'Case');
            insert mappingObject5;
            QueueSobject mappingObject6 = new QueueSobject(QueueId = g6.Id, SobjectType = 'Case');
            insert mappingObject6;
            QueueSobject mappingObject7 = new QueueSobject(QueueId = g7.Id, SobjectType = 'Case');
            insert mappingObject7;
            QueueSobject mappingObject8 = new QueueSobject(QueueId = g8.Id, SobjectType = 'Case');
            insert mappingObject8;
            
            QueueSobject mappingObject9 = new QueueSobject(QueueId = g9.Id, SobjectType = 'Case');
            insert mappingObject9;
            QueueSobject mappingObject10 = new QueueSobject(QueueId = g10.Id, SobjectType = 'Case');
            insert mappingObject10;
        }
        
        Integer conta = 0;       
        List<EmailMessage> listaEmail = new List<EmailMessage>();
        
        for (Case c : caseToTest){
            if(conta < 10){          		                    
                listaEmail.add(creaEmail('dylan.inner@gmail.com',c.id));
                conta++;              
            }
            else if(conta >= 10 && conta < 20){        
                listaEmail.add(creaEmail('emailprovasales@gmail.com',c.id));
                conta++;              
            }
        }
        insert listaEmail;
    }
    
    @isTest
    public static void doInitTest(){
        
        RoutingEmailFax routing = new RoutingEmailFax();
        
        RecordType r = [select id, developerName from recordType where developerName = 'CRM_Gestione_Email'];
        Group gx2 = [Select id from group where DeveloperName = 'qx2'];
        
        Case alreadyInQueue = new Case();
        alreadyInQueue.ActivityType__c = 'CRM_Gestione_Email';
        alreadyInQueue.Origin = 'Email';
        alreadyInQueue.RecordTypeId = r.id;
        alreadyInQueue.OwnerId = gx2.id;        
        insert alreadyInQueue;
        
        routing.init();
        
        System.assert(routing.queueMailFaxMap.size() > 0); 
        System.assert(routing.mailsMap.size() > 0);
        
        RoutingEmailFax.Mail mail = routing.mailsMap.get('emailprovasales@gmail.com');
        
        List<Case> cases = [SELECT Id,Subject,origin,ActivityType__c, status, recordType.developerName, OwnerId FROM Case where Subject = 'TestEmailFax'];        
        System.assert(cases.size() > 0);
        
        routing.routing(cases);                      
        routing.routing(cases,'emailprovasales@gmail.com');   
        
    } 
    
    public static EmailMessage creaEmail(String indirizzo, String IdCase){
        EmailMessage g = new EmailMessage();
        g.ParentId = IdCase;
        g.FromAddress = 'test@abc.org';
        g.Incoming = True;
        g.ToAddress = indirizzo;
        g.Subject = 'TestRouting';
        g.HtmlBody = 'Test email body';  
        
        return g;
    }    
}