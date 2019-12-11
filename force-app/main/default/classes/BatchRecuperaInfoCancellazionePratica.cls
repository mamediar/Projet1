/**
 * @File Name          : BatchRecuperaInfoCancellazionePratica.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 22/10/2019, 12:03:51
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    30/9/2019   sabrina vitali     Initial Version
**/
public class BatchRecuperaInfoCancellazionePratica implements Database.Batchable<Case>, Database.Stateful, Database.AllowsCallouts {
    
    private final String EMPTY_STRING = ''; 
    public static final String CATEGORY_1766 = '1766';
    private final String ZERO_VALUE = '0';
    private String strFlagError = EMPTY_STRING;    
    private String destinatario = 'crm@compass.it';    
    private List<Case> casiOCS;
    List<Case> elencoPraticheDaAgg = new List<Case>();                                  //  lista di Casi per aggiornamento pratiche
    List<ConnectApi.BatchInput> listaFeed = new List<ConnectApi.BatchInput>();          //  lista feed
    List<XCS_Messaggio__c> elencoNoteOCS = new List<XCS_Messaggio__c>();                //  lista note OCS
    //Map<String, Case> caseDBMapKO = new Map<String, Case>();                            //  pratiche da reinserire in registro per precedente KO
    Boolean insericiRegistro = false;                                                   //  rilancia batch di inserimento in registro 

    
    public BatchRecuperaInfoCancellazionePratica(List<Case> casiOCS) {
        this.casiOCS = casiOCS;
    }
    
    public Iterable<Case> start(Database.BatchableContext context) {
        return this.casiOCS;
    }
    
