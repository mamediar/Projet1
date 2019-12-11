@isTest
private class XCS_GestioneIndisponibilitaClassTest {
	
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

		if(([SELECT Id FROM XCS_Appointment__c]).size()==0){
			XCS_Desk__c desk = [SELECT Id,Branch__c,DeskName__c,isActive__c FROM XCS_Desk__c WHERE DeskName__c = 'Desk2'];    

            XCS_Appointment__c indisposizione = new XCS_Appointment__c(
				Type__c = 'Ind',
				Note__c = 'toUpdate',
                Date__c = Date.today(),
				StartTime__c = Time.newInstance(09, 0, 0, 0), 
				EndTime__c = Time.newInstance(18, 0, 0, 0)
			);

			XCS_Appointment__c indisposizione2 = new XCS_Appointment__c(
				XCS_Desk__c = desk.Id,
				Type__c = 'Ind',
				Note__c = 'toDelete',
                Date__c = Date.today(),
				StartTime__c = Time.newInstance(09, 0, 0, 0), 
				EndTime__c = Time.newInstance(18, 0, 0, 0)
			);

            insert new List<XCS_Appointment__c>{indisposizione,indisposizione2};
            Date myDate = Date.today();
            Time myStartTime = Time.newInstance(9, 0, 0, 0);
            Time myEndTime = Time.newInstance(18, 0, 0, 0);

            Event appuntamento = new Event(

                Desk__c = desk.Id,
                StartDateTime = DateTime.newInstanceGMT(myDate, myStartTime),
                EndDateTime  = DateTime.newInstanceGMT(myDate, myEndTime)
            );

            insert appuntamento;
        }

    }

	@isTest static void initApexTest(){
        User u = [SELECT Id,FirstName,Name,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'TestManager'];
        XCS_GestioneIndisponibilitaClass.InitWrapper Wr;
            
        Test.startTest();
        System.runAs(u){
                Wr = XCS_GestioneIndisponibilitaClass.initApex(); 
        }
        Test.stopTest();    
        System.assertEquals('F00-TEST',Wr.branchListPerArea.get('5')[0].OCS_External_Id__c);    
    }
	
	@isTest static void insertIndisponibilitaApexTest(){
        User u = [SELECT Id,FirstName,Name,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'TestManager'];
        XCS_Desk__c desk = [SELECT Id,Branch__c,DeskName__c,isActive__c FROM XCS_Desk__c WHERE DeskName__c = 'Desk1'];    
            
        Test.startTest();
        System.runAs(u){
			XCS_Appointment__c indisposizione = new XCS_Appointment__c(
				XCS_Desk__c = desk.Id,
				Type__c = 'Ind',
				StartTime__c = Time.newInstance(09, 0, 0, 0), 
				EndTime__c = Time.newInstance(18, 0, 0, 0)
			);

			XCS_GestioneIndisponibilitaClass.insertIndisponibilitaApex(indisposizione);

        }
        Test.stopTest();    
		List<XCS_Appointment__c> indisposizioneList = [SELECT Id,StartTime__c FROM XCS_Appointment__c WHERE XCS_Desk__c =: desk.Id AND Type__c = 'Ind'];
        System.assertEquals(1,indisposizioneList.size());    
    }

	@isTest static void deleteIndisponibilitaApexTest(){
        User u = [SELECT Id,FirstName,Name,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'TestManager'];
            
        Test.startTest();
        System.runAs(u){
			XCS_Appointment__c indisposizioneToDelete = [SELECT Id,StartTime__c FROM XCS_Appointment__c WHERE Note__c = 'toDelete' AND Type__c = 'Ind'];			
			XCS_GestioneIndisponibilitaClass.deleteIndisponibilitaApex(indisposizioneToDelete);

        }
        Test.stopTest();    
		List<XCS_Appointment__c> indisposizioneList = [SELECT Id,StartTime__c FROM XCS_Appointment__c WHERE Note__c = 'toDelete' AND Type__c = 'Ind'];
        System.assertEquals(0,indisposizioneList.size());    
    }

	@isTest static void updateAppointmentListApexTest(){
        User u = [SELECT Id,FirstName,Name,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'TestManager'];
            
        Test.startTest();
        System.runAs(u){
			List<XCS_Appointment__c> indisposizioneToUpdate = [SELECT Id,StartTime__c FROM XCS_Appointment__c WHERE Note__c = 'toUpdate' AND Type__c = 'Ind'];			
			indisposizioneToUpdate[0].Note__c = 'Updated';
			XCS_GestioneIndisponibilitaClass.updateAppointmentListApex(indisposizioneToUpdate);

        }
        Test.stopTest();    
		List<XCS_Appointment__c> indisposizioneList = [SELECT Id,StartTime__c FROM XCS_Appointment__c WHERE Note__c = 'Updated' AND Type__c = 'Ind'];
        System.assertEquals(1,indisposizioneList.size());    
    }

	@isTest static void getAppointmentWrapperTest(){
        User u = [SELECT Id,FirstName,Name,LastName,Username,Email,Alias,TimeZoneSidKey,LocaleSidKey,EmailEncodingKey,ProfileId,LanguageLocaleKey,DefaultQueueId__c FROM User WHERE LastName = 'TestManager'];
		Account branch = [SELECT Id,OCS_External_Id__c,Name,RecordTypeId,OCSAreaId__c,Type FROM Account WHERE OCS_External_Id__c = 'F00-TEST'];    
        XCS_GestioneIndisponibilitaClass.AppointmentWrapper appWrapper;

        Test.startTest();
        System.runAs(u){
			Date dt = Date.today();
			appWrapper = XCS_GestioneIndisponibilitaClass.getAppointmentWrapper(branch,dt);

        }
        Test.stopTest();    
		
		System.assertEquals(2,appWrapper.deskList.size());    
    }

}