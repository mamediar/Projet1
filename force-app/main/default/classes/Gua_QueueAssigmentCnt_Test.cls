@isTest
public class Gua_QueueAssigmentCnt_Test {
    @testSetup 
    static void testSetup() {
        
    }
    
    @isTest
    static void getAreaTest(){
        GUA_Queue_Assigment__c QueueAssignement = new GUA_Queue_Assigment__c(Q281__c='', Q285__c='', Q286__c='', Q287__c='', IsActive__c=true);
        insert QueueAssignement;
        Test.startTest();
        	Map<String,Object> res = Gua_QueueAssigmentCnt.getArea();
        Test.stopTest();
    }
    
    @isTest
    static void getAreaTestKO(){
        Test.startTest();
        	Map<String,Object> res = Gua_QueueAssigmentCnt.getArea();
        Test.stopTest();
    }

    @isTest
    static void saveQueueAssigmentTest(){
        GUA_Queue_Assigment__c QueueAssignement = new GUA_Queue_Assigment__c(Q281__c='', Q285__c='', Q286__c='', Q287__c='', IsActive__c=true);
        insert QueueAssignement;
        Test.startTest();
        	Map<String,Object> res = Gua_QueueAssigmentCnt.saveQueueAssigment(QueueAssignement);
        Test.stopTest();
    }
    
    @isTest
    static void saveQueueAssigmentTestKO(){
 
        Test.startTest();
        	Map<String,Object> res = Gua_QueueAssigmentCnt.saveQueueAssigment(null);
        Test.stopTest();
    }

}