    public void execute(Database.BatchableContext context, List<Case> casiOCS) {
        
        List<Messaging.SingleEmailMessage> emailToSend = new List<Messaging.SingleEmailMessage>();
        //recupero id template
        String recordTypeIdTemplate = [select Id from RecordType where SobjectType = 'XCS_Messaggio__c' AND IsActive = true AND Name =: 'Note'].Id;

        //recupero le richieste pendenti
        List<Case> cancellazioniPendenti = ([SELECT Id,CreatedDate, NumeroPratica__c, Tipo_Pratica__c, Disposition__r.Name, pv_esito_poste__c, pv_data_poste__c, Note__c 
                                        from Case 
                                        where RecordType.Name = 'XCS_Post_Vendita' 
                                            and Categoria_Riferimento__r.External_Id__c =: CATEGORY_1766
                                                and Step_PV__c = '998' /*and pv_esito_poste__c = 'OK'*/]);
                                                //mi servono anche i KO per il rilasncio di Async (o fare batch da lanciare al termine)
                                                //and pv_esito_poste__c = 'OK']);

       System.debug('######### cancellazioniPendenti : ' + cancellazioniPendenti);

        //mi segno tutte le pratiche in attesa di esito
        Map<String, Case> caseDBMapOK = new Map<String, Case>();
        String chiave;
        String tipoPraticaConfronto;

        if(cancellazioniPendenti.size()>0){
            for(Case praticaPending : cancellazioniPendenti){
                //prendo solo le pratiche OK. Le KO andranno reinserite in registro
                if('OK'.equalsIgnoreCase(praticaPending.pv_esito_poste__c)){
                    //converto il tipo pratica da confrontare con il risultato OCS
                    switch on praticaPending.Tipo_Pratica__c {
                        when  'CP'{tipoPraticaConfronto = 'PB';} 
                        when  'BEcp'{tipoPraticaConfronto = 'PB';} 
                        when  'CAcp'{tipoPraticaConfronto = 'CA';}
                        when else {tipoPraticaConfronto = praticaPending.Tipo_Pratica__c;}
                    }
                    //costruisco la chiave di ricerca
                    chiave = praticaPending.NumeroPratica__c + '|' + DateUtils.formatDateYYYYMMDD(praticaPending.pv_data_poste__c) + '|' + tipoPraticaConfronto;
                    caseDBMapOK.put(chiave, praticaPending);
                }else{
                    //qui le pratiche con erorre di inserimento in registro o non ancora inserite
                    //caseDBMapKO.put(chiave, praticaPending);
                    insericiRegistro = true;
                }
            }
        }
        System.debug('######### caseDBMapOK : ' + caseDBMapOK);

        if(casiOCS.size()>0){
            // spostata creazione mappa al di fuori : servirà anche dopo per le pratiche non trovate fra gli esiti 

            //ciclo sulle pratiche esitate da OCS e le ricerco fra le pratiche pendenti
            Case praticaPending = new Case();                           //  pratica in attesa di esito per essere portata avanti
            String key = '';

            //String tipoPraticaConfronto;
            for(Case praticaOCS : casiOCS){
                System.debug('data inserimento da OCS : ' + DateUtils.formatDateYYYYMMDD(praticaOCS.pv_data_poste__c));
                key = praticaOCS.NumeroPratica__c + '|' +  DateUtils.formatDateYYYYMMDD(praticaOCS.pv_data_poste__c) + '|' + praticaOCS.Tipo_Pratica__c;
                System.debug('chiave da ricercare : ' + key);
                if(caseDBMapOK.containsKey(key)){
                    //TROVATA, recupero la pratica dalla chiave
                    praticaPending = caseDBMapOK.get(praticaOCS.NumeroPratica__c + '|' +  DateUtils.formatDateYYYYMMDD(praticaOCS.pv_data_poste__c) + '|' + praticaOCS.Tipo_Pratica__c);
                    System.debug('######### trovata : ' + praticaPending); 
                    //preparo i dati per aggiornare il case ed essere riassegnati dal motore di regole
                    praticaPending.Step_PV__c = '3';
                    praticaPending.Status = CaseUtils.DA_PROCESSARE;
                    //praticaPending.Note__c = praticaOCS.Note__c;
                    praticaPending.pv_other_loan_number__c = praticaOCS.pv_other_loan_number__c;
                    praticaPending.pv_data_sbf__c = praticaOCS.pv_data_sbf__c;          //  data aggiornamento OCS
                    praticaPending.pv_esito_sbf__c = praticaOCS.pv_esito_sbf__c;        //  esito aggiornamento OCS             :   S/N
                    // pv_send_to__c : se pratica cancellata : Reclami per eventuale cancellazione SIC manuale               
                    // pv_send_to__c : se pratica non cancellata : Ufficio inserimento per eventuale riassegnazione
                    praticaPending.pv_send_to__c = praticaOCS.pv_send_to__c;            // riassegnazione
                    //praticaPending.pv_uffpost_boll__c = praticaOCS.pv_uffpost_boll__c;  //  reinoltro ad ufficio di inserimento :   S/N     (solo se esito N)

                    //SE CANCELLATA ed esito verde c'è qualcosa da fare per antiriciclaggio  !!! //if(praticaOCS.pv_ctr_no_sign__c.equalsIgnoreCase('S'))

                    //aggiungo Case da aggiornare dopo il giro batch
                    elencoPraticheDaAgg.add(praticaPending);
                    //preparo la lista feed
                    listaFeed.add(getfeedElement(praticaPending.Id,praticaOCS.Note__c));

                    //preparo la lista note per OCS:
                    if(!praticaOCS.pv_esito_sbf__c.equalsIgnoreCase('S')){
                        //pratica non cancellata : nota OCS solo per la pratica
                        elencoNoteOCS.add(getNotaOcs(praticaOCS.NumeroPratica__c,'',praticaOCS.Note__c,recordTypeIdTemplate));
                    }else{
                        if(String.isNotBlank(praticaOCS.pv_ctr_no_titolare__c)){
                            //pratica cancellata con anagrafiche non cancellate : nota OCS solo per anagrafiche non cancellate
                            String[] anagraficheKO=praticaOCS.pv_ctr_no_titolare__c.split('\\|');
                            for(String anagraficaKO:anagraficheKO){
                                elencoNoteOCS.add(getNotaOcs('',anagraficaKO,praticaOCS.Note__c,recordTypeIdTemplate));
                            }
                        }
                    }
                    //rimuovo dalla mappa
                    caseDBMapOK.remove(key);
                }
                else{
                    //NON TROVATA IN SF
                    strFlagError += 'Pratica ' + praticaOCS.NumeroPratica__c + ' non trovata in SF. ';
                    //rimuovo dalla mappa
                    caseDBMapOK.remove(key);
                }
            }
        } // casiOCS.size()>0

        //se fossero rimasti elementi nella mappa, significa che la pratica non è stata esitata da OCS, segnalo
        if(!caseDBMapOK.isEmpty()){
            strFlagError += '\n\nPratiche non trovate in OCS : ' + caseDBMapOK.values();    
        }
    }
    
