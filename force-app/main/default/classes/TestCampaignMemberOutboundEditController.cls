@isTest
public class TestCampaignMemberOutboundEditController {
    @TestSetup
    static void initData(){
        String statoCampagna = 'In Progress';
        String RTCampaignId = [select id,SobjectType,name from RecordType where SobjectType='Campaign' and Name = 'Campaign Outbound' LIMIT 1].ID;
        String RTCampaignMemberId = [select id,SobjectType,name from RecordType where SobjectType='Campaignmember' and name='Campagna Outbound' LIMIT 1].ID;
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

        list<Account> accountList = [select id,PersonContactId from account where recordtype.DeveloperName='PersonAccount'];

        CampaignMember m1 = new CampaignMember(CampaignId=figlia1.Id,ContactId=accountList[0].PersonContactId,Status='Sent',TipoCampagna__c='Compass Classico - 9K1');
        insert m1;
        CampaignMember m2 = new CampaignMember(CampaignId=figlia1.Id,ContactId=accountList[1].PersonContactId,Status='Sent',TipoCampagna__c='Compass Classico - 9K1');
        insert m2;
        
        /*CampaignMember m1 = new CampaignMember(CampaignId=figlia1.Id,ContactId=account.PersonContactId,Status='Sent',TipoCampagna__c='Compass Classico - 9K1');
        insert m1;
        CampaignMember m2 = new CampaignMember(CampaignId=figlia1.Id,ContactId=account.PersonContactId,Status='Sent',TipoCampagna__c='Compass Classico - 9K1');
        insert m2;*/
        
    }

    @isTest 
    public static void saveCampaignMemberSent(){
        CampaignMember member = [select id from CampaignMember limit 1];
        //member.Esito__c = 'Chiede di essere richiamato';
        member.Esito__c = '01';
        CampaignMemberOutboundEditController.saveCampaignMember(member);
        CampaignMember memberUpdated = [select id,Status from CampaignMember limit 1];
        System.assertEquals('Sent', memberUpdated.Status);
    }

    @isTest 
    public static void saveCampaignMemberResponded(){
        CampaignMember member = [select id from CampaignMember limit 1];
        //member.Esito__c = 'Non risponde al telefono (più tentativi)';
        member.Esito__c = '15';
        CampaignMemberOutboundEditController.saveCampaignMember(member);
        CampaignMember memberUpdated = [select id,Status from CampaignMember limit 1];
        System.assertEquals('Responded', memberUpdated.Status);
    }

     @isTest 
    public static void getNextRecord(){
        CampaignMember member = [select id,CampaignId from CampaignMember limit 1];
        CampaignMemberOutboundEditController.getNextRecord(member.iD,member.CampaignId);
        
    }
}