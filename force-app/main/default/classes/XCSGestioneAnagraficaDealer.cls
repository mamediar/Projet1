public class XCSGestioneAnagraficaDealer {

    public static void execute(final Map<Account, DealerAccount> accountMap, final Boolean isFromOCS) {
        run(accountMap, isFromOCS, false);
    }

    public static void executeFromWS(final Map<Account, DealerAccount> accountMap, final Boolean isFromOCS) {
        run(accountMap, isFromOCS, true);
    }

    private static void run(final Map<Account, DealerAccount> accountMap, final Boolean isFromOCS, final Boolean isFromWS) {
        if (accountMap == null || accountMap.size() == 0) {
            return;
        }
		
        System.debug(LoggingLevel.DEBUG, 'Starting GestioneAnagraficaDealer for ' + accountMap.size() + ' Accounts');
    	
        allineaCodiceOCS(accountMap);   
		
        // try {
            XCSRicercaAnagraficaDealer.ricercaPerOcsID(accountMap); 
            XCSRicercaAnagraficaDealer.ricercaPerPIVAoCF(accountMap);
            XCSAggiornaAnagraficaDealer.aggiorna(accountMap, isFromOCS, isFromWS);
            XCSCreazioneAnagraficaDealer.crea(accountMap, isFromWS);
        // }
        // catch(Exception ex) {
        //    System.debug(LoggingLevel.ERROR, 'ERROR: ' + ex.getMessage());
        //    System.debug(LoggingLevel.ERROR, 'CAUSE: ' + ex.getCause());
        //}
        System.debug(LoggingLevel.DEBUG, 'Finished GestioneAnagraficaDealer');
    }

    // Allinea il codice OCS in input in modo che abbia sempre il prefisso 'D'
    public static void allineaCodiceOCS(final Map<Account, DealerAccount> accountMap) {
        Map<Account, DealerAccount> tempAccountMap = new Map<Account, DealerAccount>();
        
        final String prefix = 'D';
        
        for (Account acc : accountMap.keySet()) {
            final DealerAccount targetAccount = accountMap.get(acc); // dovrebbe essere sempre null
            final String inputOcsId = acc.OCS_External_Id__c;
            final String ocsId = XCSModuloAnagraficaUtils.getCodiceOCSconPrefisso(inputOcsId, prefix);
            if (inputOcsId <> null) {
                acc.OCS_External_Id__c = ocsId;
            }
            acc.Customer_Type__c = 'Compass';
            tempAccountMap.put(acc, targetAccount);
        }

        accountMap.clear();
        for (Account acc : tempAccountMap.keySet()) accountMap.put(acc, tempAccountMap.get(acc)); 
    }
    
    // Ricerca Account per codice OCS prima su CRM e, se non trovato, su OCS
    public static Account ricercaOCS(final String codiceDealer) {
        System.debug('Starting ricercaOCS per codiceDealer ' + codiceDealer);
        final String ocsId = XCSModuloAnagraficaUtils.getCodiceOCSconPrefisso(codiceDealer, 'D');
        final Account account = new Account(OCS_External_Id__c = ocsId);

        final Map<Account, DealerAccount> accountMap = new Map<Account, DealerAccount>();
        accountMap.put(account, null);
        XCSRicercaAnagraficaDealer.ricercaPerOcsID(accountMap);

        DealerAccount outDealerAccount = accountMap.get(account);
        System.debug('Account trovato su CRM: ' + outDealerAccount);
        if (!XCSModuloAnagraficaUtils.isEmptyDealerAccount(outDealerAccount))
            return outDealerAccount.account;

        final Account outAccount = ricercaAccountSuOCS(codiceDealer);
        System.debug('Account trovato su OCS: ' + outAccount);
        
        if (outAccount == null) {
            System.debug('Impossibile trovare un Account per codice dealer ' + codiceDealer);
        }
        return outAccount;
    }

    // Ricerca Account per codice OCS prima su CRM e, se non trovato, su OCS; quindi aggiorna su CRM
    public static Account ricercaOCSUpdateCRM(final String codiceCliente) {
        final Account account = ricercaOCS(codiceCliente);
        if (account == null) return null;
        if (account.Id <> null) return account;
        final Map<Account, DealerAccount> accountMap = new Map<Account, DealerAccount>();
        accountMap.put(account, null);
        execute(accountMap, true);
        DealerAccount dealerAcc = accountMap.get(account);
        if (XCSModuloAnagraficaUtils.isEmptyDealerAccount(dealerAcc)) return null;
        return dealerAcc.account;
    }

    // recupera i dati dell'account dealer dal WS
    public static Account ricercaAccountSuOCS(final String codiceDealer){
        final OCSRecuperaDatiPostvenditaResponse responseDatiPost = OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV(codiceDealer);
        if (responseDatiPost == null || responseDatiPost.cliente == null || responseDatiPost.cliente.size() == 0) {
            return null;
        }
        final List<OCSCliente> ocsClients = OCSObjectsFactory.makeClienti(responseDatiPost);
        List<Account> accounts = AccountUtils.makeDealerAccounts(ocsClients, 'Compass');
        return accounts.get(0);
    }
}