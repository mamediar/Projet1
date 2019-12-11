public class XCSFusioneAnagrafica {
    
    public static void fondi(final Map<Account,Account> accountMap) {
        if (accountMap == null || accountMap.size() == 0) {
            return;
        }
        System.debug(LoggingLevel.DEBUG, 'Starting FusioneAnagrafica for ' + accountMap.size() + ' Accounts');

        // filtro gli Account con match e RSS_External_Id__c non nullo
        List<Account> accountToMergeList = getAccountToMergeList(accountMap);

        System.debug(LoggingLevel.DEBUG, 'Found ' + accountToMergeList.size() + ' Accounts with CRM_ID defined');

        Map<Account,Account> accountToSearchMap = new Map<Account,Account>();
        for (Account inputAccount : accountToMergeList) {
            String crmId = inputAccount.RSS_External_Id__c;
            String foundAccountCrmId = accountMap.get(inputAccount).RSS_External_Id__c;
            if (foundAccountCrmId == null) continue;
            if (crmId.equalsIgnoreCase(foundAccountCrmId)) continue;
            accountToSearchMap.put(inputAccount, null);
        }

        System.debug(LoggingLevel.DEBUG, 'Found ' + accountToSearchMap.size() + ' Accounts to merge');
        if (accountToSearchMap.size() == 0) {
            System.debug(LoggingLevel.DEBUG, 'Finished FusioneAnagrafica: no Accounts to merge');
            return;
        }

        XCSRicercaAnagrafica.ricercaPerCrmId(accountToSearchMap);

        Integer count = 0;
        for (Account inputAccount : accountToMergeList) {
            Account account1 = accountMap.get(inputAccount);
            System.debug(LoggingLevel.DEBUG, 'Found Account to merge 1: ' + account1);
            Account account2 = accountToSearchMap.get(inputAccount);
            System.debug(LoggingLevel.DEBUG, 'Found Account to merge 2: ' + account2);
            if (account2 == null) continue;
            accountMap.remove(inputAccount);
            count++;
            merge account1 account2;
            accountMap.put(inputAccount, account1);
        }

        System.debug(LoggingLevel.DEBUG, 'Finished FusioneAnagrafica for ' + accountMap.size() + ' Accounts: merged ' + count + ' Accounts');
    }

    private static List<Account> getAccountToMergeList(final Map<Account,Account> accountMap) {
        final List<Account> accountToMergeList = new List<Account>();
        List<Account> inputAccounts = new List<Account>(accountMap.keySet());
        for (Account inputAccount : inputAccounts) {
            if (accountMap.get(inputAccount) <> null && inputAccount.RSS_External_Id__c <> null) 
                accountToMergeList.add(inputAccount);
        }
        return accountToMergeList;
    }

}