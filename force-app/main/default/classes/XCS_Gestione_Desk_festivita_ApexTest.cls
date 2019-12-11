@isTest
public class XCS_Gestione_Desk_festivita_ApexTest {
    @TestSetup
    static void setup(){   
        if(([SELECT Id FROM User WHERE DefaultQueueId__c = 'F00-TEST']).size()==0){
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User utenteMaster = new User(
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
                DefaultQueueId__c= 'F00-TEST'
            );
            insert utenteMaster;
        }
        if(([SELECT Id FROM Account WHERE OCS_External_Id__c = 'F00-TEST']).size()==0){
            Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Branch').getRecordTypeId();
            
            Account Venezia= new Account(
                Name= 'VENEZIA', 
                Region_Name__c= 'RN',
                OCS_External_Id__c = 'F00-TEST',
                RecordTypeId = recordTypeId,
                OCSAreaId__c= 1

            );
            insert Venezia;
        }

        if(([SELECT Id FROM XCS_Appointment__c WHERE Branch__r.Name='VENEZIA']).size()==0){
            Account acc=[SELECT Id, OCS_External_Id__c FROM Account WHERE OCS_External_Id__c = 'F00-TEST'];
            XCS_Appointment__c appuntamento= new XCS_Appointment__c(
                Date__c=Date.today(),
                Branch__c= acc.Id,
                EndTime__c= Time.newInstance(18, 0, 0, 0),
                StartTime__c= Time.newInstance(9, 0, 0, 0),
                Type__c= 'Fest'
            );
            insert appuntamento;
        }

        if(([SELECT Id FROM XCS_Desk__c WHERE DeskName__c='Desk1']).size()==0){
            Account filialeSelected=[SELECT Id FROM Account WHERE OCS_External_Id__c='F00-TEST'];
            XCS_Desk__c deskToAdd = new XCS_Desk__c(
                Branch__c = filialeSelected.Id,
                isActive__c = true,
                DeskName__c = 'Desk1'
            );
		    insert deskToAdd;
        }

    }

    @isTest
    static void initApexTest(){
        User u = [SELECT Id FROM User WHERE LastName = 'Test'];
        XCS_Gestione_Desk_festivita_Apex.InitWrapper wr;
        Test.startTest();
		System.runAs(u) {
            wr= XCS_Gestione_Desk_festivita_Apex.initApex();
        }
        Test.stopTest();
        System.assertEquals(wr.allFestivities.size(), 1);
    }

    @isTest
    static void insertNewfestivitiesTest(){
        User u = [SELECT Id FROM User WHERE LastName = 'Test'];
        XCS_Appointment__c basicAppointment=new XCS_Appointment__c(
            Date__c=Date.today(),
            EndTime__c= Time.newInstance(18, 0, 0, 0),
            StartTime__c= Time.newInstance(9, 0, 0, 0),
            Type__c= 'Fest'
        );
        List<XCS_Appointment__c> newFestivity;
        Test.startTest();
		System.runAs(u) {
            newFestivity= XCS_Gestione_Desk_festivita_Apex.insertNewfestivities(new List<String>{'F00-TEST'},
            basicAppointment,false);
        }
        Test.stopTest();
        List<XCS_Appointment__c> festivities=[SELECT Id FROM XCS_Appointment__c WHERE Branch__r.Name='VENEZIA'];
        System.assertEquals(festivities.size(), 2);
    }

    @isTest
    static void insertNewfestivitiesFailTest(){
        User u = [SELECT Id FROM User WHERE LastName = 'Test'];
        XCS_Appointment__c basicAppointment=new XCS_Appointment__c(
            Date__c=Date.today(),
            EndTime__c= Time.newInstance(18, 0, 0, 0),
            StartTime__c= Time.newInstance(9, 0, 0, 0),
            Type__c= 'e'
        );
        List<XCS_Appointment__c> newFestivity;
        String errorMessage;
        Test.startTest();
		System.runAs(u) {
            try {
                XCS_Gestione_Desk_festivita_Apex.insertNewfestivities(new List<String>{'e'},
                basicAppointment,false);
            } catch (AuraHandledException ex) {
                errorMessage=ex.getMessage();
            }
        }
        Test.stopTest();
        System.assertEquals(errorMessage, 'Inserimento fallito');
    }

