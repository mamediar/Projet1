global class SFADematerializzazioneRecuperaEsiti implements Database.AllowsCallouts, Database.Stateful, Schedulable{

    private Case cercaDematerializzazionePerDealer(List<Case> listaAttivitaDem, String codIntemrediario){
        if (listaAttivitaDem!=null) {
            for (Case dematerial:listaAttivitaDem) {
                String ocsExternal = (dematerial.Account.OCS_External_Id__c != null && dematerial.Account.OCS_External_Id__c.length()>0)?dematerial.Account.OCS_External_Id__c.substring(1):'';
                // check per codice intermediario
                if (ocsExternal.equals(codIntemrediario)) {
                    System.debug('cercaDematerializzazionePerDealer trovata dematerializzazione:'+dematerial.Id);
                    return dematerial;
                }
            }
        }
        return null;
    }

    global void execute(SchedulableContext sc) {
        // precarica tutte le attivita' di dematerializzazione
        List<Case> listaAttivitaDem = [SELECT ID, Account.OCS_External_Id__c, Account.Tipo_Intermediario__c, Description, Esito__c FROM Case  WHERE Status = 'New' AND Categoria_Riferimento__c =:SFADematerializzazioneHelper.categoriaDematerializzazione.id]; 
        // 1.	Richiama il servizio B2BSOAP “recuperaEsitiRichiestaDematerializzazioneDealer”. Il servizio restituira' un elenco di richieste evase con i seguenti elementi:
        RecuperaEsitiRichiestaDemDealerInvoker.Request req = new RecuperaEsitiRichiestaDemDealerInvoker.Request(); 
        RecuperaEsitiRichiestaDemDealerInvoker.Response res = RecuperaEsitiRichiestaDemDealerInvoker.invoke(req);
        System.debug('RecuperaEsitiRichiestaDemDealerInvoker isOK:'+res.isOK());
        System.debug('RecuperaEsitiRichiestaDemDealerInvoker getMessage():'+res.getMessage());
        List<RecuperaEsitiRichiestaDemDealerInvoker.EsitoRichiestaDemDealerDTO> listEsiti = new List<RecuperaEsitiRichiestaDemDealerInvoker.EsitoRichiestaDemDealerDTO>();
        if (res.recuperaEsitiRichiestaDematerializzazioneDealerResponse!=null && res.recuperaEsitiRichiestaDematerializzazioneDealerResponse.elenco!=null) {
            for (RecuperaEsitiRichiestaDemDealerInvoker.EsitoRichiestaDemDealerDTO dto:res.recuperaEsitiRichiestaDematerializzazioneDealerResponse.elenco) {
                // 2.	Per ogni dealer cerca l’attività di tipo “demdeal” aperta (o se non la trova l’ultima chiusa) 
                Case attivitaDem = cercaDematerializzazionePerDealer(listaAttivitaDem,dto.codIntermediario);
                if  (attivitaDem!=null) {
                  //  3.	Se trova l’attività registra l’esito della dematerializzazione in un item dell’activity con:
                  // a.	Item_key
                  //     i.	  Se FlagDematerializzazione() = S -> RESULT_DEMAT_OK
                  //    ii.	  Se FlagDematerializzazione() = N -> RESULT_DEMAT_KO
                  // b. Item_desc: EsitoDematerializzazione()
                    attivitaDem.Esito__c = dto.flagDematerializzazione;
                    attivitaDem.Description = dto.esitoDematerializzazione;
                    attivitaDem.Data_Ricezione__c = Date.today();  // setto la data di ricezione dell'esito per il batch di chiusura
                   //   4.	Se l’item è creato correttamente richiama il B2BSOAP "richiestaDematerializzazioneDealerFlagLettura" per indicare a OCS che l’esito della dematerializzazione per quel dealer con quella data di inserimento è stata elaborata.
                    RichiestaDemDealerFlagLetturaInvoker.Request reqFlag = new RichiestaDemDealerFlagLetturaInvoker.Request(dto.tipoIntermediario,dto.codIntermediario,dto.dataInserimento);
                    RichiestaDemDealerFlagLetturaInvoker.Response resFlag = RichiestaDemDealerFlagLetturaInvoker.invoke(reqFlag);
                    System.debug('RichiestaDemDealerFlagLetturaInvoker isOK:'+resFlag.isOK());
                    // devo salvarmi l'esito da qualche parte???
                    // probabilmente non serve, perchè se l'esito è OK al giro successivo non ritrovaro' piu' l'esito dalla prima chiamata al servizio 'recuperaEsitiRichiestaDemDealer'
                    // update ultimo step perchè deve essere dopo i servizi
                    update attivitaDem;
                }
            }
        }
    }
}