    public void finish(Database.BatchableContext context) {

        /************************************************************************/
        /********** aggiorno le pratiche ed inserisco le note per OCS ***********/
        /************************************************************************/

        if ((elencoPraticheDaAgg != null) && (elencoPraticheDaAgg.size()>0)) {
            //aggiorno Case, note OCS e chatter  
            insert elencoNoteOCS;
            update elencoPraticheDaAgg;
            postfeedElementBatch(null,listaFeed);

        /************************************************************************/
        /***************** impostazione flag di lettura per elenco **************/
        /************************************************************************/
            
            //for(Integer i=0;i<elencoPraticheDaAgg.size();i++){
            BatchFlagLetturaCancellazionePratica b=new BatchFlagLetturaCancellazionePratica(elencoPraticheDaAgg); // Invalid type: BatchCallOut
            Id batchId = Database.executeBatch(b, 500);        
				//Id jobId = System.enqueueJob(setFlagLettura);
           //}                
        }

        /************************************************************************/
        /*************** invio email per termine elaborazione *******************/
        /************************************************************************/

        List<Messaging.SingleEmailMessage> emailToSend = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[]{destinatario};
        mail.setToAddresses(toAddresses);

        if (!EMPTY_STRING.equals(strFlagError)) {
            mail.setSubject('PV Cancellazione Pratiche ERRORE');
            mail.setPlainTextBody('Errori:\n' + strFlagError);
            emailToSend.add(mail);
        } else {
            mail.setSubject('PV Cancellazione Pratiche TERMINATO');
            emailToSend.add(mail);
        }
        if ((emailToSend != null) && (emailToSend.size() > 0)) {
            EmailUtils.sendEmail(emailToSend);
            elencoPraticheDaAgg = null;
        }
        //se nessun errore ed ho pratiche che sono in KO per la scrittura in registro, rilancio la scrittura
        if (/*EMPTY_STRING.equals(strFlagError) &&*/ insericiRegistro) {
            //RILANCIARE BATCH DI SCRITTURA IN REGISTRO!
            String query = 'SELECT Id, Tipo_Pratica__c, NumeroPratica__c, Branch__r.Codice_Ufficio__c, Status, Step_PV__c ';
            query += 'FROM Case WHERE RecordType.Name = \'XCS_Post_Vendita\' and  Step_PV__c = \'998\' and Categoria_Riferimento__r.External_Id__c = \'1766\'';
            query += ' and pv_esito_poste__c <> \'OK\''; 
            Id idjob = Database.executeBatch(new BatchInserisciCancellazionePratica(query),80);
        }
    }

    private static XCS_Messaggio__c getNotaOcs(String numPrat, String codCli, String nota, String recordTypeIdTemplate) {
        //aggiungere Header e Footer
        XCS_Messaggio__c xcs_messaggio = new XCS_Messaggio__c();
        xcs_messaggio.RecordTypeId = recordTypeIdTemplate;
        xcs_messaggio.CompanyType__c = 'COMPASS';
        xcs_messaggio.Modalita__c = 'A';
        xcs_messaggio.TipoNote__c = 'P';
        xcs_messaggio.Testo__c = nota;
        xcs_messaggio.NumPratica__c = numPrat;
        xcs_messaggio.CodCliente__c = codCli;
        return xcs_messaggio;
    }

    public static ConnectApi.BatchInput getfeedElement(String recordId, String note){
        ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
        input.subjectId = recordId;
        ConnectApi.MessageBodyInput body = new ConnectApi.MessageBodyInput();
        body.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = note;
        body.messageSegments.add(textSegment);
        input.body = body;
        ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(input);
        return batchInput;
	}

    public static void postfeedElementBatch(String communityId, List<ConnectApi.BatchInput> feedElements){
        ConnectApi.ChatterFeeds.postFeedElementBatch(communityId, feedElements);
	}    
}