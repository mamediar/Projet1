public class XCSGestioneAnagrafica {
    
    public static void execute(final Map<Account,Account> accountMap, final Boolean isFromOCS, final Boolean isProspect) {
        run(accountMap, isFromOCS, isProspect, false);
    }

    public static void executeFromWS(final Map<Account,Account> accountMap, final Boolean isFromOCS, final Boolean isProspect) {
        run(accountMap, isFromOCS, isProspect, true);
    }
    
    private static void run(final Map<Account,Account> accountMap, final Boolean isFromOCS, final Boolean isProspect, final Boolean isFromWS) {
        if (accountMap == null || accountMap.size() == 0) {
            return;
        }
		
        System.debug(LoggingLevel.DEBUG, 'Starting GestioneAnagrafica for ' + accountMap.size() + ' Accounts');
    	
        allineaCodiceOCS(accountMap);   
		
        // try {
            if (!isProspect) {
                XCSRicercaAnagrafica.ricercaPerOcsID(accountMap); 
                XCSFusioneAnagrafica.fondi(accountMap);
                XCSRicercaAnagrafica.ricercaPerCodiceFiscale(accountMap);
                XCSRicercaAnagrafica.ricercaPerCrmId(accountMap);
                XCSRicercaAnagrafica.ricercaPerEmailNomeCognome(accountMap);
                XCSAggiornaAnagrafica.aggiorna(accountMap, isFromOCS, isFromWS);
                XCSCreazioneAnagrafica.crea(accountMap, isFromWS);
            }
            else {
                XCSRicercaAnagrafica.ricercaPerOcsID(accountMap); 
                XCSRicercaAnagrafica.ricercaPerCodiceFiscale(accountMap);
                XCSRicercaAnagrafica.ricercaPerCrmId(accountMap);
                XCSRicercaAnagrafica.ricercaPerEmailNomeCognome(accountMap);
                XCSCensimentoProspect.censisci(accountMap);
                XCSFusioneAnagrafica.fondi(accountMap);
                XCSAggiornaAnagrafica.aggiorna(accountMap, isFromOCS, isFromWS);
                XCSCreazioneAnagrafica.crea(accountMap, isFromWS);
            }
        //}
        // catch(Exception ex) {
        //    System.debug(LoggingLevel.ERROR, 'ERROR: ' + ex.getMessage());
        //    System.debug(LoggingLevel.ERROR, 'CAUSE: ' + ex.getCause());
        // }
        System.debug(LoggingLevel.DEBUG, 'Finished GestioneAnagrafica for ' + accountMap.size() + ' Accounts');
    }

    // Allinea il codice OCS in input in modo che abbia sempre il prefisso 'C'
    public static void allineaCodiceOCS(final Map<Account, Account> accountMap) {
        Map<Account, Account> tempAccountMap=new Map<Account,Account>();
        
        final String prefix = 'C';
        
        for (Account acc : accountMap.keySet()) {
            final Account targetAccount = accountMap.get(acc); // dovrebbe essere sempre null
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
    public static Account ricercaOCS(final String codiceCliente) {
        System.debug('Starting ricercaOCS per codiceCliente ' + codiceCliente);
        final String ocsId = XCSModuloAnagraficaUtils.getCodiceOCSconPrefisso(codiceCliente, 'C');
        final Account account = new Account(OCS_External_Id__c = ocsId);

        final Map<Account, Account> accountMap = new Map<Account, Account>();
        accountMap.put(account, null);
        XCSRicercaAnagrafica.ricercaPerOcsID(accountMap);

        Account outAccount = accountMap.get(account);
        System.debug('Account trovato su CRM: ' + outAccount);
        if (outAccount <> null)
            return outAccount;

        outAccount = ricercaAccountSuOCS(codiceCliente);
        System.debug('Account trovato su OCS: ' + account);
        
        if (outAccount == null) {
            System.debug('Impossibile trovare un Account per codice cliente ' + codiceCliente);
        }
        return outAccount;
    }

    // Ricerca Account per codice OCS prima su CRM e, se non trovato, su OCS; quindi aggiorna su CRM
    public static Account ricercaOCSUpdateCRM(final String codiceCliente) {
        final Account account = ricercaOCS(codiceCliente);
        if (account == null) return null;
        if (account.Id <> null) return account;
        final Map<Account, Account> accountMap = new Map<Account, Account>();
        accountMap.put(account, null);
        execute(accountMap, true, false);
        return accountMap.get(account);
    }

    // recupera i dati dell'account dal WS
    public static Account ricercaAccountSuOCS(final String codiceCliente){
        final OCSRecuperaDatiPostvenditaResponse responseDatiPost = OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV(codiceCliente);
        if (responseDatiPost == null || responseDatiPost.cliente == null || responseDatiPost.cliente.size() == 0) {
            return null;
        }
        final List<OCSCliente> ocsClients = OCSObjectsFactory.makeClienti(responseDatiPost);
        List<Account> accounts = AccountUtils.makeAccounts(ocsClients, 'Compass');
        return accounts.get(0);
    }

    //Deprecated
    public static void deduplica(final Map<Account,Account> accountMap, final Boolean isFromOCS) {
        execute(accountMap, isFromOCS, false);
    }
}