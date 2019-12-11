/**
 * @File Name          : BatchInserisciCancellazionePratica.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 23/10/2019, 14:12:04
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    14/10/2019   sabrina vitali     Initial Version
**/

/*
    -   ESEGUITA LA SERA DALLA SCHEDULAZIONE DI SchedInserisciCancellazionePratica
    -   LANCIATA LA MATTINA DA BatchRecuperaInfoCancellazionePratica PER LE PRATICHE CHE SONO ANDATE IN ERRORE 
        NELL'INSERIMENTO IN REGISTRO LA SERA PRIMA
*/

global class BatchInserisciCancellazionePratica implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    public String query;
    private final String EMPTY_STRING = ''; 
    private String strFlagError = EMPTY_STRING;    
    private String destinatario = 'crm@compass.it';    

    //Casi da aggiornare con l'esito della scrittura
    public List<Case> caseLists = new List<Case>();
    //Feed con aggiornamento esito scrittura
    List<ConnectApi.BatchInput> listaFeed = new List<ConnectApi.BatchInput>();    //  lista feed

    
    public BatchInserisciCancellazionePratica(String query) {
        this.query = query;
    }
    
    global Database.QueryLocator start(Database.BatchableContext  BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext ct, List<Case> casiOCS){
        System.debug('*********** execute BatchInserisciCancellazionePratica - numero pratiche -  '+ casiOCS.size());
        String dataInserimento = System.today().year() + String.valueOf(System.today().month()).leftPad(2,'0') + String.valueOf(System.today().day()).leftPad(2,'0');
        Date oggi = Date.today();
        String messaggioFinaleOK = 'Richiesta inviata a Sistema OCS'; 
        String messaggioFinaleKO = 'Errore inserimento nel registro OCS : ';
        //elenco pratiche da passare al servizio
        List<OCSInserisciCancellazionePraticheInvoker.CancellazionePraticaDTO> elencoPraticheDaAgg = new List<OCSInserisciCancellazionePraticheInvoker.CancellazionePraticaDTO>();
        //Case da aggiornare in attesa di esito
        Map<String, Case> mapCasiDaEsitare = new Map<String, Case>();


        if(casiOCS.size() > 0 ){
            for(Case praticaOCS : casiOCS){
                System.debug('praticaOCS : ' + praticaOCS);
                String ufficio = '';
                String tipoPratica = '';
                switch on praticaOCS.Tipo_Pratica__c {
                    when  'CP'{tipoPratica = 'PB';}
                    when  'CAcp'{tipoPratica = 'CA';}
                    when  'BEcp'{tipoPratica = 'PB';}
                    when else {tipoPratica = praticaOCS.Tipo_Pratica__c;}
                }
                ufficio=String.isNotBlank(praticaOCS.Branch__r.Codice_Ufficio__c) && praticaOCS.Branch__r.Codice_Ufficio__c.equalsIgnoreCase('Reclami')?'R':'';
                
                //  preparo per invio lista
                OCSInserisciCancellazionePraticheInvoker.CancellazionePraticaDTO pratica = new OCSInserisciCancellazionePraticheInvoker.CancellazionePraticaDTO();
                pratica.numPratica = praticaOCS.NumeroPratica__c;
                pratica.tipoPratica = tipoPratica; 
                pratica.dataInserimento = dataInserimento;
                pratica.ufficio = ufficio;
                pratica.esito = '';
                System.debug('**9**');
                elencoPraticheDaAgg.add(pratica);
                //preparo la mappa con chiave numero pratica (si accumulano i Casi in ingresso per la gestione nel finish)
                mapCasiDaEsitare.put(praticaOCS.NumeroPratica__c, praticaOCS);
            }

            // CHIAMATA AL SERVIZIO DI SCRITTURA DELLA PRATICA IN REGISTRO
            //lancio qui perchè spezzetto le lista in execute, nel finish valuto il risultato finale
            if ((elencoPraticheDaAgg != null) && (elencoPraticheDaAgg.size()>0)) {
                OCSInserisciCancellazionePraticheInvoker.Request req = new OCSInserisciCancellazionePraticheInvoker.Request();
                req.inserisciCancellazionePraticheRequest.elenco = elencoPraticheDaAgg;
                OCSInserisciCancellazionePraticheInvoker.Response resp;
                try {
                    resp = OCSInserisciCancellazionePraticheInvoker.invoke(req.inserisciCancellazionePraticheRequest);
                } catch (Exception e) {
                    strFlagError = e.getMessage();
                } finally{
                    if(''.equalsIgnoreCase(strFlagError) && resp.resultCode == 0 && resp.inserisciCancellazionePraticheResponse.elenco.size()>0){
                        //preparo gli aggiornamenti sui Case: ciclo sugli esiti e preparo lista Case da aggiornare
                        for(OCSInserisciCancellazionePraticheInvoker.CancellazionePraticaDTO esitoFinalePratica : resp.inserisciCancellazionePraticheResponse.elenco){
                            //riprendo il Case della pratica e ne aggiorno i campi
                            if(mapCasiDaEsitare.containsKey(esitoFinalePratica.numPratica)){
                                Case caso = mapCasiDaEsitare.get(esitoFinalePratica.numPratica);
                                //aggiorno il Case in base all'esito del servizio e lo aggiungo in Lista da updatare
                                // scrittura in registro: OK - analizzato da batch di recupero esito cancellazione / KO - rielaborata al termine del batch di recupero esito cancellazione
                                caso.pv_esito_poste__c = 'OK'.equalsIgnoreCase(esitoFinalePratica.esito)?'OK':'KO';     
                                caso.pv_data_poste__c = oggi;
                                System.debug('-- Pratica : ' + caso.NumeroPratica__c + ' - esito scrittura : ' + caso.pv_esito_poste__c +  ' - Status : ' + caso.Status + ' - Step : ' + caso.Step_PV__c + ' - esito : ' + esitoFinalePratica.esito);
                                caseLists.add(caso);
                                listaFeed.add(getfeedElement(caso.Id,caso.pv_esito_poste__c.equalsIgnoreCase('OK')?messaggioFinaleOK:messaggioFinaleKO + esitoFinalePratica.esito));
                            }
                        }
                    }else{
                        strFlagError += '\n' + resp.getMessage();
                    }
                } 
            }
        }
/*
    caso.pv_data_poste__c = Date.today();
    //SREMMARE!!!
    caso.pv_esito_poste__c = resCanc.resultCode == 0 && resCanc.inserisciCancellazionePraticaResponse.esito.equalsIgnoreCase('OK')?'OK':'KO'; // solo le OK verranno analizzate dal batch
    //se la scrittura in registro va KO lascio la pratica in gestione per annullamento e verrà rielaborata al termine del batch di recupero
    //aggiorno solo feed e esito
    //caso.Status = caso.pv_esito_poste__c.equalsIgnoreCase('OK')?caso.Status:CaseUtils.DA_PROCESSARE;
    //caso.Step_PV__c = caso.pv_esito_poste__c.equalsIgnoreCase('OK')?caso.Step_PV__c:'999';
    messaggioFinale = caso.pv_esito_poste__c.equalsIgnoreCase('OK')?messaggioFinale:'Errore inserimento nel registro OCS : ' + resCanc.resultMessage;
    //se KO, il batch di recupero esiti dovrebbe reinserirla in registro
*/                        
    }
    
    global void finish(Database.BatchableContext BC){
        
        System.debug(' ************  finish BatchInserisciCancellazionePratica '+caseLists.size());
        //se strFlagError <> '' la chiamata è andata in eccezione, mando mail di avviso
        if(!EMPTY_STRING.equalsIgnoreCase(strFlagError)){
            List<Messaging.SingleEmailMessage> emailToSend = new List<Messaging.SingleEmailMessage>();
            //servizio scrittura andato in errore...
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[]{destinatario};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Compass: Inserimento in registro delle pratica da cancellare : ERRORE');
            mail.setPlainTextBody(strFlagError);
            emailToSend.add(mail);
            if ((emailToSend != null) && (emailToSend.size() > 0)) {
                EmailUtils.sendEmail(emailToSend);
            }
        }else{
            //altrimenti aggiorno i casi e i feed
            update caseLists;
            postfeedElementBatch(null,listaFeed);
        }
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