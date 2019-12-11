public class BatchSaldiRossiCarteAttive implements Database.Batchable<SaldiRossiWrapper>, Database.Stateful, Database.AllowsCallouts {
    
    private final String EMPTY_STRING = ''; 
    private final String ZERO_VALUE = '0';
    private String strFlagError = EMPTY_STRING;
    private String destinatario = 'crm@compass.it';    
    private List<SaldiRossiWrapper> dtos;
    private List<OCSSbloccaSaldiRossiOngoingRequest.SbloccoSaldoRossoOngoingDTO> elencoPraticheDaAgg = new List<OCSSbloccaSaldiRossiOngoingRequest.SbloccoSaldoRossoOngoingDTO>();
    
	public BatchSaldiRossiCarteAttive(List<SaldiRossiWrapper> dtos) {
        this.dtos = dtos;
    }
    
    public Iterable<SaldiRossiWrapper> start(Database.BatchableContext context) {
        return this.dtos;
    }

    public void execute(Database.BatchableContext context, List<SaldiRossiWrapper> srw) {
        
        
        List<Messaging.SingleEmailMessage> emailToSend = new List<Messaging.SingleEmailMessage>();
        //preparazione mappa account per verifica deduplica anagrafica
        Map<Account, Account> accountMap = new Map<Account, Account>();
        String strDetailNotes;
        
        for (SaldiRossiWrapper objSrw : srw) {
            
            List<OCSRecuperaSaldiRossiCarteAttiveResponse.SaldoRossoOngoingDTO> saldiRossiOngoingJson = objSrw.objSaldoRossoCAToPV;
            List<PV1751GirocontoIncassoInserimento.PraticaDestinazione> praticheDestinazione = new List<PV1751GirocontoIncassoInserimento.PraticaDestinazione>();
            for (OCSRecuperaSaldiRossiCarteAttiveResponse.SaldoRossoOngoingDTO saldoRossoOngoing : saldiRossiOngoingJson) {
                
                //alimentazione mappa deduplica anagrafica
                Account acc = new Account(OCS_External_Id__c = saldoRossoOngoing.codCliente,                                                
                                          FirstName = saldoRossoOngoing.nome,
                                          LastName = saldoRossoOngoing.cognome,
                                          Codice_Fiscale__pc = saldoRossoOngoing.codFiscale,
                                          PersonEmail = saldoRossoOngoing.email,
                                          PersonBirthdate = getDateValue(saldoRossoOngoing.dataNascita),
                                          Birthcity__c = saldoRossoOngoing.luogoNascita,
                                          Birthprovince__c = saldoRossoOngoing.provNascita,
                                          Sesso__pc = saldoRossoOngoing.sesso,                                                
                                          Phone = saldoRossoOngoing.telefonoCasa,
                                          PersonMobilePhone = saldoRossoOngoing.telCellulare
                                         );
                
                accountMap.put(acc, null);
                
                if (SaldiRossiUtils.ROW_TYPE_DETAIL.equalsIgnoreCase(saldoRossoOngoing.tipoRecord)) {
                    
                    if (String.isEmpty(saldoRossoOngoing.numPraticaDe)) {
                        strFlagError = 'numero pratica vuoto.';
                        break;
                    }
                    
                    strDetailNotes += 'Destinazione ' + saldoRossoOngoing.progressivoDe + ': \n';
                    strDetailNotes += '- Pratica : ' + saldoRossoOngoing.tipoPraticaDe + ' ' + saldoRossoOngoing.numPraticaDe + ' \n';                        
                    if (SaldiRossiUtils.COMPENSATION_TYPE_EXPENSE.equalsIgnoreCase(saldoRossoOngoing.tipoCompensazioneDe)) {                          
                        strDetailNotes += '- Tipo Compensazione : Spese \n';
                    } else if (SaldiRossiUtils.COMPENSATION_TYPE_UNSOLVED.equalsIgnoreCase(saldoRossoOngoing.tipoCompensazioneDe)) {
                        strDetailNotes += '- Tipo Compensazione : Insoluto (Anzianità ' + saldoRossoOngoing.anzianitaInsolutoDe + ') \n'; 
                    }
                    Double compensabile;               
                    Double totaleSpesa;
                    Double compensazioneProposta;
                    String strTotaleSpesa = saldoRossoOngoing.totaleSpesaDe;
                    String strCompensazioneProposta = saldoRossoOngoing.compensazionePropostaDe;
                    String strCompensabile = (String.isEmpty(saldoRossoOngoing.compensabileTe)) ? ZERO_VALUE : saldoRossoOngoing.compensabileTe;
                    if (String.isEmpty(strTotaleSpesa)) strTotaleSpesa = ZERO_VALUE;
                    if (String.isEmpty(strCompensazioneProposta)) strCompensazioneProposta = ZERO_VALUE;                                                                                         
                    try {                          
                        totaleSpesa = Double.valueOf(saldoRossoOngoing.totaleSpesaDe);
                        compensazioneProposta = Double.valueOf(saldoRossoOngoing.compensazionePropostaDe);
                        compensabile = Double.valueOf(strCompensabile);                  
                    } catch (Exception e) {                           
                        strFlagError = e.getMessage();
                        break;
                    }
                    Double totDaCompensare = compensabile / 100;
                    Double totSpesaPratica = totaleSpesa / 100;
                    Double importoCompensazioneProposta = compensazioneProposta / 100;
                    List<String> args = new String[]{'0','number','0.00'};
                        String strTotSpesaPratica = String.format(totSpesaPratica.format(), args);
                    String strImportoCompensazioneProposta = String.format(importoCompensazioneProposta.format(), args);
                    strDetailNotes += '- Totale spesa per la pratica : ' + strTotSpesaPratica + '\n';
                    strDetailNotes += '- Importo compensazione proposta : ' + strImportoCompensazioneProposta + '\n';
                    
                    if (totDaCompensare >= 5.00) {
                        //si tratta di un record di dettaglio che deve diventare pratica di destinazione di una richiesta di pv GIROCONTO INCASSO
                        PV1751GirocontoIncassoInserimento.PraticaDestinazione praticaDestinazione = new PV1751GirocontoIncassoInserimento.PraticaDestinazione();
                        praticaDestinazione.numPratica = saldoRossoOngoing.numPraticaDe;
                        praticaDestinazione.tipoPratica = saldoRossoOngoing.tipoPraticaDe;                    
                        praticaDestinazione.tipoCompensazione = saldoRossoOngoing.tipoCompensazioneDe;
                        if (SaldiRossiUtils.COMPENSATION_TYPE_UNSOLVED.equalsIgnoreCase(saldoRossoOngoing.tipoCompensazioneDe)) {
                            praticaDestinazione.anzianitaInsoluto = saldoRossoOngoing.anzianitaInsolutoDe; 
                        }                  
                        praticaDestinazione.totaleSpesa = totaleSpesa;                  
                        praticaDestinazione.importoCompensazione = compensazioneProposta;
                        
                        praticheDestinazione.add(praticaDestinazione);
                        
                    }
                    
                } else if (SaldiRossiUtils.ROW_TYPE_HEADER.equalsIgnoreCase(saldoRossoOngoing.tipoRecord)) {
                    
                    if (String.isEmpty(saldoRossoOngoing.numPraticaTe)) {
                        strFlagError = 'numero pratica vuoto.';
                        break;
                    }
                    
                    Double compensabile;
                    Double saldo;
                    String strCompensabile = (String.isEmpty(saldoRossoOngoing.compensabileTe)) ? ZERO_VALUE : saldoRossoOngoing.compensabileTe;
                    String strSaldo = saldoRossoOngoing.saldoTe;
                    try {
                        compensabile = Double.valueOf(strCompensabile);
                        saldo = Double.valueOf(strSaldo);
                    } catch (Exception e) {
                        strFlagError = e.getMessage();
                        break;
                    }
                    
                    Double totDaCompensare = compensabile / 100;
                    Double importoRimborso = (saldo * -1) / 100;
                    
                    if (totDaCompensare >= 5.00) {
                        
                        importoRimborso = importoRimborso - totDaCompensare;
                        
                        PV1751GirocontoIncassoInserimento.PV1751GirocontoIncassoForm datiForm = new PV1751GirocontoIncassoInserimento.PV1751GirocontoIncassoForm();
                        datiForm = (PV1751GirocontoIncassoInserimento.PV1751GirocontoIncassoForm) PV1751GirocontoIncassoInserimento.prepareFormExternal(datiForm, '1751', null);
                        //datiForm = (PV1751GirocontoIncassoInserimento.PV1751GirocontoIncassoForm) PV1751GirocontoIncassoInserimento.prepareFormExternal(datiForm, '1751', '0050Q000002FQu4QAG');
                        datiForm.cliente = new OCSCliente();
                        datiForm.cliente.email = saldoRossoOngoing.email;
                        datiForm.cliente.codCliente = saldoRossoOngoing.codCliente;
                        datiForm.cliente.cognome = saldoRossoOngoing.cognome;
                        datiForm.cliente.nome = saldoRossoOngoing.nome;
                        datiForm.cliente.denominazioneAzienda = saldoRossoOngoing.nome + ' ' + saldoRossoOngoing.cognome;
                        datiForm.cliente.dataNascita = saldoRossoOngoing.dataNascita;
                        
                        datiform.note = 'richiesta creata automaticamente';
                        
                        datiform.pratica = new OCSPratica();
                        datiform.pratica.tipoPratica = saldoRossoOngoing.tipoPraticaTe;
                        datiform.pratica.numPratica = saldoRossoOngoing.numPraticaTe;
                        
                        if (SaldiRossiUtils.PAYMENT_METHOD_RID.equalsIgnoreCase(saldoRossoOngoing.tipoPagamento)) {
                            datiform.modalitaRimborso = 'Bonifico';  
                        } else {
                            datiform.modalitaRimborso = 'Assegno';  
                        }
                        
                        datiForm.hasRimborso = true;
                        datiForm.totImporto = totDaCompensare;
                        datiForm.totRimborso = importoRimborso;
                        
                        if (!(String.isEmpty(strDetailNotes))) {
                            datiform.noteRimborso = strDetailNotes;
                            strDetailNotes = EMPTY_STRING;
                        }
                        
                        if ((praticheDestinazione != null) && (praticheDestinazione.size() > 0)) {
                            datiForm.praticheDestinazione = new List<PV1751GirocontoIncassoInserimento.PraticaDestinazione>();
                            datiForm.praticheDestinazione.addAll(praticheDestinazione);
                            praticheDestinazione.clear();
                        } 
                        
                        PV1751GirocontoIncassoInserimento.conferma(datiform);
                        
                    } else {
                        
                        PV1757RimborsoCliSaldoRossoInserimento.PV1757RimborsoCliSaldoRossoForm datiForm = new PV1757RimborsoCliSaldoRossoInserimento.PV1757RimborsoCliSaldoRossoForm();
                        datiForm = (PV1757RimborsoCliSaldoRossoInserimento.PV1757RimborsoCliSaldoRossoForm) PV1757RimborsoCliSaldoRossoInserimento.prepareFormExternal(datiForm, '1757', null);
                        //datiForm = (PV1757RimborsoCliSaldoRossoInserimento.PV1757RimborsoCliSaldoRossoForm) PV1757RimborsoCliSaldoRossoInserimento.prepareFormExternal(datiForm, '1757', '0050Q000002FQu4QAG');
                        datiForm.cliente = new OCSCliente();
                        datiForm.cliente.email = saldoRossoOngoing.email;
                        datiForm.cliente.codCliente = saldoRossoOngoing.codCliente;
                        datiForm.cliente.cognome = saldoRossoOngoing.cognome;
                        datiForm.cliente.nome = saldoRossoOngoing.nome;
                        datiForm.cliente.denominazioneAzienda = saldoRossoOngoing.nome + ' ' + saldoRossoOngoing.cognome;
                        datiForm.cliente.dataNascita = saldoRossoOngoing.dataNascita;
                        
                        datiform.note = 'richiesta creata automaticamente';
                        
                        datiform.pratica = new OCSPratica();
                        datiform.pratica.tipoPratica = saldoRossoOngoing.tipoPraticaTe;
                        datiform.pratica.numPratica = saldoRossoOngoing.numPraticaTe;
                        
                        if (SaldiRossiUtils.PAYMENT_METHOD_RID.equalsIgnoreCase(saldoRossoOngoing.tipoPagamento)) {
                            datiform.modalitaRimborso = 'Bonifico';  
                        } else {
                            datiform.modalitaRimborso = 'Assegno';  
                        }
                        
                        datiform.importo = importoRimborso;
                        
                        if (!(String.isEmpty(strDetailNotes))) {
                            datiform.noteRimborso = strDetailNotes;
                            strDetailNotes = EMPTY_STRING;
                        }
                        
                        PV1757RimborsoCliSaldoRossoInserimento.conferma(datiform);
                        
                    }
                    //alimentazione lista di pratiche da aggiornare in OCS...   
                    OCSSbloccaSaldiRossiOngoingRequest.SbloccoSaldoRossoOngoingDTO pratica = new OCSSbloccaSaldiRossiOngoingRequest.SbloccoSaldoRossoOngoingDTO();
                    pratica.numPratica = saldoRossoOngoing.numPraticaTe;
                    pratica.periodo = saldoRossoOngoing.periodo;
                    elencoPraticheDaAgg.add(pratica);
                }                               
            }
            
            //usciti dal ciclo for, potrebbe esserci il strFlagError valorizzato da eccezioni di elaborazioni...
            if (!EMPTY_STRING.equals(strFlagError)) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[]{destinatario};
                    mail.setToAddresses(toAddresses);
                mail.setSubject('Compass: Recupero Saldi Rossi carte attive ERRORE');
                mail.setPlainTextBody('Errore lettura saldi:' + strFlagError);
                emailToSend.add(mail);
            } else {
                //richiamo deduplica anagrafica                   
                if ((accountMap != null) && (accountMap.size()>0)) {
                    XCSGestioneAnagrafica.deduplica(accountMap, true);
                    Map<String, Account> accountVerifiedMap = new Map<String, Account>();
                    for (Account acc : AccountMap.values()) {                       
                        accountVerifiedMap.put(decodeOcsExternalId(acc.OCS_external_id__c), acc);
                    }
                    
                }
                
            }
            
        }
                  
        if ((emailToSend != null) && (emailToSend.size() > 0)) {
            EmailUtils.sendEmail(emailToSend);
            elencoPraticheDaAgg = null;
        }
        
    }
    
    public void finish(Database.BatchableContext context) {
        
        List<Messaging.SingleEmailMessage> emailToSend = new List<Messaging.SingleEmailMessage>();
        //richiamo servizio SOAP per sblocco pratiche in OCS...
        if ((elencoPraticheDaAgg != null) && (elencoPraticheDaAgg.size()>0)) {
            OCSSbloccaSaldiRossiOngoingResponse resp;
            try {
                resp = OCSSbloccaSaldiRossiOngoingInvoker.sbloccaSaldiRossiOngoing('sbloccaSaldiRossiCarteAttive', elencoPraticheDaAgg);                        
            } catch (Exception e) {
                strFlagError = e.getMessage();
            } 
            
            if (!(String.isEmpty(strFlagError))) {
                //servizio sblocca andato in errore...
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[]{destinatario};
                    mail.setToAddresses(toAddresses);
                mail.setSubject('Compass: Sblocco Saldi Rossi carte attive ERRORE');
                mail.setPlainTextBody('Errore sblocco :' + strFlagError);
                emailToSend.add(mail);
            } else {
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[]{destinatario};
                    mail.setToAddresses(toAddresses);
                mail.setSubject('Compass: Sblocco Saldi Rossi carte attive TERMINATO');                       
                emailToSend.add(mail); 
                
            }
            
            if ((emailToSend != null) && (emailToSend.size() > 0)) {
                EmailUtils.sendEmail(emailToSend);
            }

            
        }
        
    }
    
    private static Date getDateValue(String strDate) {
        
        if (!(String.isEmpty(strDate))) {
            
            if (strDate.length() == 8) {
                return Date.newInstance(Integer.valueOf(strDate.substring(0,4)), Integer.valueOf(strDate.substring(4,6)), Integer.valueOf(strDate.substring(6,8)));   
            } else {
                throw new UnexpectedException('Errore formato data non riconosciuto.');
            }
            
        } else {
            
            return null;
            
        }
        
    }
    
    private static String decodeOcsExternalId(String OcsExternalID) {
        
        String ret = null;
        final String CHAR_C = 'C';
        
        if (CHAR_C.equalsIgnoreCase(OcsExternalID.substring(0,1))) {
            ret = OcsExternalID.substring(1);
        }
        
        return ret;
    }

}