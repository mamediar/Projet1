public class XCSCreazioneAnagrafica {
    
    public static void crea(final Map<Account,Account> accountMap, final Boolean isFromWS) {
        if (accountMap == null) {
            System.debug(LoggingLevel.DEBUG, 'Input AccountMap is Null!');
            return;
        }
        System.debug(LoggingLevel.DEBUG, 'Starting CreazioneAnagrafica for ' + accountMap.size() + ' Accounts');

        // filtro gli Account senza match
        List<Account> accountToCreateList = getAccountToCreateList(accountMap);
        
        System.debug(LoggingLevel.DEBUG, 'Found ' + accountToCreateList.size() + ' Accounts with no match');

        for (Account account : accountToCreateList) {
            accountMap.remove(account);
        }
        
        System.debug(LoggingLevel.DEBUG, 'accountMap size dopo remove: ' + accountMap.size());

        System.debug(LoggingLevel.DEBUG, 'Found ' + accountToCreateList.size() + ' Accounts to create');

        checkCreateAccountList(accountToCreateList);

        final List<Account> noExternalIdAccountList = XCSModuloAnagraficaUtils.getNoExternalIdAccountList(accountToCreateList);

        System.debug(LoggingLevel.DEBUG, 'Inserting ' + noExternalIdAccountList.size() + ' Accounts with no external Id defined');
        
        if (noExternalIdAccountList.size() > 0) {
            if (isFromWS)
        	    Database.insert(noExternalIdAccountList, false);
            else {
                insert noExternalIdAccountList;
            }
        	System.debug(LoggingLevel.DEBUG, 'Insert done');
        }

        final Map<String, Account> externalIdAccountMap = XCSModuloAnagraficaUtils.getExternalIdAccountMap(accountToCreateList);

        final List<Account> withExternalIdAccountList = new List<Account>(externalIdAccountMap.values());

        System.debug(LoggingLevel.DEBUG, 'Inserting ' + withExternalIdAccountList.size() + ' Accounts with duplicated external Id');
        
        if (withExternalIdAccountList.size() > 0) {
            if (isFromWS)
        	    Database.insert(withExternalIdAccountList, false);
            else {
                insert withExternalIdAccountList;
            }
        	System.debug(LoggingLevel.DEBUG, 'Insert done');
        }

        Map<String, Account> createdAccountIdMap = new Map<String, Account>();
        
        for (Account account : accountToCreateList) {
            if (account.OCS_External_Id__c == null) {
                accountMap.put(account, getValidAccount(account));
            } 
            else {
                Account ocsIdAccount = externalIdAccountMap.get(account.OCS_External_Id__c);
                if (accountMap.get(account) == null) {
                    Account validAccount = getValidAccount(ocsIdAccount);
                    accountMap.put(account, validAccount);
                }
            }
            createdAccountIdMap.put(accountMap.get(account).Id, account);
        }
        System.debug(LoggingLevel.DEBUG, 'createdAccountIdMap ' + createdAccountIdMap);

        final List<String> fieldList = new List<String>(createdAccountIdMap.keySet());
        String query = XCSModuloAnagraficaUtils.BASE_QUERY + 'Id IN :fieldList';

        System.debug(LoggingLevel.DEBUG, 'Executing query: ' + query);

        final List<Account> retrievedAccounts = Database.query(query);

        for (Account foundAcc : retrievedAccounts) {
            final Account acc = createdAccountIdMap.get(foundAcc.Id);
            accountMap.put(acc, foundAcc);
        }

        System.debug(LoggingLevel.DEBUG, 'Finished CreazioneAnagrafica for ' + accountMap.size() + ' Accounts');
    }

    private static void checkCreateAccountList(List<Account> accountToCreateList) {
        for (Account inputAccount : accountToCreateList) {
            inputAccount.RecordTypeID = personRecordTypeId;
            XCSModuloAnagraficaUtils.checkValidEmail(inputAccount, 'personEmail');
        }
    }

    private static List<Account> getAccountToCreateList(final Map<Account,Account> accountMap) {
        final List<Account> accountToCreateList = new List<Account>();
        
        for (Account inputAccount : accountMap.keySet()) {
            if (accountMap.get(inputAccount) == null) accountToCreateList.add(inputAccount);
        }
        return accountToCreateList;
    }

    private static Account getValidAccount(final Account account) {
        if (account == null) return null;
        if (account.Id == null) return null;
        return account;
    }

    private static String personRecordTypeId  = RecordTypeUtil.getPersonRecordType();

}