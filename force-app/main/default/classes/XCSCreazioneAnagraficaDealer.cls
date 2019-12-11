public class XCSCreazioneAnagraficaDealer {

    public static void crea(final Map<Account, DealerAccount> accountMap, final Boolean isFromWS) {
        if (accountMap == null) {
            System.debug(LoggingLevel.DEBUG, 'Input AccountMap is Null!');
            return;
        }
        System.debug(LoggingLevel.DEBUG, 'Starting CreazioneAnagraficaDealer for ' + accountMap.size() + ' Accounts');

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
            else
        	    insert noExternalIdAccountList;
        	System.debug(LoggingLevel.DEBUG, 'Insert done');
        }

        final Map<String, Account> externalIdAccountMap = XCSModuloAnagraficaUtils.getExternalIdAccountMap(accountToCreateList);

        final List<Account> withExternalIdAccountList = new List<Account>(externalIdAccountMap.values());

        System.debug(LoggingLevel.DEBUG, 'Inserting ' + withExternalIdAccountList.size() + ' Accounts with duplicated external Id');
        
        if (withExternalIdAccountList.size() > 0) {
            if (isFromWS)
                Database.insert(withExternalIdAccountList, false);
            else
        	    insert withExternalIdAccountList;
        	System.debug(LoggingLevel.DEBUG, 'Insert done');
        }

        final List<Account> createdAccountList = new List<Account>();
        createdAccountList.addAll(noExternalIdAccountList);
        createdAccountList.addAll(withExternalIdAccountList);
 
        if (createdAccountList.size() == 0) {
            System.debug(LoggingLevel.DEBUG, 'No Accounts created');
            return;
        }

        final List<Contact> createdContactList = getCreatedContactList(createdAccountList);
        final Map<String, Contact> accountIdContactMap = getAccountIdContactMap(createdContactList);
        
        for (Account account : accountToCreateList) {
            if (account.OCS_External_Id__c == null) {
                accountMap.put(account, getOutputDealerAccount(account, accountIdContactMap.get(account.Id)));
            } 
            else {
                Account ocsIdAccount = externalIdAccountMap.get(account.OCS_External_Id__c);
                if (accountMap.get(account) == null) {
                    accountMap.put(account, getOutputDealerAccount(ocsIdAccount, accountIdContactMap.get(ocsIdAccount.Id)));
                }
            }
        }

        System.debug(LoggingLevel.DEBUG, 'Finished CreazioneAnagrafica');
    }

    private static List<Contact> getCreatedContactList(final List<Account> createdAccountList) {
        final List<Contact> createdContactList = new List<Contact>();
        for (Account account: createdAccountList) {
            if (account.Id == null) continue;
            final Contact cont = new Contact(
                AccountId = account.Id,
                LastName = account.Name,
                Email = account.BusinessEmail__c,
                MobilePhone = account.Telefono_Cellulare__c
            );

            createdContactList.add(cont);
        }

        System.debug(LoggingLevel.DEBUG, 'Inserting ' + createdContactList.size() + ' Contacts');

        if (createdContactList.size() > 0) {
        	Database.insert(createdContactList, false);
        	System.debug(LoggingLevel.DEBUG, 'Insert done');
        }
        return createdContactList;
    }

    private static Map<String, Contact> getAccountIdContactMap(final List<Contact> createdContactList) {
        final Map<String, Contact> accountIdContactMap = new Map<String, Contact>();
        for (Contact cont : createdContactList) {
            accountIdContactMap.put(cont.AccountId, cont);
        }
        return accountIdContactMap;
    }

    private static void checkCreateAccountList(List<Account> accountToCreateList) {
        for (Account inputAccount : accountToCreateList) {
            inputAccount.RecordTypeID = dealerRecordTypeId;
            XCSModuloAnagraficaUtils.checkValidEmail(inputAccount, 'BusinessEmail__c');
            XCSModuloAnagraficaUtils.checkValidPhone(inputAccount, 'Telefono_Cellulare__c');
        }
    }

    private static List<Account> getAccountToCreateList(final Map<Account, DealerAccount> accountMap) {
        final List<Account> accountToCreateList = new List<Account>();
        
        for (Account inputAccount : accountMap.keySet()) {
            if (XCSModuloAnagraficaUtils.isEmptyDealerAccount(accountMap.get(inputAccount))) accountToCreateList.add(inputAccount);
        }
        return accountToCreateList;
    }

    private static DealerAccount getOutputDealerAccount(final Account account, final Contact contact) {
        final DealerAccount dealerAcc = new DealerAccount();
        if (account == null) return dealerAcc;
        if (account.Id == null) return dealerAcc;
        dealerAcc.account = account;
        dealerAcc.contact = contact;
        return dealerAcc;
    }

    private static String dealerRecordTypeId  = RecordTypeUtil.getDealerRecordType();

}