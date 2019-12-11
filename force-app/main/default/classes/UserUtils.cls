public class UserUtils {

    public static Group getFilialeUtenteById(final Id userId) {
        return getFilialeUtente(userId, null);
    }

    public static Group getFilialeUtenteByName(final String userName) {
        return getFilialeUtente(null, userName);
    }

    public static Map<Id, Id> getUserIdDefaultQueueIdMap(final List<Id> userIdList) {
        final List<User> users = UserUtils.getUtenti(userIdList);
        final Map<Id, String> userIdDevNameMap = new Map<Id, String>();
        for (User userItem : users) {
            System.debug('User default queue: ' + userItem.DefaultQueueId__c);
            userIdDevNameMap.put(userItem.Id, userItem.DefaultQueueId__c);
        }

        final List<Group> groupList = GroupUtils.getQueueList(userIdDevNameMap.values());

        final Map<String, Id> devNameQueueIdMap = new Map<String, Id>();
        for (Group groupItem : groupList) {
            System.debug('groupItem.DeveloperName: ' + groupItem.DeveloperName);
            devNameQueueIdMap.put(groupItem.DeveloperName, groupItem.Id);
        }

        final Map<Id, Id> userIdDefaultQueueIdMap = new Map<Id, Id>();
        for (User userItem : users) {
            System.debug('userIdDevNameMap.get(userItem.Id): ' + userIdDevNameMap.get(userItem.Id));
            System.debug('devNameQueueIdMap.get: ' + devNameQueueIdMap.get(userIdDevNameMap.get(userItem.Id)));
            userIdDefaultQueueIdMap.put(userItem.Id, devNameQueueIdMap.get(userIdDevNameMap.get(userItem.Id)));
        }
        return userIdDefaultQueueIdMap;
    }

    public static Map<Id, Id> getUserIdBranchIdMap(final List<Id> userIdList) {
        final List<User> users = UserUtils.getUtenti(userIdList);
        System.debug('getUserIdBranchIdMap!');
        List<Account> branchList = AccountUtils.getBranchList();
        final Map<String, Id> ocsExternalIdBranchIdMap = new Map<String, Id>();
        for (Account acc : branchList) {
            System.debug('acc.OCS_External_Id__c: ' + acc.OCS_External_Id__c);
            System.debug('acc.Id: ' + acc.Id);
            ocsExternalIdBranchIdMap.put(acc.OCS_External_Id__c, acc.Id);
        }

        final Map<Id, Id> userIdBranchIdMap = new Map<Id, Id>();
        for (User userItem : users) {
            System.debug('userItem.Id: ' + userItem.Id);
            System.debug('userItem.DefaultQueueId__c: ' + userItem.DefaultQueueId__c);
            System.debug('ocsExternalIdBranchIdMap.get: ' + ocsExternalIdBranchIdMap.get(userItem.DefaultQueueId__c));
            userIdBranchIdMap.put(userItem.Id, ocsExternalIdBranchIdMap.get(userItem.DefaultQueueId__c));
        }

        return userIdBranchIdMap;
    }

    public static Map<Id, Id> getBranchIdDefaultQueueIdMap(final List<Id> branchIdList) {

        Map<Id, String> branchMapById = AccountUtils.getBranchMapById();

        final List<Group> groupList = GroupUtils.getQueueList(branchMapById.values());

        final Map<String, Id> developerNameQueueIdMap = new Map<String, Id>();
        for (Group groupItem : groupList) {
            developerNameQueueIdMap.put(groupItem.DeveloperName, groupItem.Id);
        }

        final Map<Id, Id> branchIdDefaultQueueIdMap = new Map<Id, Id>();
        for (Id branchId : branchIdList) {
            branchIdDefaultQueueIdMap.put(branchId, developerNameQueueIdMap.get(branchMapById.get(branchId)));
        }
        return branchIdDefaultQueueIdMap;
    }


    private static Group getFilialeUtente(final Id userId, final String userName) {
        String query = 'SELECT Branch_Or_Office__c, DefaultQueueId__c from User where ';
        if (userId <> null) {
            query += 'Id =: userId';
        }
        else {
            query += 'Name =: userName';
        }
        final User user = Database.query(query);
        
        Boolean isUtenteDiFiliale = 'FIL'.equalsIgnoreCase(user.Branch_Or_Office__c);
        if(!isUtenteDiFiliale) return null;
        return GroupUtils.getQueue(user.DefaultQueueId__c);
    }

    private static List<User> getUtenti(final List<Id> userIdList) {
        return [SELECT Id, DefaultQueueId__c FROM User WHERE Id IN :userIdList];  
    }

}