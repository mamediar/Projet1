@isTest
public class TestCampaignOutboundShareBuilder {
    static String RTCampaignId;
    static String RTCampaignMemberId;
    @TestSetup
    static void initData(){
        String statoCampagna = 'In Progress';
        RTCampaignId = [select id,SobjectType,name from RecordType where SobjectType='Campaign' and Name = 'Campaign Outbound' LIMIT 1].ID;
        RTCampaignMemberId = [select id,SobjectType,name from RecordType where SobjectType='Campaignmember' and name='Campagna Outbound' LIMIT 1].ID;
        Id idRecordTypeAccount = CGMWSUtils_1_0.getRecordTypeId('Account', 'PersonAccount');

        List<Account> listAccountCustomer = new List<Account>{
            new Account (RecordTypeId = idRecordTypeAccount, LastName='BALDEmADICKE', Codice_Fiscale__c ='RZZNNN69B25F158O'),
            new Account (RecordTypeId = idRecordTypeAccount, LastName='BALDEMacky', Codice_Fiscale__c ='447')
        };
        insert  listAccountCustomer;
        idRecordTypeAccount = CGMWSUtils_1_0.getRecordTypeId('Account', 'Branch');
        List<Account> listAccountCustomer1 = new List<Account>{
            new Account (RecordTypeId = idRecordTypeAccount, Name='Test1', Codice_Fiscale__c ='RZZNNN69225F158O',OCS_External_Id__c='F1',NameRoleReference__c='Parma'),
            new Account (RecordTypeId = idRecordTypeAccount, Name='Test2', Codice_Fiscale__c ='448',OCS_External_Id__c='F2',NameRoleReference__c='Reggio_Calabria')
        };
        insert  listAccountCustomer1;

       Campaign padre = new Campaign(Name='CampagnaOutbound'+Integer.valueOf((math.random()*(1000))),startdate=System.today(),RecordTypeId=RTCampaignId,Status=statoCampagna,isActive=(statoCampagna=='In Progress'),CampaignMemberRecordTypeId=RTCampaignMemberId);
        insert padre;
        Campaign figlia1 = new Campaign(Name='CampagnaOutboundFiglia1',startdate=System.today(),ParentId=padre.Id,RecordTypeId=RTCampaignId,CampaignMemberRecordTypeId=RTCampaignMemberId,Status=statoCampagna,isActive=(statoCampagna=='In Progress'),CodOutsourcer__c='1');
        insert figlia1;
        Campaign figlia2 = new Campaign(Name='CampagnaOutboundFiglia2',startdate=System.today(),ParentId=padre.Id,RecordTypeId=RTCampaignId,CampaignMemberRecordTypeId=RTCampaignMemberId,Status=statoCampagna,isActive=(statoCampagna=='In Progress'),CodOutsourcer__c='2');
        insert figlia2;
        Account account = [select id,PersonContactId from account limit 1];
        CampaignMember m1 = new CampaignMember(CampaignId=figlia1.Id,ContactId=account.PersonContactId,Status='Sent',TipoCampagna__c='Compass Classico - 9K1');
        insert m1;
        CampaignMember m2 = new CampaignMember(CampaignId=figlia2.Id,ContactId=account.PersonContactId,Status='Sent',TipoCampagna__c='Compass Classico - 9K1');
        insert m2;
    }

    @isTest 
    public static void shareCampaign(){
        List<Id> setId = new List<Id>();
        List<Campaign> campagne = [select id from campaign where parentId != null];
        for(Campaign campagna:campagne){
            setId.add(campagna.Id);
        }
        CampaignOutboundShareBuilder.shareCampaign(setId);

        List<CampaignShare> share = [select id from campaignshare];
        System.assert(share.size()>0);
    }
}