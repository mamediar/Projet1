public class GroupUtils 
{
    private FINAL static String branchChar = 'F';
    private FINAL static String riverstarChar = 'Q';
    private FINAL static String TypeRole = 'Role';
	private FINAL static String TypeQueue = 'queue';
    
    public final static String DCR_AV='DCR_AV';
    public final static String MonitoraggioDealer='Monitoraggio_Dealer';
    public static final String IDM_RITORNIPOSTALI = 'IDM_Ritorni_Postali';

	public static final String QUEUE_MD = 'Q502';
    public static final String QUEUE_AV = 'Q500';
    
    public static List<Group> getQueueList()
    {
        return [Select Id,Name,DeveloperName From Group Where Type =:TypeQueue];
    }
    
    public static List<Group> getQueueList(String developerName)
    {
        return [Select Id,Name,DeveloperName From Group Where Type =:TypeQueue AND DeveloperName = :developerName];
    }
    
    public static Group getQueue(String developerName)
    {
        return [Select Id,Name,DeveloperName From Group Where Type =:TypeQueue AND DeveloperName = :developerName];
    }
    
    public static List<Group> getQueueList(List<String> developerName)
    {
        return [Select Id,Name,DeveloperName From Group Where Type =:TypeQueue AND DeveloperName in:developerName];
    }
    
    public static List<Group> getRoleList(Set<String> developerName)
    {
        return [Select Id,Name,DeveloperName From Group Where Type =:TypeRole AND DeveloperName in:developerName];
    }
    public static Group getRoleGroup(String developerName)
    {
        return [Select Id,Name,DeveloperName From Group Where Type =:TypeRole AND DeveloperName = :developerName];
    }
   
    // Recupera Lista di code basate sul tipo (F : Filiali , Q : Code Riverstar)
    private static List<Group> getQueueTypeList(String type)
    {
        String workType = type + '%';
        return[Select id,Name,DeveloperName from Group Where Type =:TypeQueue AND DeveloperName like :workType ];
    }
    public static List<Group> getQueueBranchList()
    {
        return getQueueTypeList(branchChar);
    }
    
    public static List<Group> getQueueRiverstarList()
    {
        return getQueueTypeList(riverstarChar);
    }
    
    public static String getQueueName(String queueId){
        return [select Id,Name from Group where type='queue' and Id=:queueId].Name;
    }
    
    public static String getQueueDeveloperName(String queueId){
        return [select Id,DeveloperName from Group where type='queue' and Id=:queueId].DeveloperName;
    }    
    
    public static Map<String, Group> getQueuesByDeveloperName(List<String> developerName){
        List<Group> queueList = getQueueList(developerName);
        return getQueueMapByDeveloperName(queueList);
    }
    
    public static Map<String, Group> getAllQueuesByDeveloperName () {
        List<Group> queueList = getQueueList();
        return getQueueMapByDeveloperName(queueList);
    }
    
    public static Map<id,Group> getQueueIdGroupMapFromList(List<Group> groupList)
    {        
        Map<id,Group> queueMap = new Map<id,Group>();
        for (Group g : groupList)
        {
            queueMap.put(g.id,g);
        }
        return queueMap;
    }
    
    public static Map<String, Group> getQueueMapByDeveloperName(List<Group> groupList){
        Map<String, Group> queueMap = new Map<String,Group>();
        for (Group g : groupList ) {
            queueMap.put(g.DeveloperName, g);
        }
        return queueMap;
    }
}