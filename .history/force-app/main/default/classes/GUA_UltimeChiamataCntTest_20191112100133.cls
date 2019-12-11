//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 15/07/2019
//-- - Description  : Handle GUA_UltimeChiamataCntTest
//----------------------------------------------------------------------
@isTest
public with sharing class GUA_UltimeChiamataCntTest {
   
@TestSetup
static void makeData(){
    
    Account[] accts = new List < Account > ();

    Account a1 = new Account(
    Name = 'test1', DEM_Da_Inviare__c = false,  BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911134');
    accts.add(a1);
    insert accts;

    System.debug(' listAccount '+ accts );

    List<Task> t = new List<Task>{ new Task(
        WhatID = accts[0].Id,
        CallObject='H3G TEST',
        Status='Completed',
        Priority='Normal'
        )};
        insert t;  
        System.debug(' task '+ t );

}


   
@IsTest
static void getTaskByIDTest(){
    Test.startTest();
    List<Account> listAccount = [SELECT Id,Name ,
    DEM_Da_Inviare__c ,BillingCity  FROM Account ];
    String accountId=listAccount[0].Id;
    List<Task> listTask= GUA_UltimeChiamataCnt.getTaskByID(accountId);
    
    System.assertEquals(1, listTask.size(), 'listCase.size()==1');
    Test.stopTest();
}

}