@isTest
private class XCS_GestioneDeskClassTest {
	
	@TestSetup
    static void setup(){   
        if(([SELECT Id FROM User WHERE DefaultQueueId__c = 'F00-TEST']).size()==0){
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            
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
            insert new List<User>{managerFiliale};
        }
        
        if(([SELECT Id FROM Account WHERE OCS_External_Id__c = 'F00-TEST']).size()==0){
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Branch').getRecordTypeId();
            
            Account branch1 = new Account(
                Name= 'Branch1', 
                OCS_External_Id__c = 'F00-TEST',
                RecordTypeId = recordTypeId,
                OCSAreaId__c = 5,
                Region_Name__c = 'RC',
                Type= 'FIL'
            );

            Account branch2 = new Account(
                Name= 'Branch2', 
                OCS_External_Id__c = 'F01-TEST',
                RecordTypeId = recordTypeId,
                OCSAreaId__c = 6,
                Region_Name__c = 'RC',
                Type= 'FIL'
            );

            Account branch3 = new Account(
                Name= 'Branch3', 
                OCS_External_Id__c = 'F02-TEST',
                RecordTypeId = recordTypeId,
                OCSAreaId__c = 6,
                Region_Name__c = 'RC',
                Type= 'FIL'
            );

            insert new List<Account>{branch1,branch2,branch3};
        }

        if(([SELECT Id FROM XCS_Desk__c]).size()==0){
            Account branch = [SELECT Id,OCS_External_Id__c,Name,RecordTypeId,OCSAreaId__c,Type FROM Account WHERE OCS_External_Id__c = 'F00-TEST'];    
        
            XCS_Desk__c desk1 = new XCS_Desk__c(
                Branch__c = branch.Id,
			    isActive__c = true,
			    DeskName__c = 'Desk1'
            );

            XCS_Desk__c desk2 = new XCS_Desk__c(
                Branch__c = branch.Id,
			    isActive__c = true,
			    DeskName__c = 'Desk2'
            );

            insert new List<XCS_Desk__c>{desk1,desk2};
        }

        if(([SELECT Id FROM XCS_DeskItem__c]).size()==0){
            XCS_Desk__c desk = [SELECT Id,Branch__c,DeskName__c,isActive__c FROM XCS_Desk__c WHERE DeskName__c = 'Desk1'];    
        
            XCS_DeskItem__c deskItem1 = new XCS_DeskItem__c(
                Desk__c = desk.Id,
                Monday__c = true,
                Tuesday__c = true,
                Wednesday__c = true,
                Thursday__c = true,
                Friday__c = true,
                Saturday__c = true,
                Sunday__c = false,
                StartTime__c = Time.newInstance(09, 0, 0, 0),
                EndTime__c = Time.newInstance(18, 0, 0, 0)
            );

            XCS_DeskItem__c deskItem2 = new XCS_DeskItem__c(
                Desk__c = desk.Id,
                Monday__c = false,
                Tuesday__c = true,
                Wednesday__c = true,
                Thursday__c = true,
                Friday__c = true,
                Saturday__c = true,
                Sunday__c = false,
                StartTime__c = Time.newInstance(09, 0, 0, 0),
                EndTime__c = Time.newInstance(18, 0, 0, 0)
            );

            insert new List<XCS_DeskItem__c>{deskItem1,deskItem2};
        }
    }

    @isTest static void initApexTest(){
        User u = [SELECT Id,FirstName,Name,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'TestManager'];
        XCS_GestioneDeskClass.InitWrapper Wr;
            
        Test.startTest();
        System.runAs(u){
                Wr = XCS_GestioneDeskClass.initApex(); 
        }
        Test.stopTest();
        System.assertEquals('TestManager TestManager',Wr.manager.Name);    
        System.assertEquals('F00-TEST',Wr.branchListPerArea.get('5')[0].OCS_External_Id__c);    
    }

	@isTest static void addDeskTest(){
        User u = [SELECT Id,FirstName,Name,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'TestManager'];
        Account branch = [SELECT OCS_External_Id__c,Name,RecordTypeId,OCSAreaId__c,Type FROM Account WHERE OCS_External_Id__c = 'F00-TEST'];    
        XCS_Desk__c deskReturned;

        Test.startTest();
        System.runAs(u){
            deskReturned = XCS_GestioneDeskClass.addDesk(branch,'Desk2');
        }
        Test.stopTest();
        System.assertEquals('Desk2',deskReturned.DeskName__c);    
    }

