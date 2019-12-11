public class XCSRicercaAnagraficaDealer {

    public static void ricercaPerOcsID(final Map<Account, DealerAccount> accountMap) {
        if (accountMap == null || accountMap.size() == 0) {
            return;
        }
        logStart(accountMap, 'ricercaPerOcsID');

        final String fieldName = 'OCS_External_Id__c';

		System.debug(LoggingLevel.DEBUG, 'Starting ricercaPerOCSID for ' + accountMap.size() + ' Accounts');
        
        final Map<String, Account> fieldAccountMap = getInputAccountMap(accountMap, fieldName);
        
        System.debug(LoggingLevel.DEBUG, 'There are ' + fieldAccountMap.size() + ' Accounts foundable by OCS_ID');

        search(accountMap, fieldAccountMap, fieldName);
        
        logEnd(accountMap, 'ricercaPerOcsID');
    }

    public static void ricercaPerPIVAoCF(final Map<Account, DealerAccount> accountMap) {
        if (accountMap == null || accountMap.size() == 0) {
            return;
        }
        logStart(accountMap, 'ricercaPerPIVAoCF');

        final String fieldName1 = 'Partita_IVA__c';
        final String fieldName2 = 'Codice_Fiscale__c';

        Map<String, Account> fieldAccountMap = getInputAccountMapByPIVA(accountMap, fieldName1);
        System.debug(LoggingLevel.DEBUG, 'There are ' + fieldAccountMap.size() + ' Accounts foundable by P_IVA');

        search(accountMap, fieldAccountMap, fieldName1);
        search(accountMap, fieldAccountMap, fieldName2);

        logEnd(accountMap, 'ricercaPerPIVAoCF');
    }

    private static Map<String, Account> getInputAccountMap(Map<Account, DealerAccount> accountMap, String fieldName) {
        final Map<String, Account> fieldAccountMap = new Map<String, Account>();

        List<Account> inputAccounts = new List<Account>(accountMap.keySet());
        for (Account account : inputAccounts) {
            final DealerAccount dealerAcc = accountMap.get(account);
            if (XCSModuloAnagraficaUtils.isEmptyDealerAccount(dealerAcc) && account.get(fieldName) <> null) {
                fieldAccountMap.put(String.valueOf(account.get(fieldName)), account);
            }
        }

        return fieldAccountMap;
    }

    private static Map<String, Account> getInputAccountMapByPIVA(Map<Account, DealerAccount> accountMap, String fieldName) {
        final Map<String, Account> fieldAccountMap = new Map<String, Account>();

        List<Account> inputAccounts = new List<Account>(accountMap.keySet());
        for (Account account : inputAccounts) {
            final DealerAccount dealerAcc = accountMap.get(account);
            if (XCSModuloAnagraficaUtils.isEmptyDealerAccount(dealerAcc) && 
                account.Partita_IVA__c <> null &&
                account.OCS_External_Id__c == null &&
                (account.Type_Anag__c <> 'A' || account.Tipo_Intermediario__c <> 'PV')) {
                    fieldAccountMap.put(String.valueOf(account.Partita_IVA__c), account);
            }
        }

        return fieldAccountMap;
    }

    private static void search(final Map<Account, DealerAccount> accountMap, final Map<String, Account> fieldAccountMap, final String fieldName) {
        System.debug(LoggingLevel.DEBUG, 'Searching by ' + fieldName);
        final List<String> fieldList = new List<String>(fieldAccountMap.keySet());
        if (fieldList.size() == 0) return;

        String query1 = ACCOUNT_BASE_QUERY + fieldName + ' IN :fieldList';

        System.debug(LoggingLevel.DEBUG, 'Executing query: ' + query1);

        final List<Account> foundAccounts = Database.query(query1);

        if (foundAccounts == null || foundAccounts.size() == 0) return;

        System.debug(LoggingLevel.DEBUG, 'Found ' + foundAccounts.size() + ' Account matches');

        // Mappa campo di ricerca - account trovato
        final Map<String, Account> foundAccountsMap = XCSModuloAnagraficaUtils.getFoundAccountsMap(foundAccounts, fieldName);

        // Mappa Id account trovato - account trovato
        final Map<String, Account> foundAccountsIdMap = XCSModuloAnagraficaUtils.getFoundAccountsMap(foundAccounts, 'Id');
        final List<String> accountIdList = new List<String>(foundAccountsIdMap.keySet());
        String query2 = CONTACT_BASE_QUERY + ' AccountId IN :accountIdList';

        System.debug(LoggingLevel.DEBUG, 'Executing query: ' + query2);

        List<Contact> foundContacts = Database.query(query2);

        if (foundAccounts == null) foundContacts = new List<Contact>(); // non dovrebbe capitare mai, serve solo per schermare i nullpointer
        System.debug(LoggingLevel.DEBUG, 'Found ' + foundAccounts.size() + ' Contact matches');

         // Mappa Id account trovato - contact trovato
        final Map<String, Contact> foundContactsIdMap = getFoundContactsMap(foundContacts, foundAccountsIdMap);

        final List<Account> inputAccountList = new List<Account>(accountMap.keySet());
        for (Account inputAccount : inputAccountList) {
            if(accountMap.get(inputAccount) != null) continue;
            String fieldValue = (String)inputAccount.get(fieldName);
            Account foundAccount = foundAccountsMap.get(fieldValue);
            if(foundAccount == null) continue;
            final DealerAccount dealerAcc = new DealerAccount();
            dealerAcc.account = foundAccount;
            dealerAcc.contact = (Contact) foundContactsIdMap.get(foundAccount.Id);
            accountMap.put(inputAccount, dealerAcc);
        }
    }

    public static DealerAccount ricercaDealerAccount(Account account) {
        final Map<Account, DealerAccount> accountMap = new Map<Account, DealerAccount>();
        accountMap.put(account, null);
        ricercaPerOcsID(accountMap);
        ricercaPerPIVAoCF(accountMap);

        if (accountMap.values() == null) return null;
        return accountMap.values().get(0);
    }

    private static Map<String, Contact> getFoundContactsMap (final List<Contact> foundContacts, final Map<String, Account> foundAccountsIdMap) {
        final Map<String, Contact> foundContactsMap = new Map<String, Contact>();
        for (Contact foundContact : foundContacts) {
            //Account acc = foundAccountsIdMap.get(foundContact.AccountId);
            //if (foundContact.LastName == acc.Name)
                foundContactsMap.put(foundContact.AccountId, foundContact);
        }
        return foundContactsMap;
    }

    private static void logStart(final Map<Account, DealerAccount> accountMap, String methodName) {
        System.debug(LoggingLevel.DEBUG, 'Starting ' + methodName + ' for ' + accountMap.size() + ' Accounts');
    }

    private static void logEnd(final Map<Account, DealerAccount> accountMap, String methodName) {
        System.debug(LoggingLevel.DEBUG, 'Finished ' + methodName + ' with ' + accountMap.size() + ' Accounts');
    }

    private static final String ACCOUNT_SELECT_FIELDS = 
    'Id, OCS_External_Id__c, Codice_Fiscale__c, Partita_IVA__c, Name, BusinessEmail__c, EmailNonConforme__c, Tipo_Intermediario__c, Is_Ag__c, Is_Sa__c, Is_Pv__c, is_cv__c, Tipo_Accordo_New__c, Type_Anag__c, CodiceAgente__c, Macroarea__c, ProdottoDominanteMacroarea__c, ShippingStreet, ShippingCity, ShippingCountry, ShippingPostalCode, Phone, Telefono_Cellulare__c, Fax';
  
    private static final String ACCOUNT_BASE_QUERY = 'SELECT ' + ACCOUNT_SELECT_FIELDS + ' FROM Account WHERE RecordType.Name = \'Dealer\' AND ';

    private static final String CONTACT_SELECT_FIELDS = 
    'Id, AccountId, LastName, Email, MobilePhone';

    private static final String CONTACT_BASE_QUERY = 'SELECT ' + CONTACT_SELECT_FIELDS + ' FROM Contact WHERE ';

}