/**
 * @File Name          : Gua_QueueAssigmentCnt
 * @Description        : test of the Assigne case to a queue after update or insert in unita affari
 * @Author             : Abdoulaye DIOP (AD)
 * @CreatedDate        : 09/11/2019
**/
@Istest
public with sharing class Gua_CaseAssigneToQueuTriggerTest {
    
    @isTest static void testInserCase(){
        String recTypeIdAcc = [select Id from RecordType where (Name='Dealer') and (SobjectType='Account')].Id;
        String recTypeIdCase = [select Id from RecordType where (Name='GUA Contact') and (SobjectType='Case')].Id;
        
        GUA_Queue_Assigment__c queuAssignement = new GUA_Queue_Assigment__c(Q281__c= '1', Q285__c= '2', Q286__c= '3', Q287__c= '4', IsActive__c= true);
        insert queuAssignement;

        List<Account> accounts = new List<Account>();
        Account acc1 = new Account(RecordTypeID=recTypeIdAcc, Name='test', OCSAreaId__c =1);
        Account acc2 = new Account(RecordTypeID=recTypeIdAcc, Name='test', OCSAreaId__c =2);
        Account acc3 = new Account(RecordTypeID=recTypeIdAcc, Name='test', OCSAreaId__c =3);
        Account acc4 = new Account(RecordTypeID=recTypeIdAcc, Name='test', OCSAreaId__c =4);
        accounts.add(acc1);
        accounts.add(acc2);
        accounts.add(acc3);
        accounts.add(acc4);
        insert accounts;

        List<Case> cases = new List<Case>();
        Case c1 = new Case(Status='New', AccountId= accounts[0].Id, RecordTypeId=recTypeIdCase);
        Case c2 = new Case(Status='New', AccountId= accounts[1].Id, RecordTypeId=recTypeIdCase);
        Case c3 = new Case(Status='New', AccountId= accounts[2].Id, RecordTypeId=recTypeIdCase);
        Case c4 = new Case(Status='New', AccountId= accounts[3].Id, RecordTypeId=recTypeIdCase);
        cases.add(c1);
        cases.add(c2);
        cases.add(c3);
        cases.add(c4);
        Test.startTest();
            insert cases;
        Test.stopTest();
    }
}