@isTest
public class GestioneFaxCQTest {
    
    @isTest
    public static void executeTest(){
        
        Group queueOutsourcer = new Group();
        queueOutsourcer.Name = 'CodaCQOutsourcer';
        queueOutsourcer.type = 'Queue';
        queueOutsourcer.DeveloperName = 'CodaCQOutsourcer';
        insert queueOutsourcer;
        
        Group queueAssignToEmail = new Group();
        queueAssignToEmail.Name = 'CodaBalancing';
        queueAssignToEmail.type = 'Queue';
        queueAssignToEmail.DeveloperName = 'CodaBalancing';
        insert queueAssignToEmail;
        
        Group queueCSI = new Group();
        queueCSI.Name = 'CodaCQCsi';
        queueCSI.type = 'Queue';
        queueCSI.DeveloperName = 'CodaCQCsi';
        insert queueCSI;
        
        CRM_QueueMailFaxConfig__c  qmfxTest = new CRM_QueueMailFaxConfig__c();
        qmfxTest.Balancing__c = 100;
        qmfxTest.Type__c = 'fax';
        qmfxTest.DeveloperName__c = 'CodaBalancing';
        qmfxTest.MailBox__c = 'Prova@Test.com';
        qmfxTest.Queue_Outsourcer__c = 'CodaCQOutsourcer';
        qmfxTest.Queue_CSI__C = 'CodaCQCsi';
        qmfxTest.Fax_to_check__c = 1;
        qmfxTest.Checked_in_this_month__c = 0;
        insert qmfxTest;
               
        System.runAs(new User(Id=UserInfo.getUserId())){
            QueueSobject mappingObject1 = new QueueSobject(QueueId = queueOutsourcer.Id, SobjectType = 'Case');
            insert mappingObject1;
            QueueSobject mappingObject2 = new QueueSobject(QueueId = queueAssignToEmail.Id, SobjectType = 'Case');
            insert mappingObject2;
            QueueSobject mappingObject3 = new QueueSobject(QueueId = queueCSI.Id, SobjectType = 'Case');
            insert mappingObject3;
                       
            Case c = new Case();
            c.ownerId = queueAssignToEmail.id;
            c.Origin = 'fax';
            c.Subject = 'Case di prova';
            c.status = 'Closed';
            c.Queue_Mail_Fax_Config__c = qmfxTest.id;                    
            insert c;
            
            Datetime oneMonthBefore = Datetime.now().addDays(-30);
            Test.setCreatedDate(c.id, oneMonthBefore);
            
            Case c2 = new Case();
            c.ownerId = queueAssignToEmail.id;
            c2.Origin = 'fax';
            c2.Subject = 'Case di prova 2';
            c2.status = 'Closed';
            c2.Queue_Mail_Fax_Config__c = qmfxTest.id;
            insert c2;    
            
            //lancio della classe da testare
             System.debug('qmfxTest prima del metodo ' + qmfxTest);
            GestioneFaxCQ cq = new GestioneFaxCQ();
            cq.execute();
            
            //Il case inizialmente ha come owner la coda di smsistamento associata alla email.
            //Mi aspetto che alla fine del metodo il case sia associato alla coda CQ del Csi
            
            System.assertEquals(queueCSI.id,[Select ownerId from case where id =: c.id].ownerId);
            
            //Mi aspetto che sia stato creato un task associato al case con subject 'Task di controllo qualità'
            //Mi aspetto che sia stato creato un task associato al case con type 'Fax Controllo'
            
            System.assertEquals('Task di controllo qualità', [Select subject from task where whatId =: c.id].subject);
            System.assertEquals('Fax Controllo',[Select type from task where whatId =: c.id].type);
            
            //Mi aspetto che dopo il metodo il valore Checked_in_this_month__c sia passato da 0 a 1 (Ho controllato un solo caso)
            
            System.assertEquals(1,[Select Checked_in_this_month__c from CRM_QueueMailFaxConfig__c].Checked_in_this_month__c);
            
        }
    }
    
}