public class XCSAggiornaAnagrafica {
    
    public static void aggiorna(final Map<Account,Account> accountMap, final Boolean isFromOCS, final Boolean isFromWS) {
        if (accountMap == null || accountMap.size() == 0) {
            return;
        }
        System.debug(LoggingLevel.DEBUG, 'Starting AggiornaAnagrafica for ' + accountMap.size() + ' Accounts');
         System.debug(LoggingLevel.DEBUG, 'Starting AggiornaAnagrafica for  key' + accountMap.keySet() + ' Accounts');
          System.debug(LoggingLevel.DEBUG, 'Starting AggiornaAnagrafica for  value' + accountMap.values() + ' Accounts');

        // filtro gli Account senza match
        final Map<Account,Account> accountsToUpdateMap = getAccountsToUpdateMap(accountMap);
        System.debug(LoggingLevel.DEBUG, '########### accountsToUpdateMap'+accountsToUpdateMap);
        System.debug(LoggingLevel.DEBUG, 'Found ' + accountsToUpdateMap.size() + ' Accounts to update');

        final Map<Account,Account> updatedAccountMap = getUpdatedAccountMap(accountsToUpdateMap, isFromOCS);
        final List<Account> updatedAccounts = new List<Account>(updatedAccountMap.values());

        System.debug(LoggingLevel.DEBUG, 'Updating ' + updatedAccounts.size() + ' Accounts');
        if (isFromWS)
            Database.update(updatedAccounts, false);
        else
            update updatedAccounts;

        System.debug(LoggingLevel.DEBUG, 'Update done');
        setUpdatedFields(updatedAccountMap, accountMap);

        System.debug(LoggingLevel.DEBUG, 'Finished AggiornaAnagrafica for ' + accountMap.size() + ' Accounts');
    }

    private static Map<Account,Account> getUpdatedAccountMap(Map<Account,Account> accountToUpdateMap, final Boolean isFromOCS) {
        System.debug('###################### is isFromOCS test '+isFromOCS);
        System.debug('###################### is isFromOCS test accountToUpdateMap '+accountToUpdateMap);
        final Map<Account,Account> updatedAccountMap = new Map<Account,Account>();

        List<Account> inputAccounts = new List<Account>(accountToUpdateMap.keySet());
        System.debug(LoggingLevel.DEBUG, 'DataSource is' + (isFromOCS ? '' : ' not') + ' from OCS');
        for (Account inputAccount : inputAccounts) {
            System.debug('#############  inputAccounts '+inputAccounts);
            final Map<String,Object> populatedFieldsMap = new Map<String,Object>(inputAccount.getPopulatedFieldsAsMap());
            List<String> fieldList = new List<String>(populatedFieldsMap.keySet());
            
            for (String field : fieldList) {
                if (isFromOCS) {
                    removeFieldIfPopulated(accountToUpdateMap, populatedFieldsMap, inputAccount, field, 'PersonEmail');
                }
                else {
                    removeFieldIfPopulated(accountToUpdateMap, populatedFieldsMap, inputAccount, field, 'FirstName');
                    removeFieldIfPopulated(accountToUpdateMap, populatedFieldsMap, inputAccount, field, 'LastName');
                    removeFieldIfPopulated(accountToUpdateMap, populatedFieldsMap, inputAccount, field, 'Codice_Fiscale__pc');
                }
            }
            System.debug('################ getUpdatedAccountMap xxxxxx ');
            XCSModuloAnagraficaUtils.checkValidEmail(populatedFieldsMap, inputAccount, 'PersonEmail');

            final Account foundAccount = accountToUpdateMap.get(inputAccount);

            populatedFieldsMap.put('Id', foundAccount.Id);

            final Account account = new Account ();
            List<String> updatedFieldList = new List<String>(populatedFieldsMap.keySet());
            for (String field : updatedFieldList) {
                account.put(field, populatedFieldsMap.get(field));
            }

            updatedAccountMap.put(inputAccount, account);
        }
        return updatedAccountMap;
    }

    private static void removeFieldIfPopulated(Map<Account,Account> accountToUpdateMap, Map<String,Object> populatedFieldsMap, Account inputAccount, String field, String fieldName) {
         System.debug('######################## field  removeFieldIfPopulated '+field);
        if (field <> fieldName) return;
        
        Account foundAccount = accountToUpdateMap.get(inputAccount);
        if (foundAccount.get(field) <> null) {
            populatedFieldsMap.remove(field);
        }
    }

    private static Map<Account,Account> getAccountsToUpdateMap(final Map<Account,Account> accountMap) {
        System.debug('######################  getAccountsToUpdateMap running '+accountMap);
        final Map<Account,Account> accountToUpdateMap = new Map<Account,Account>();
        List<Account> inputAccounts = new List<Account>(accountMap.keySet());
        for (Account inputAccount : inputAccounts) {
            if (accountMap.get(inputAccount) <> null) accountToUpdateMap.put(inputAccount, accountMap.get(inputAccount));
        }
        return accountToUpdateMap;
    }

    private static void setUpdatedFields(Map<Account,Account> updatedAccountMap, Map<Account,Account> accountMap) {
        List<Account> inputAccounts = new List<Account>(accountMap.keySet());
        for (Account inputAccount : inputAccounts) {
            Account updateAccount = updatedAccountMap.get(inputAccount);
            if (updateAccount == null) continue;
            final Map<String,Object> populatedFieldsMap = new Map<String,Object>(updateAccount.getPopulatedFieldsAsMap());
            List<String> fieldList = new List<String>(populatedFieldsMap.keySet());

            for (String field : fieldList) {
                Account foundAccount = accountMap.get(inputAccount);
                foundAccount.put(field, updateAccount.get(field));
            }
        }
    }
        
}