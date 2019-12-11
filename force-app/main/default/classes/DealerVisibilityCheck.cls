public class DealerVisibilityCheck {
    
    private static List<Account> listDealer;
    private static Map<id,Account> mapBeforeDealer;
    
    Public Static void DealerInsert(List<Account> listBeforeAccount)
    {
        if(!listBeforeAccount.isEmpty())
        {
            System.debug('Dentro Trigger Insert');
            ApexShareUtils.VisibilityDealerOnBranch(listBeforeAccount);
        }
    }
    
    Public Static void DealerUpdate(List<Account> listBeforeAccount,List<Account> listAfterAccount)
    {
        //List<Account> listDealerToWork = new List<Account>();
        Map<id,Account> mapAfterAccount = AccountUtils.listToMap(listAfterAccount);
        if(!listBeforeAccount.isEmpty())
        {
            mapBeforeDealer = AccountUtils.listToMap(listBeforeAccount);
            for(Id accountId : mapAfterAccount.keySet())
            {
                if(mapBeforeDealer.get(accountId) == null)
                {
                    mapAfterAccount.remove(accountId);
                }
            }
           ApexShareUtils.VisibilityDealerOnBranch(mapAfterAccount.values());
           ApexShareUtils.ChangeOwnerCase(listBeforeAccount,mapAfterAccount);
        }
        
    }
}