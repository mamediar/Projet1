@isTest
public class CaseAssignmentRuleTest {
   @isTest
   public static void createCaseClosed(){
       Database.DMLOptions dmlOpts = new Database.DMLOptions();
       dmlOpts.assignmentRuleHeader.useDefaultRule= true;

       Map<Id,User> mapUser=new Map<Id,User>([select id,name from user]);
       FObject objCase=new FObject('Case',1);
       objCase.setDefinition('RecordTypeId','static value(CRM_Master)');
       objCase.insertRecords(true);
       Case c=[select id,ownerid,owner.name from case];
       Id oldUserId=c.ownerId;
       System.assert(c.ownerid!=null,'OWNER IS NULL');
      // System.assert(c.owner.name!=null,'OWNERNAME IS NULL');
       Test.startTest();
       c.status='Closed';
       //c.setOptions(dmlOpts);
       update c;
       Test.stopTest();
       c=[select id,ownerid,owner.name,isclosed from case];
       Id newUserId=c.ownerId;       
       System.assert(c.isclosed,'CASO NON CHIUSO');
       System.assert(mapUser.get(c.id)==null,'USER IS OWNER '+mapUser.get(c.id));
       System.assertNotEquals(newUserId, oldUserId,'OLD & NEW EQUALS');
        Group g=[select id,name,developername from Group where id=:c.ownerId];
      System.assertEquals('Coda Casi chiusi'.toUpperCase(), g.name.toUpperCase(), 'CODA NON CASI CHIUSI');
   }


    @isTest
   public static void createCaseNOTClosed(){      
       Map<Id,User> mapUser=new Map<Id,User>([select id,name from user]);
       FObject objCase=new FObject('Case',1);
       objCase.setDefinition('RecordTypeId','static value(CRM_Master)');
       objCase.insertRecords(true);
       Case c=[select id,ownerid,owner.name from case];
       Id oldUserId=c.ownerId;
       System.assert(c.ownerid!=null,'OWNER IS NULL');
      // System.assert(c.owner.name!=null,'OWNERNAME IS NULL');
       Test.startTest();
       c.status='In Corso';       
       update c;
       Test.stopTest();
       c=[select id,ownerid,owner.name,isclosed from case];
       Id newUserId=c.ownerId;       
       System.assert(!c.isclosed,'CASO NON CHIUSO');
       //System.assert(mapUser.get(c.id)!=null,'USER IS OWNER '+mapUser.get(c.id) + ' '+c.id);
       System.assertEquals(newUserId, oldUserId,'OLD & NEW EQUALS');        
   }
   
}