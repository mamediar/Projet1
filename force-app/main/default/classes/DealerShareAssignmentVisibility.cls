public class DealerShareAssignmentVisibility {
    @invocableMethod
    public static void setVisibility(List<Account> dealers)
    {
        
        
        system.debug('Test process builder dealer' );
        Set<String> dealerID = new Set<String>();
        Set<String> roleName = new Set<String>();
        String rName;
        List<AccountShare> ListAccountShareToInsert = new List<AccountShare>();
        Map<String,String> GroupMap = new Map<String,String>();
        Map<String,Account> BranchMap = new Map<String,Account>([Select id,NameRoleReference__c from account where RecordType.Name = 'Branch']);
        For(Account d : dealers)
        {
            dealerID.add(d.Id);
            //System.debug(BranchMap.get(d.Branch__c).NameRoleReference__c + 'ID DEL BRANCH');
            if(d.Branch__c != null && !'N00002'.equalsIgnoreCase(d.OCS_External_Id__c))
            {
                roleName.add(BranchMap.get(d.Branch__c).NameRoleReference__c);
                system.debug(BranchMap.get(d.Branch__c).NameRoleReference__c + 'NOME RUOLO ');
            }
            System.debug(roleName);
        }
        List<AccountShare> ListAccountShareToDelete = [SELECT Id, AccountId, UserOrGroupId, AccountAccessLevel, OpportunityAccessLevel, ContactAccessLevel, RowCause FROM AccountShare where AccountId In :dealerID AND RowCause = 'Manual'];
        for(Group g:[SELECT Id, Name, DeveloperName, RelatedId, Type, Email, QueueRoutingConfigId, Ownerid FROM Group where DeveloperName IN :roleName AND type = 'Role'])     
        {
            GroupMap.put(g.DeveloperName.tolowercase(),g.Id);  
        }
        for(Account a : dealers)
        {
            if(a.Branch__c != null && !'N00002'.equalsIgnoreCase(a.OCS_External_Id__c))
            {
                
                ListAccountShareToInsert.add(new AccountShare(
                    Accountid=a.Id,
                    UserOrGroupId=GroupMap.get(BranchMap.get(a.branch__c).NameRoleReference__c.tolowercase()),
                    AccountAccessLevel='Read',
                    OpportunityAccessLevel='None'
                )
                                            );
            }   
        }
        System.debug('Lista da eliminare ' + ListAccountShareToDelete);
        System.debug('Lista da inserire ' + ListAccountShareToInsert);
        if(!Test.isRunningTest()){
            if(ListAccountShareToDelete.size() > 0)
            {
                Delete ListAccountShareToDelete;
            }
            Insert  ListAccountShareToInsert;
        }
        System.debug('FINITO');
    }
    
}