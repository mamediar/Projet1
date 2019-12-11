@isTest
public class GroupUtilsTest {
    
    private static FINAL string TypeQueue = 'queue';
    @isTest
    public static void testGetQueueList(){
        GroupUtils.getQueueList(); 
         List<Group> groupList = [Select Id,Name,DeveloperName From Group Where Type =:TypeQueue];
        System.assert(groupList.size() == GroupUtils.getQueueList().size() 
                     && groupList[0].DeveloperName == GroupUtils.getQueueList()[0].DeveloperName );
    }
    
    @isTest
    public static void testGetQueueListWithParameter(){
        GroupUtils.getQueueList('FAX - CQ contestati - Visiant'); 
    }
    
    @isTest
    public static void testGetQueue(){
        GroupUtils.getQueue('Q275'); 
    }
    
    @isTest
    public static void testGetQueueListWithOneParameter(){
        List<String> devNameList = new List<String>();
        devNameList.add('FAX - CQ contestati - Visiant');
        GroupUtils.getQueueList(devNameList); 
    }
    
    @isTest
    public static void testGetQueueName(){
        Group idTest = [select Id,Name from Group where type=:TypeQueue AND Name = 'FAX - CQ contestati - Visiant' LIMIT 1];
        GroupUtils.getQueueName(idTest.Id); 
    }
    
    @isTest
    public static void testGetAllQueuesByDeveloperName(){
        GroupUtils.getAllQueuesByDeveloperName(); 
    }
    
    @isTest
    public static void testGetQueuesByDeveloperName(){
        List<String> devNameList = new List<String>();
        devNameList.add('FAX - CQ contestati - Visiant');
        GroupUtils.getQueuesByDeveloperName(devNameList); 
    }
    @isTest
    public static void testGetRoleList()
    {
       	set<String> lRole = new set<String>();
        lRole.add('Alessandria');
        List<Group> lGroup = GroupUtils.getRoleList(lRole);
        system.assert(!lGroup.isEmpty());
    }
    
}