trigger DealerVisibilityCheck on Account (after insert,before update) 
{
    List<Account> listDealer;
    if(Trigger.isInsert)
    {
        system.debug(Trigger.new);
        listDealer = AccountUtils.filterDealer(Trigger.new);
        system.debug(listDealer);
        DealerVisibilityCheck.DealerInsert(listDealer);
    }
    if(Trigger.isUpdate)
    {
        listDealer = AccountUtils.filterDealer(Trigger.old);
        List<Account> listDealerToWork = new List<Account>();
        Map<Id,Account> mapAfterAccount = Trigger.newMap;
        System.debug('Sono Dentro isUpdate' + listDealer);
        for(Account a : listDealer)
        {
            System.debug('Sono Dentro isUpdate nel for');
            if(a.recordtypeId.equals(mapAfterAccount.get(a.id).recordtypeid))
            {
                if(String.isNotBlank(a.branch__c) && String.isNotBlank(mapAfterAccount.get(a.id).branch__c))
                {
                    System.debug('Sono Dentro isUpdate nel for e if equals');
                    if(!mapAfterAccount.get(a.id).branch__c.equals(a.branch__c))
                    { 
                        System.debug('Sono Dentro isUpdate nel for e if');
                        listDealerToWork.add(a);
                    }
                }
                else if((String.isBlank(a.branch__c) && String.isNotBlank(mapAfterAccount.get(a.id).branch__c)) || (String.isNotBlank(a.branch__c) && String.isBlank(mapAfterAccount.get(a.id).branch__c)))
                {
                   System.debug('Sono Dentro isUpdate nel for e if equals else if');
                   listDealerToWork.add(a);
                }
            }       
        }
        if(!listDealerToWork.isEmpty())
        {
            System.debug('Sono Dentro isUpdate nel for e if isEmpty');
            DealerVisibilityCheck.DealerUpdate(listDealerToWork,mapAfterAccount.values()); 
        }
    }
}