    @isTest
    static void insertNewEmptyfestivitiesTest(){
        User u = [SELECT Id FROM User WHERE LastName = 'Test'];
        XCS_Appointment__c basicAppointment=new XCS_Appointment__c(
            Date__c=Date.today(),
            EndTime__c= Time.newInstance(18, 0, 0, 0),
            StartTime__c= Time.newInstance(9, 0, 0, 0),
            Type__c= 'Fest'
        );
        List<XCS_Appointment__c> newFestivity;
        Test.startTest();
		System.runAs(u) {
            newFestivity= XCS_Gestione_Desk_festivita_Apex.insertNewfestivities(new List<String>{'F00-TEST'},
            basicAppointment,true);
        }
        Test.stopTest();
        List<XCS_Appointment__c> festivities=[SELECT Id FROM XCS_Appointment__c WHERE Branch__r.Name='VENEZIA'];
        System.assertEquals(festivities.size(), 2);
    }

    @isTest
    static void updateFestivitiesTest(){
        User u = [SELECT Id FROM User WHERE LastName = 'Test'];
        List<XCS_Appointment__c> festivities=[SELECT Id, EndTime__c FROM XCS_Appointment__c WHERE Branch__r.Name='VENEZIA'];
        XCS_Appointment__c myFestivity= festivities[0];
        myFestivity.EndTime__c=Time.newInstance(17,0,0,0);
        Test.startTest();
		System.runAs(u) {
            XCS_Gestione_Desk_festivita_Apex.updateFestivities(new List<XCS_Appointment__c>{myFestivity});
        }
        Test.stopTest();
        List<XCS_Appointment__c> newQueriedFestivities=[SELECT Id, EndTime__c FROM XCS_Appointment__c WHERE Branch__r.Name='VENEZIA'];
        System.assertEquals(newQueriedFestivities[0].EndTime__c, Time.newInstance(17,0,0,0));
    }

    @isTest
    static void updateFestivitiesFailTest(){
        User u = [SELECT Id FROM User WHERE LastName = 'Test'];
        List<XCS_Appointment__c> festivities=[SELECT Id, Type__c FROM XCS_Appointment__c WHERE Branch__r.Name='VENEZIA'];
        XCS_Appointment__c myFestivity= festivities[0];
        myFestivity.Type__c='e';
        String errorMessage;
        Test.startTest();
		System.runAs(u) {
            try {
                XCS_Gestione_Desk_festivita_Apex.updateFestivities(new List<XCS_Appointment__c>{myFestivity});                
            } catch (AuraHandledException ex) {
                errorMessage=ex.getMessage();
            }
        }
        Test.stopTest();
        List<XCS_Appointment__c> newQueriedFestivities=[SELECT Id, EndTime__c FROM XCS_Appointment__c WHERE Branch__r.Name='VENEZIA'];
        System.assertEquals(errorMessage, 'Aggiornamento fallito');
    }

    @isTest
    static void deleteFestivitiesTest(){
        User u = [SELECT Id FROM User WHERE LastName = 'Test'];
        List<XCS_Appointment__c> festivities=[SELECT Id FROM XCS_Appointment__c WHERE Branch__r.Name='VENEZIA'];
        XCS_Appointment__c myFestivity= festivities[0];
        Test.startTest();
		System.runAs(u) {
            XCS_Gestione_Desk_festivita_Apex.deleteFestivities(new List<XCS_Appointment__c>{myFestivity});
        }
        Test.stopTest();
        List<XCS_Appointment__c> newQueriedFestivities=[SELECT Id FROM XCS_Appointment__c WHERE Branch__r.Name='VENEZIA'];
        System.assertEquals(newQueriedFestivities.size(), 0);
    }

    @isTest
    static void deleteFestivitiesFailTest(){
        User u = [SELECT Id FROM User WHERE LastName = 'Test'];
        List<XCS_Appointment__c> festivities=[SELECT Id FROM XCS_Appointment__c WHERE Branch__r.Name='VENEZIA'];
        XCS_Appointment__c myFestivity= festivities[0];
        String errorMessage;
        myFestivity.Id=null;
        Test.startTest();
		System.runAs(u) {
            try {
                XCS_Gestione_Desk_festivita_Apex.deleteFestivities(new List<XCS_Appointment__c>{myFestivity});
            } catch (AuraHandledException ex) {
                errorMessage=ex.getMessage();
            }
        }
        Test.stopTest();
        System.assertEquals(errorMessage, 'Rimozione fallita');
    }

}