    @isTest static void addDeskItemTest(){
        User u = [SELECT Id,FirstName,Name,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'TestManager'];
        XCS_Desk__c desk = [SELECT Id,Branch__c,DeskName__c,isActive__c FROM XCS_Desk__c WHERE DeskName__c = 'Desk1'];    
        XCS_DeskItem__c deskItemReturned;

        Test.startTest();
        System.runAs(u){
            deskItemReturned = XCS_GestioneDeskClass.addDeskItem(desk);
        }
        Test.stopTest();
        System.assertEquals(desk.Id,deskItemReturned.Desk__c);    
    }
	
    @isTest static void updateDeskApexTest(){
        User u = [SELECT Id,FirstName,Name,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'TestManager'];
        List<XCS_Desk__c> deskList = [SELECT Id,Branch__c,DeskName__c,isActive__c FROM XCS_Desk__c WHERE DeskName__c = 'Desk1'];    
        
        Test.startTest();
        System.runAs(u){
            deskList[0].isActive__c = false;
            XCS_GestioneDeskClass.updateDeskApex(deskList);
        }
        Test.stopTest();

        List<XCS_Desk__c> deskListNew = [SELECT Id,Branch__c,DeskName__c,isActive__c FROM XCS_Desk__c WHERE DeskName__c = 'Desk1'];    
        System.assertEquals(false,deskList[0].isActive__c);    
    }
    
    @isTest static void updateDeskItemApexTest(){
        User u = [SELECT Id,FirstName,Name,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'TestManager'];
        XCS_Desk__c desk = [SELECT Id,Branch__c,DeskName__c,isActive__c FROM XCS_Desk__c WHERE DeskName__c = 'Desk1'];    
        List<XCS_DeskItem__c> deskItemList = [SELECT Id,Desk__c,StartTime__c,EndTime__c,Monday__c,Tuesday__c,Wednesday__c,Thursday__c,Friday__c,Saturday__c,Sunday__c FROM XCS_DeskItem__c WHERE Desk__c =: desk.Id];    
        
        Test.startTest();
        System.runAs(u){
            deskItemList[0].Sunday__c = false;
            XCS_GestioneDeskClass.updateDeskItemApex(deskItemList);
        }
        Test.stopTest();

        List<XCS_DeskItem__c> deskItemListNew = [SELECT Id,Desk__c,StartTime__c,EndTime__c,Monday__c,Tuesday__c,Wednesday__c,Thursday__c,Friday__c,Saturday__c,Sunday__c FROM XCS_DeskItem__c WHERE Desk__c =: desk.Id];    
        System.assertEquals(false,deskItemListNew[0].Sunday__c);    
    }

    @isTest static void deleteDeskItemApexTest(){
        User u = [SELECT Id,FirstName,Name,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'TestManager'];
        List<XCS_DeskItem__c> deskItemList = [SELECT Id,Desk__c,StartTime__c,EndTime__c,Monday__c,Tuesday__c,Wednesday__c,Thursday__c,Friday__c,Saturday__c,Sunday__c FROM XCS_DeskItem__c WHERE Monday__c = false];    
        
        Test.startTest();
        System.runAs(u){
            XCS_GestioneDeskClass.deleteDeskItemApex(deskItemList[0]);
        }
        Test.stopTest();

        List<XCS_DeskItem__c> deskItemListNew = [SELECT Id,Desk__c,StartTime__c,EndTime__c,Monday__c,Tuesday__c,Wednesday__c,Thursday__c,Friday__c,Saturday__c,Sunday__c FROM XCS_DeskItem__c WHERE Monday__c = false];    
        System.assertEquals(0,deskItemListNew.size());    
    }

    @isTest static void initDeskItemPerDeskTest(){
        User u = [SELECT Id,FirstName,Name,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'TestManager'];
        Account branch = [SELECT OCS_External_Id__c,Name,RecordTypeId,OCSAreaId__c,Type FROM Account WHERE OCS_External_Id__c = 'F00-TEST'];    
        XCS_Desk__c desk = [SELECT Id,Branch__c,DeskName__c,isActive__c FROM XCS_Desk__c WHERE DeskName__c = 'Desk1'];    
        Map<String,List<XCS_DeskItem__c>> deskItemPerDesk;

        Test.startTest();
        System.runAs(u){
            deskItemPerDesk = XCS_GestioneDeskClass.initDeskItemPerDesk(branch);
        }
        Test.stopTest();
        System.assertEquals(false,deskItemPerDesk.get(desk.Id)[0].Sunday__c);    
    }
}