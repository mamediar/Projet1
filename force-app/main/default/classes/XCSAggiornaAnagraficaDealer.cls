public class XCSAggiornaAnagraficaDealer {

    public static void aggiorna(final Map<Account, DealerAccount> accountMap, final Boolean isFromOCS, final Boolean isFromWS) {
        if (accountMap == null || accountMap.size() == 0 || !isFromOCS) {
            return;
        }
        System.debug(LoggingLevel.DEBUG, 'Starting AggiornaAnagraficaDealer for ' + accountMap.size() + ' Accounts');

        // filtro gli Account senza match
        final Map<Account, DealerAccount> accountsToUpdateMap = getAccountsToUpdateMap(accountMap);

        System.debug(LoggingLevel.DEBUG, 'Found ' + accountsToUpdateMap.size() + ' Accounts to update');

        final Map<Account, DealerAccount> updatedAccountMap = getUpdatedAccountMap(accountsToUpdateMap);
        final List<DealerAccount> updatedDealerAccounts = new List<DealerAccount>(updatedAccountMap.values());

        final List<Account> updatedAccounts = new List<Account>();
        final List<Contact> updatedContacts = new List<Contact>();
        
        for (DealerAccount dealerAcc : updatedDealerAccounts) {
            updatedAccounts.add(dealerAcc.account);
            if (dealerAcc.contact <> null)
                updatedContacts.add(dealerAcc.contact);
        }

        System.debug(LoggingLevel.DEBUG, 'Updating ' + updatedAccounts.size() + ' Accounts');
        if (isFromWS)
            Database.update(updatedAccounts, false);
        else
            update updatedAccounts;
        System.debug(LoggingLevel.DEBUG, 'Update done');

        System.debug(LoggingLevel.DEBUG, 'Updating ' + updatedContacts.size() + ' Contacts');
        if (isFromWS)
            Database.update(updatedContacts, false);
        else
            update updatedContacts;
        System.debug(LoggingLevel.DEBUG, 'Update done');

        setUpdatedFields(updatedAccountMap, accountMap);

        System.debug(LoggingLevel.DEBUG, 'Finished AggiornaAnagraficaDealer for ' + accountMap.size() + ' Accounts');
    }

    private static Map<Account, DealerAccount> getUpdatedAccountMap(Map<Account, DealerAccount> accountToUpdateMap) {
        final Map<Account,DealerAccount> updatedAccountMap = new Map<Account,DealerAccount>();

        List<Account> inputAccounts = new List<Account>(accountToUpdateMap.keySet());
        
        for (Account inputAccount : inputAccounts) {
            final Map<String,Object> populatedFieldsMap = new Map<String,Object>();
            if (inputAccount.Tipo_Intermediario__c == 'AG') {
                System.debug(LoggingLevel.DEBUG, 'Tipo_Intermediario__c is AG: updating olny Is_Ag__c field');
                populatedFieldsMap.put('Is_Ag__c', 1);
            }
            else {
                System.debug(LoggingLevel.DEBUG, 'Updating fields');
                
                populatedFieldsMap.putAll(inputAccount.getPopulatedFieldsAsMap());
            
                List<String> fieldList = new List<String>(populatedFieldsMap.keySet());
                
                for (String field : fieldList) {
                    removeFieldIfPopulatedAs(accountToUpdateMap, populatedFieldsMap, inputAccount, field, 'BusinessEmail__c', null);
                    removeFieldIfPopulatedAs(accountToUpdateMap, populatedFieldsMap, inputAccount, field, 'Tipo_Intermediario__c ', 'CV');
                }
            }
            XCSModuloAnagraficaUtils.checkValidEmail(populatedFieldsMap, inputAccount, 'BusinessEmail__c');
            XCSModuloAnagraficaUtils.checkValidPhone(populatedFieldsMap, inputAccount, 'Telefono_Cellulare__c');

            final DealerAccount foundAccount = accountToUpdateMap.get(inputAccount);

            populatedFieldsMap.put('Id', foundAccount.account.Id);

            final Account account = new Account();

            final List<String> updatedFieldList = new List<String>(populatedFieldsMap.keySet());
            for (String field : updatedFieldList) {
                account.put(field, populatedFieldsMap.get(field));   
            }
            final DealerAccount dealerAcc = new DealerAccount();
            dealerAcc.account = account;
            dealerAcc.contact = getContactToUpdate(foundAccount, account);

            updatedAccountMap.put(inputAccount, dealerAcc);
        }
        return updatedAccountMap;
    }

    private static Contact getContactToUpdate(final DealerAccount foundAccount, Account account) {
        if (foundAccount.contact == null) return null;
        final Contact contact = new Contact(
            Id = foundAccount.contact.Id, 
            accountId = account.Id);
        if (account.Name <> null) contact.LastName = account.Name;
        if (account.BusinessEmail__c <> null) contact.Email = account.BusinessEmail__c;
        if (account.Telefono_Cellulare__c <> null) contact.MobilePhone = account.Telefono_Cellulare__c;
        return contact;
    }

    private static void removeFieldIfPopulatedAs(Map<Account,DealerAccount> accountToUpdateMap, Map<String,Object> populatedFieldsMap, Account inputAccount, String field, String fieldName, String populateValue) {
        if (field <> fieldName) return;
        
        DealerAccount foundDealerAccount = accountToUpdateMap.get(inputAccount);
        
        if (foundDealerAccount.account.get(field) <> null) {
            if (populateValue == null || ((populateValue <> null) && (String.valueOf(foundDealerAccount.account.get(field)) == populateValue)))
                populatedFieldsMap.remove(field);
        }
    }
    
    private static Map<Account,DealerAccount> getAccountsToUpdateMap(final Map<Account,DealerAccount> accountMap) {
        final Map<Account,DealerAccount> accountToUpdateMap = new Map<Account,DealerAccount>();
        List<Account> inputAccounts = new List<Account>(accountMap.keySet());
        for (Account inputAccount : inputAccounts) {
            final DealerAccount dealerAcc = accountMap.get(inputAccount);
            if (!XCSModuloAnagraficaUtils.isEmptyDealerAccount(dealerAcc)) accountToUpdateMap.put(inputAccount, dealerAcc);
        }
        return accountToUpdateMap;
    }

    private static void setUpdatedFields(Map<Account, DealerAccount> updatedAccountMap, Map<Account, DealerAccount> accountMap) {
        List<Account> inputAccounts = new List<Account>(accountMap.keySet());
        for (Account inputAccount : inputAccounts) {
            DealerAccount updateDealerAccount = updatedAccountMap.get(inputAccount);
            if (XCSModuloAnagraficaUtils.isEmptyDealerAccount(updateDealerAccount)) continue;
            final Account updateAccount = updateDealerAccount.account;
            final Contact updatContact = updateDealerAccount.contact;
            final Map<String,Object> populatedFieldsMap = new Map<String,Object>(updateAccount.getPopulatedFieldsAsMap());
            List<String> fieldList = new List<String>(populatedFieldsMap.keySet());

            DealerAccount foundDealerAccount = accountMap.get(inputAccount);
            for (String field : fieldList) {
                foundDealerAccount.account.put(field, updateAccount.get(field));
            }

            if (updatContact <> null) {
                if (updatContact.accountId <> null) foundDealerAccount.contact.accountId = updateAccount.Id;
                if (updatContact.LastName <> null) foundDealerAccount.contact.LastName = updatContact.LastName;
                if (updatContact.Email <> null) foundDealerAccount.contact.Email = updatContact.Email;
                if (updatContact.MobilePhone <> null) foundDealerAccount.contact.MobilePhone = updatContact.MobilePhone;
            }
        }
    }
        
}