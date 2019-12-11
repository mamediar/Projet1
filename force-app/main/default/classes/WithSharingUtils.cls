public with sharing  class WithSharingUtils {

    @AuraEnabled
    public static boolean hasEditAccess(Id caseId){
     
        List<Id> listaCase = new List<id>();
        listaCase.add(caseId); 
    	List<UserRecordAccess> access = [SELECT RecordId, HasEditAccess FROM UserRecordAccess Where UserId = :UserInfo.getUserId() AND RecordId In :listaCase];
 		System.debug(access[0].hasEditAccess);
        return access != null && access.size() > 0 && access[0].hasEditAccess;
    }
}