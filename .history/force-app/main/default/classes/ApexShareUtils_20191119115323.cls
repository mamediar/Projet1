public class ApexShareUtils
{
    private static List<Group> listGroup;
    private static Map<id,group> mapIdGroup;
    private static Map<String,Group> mapNameGroup;
    private static Map<id,Account> branchMap;

    private static List<Group> getListGroup()
    {
        if(listGroup == null || listGroup.isEmpty())
        {
            listGroup = GroupUtils.getQueueBranchList();
        }
        return listGroup;
    }
    private static Map<id,Group> getMapIdGroup()
    {
        if(mapIdGroup == null || mapIdGroup.isEmpty())
        {
            mapIdGroup = GroupUtils.getQueueIdGroupMapFromList(getListGroup());
        }
        return mapIdGroup;
    }
    private static Map<String,Group> getMapNameGroup()
    {
        if(mapNameGroup == null || mapNameGroup.isEmpty())
        {
            mapNameGroup = GroupUtils.getQueueMapByDeveloperName(getListGroup());
        }
        return mapNameGroup;
    }
    private static Map<id,Account> getBranchMap()
    {
        if(branchMap == null ||branchMap.isEmpty())
        {
            branchMap = AccountUtils.getBranchMap();
            System.debug('DP dentro IF getBranchMap');
        }
        return branchMap;
    }
    
    public static void VisibilityDealerOnBranch(list<Account> listDealer)
    {
        system.debug('DP Test process builder dealer' );
        Set<String> dealerID = new Set<String>();
        Set<String> roleName = new Set<String>();
        Map<String,Group> mapNameRoleGroup = new Map<String,Group>();
        Map<id,Account> branchIdMap = getBranchMap();
        List<AccountShare> ListAccountShareToInsert = new List<AccountShare>();
 
        For(Account d : listDealer)
        {
            dealerID.add(d.Id);
            //System.debug(BranchMap.get(d.Branch__c).NameRoleReference__c + 'DP ID DEL BRANCH');
            if(String.isNotBlank(d.Branch__c) &&  !AccountUtils.isDummy(d))
            {
                roleName.add(branchIdMap.get(d.Branch__c).NameRoleReference__c);
                system.debug(branchIdMap.get(d.Branch__c).NameRoleReference__c + ' DP NOME RUOLO ');
            }
            System.debug(roleName);
        }
        List<AccountShare> ListAccountShareToDelete = [SELECT Id, AccountId, UserOrGroupId, AccountAccessLevel, OpportunityAccessLevel, ContactAccessLevel, RowCause FROM AccountShare where AccountId In :dealerID AND RowCause = 'Manual'];
        for(Group g: GroupUtils.getRoleList(roleName))     
        {
            mapNameRoleGroup.put(g.DeveloperName.tolowercase(),g);  
        }
        for(Account a : listDealer)
        {
            if(a.Branch__c != null && (String.isBlank(a.OCS_External_Id__c) ||!AccountUtils.isDummy(a)) && mapNameRoleGroup != null && getBranchMap().get(a.branch__c).NameRoleReference__c != null)
            {
                ListAccountShareToInsert.add(new AccountShare(
                    	Accountid=a.Id,
                    	UserOrGroupId=mapNameRoleGroup.get(getBranchMap().get(a.branch__c).NameRoleReference__c.tolowercase()).id,
                    	AccountAccessLevel='Edit',
                    	OpportunityAccessLevel='None'
                	)
				);
            }   
        }
        System.debug('DP  Lista da eliminare ' + ListAccountShareToDelete);
        System.debug('DP  Lista da inserire ' + ListAccountShareToInsert);      
        if(ListAccountShareToDelete.size() > 0)
        {
            Delete ListAccountShareToDelete;
        }
        Insert  ListAccountShareToInsert;
        System.debug('FINITO');
    }
    
    
    public static void ChangeOwnerCase(List<Account> listDealerBefore,Map<id,Account> mapDealerAfter)
    {
        List<Case> listCaseToUpdate = new List<Case>();
        list<Case> test = CaseUtils.caseListForAccountidOwner('id,AccountId,OwnerId',listDealerBefore,getMapIdGroup().values());
        system.debug(test);
        for(Case c: CaseUtils.caseListForAccountidOwner('id,AccountId,OwnerId',listDealerBefore,getMapIdGroup().values()))
        {
            if(getMapIdGroup().get(c.ownerId) != null)
            {
                If(String.isNotBlank(mapDealerAfter.get(c.AccountId).branch__c))
                {
                    c.ownerId = getMapNameGroup().get(getBranchMap().get(mapDealerAfter.get(c.AccountId).branch__c).OCS_External_Id__c).id;
                    listCaseToUpdate.add(c);
                }
            }
        }
        if(!listCaseToUpdate.isEmpty())
        {
           	System.debug('DP Sto Aggiornando i Case:' + listCaseToUpdate);
            update listCaseToUpdate;
        }
    }
    
    private static void createCaseShare(String caseId, String userOrGroupId,String caseAccessLevel){
        CaseShare c_share=new CaseShare();
        c_share.CaseId=caseId;
        c_share.UserOrGroupId=userOrGroupId;
        c_share.CaseAccessLevel=caseAccessLevel;
        c_share.RowCause='Manual';
        System.debug(c_share);
        insert c_share;
    }
    
    public static void createCaseShareInRead(String caseId, String userOrGroupId){
        createCaseShare(caseId,userOrGroupId,'Read');
    }    
    
    public static void createCaseShareInEdit(String caseId, String userOrGroupId){
        createCaseShare(caseId,userOrGroupId,'Edit');
    }

    public static void createCaseShareInAll(String caseId, String userOrGroupId){
        createCaseShare(caseId,userOrGroupId,'All');
    }    
    
    private static void createAccountShare(String accountId, String userOrGroupId,String accountAccessLevel){
        AccountShare a_share=new AccountShare();
        a_share.AccountId=accountId;
        a_share.UserOrGroupId=userOrGroupId;
        a_share.AccountAccessLevel=accountAccessLevel;
        a_share.OpportunityAccessLevel=accountAccessLevel;
        a_share.RowCause='Manual';
        System.debug(a_share);
        insert a_share;
    }
    
    public static void createAccountShareInRead(String accountId, String userOrGroupId){
        createAccountShare(accountId,userOrGroupId,'Read');
    }    
    
    public static void createAccountShareInEdit(String accountId, String userOrGroupId){
        createAccountShare(accountId,userOrGroupId,'Edit');
    }

    public static void createAccountShareInAll(String accountId, String userOrGroupId){
        createAccountShare(accountId,userOrGroupId,'All');
    }        
    
}