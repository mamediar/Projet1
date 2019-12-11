public class XCSCensimentoProspect {

    public static void censisci(final Map<Account, Account> accountMap) {
        if (accountMap == null || accountMap.size() == 0) {
            return;
        }
        System.debug(LoggingLevel.DEBUG, 'Starting CensimentoProspect for ' + accountMap.size() + ' Accounts');
    	
        final List<Account> accountToSendList = getAccountToSendList(accountMap);

        for (Account account : accountToSendList) {
            final OCSCreaProspectResponse resp = OCSCreaProspectInvoker.callRecDati(account);
            if (!resp.isOK()) {
                String errorMsg = 'Error invoking OCSCreaProspect Web Service: ' + resp.getMessage();
                System.debug(LoggingLevel.ERROR, errorMsg);
                throw new CensimentoProspectException(errorMsg);
            }
            if (resp.datiCreaProspectResponse == null) {
                 System.debug(LoggingLevel.DEBUG, 'OCSCreaProspect Web Service: resp.datiCreaProspectResponse is null');
                 continue;
            }

            final String codiceAnag = resp.datiCreaProspectResponse.codiceAnagrafico;
            final String flagAnag = resp.datiCreaProspectResponse.flagAnagraficaEsistente;
            if (String.isNotEmpty(codiceAnag) && codiceAnag.isNumeric() && Integer.valueOf(codiceAnag) > 0) {
                account.OCS_External_Id__c = 'C' + codiceAnag;
            }
            account.Status__pc = 'C';
            if (String.isNotEmpty(flagAnag) && flagAnag == 'S') {
                account.Status__pc = 'P';
            }
        }

        // update accountToSendList;

        System.debug(LoggingLevel.DEBUG, 'Finished CensimentoProspect for ' + accountMap.size() + ' Accounts');	
    }

    // recupero Account di input senza match che non hanno OCS ID e Account di input il cui match e' senza OCS ID
    private static List<Account> getAccountToSendList(final Map<Account, Account> accountMap) {
        final List<Account> accountToSendList = new List<Account>();
        System.debug('###########################  accountMap.keySet()  getAccountToSendList'+accountMap.keySet());
        for (Account inAccount : accountMap.keySet()) {
            final Account outAccount = accountMap.get(inAccount);
            if (inAccount.OCS_External_Id__c <> null) continue;
            if (outAccount == null) accountToSendList.add(inAccount);
            else if (outAccount.OCS_External_Id__c == null) accountToSendList.add(inAccount);
        }
        return accountToSendList;
    }

    public class CensimentoProspectException extends Exception{}
}