@isTest
public class SFACambioFilialeClassTest{
	
    @TestSetup
    static void setup(){   
        if(([SELECT Id FROM User WHERE DefaultQueueId__c = 'F00-TEST']).size()==0){
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User testerUser = new User(
                FirstName= 'Test',
                LastName= 'Test',
                Username= 'test@compass.com.test',
                Email= 'test@lynxspa.com',
                Alias= 'test',
                TimeZoneSidKey= 'Europe/Rome',
                LocaleSidKey= 'it_IT',
                EmailEncodingKey= 'ISO-8859-1',
                ProfileId= p.Id,
                LanguageLocaleKey= 'en_US',
                Area__c = '5',
                DefaultQueueId__c= 'F00-TEST'
            );
            User managerFiliale = new User(
                FirstName= 'TestManager',
                LastName= 'TestManager',
                Username= 'TestManager@compass.com.test',
                Email= 'TestManager@lynxspa.com',
                Alias= 'TM',
                TimeZoneSidKey= 'Europe/Rome',
                LocaleSidKey= 'it_IT',
                EmailEncodingKey= 'ISO-8859-1',
                ProfileId= p.Id,
                LanguageLocaleKey= 'en_US',
                DefaultQueueId__c= 'F00-TEST'
            );
            insert new List<User>{testerUser,managerFiliale};
        }
        
        if(([SELECT Id FROM Account WHERE OCS_External_Id__c = 'F00-TEST']).size()==0){
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Branch').getRecordTypeId();
            
            Account branch1 = new Account(
                Name= 'Branch1', 
                OCS_External_Id__c = 'F00-TEST',
                RecordTypeId = recordTypeId,
                OCSAreaId__c = 5,
                Type= 'FIL'
            );
            Account branch2 = new Account(
                Name= 'Branch2', 
                OCS_External_Id__c = 'F01-TEST',
                RecordTypeId = recordTypeId,
                OCSAreaId__c = 10,
                Type= 'FIL'
            );
            Account branch3 = new Account(
                Name= 'Branch3', 
                OCS_External_Id__c = 'F02-TEST',
                RecordTypeId = recordTypeId,
                OCSAreaId__c = 10,
                Type= 'FIL'
            );
            insert new List<Account>{branch1,branch2,branch3};
        }
    }
    
    @isTest static void initApexTest(){
       User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'Test'];
       SFACambioFilialeClass.InitWrapper Wr;
        
       Test.startTest();
       System.runAs(u){
       		Wr = SFACambioFilialeClass.initApex(); 
       }
       Test.stopTest();
       System.assertEquals('5',Wr.areaSelezionata);    
       System.assertEquals('F00-TEST',Wr.filialeSelezionata);    
    }
    
    @isTest static void updateUserTest(){
       User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c,Area__c FROM User WHERE LastName = 'Test'];
       SFACambioFilialeClass.InitWrapper Wr;
       Test.startTest();
       System.runAs(u){
           u.DefaultQueueId__c = 'F01-TEST';
           SFACambioFilialeClass.updateUser(u);
           Wr = SFACambioFilialeClass.initApex();
       }
       Test.stopTest();
       System.assertEquals('F01-TEST',Wr.manager.DefaultQueueId__c);    
    }
    
    @isTest static void setAllBranchListPerAreaMapTest(){
       User u = [SELECT Id,FirstName,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'TestManager'];
       SFACambioFilialeClass.InitWrapper Wr;
       List<Account> filiali; 
       Test.startTest();
       System.runAs(u){
       		Wr = SFACambioFilialeClass.initApex();
            filiali = Wr.branchListPerArea.get('5');
       }
       Test.stopTest();   
       System.assertEquals('F00-TEST',Wr.filialeSelezionata);
       System.assertEquals('Branch1',filiali[0].Name);  
    }
	
}