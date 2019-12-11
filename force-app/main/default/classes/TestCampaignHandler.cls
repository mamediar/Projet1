@isTest
public class TestCampaignHandler {

    @TestSetup
    static void initData(){
        
         Id idRecordTypeAccount = CGMWSUtils_1_0.getRecordTypeId('Account', 'PersonAccount');

       List<Account> listAccountCustomer = new List<Account>{
           new Account (RecordTypeId = idRecordTypeAccount, LastName='BALDEmADICKE', Codice_Fiscale__c ='RZZNNN69B25F158O'),
           new Account (RecordTypeId = idRecordTypeAccount, LastName='BALDEMacky', Codice_Fiscale__c ='447')
       };
       insert  listAccountCustomer;
    }


    @isTest 
    public static void insertRecord(){
        String RTCampaignId = [select id,SobjectType,name from RecordType where SobjectType='Campaign' and Name = 'Campaign Outbound' LIMIT 1].ID;
        String RTCampaignMemberId = [select id,SobjectType,name from RecordType where SobjectType='Campaignmember' and name='Campagna Outbound' LIMIT 1].ID;
        String statoCampagna = 'Planned';
        Campaign c = new Campaign(Name='CampagnaOutbound'+Integer.valueOf((math.random()*(1000))),startdate=System.today(),RecordTypeId=RTCampaignId,Status=statoCampagna,isActive=(statoCampagna=='In Progress'),CampaignMemberRecordTypeId=RTCampaignMemberId);
        insert c;
    }

    @isTest 
    public static void updateRecord_CheckCompleted(){
        String RTCampaignId = [select id,SobjectType,name from RecordType where SobjectType='Campaign' and Name = 'Campaign Outbound' LIMIT 1].ID;
        String RTCampaignMemberId = [select id,SobjectType,name from RecordType where SobjectType='Campaignmember' and name='Campagna Outbound' LIMIT 1].ID;
        String statoCampagna = 'In Progress';
        Campaign padre = new Campaign(Name='CampagnaOutbound'+Integer.valueOf((math.random()*(1000))),startdate=System.today(),RecordTypeId=RTCampaignId,Status=statoCampagna,isActive=(statoCampagna=='In Progress'),CampaignMemberRecordTypeId=RTCampaignMemberId);
        insert padre;
        Campaign figlia = new Campaign(Name='CampagnaOutboundFiglia',startdate=System.today(),ParentId=padre.Id,RecordTypeId=RTCampaignId,CampaignMemberRecordTypeId=RTCampaignMemberId,Status=statoCampagna,isActive=(statoCampagna=='In Progress'));
        insert figlia;
        Account account = [select id,PersonContactId from account limit 1];
        CampaignMember m1 = new CampaignMember(CampaignId=figlia.Id,ContactId=account.PersonContactId,Status='Sent',TipoCampagna__c='Compass Classico - 9K1');
        insert m1;
        m1.Status = 'Responded';
        update m1;
        
    }

    @isTest 
    public static void updateRecord_CheckInProgress(){
        String RTCampaignId = [select id,SobjectType,name from RecordType where SobjectType='Campaign' and Name = 'Campaign Outbound' LIMIT 1].ID;
        String RTCampaignMemberId = [select id,SobjectType,name from RecordType where SobjectType='Campaignmember' and name='Campagna Outbound' LIMIT 1].ID;
        String statoCampagna = 'Planned';
        Campaign padre = new Campaign(Name='CampagnaOutbound'+Integer.valueOf((math.random()*(1000))),startdate=System.today(),RecordTypeId=RTCampaignId,Status=statoCampagna,isActive=(statoCampagna=='In Progress'),CampaignMemberRecordTypeId=RTCampaignMemberId);
        insert padre;
        Campaign figlia = new Campaign(Name='CampagnaOutboundFiglia',startdate=System.today(),ParentId=padre.Id,RecordTypeId=RTCampaignId,CampaignMemberRecordTypeId=RTCampaignMemberId,Status=statoCampagna,isActive=(statoCampagna=='In Progress'));
        insert figlia;
        Account account = [select id,PersonContactId from account limit 1];
        CampaignMember m1 = new CampaignMember(CampaignId=figlia.Id,ContactId=account.PersonContactId,Status='Sent',TipoCampagna__c='Compass Classico - 9K1');
        insert m1;
        padre.Status = 'In Progress';
        update padre;
        Campaign figlioAggiornato = [SELECT ID,Status FROM Campaign where ParentId != null LIMIT 1];
        System.assertEquals('In Progress', figlioAggiornato.Status);
    }

    @isTest 
    public static void updateRecord_CheckAborted(){
        String RTCampaignId = [select id,SobjectType,name from RecordType where SobjectType='Campaign' and Name = 'Campaign Outbound' LIMIT 1].ID;
        String RTCampaignMemberId = [select id,SobjectType,name from RecordType where SobjectType='Campaignmember' and name='Campagna Outbound' LIMIT 1].ID;
        String statoCampagna = 'Planned';
        Campaign padre = new Campaign(Name='CampagnaOutbound'+Integer.valueOf((math.random()*(1000))),startdate=System.today(),RecordTypeId=RTCampaignId,Status=statoCampagna,isActive=(statoCampagna=='In Progress'),CampaignMemberRecordTypeId=RTCampaignMemberId);
        insert padre;
        Campaign figlia = new Campaign(Name='CampagnaOutboundFiglia',startdate=System.today(),ParentId=padre.Id,RecordTypeId=RTCampaignId,CampaignMemberRecordTypeId=RTCampaignMemberId,Status=statoCampagna,isActive=(statoCampagna=='In Progress'));
        insert figlia;
        Account account = [select id,PersonContactId from account limit 1];
        CampaignMember m1 = new CampaignMember(CampaignId=figlia.Id,ContactId=account.PersonContactId,Status='Sent',TipoCampagna__c='Compass Classico - 9K1');
        insert m1;
        padre.Status = 'Aborted';
        update padre;
        Campaign figlioAggiornato = [SELECT ID,Status FROM Campaign where ParentId != null LIMIT 1];
        System.assertEquals('Aborted', figlioAggiornato.Status);
    }
}