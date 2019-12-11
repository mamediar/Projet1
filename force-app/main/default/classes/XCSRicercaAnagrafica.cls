public class XCSRicercaAnagrafica {

    public static void ricercaPerOcsID(final Map<Account, Account> accountMap) {
        if (accountMap == null || accountMap.size() == 0) {
            return;
        }
        logStart(accountMap, 'ricercaPerOcsID');

        String fieldName = 'OCS_External_Id__c';
		System.debug(LoggingLevel.DEBUG, 'Starting ricercaPerOCSID for ' + accountMap.size() + ' Accounts');
        Map<String, Account> fieldAccountMap = getInputAccountMap(accountMap, fieldName);
        
        System.debug(LoggingLevel.DEBUG, 'There are ' + fieldAccountMap.size() + ' Accounts foundable by OCS_ID');

        search(accountMap, fieldAccountMap, fieldName, false, false);
        
        System.debug(LoggingLevel.DEBUG, 'after search ricercaPerOCSID' + accountMap.size() + ' Accounts');

        logEnd(accountMap, 'ricercaPerOcsID');
    }

    public static void ricercaPerCodiceFiscale(final Map<Account, Account> accountMap) {
        if (accountMap == null || accountMap.size() == 0) {
            return;
        }
        logStart(accountMap, 'ricercaPerCodiceFiscale');

        String fieldName = 'Codice_Fiscale__pc';

        Map<String, Account> fieldAccountMap = getInputAccountMap(accountMap, fieldName);
        System.debug(LoggingLevel.DEBUG, 'There are ' + fieldAccountMap.size() + ' Accounts foundable by FISCALCODE');

        search(accountMap, fieldAccountMap, fieldName, true, false);
        logEnd(accountMap, 'ricercaPerCodiceFiscale');
    }

    public static void ricercaPerCrmId(final Map<Account, Account> accountMap) {
        if (accountMap == null || accountMap.size() == 0) {
            return;
        }
        logStart(accountMap, 'ricercaPerCrmId');

        String searchFieldName = 'RSS_External_Id__c';
        Map<String, Account> fieldAccountMap = getInputAccountMap(accountMap, searchFieldName);
        List<Account> inputAccounts = new List<Account>(fieldAccountMap.values());
        System.debug(LoggingLevel.DEBUG, 'There are ' + inputAccounts.size() + ' Accounts foundable by CRM_ID');

        String fieldName = 'Id';
    
        for (Account account : inputAccounts) {
            String crmId = String.valueOf(account.get(searchFieldName));
            if (isSalesforceId(crmId)) {
                fieldAccountMap.put(crmId, account);
            }
        }

        if (fieldAccountMap.size() > 0) {
            search(accountMap, fieldAccountMap, fieldName, false, true);
             System.debug(LoggingLevel.DEBUG, 'after search ricercaPerCrmId' + accountMap.size() + ' Accounts');
            fieldAccountMap.clear();
        }

        fieldName = 'RSS_External_Id__c';
        for (Account account : inputAccounts) {
            String crmId = String.valueOf(account.get(searchFieldName));
            if (!isSalesforceId(crmId)) {
                fieldAccountMap.put(crmId, account);
            }
        }

        if (fieldAccountMap.size() > 0) {
            search(accountMap, fieldAccountMap, fieldName, false, true);
             System.debug(LoggingLevel.DEBUG, 'after search ricercaPerCrmId 2' + accountMap.size() + ' Accounts');
        }

        logEnd(accountMap, 'ricercaPerCrmId');
    }

    public static void ricercaPerEmailNomeCognome(final Map<Account, Account> accountMap) {
        if (accountMap == null || accountMap.size() == 0) {
            return;
        }
        logStart(accountMap, 'ricercaPerEmailNomeCognome');

        Map<String, Account> fieldAccountMap = new Map<String, Account>();

        final String emailFieldName = 'PersonEmail';
        final String nomeFieldName = 'FirstName';
        final String cognomeFieldName = 'LastName';

        List<String> emailList = new List<String>();
        List<String> nomeList = new List<String>();
        List<String> cognomeList = new List<String>();

        List<Account> inputAccounts = getAccountsToFind(accountMap, emailFieldName);

        System.debug(LoggingLevel.DEBUG, 'There are ' + inputAccounts.size() + ' Accounts foundable by EMAIL');

        for (Account account : inputAccounts) {
            fieldAccountMap.put(String.valueOf(account.get(emailFieldName)), account);
            emailList.add(String.valueOf(account.get(emailFieldName)));
            if (account.get(nomeFieldName) <> null) nomeList.add(String.valueOf(account.get(nomeFieldName)));
            if (account.get(cognomeFieldName) <> null) cognomeList.add(String.valueOf(account.get(cognomeFieldName)));
        }

        if (emailList.size() == 0) return;

        String query = XCSModuloAnagraficaUtils.BASE_QUERY + emailFieldName + ' IN :emailList';
        if (nomeList.size() > 0) query += ' AND ' + nomeFieldName + ' IN :nomeList';
        if (cognomeList.size() > 0) query += ' AND ' + cognomeFieldName + ' IN :cognomeList';
        query += getOrderByConditions(emailFieldName);

        System.debug(LoggingLevel.DEBUG, 'Executing query: ' + query);
        
        List<Account> foundAccounts = Database.query(query);

        System.debug(LoggingLevel.DEBUG, 'Found ' + foundAccounts.size() + ' matches');

        for (Account foundAccount : foundAccounts) {
            String fieldValue = String.valueOf(foundAccount.get(emailFieldName));
            Account inputAccount = fieldAccountMap.get(fieldValue);
            if (accountMap.get(inputAccount) == null)
                accountMap.put(inputAccount, foundAccount);
        }

        logEnd(accountMap, 'ricercaPerEmailNomeCognome');
    }

    public static Account ricercaAccount(Account account) {
        final Map<Account,Account> accountMap = new Map<Account,Account>();
        accountMap.put(account, null);
        ricercaPerOcsID(accountMap);
        ricercaPerCodiceFiscale(accountMap);
        ricercaPerCrmId(accountMap);
        ricercaPerEmailNomeCognome(accountMap);

        if (accountMap.values() == null) return null;
        return accountMap.values().get(0);
    }

    private static Map<String, Account> getInputAccountMap(Map<Account, Account> accountMap, String fieldName) {
        Map<String, Account> fieldAccountMap = new Map<String, Account>();

        List<Account> inputAccounts = new List<Account>(accountMap.keySet());
        for (Account account : inputAccounts) {
            if (accountMap.get(account) == null && account.get(fieldName) <> null) {
                fieldAccountMap.put(String.valueOf(account.get(fieldName)), account);
            }
        }

        return fieldAccountMap;
    }

    private static List<Account> getAccountsToFind(Map<Account, Account> accountMap, String fieldName) {
        List<Account> fullInputAccounts = new List<Account>(accountMap.keySet());

        List<Account> inputAccounts = new List<Account>();

        for (Account account : fullInputAccounts) {
            if (accountMap.get(account) == null && account.get(fieldName) <> null) {
                inputAccounts.add(account);
            }
        }

        return inputAccounts;
    }

    private static void search(final Map<Account, Account> accountMap, Map<String, Account> fieldAccountMap, String fieldName, Boolean withOrderBy, Boolean isCrmId) {
        System.debug(LoggingLevel.DEBUG, 'Searching by ' + fieldName);
        final List<String> fieldList = new List<String>(fieldAccountMap.keySet());
        if (fieldList.size() == 0) return;

        String query = XCSModuloAnagraficaUtils.BASE_QUERY + fieldName + ' IN :fieldList';
        if (withOrderBy) query += getOrderByConditions(fieldName);

        System.debug(LoggingLevel.DEBUG, 'Executing query: ' + query);

        final List<Account> foundAccounts = Database.query(query);
        final Map<String, Account> foundAccountsMap = XCSModuloAnagraficaUtils.getFoundAccountsMap(foundAccounts, fieldName);

        System.debug(LoggingLevel.DEBUG, 'Found ' + foundAccounts.size() + ' matches');
        
        String field_name = isCrmId ? 'RSS_External_Id__c' : fieldName;
        System.debug('field_name: ' + field_name);

        final List<Account> inputAccountList = new List<Account>(accountMap.keySet());
        for (Account inputAccount : inputAccountList) {
            if(accountMap.get(inputAccount) != null) continue;
            String fieldValue = (String)inputAccount.get(field_name);
            Account foundAccount = foundAccountsMap.get(fieldValue);
            if(foundAccount == null) continue;
            accountMap.put(inputAccount, foundAccount);
        }
    }

    private static Boolean isSalesforceId(String id) {
        if (id.isNumeric()) return false;
        if (id.length() == 15 || id.length() == 18) return true;
        return false;
    }

    private static String getOrderByConditions(final String fieldName) {
        return ' ORDER BY ' + fieldName + ', CreatedDate ASC';
    }

    private static void logStart(final Map<Account, Account> accountMap, String methodName) {
        System.debug(LoggingLevel.DEBUG, 'Starting ' + methodName + ' for ' + accountMap.size() + ' Accounts');
    }

    private static void logEnd(final Map<Account, Account> accountMap, String methodName) {
        System.debug(LoggingLevel.DEBUG, 'Finished ' + methodName + ' with ' + accountMap.size() + ' Accounts');
    }
    
}