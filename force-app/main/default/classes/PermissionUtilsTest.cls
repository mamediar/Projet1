@isTest
public class PermissionUtilsTest {
    
    @isTest()
    static void getPermissionTest()
    {
        
        PermissionSet perset = new PermissionSet();
        perset.Name = 'ciao';
        perset.Label='Num';
        insert perset;
        
        PermissionSetAssignment per = new PermissionSetAssignment();
        per.PermissionSetId=perset.id;
        per.AssigneeId = UserInfo.getUserId();
        insert per;

        PermissionUtils.getPermissionName();
        PermissionUtils.isAbilitatoVendita();
        PermissionUtils.isAV();
        //PermissionUtils.isBranchEmployee();
        PermissionUtils.isCallCenterInterno();
        PermissionUtils.isCoordinatore();
        PermissionUtils.isGDV();
        PermissionUtils.isNET();
        PermissionUtils.isVisiant();
        PermissionUtils.isNumBlu();
       
    }

    @isTest
    public static void getBranchEmployee(){
        Id profileId=[select id from profile where name=:PermissionUtils.BRANCH_EMPLOYEE limit 1].id;
        insert createUser(profileId);
        User u=[select id from user where profile.name=:PermissionUtils.BRANCH_EMPLOYEE limit 1];
        System.assert(PermissionUtils.isBranchEmployee(u.id));
    }

     @isTest
    public static void getBranchManager(){
        Id profileId=[select id from profile where name=:PermissionUtils.BRANCH_MANAGER limit 1].id;
        insert createUser(profileId);
        User u=[select id from user where profile.name=:PermissionUtils.BRANCH_MANAGER limit 1];
        System.assert(PermissionUtils.isBranchManager(u.id));
    }

    @isTest
    public static void getBranch(){
        List<Profile> lstProfile=[select id from profile where name in (:PermissionUtils.BRANCH_MANAGER,:PermissionUtils.BRANCH_EMPLOYEE ) ];
        List<User> lstUser=new List<User>();
        for(Profile p :lstProfile )    lstUser.add(createUser(p.id));
        insert lstUser;
        //System.assertEquals([select id from user].size(),2);
        for(User u : lstUser)  System.assert(PermissionUtils.isBranch(u.id));
    }
    private static Integer userNum=0;
    private static User createUser(String profileId){
        /*
        Group g = new Group();
        g.Name = 'TestName';
        g.DeveloperName = 'devTest';
        g.Type = 'queue';
        
        insert g; 
        */
        User u = new User(); 
        
        //u.DefaultQueueId__c = g.DeveloperName;
        /*TimeZoneSidKey, LocaleSidKey, EmailEncodingKey, ProfileId, LanguageLocaleKey*/
        userNum++;
        u.Username = 'Giu@k.k'+userNum;
        u.LastName='Seppe';
        u.Email='sij@iol.io';
        u.CommunityNickname='sid'+userNum;
        u.TimeZoneSidKey='Europe/Rome';
        u.LocaleSidKey='it';
        u.EmailEncodingKey='UTF-8';
        u.ProfileId=profileId; //[SELECT Id FROM Profile WHERE Name=:profileName].Id;
        u.LanguageLocaleKey='it';
        u.Alias='df'+userNum;
        
        //insert u;
        return u;
    }

}