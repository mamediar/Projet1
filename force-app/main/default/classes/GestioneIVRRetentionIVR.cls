@RestResource(urlMapping='/ivr_retention/*')
global with sharing class GestioneIVRRetentionIVR {
    
    private final static String CASE_RETENTION_SUBJECT = 'E/A x Retention';
    private final static String CASE_RETENTION_NOTE = 'IVR - Acquisizione Inbound / Info Commerciali CCL / Retention / Retention Inserita - Esito verifica ';
    
    private final static String NOTA_ALL = 'Upselling o rinegoziazione';
    private final static String NOTA_ESP = 'Troppo esposto, poco margine';
    private final static String NOTA_GIO = 'Prestito recente, consigliare';
    private final static String NOTA_RIN = 'Rinegoziazione';
    private final static String NOTA_UPS = 'Upselling';
    private final static String NOTA_CON = 'Consigliare a parole';
    
    private final static String PRATICA_CA = 'CA';
    private final static String ESITO_BAD = 'BAD';
    private final static String CODICE_IVR = 'I';
    private final static String IVR = 'IVR';
    private final static String PRATICA_PARTNER_SI = 'SI';
    
    //private final static String CAT_BKOFFICE_INBOUND = 'Back Office Inbound';  //External_Id = 1036
    //private final static String DIS_RETENTION_INSERITA = 'Retention Inserita'; //External_Id = 2231
    public final static String CAT_BKOFFICE_INBOUND = '1036';  
    public final static String DIS_RETENTION_INSERITA = 'DP2231'; 
    
    private final static String NUOVO = 'New';
    private final static String MEDIUM = 'Medium';
    //private final static String GROUP_RETENTION_EA = 'Retention su E/A'; //Q18
    private final static String GROUP_RETENTION_EA = 'Q18'; //Q18
    global final static String NESSUN_PRODOTTO = '1414';
    
    private final static String NOT_FOUND = 'NotFound';
    
    
    global class RetentionRequest {
        
        global String codicePratica;
        global String codiceTipoPratica;
        global Integer fasciaDiRicontatto;
        
        public RetentionRequest(String codicePratica,String codiceTipoPratica,Integer fasciaDiRicontatto){
            this.codicePratica = codicePratica;
            this.codiceTipoPratica = codiceTipoPratica;
            this.fasciaDiRicontatto = fasciaDiRicontatto;
        }               
    }
    
    @HttpPost
    global static Integer retention(String codicePratica,String codiceTipoPratica,Integer fasciaDiRicontatto) {
        
        RetentionRequest request = new RetentionRequest(codicePratica,codiceTipoPratica,fasciaDiRicontatto);
        System.debug('@@@ retention start');
        
        //1.Se i parametri Codice Pratica e Codice tipo pratica non sono valorizzati, restituisce a IVR il codice errore “1” 
        if (!isValidRequest(request)) {
            system.debug('@@@ isValidRequest: FALSE');
            return 1;
        }
        
        //2.Verifica sulla tabella equilon.retention_requested (CRM_Retention__c) se esiste una richiesta per quel 
        //Codice Pratica e con user_name <> NULL e disposition = NULL
        Id caseId = findRequestForCodicePratica(codicePratica);
        if(caseId!=null){
            //13.Se è presente Verifica il parametro Fascia Ricontatto
            if(checkFasciaRicontatto(codicePratica,fasciaDiRicontatto, caseId)){
                system.debug('@@@ checkFasciaRicontatto TRUE');
                return 0;
            }else{
                system.debug('@@@ checkFasciaRicontatto FALSE');
                return 1;
            }
            
        }else{
            system.debug('@@@ findRequestForCodicePratica: FALSE');
            //3.Se non è presente Richiama il WS "recuperaDatiRetention", il servizio prende in input codiceCliente, numeroPratica e tipo Pratica
            //nel nostro caso il codiceCliente è null, sarà prelevato dalla response.
            //try{
            
            OCSRecuperaDatiRetentionResponse responseDatiRetention = OCSRecuperaDatiRetentionInvoker.invoke('',codiceTipoPratica,codicePratica);
            
            if(responseDatiRetention.recuperaDatiRetentionResponse.elencoPratiche.size() < 1){
                system.debug('@@@ responseDatiRetention: FALSE');
                return 1;
                
            }else{
                //4.Il servizio restituisce un elenco, anche se in questo caso ci sarà una sola riga restituita. 
                //Per questa riga si valorizzerà il campo source, che indica nella tabella equilon.retention_requested (CRM_Retention__c) 
                //l’origine della richiesta, al valore “I” (indica IVR).
                
                String codiceCliente = responseDatiRetention.recuperaDatiRetentionResponse.elencoPratiche.get(0).codCliente;
                system.debug('@@@ responseDatiRetention: TRUE - codiceCliente: '+codiceCliente);
                //   --- addRecordOnCRMRetention --- 
                
                //5.Inoltre nel caso in cui il Codice tipo pratica è “CA” effettua anche la chiamata al WS “recuperaSaldoCliente” 
                //per recuperare il saldo di quella specifica pratica.
                if (PRATICA_CA.equalsIgnoreCase(codiceTipoPratica)) {          
                    OCSRecuperaSaldoClienteResponse responseSaldoCliente = OCSRecuperaSaldoClienteInvoker.callGetSaldoCliente(codiceCliente);
                    if(responseSaldoCliente.recuperaSaldoClienteResponse != null){
                        Integer saldoCliente = Integer.valueOf(responseSaldoCliente.recuperaSaldoClienteResponse.elencoPratiche.get(0).saldo);
                    }
                    
                }
                system.debug('@@@ codiceTipoPratica: IS NOT CA but '+codiceTipoPratica);
                
                //6.Verifica quindi che non esista nella tabella equilon.retention_requested (CRM_Retention__c) una richiesta per il 
                //cliente (codice OCS restituito dal servizio “recuperaDatiRetention”) su quella tipologia di pratica 
                //che sia stata creata meno di due giorni prima della data corrente e per cui user_name <> NULL.
                if(findRequestForCodiceCliente(codiceCliente,codiceTipoPratica)){
                    system.debug('@@@ findRequestForCodiceCliente: FALSE -> Noo record on CRM_Retention__c with codiceCliente: ' +codiceCliente+ ' and codicePratica: '+codicePratica);
                    return 1;
                    
                }else{
                    //TODO: qui o nell'else del punto 8 (in cui avrò anche l'account)
                    //se non esiste una retention su CRM_Retention__c la creo come descritta nel punto 4
                    //---- addRecordOnCRMRetention(responseDatiRetention);
                    
                    
                    //7.Recupera le informazioni di retention dalla tabella equilon.retention (Account_Retention__c)
                    Account_Retention__c accRet = retrieveInfoAccountRetention(codiceCliente);
                    
                    String esito = null;
                    String valore = null;
                    /*
                    if(accRet==null){
                        system.debug('@@@ retrieveInfoAccountRetention: NULL -> No record on Account_Retention__c with codiceCliente: '+codiceCliente);
                        return 1;
                    }else{
                    
                        esito = accRet.Esito__c;
                        valore = accRet.Valore__c;
                    
                    }*/
                    
                    if(accRet!=null){
                        
                        if(ESITO_BAD.equalsIgnoreCase(accRet.Esito__c)){
                            return 1;
                            
                        }else if(accRet.Partner__c){
                            //i.Recupera i valori delle pratiche presenti nella tabella e verifica il flag associato alla pratica in esame (Codice Pratica)
                            //ii.Se il flag  = SI -> codice errore a IVR = “1” (significa che la pratica è una pratica associata al partner e quindi non si può effettuare retention)
                            if(findPratichePartner(accRet)){
                                return 1;
                            }
                            
                        }else{
                            
                            esito = accRet.Esito__c;
                            valore = accRet.Valore__c;
                            
                        }
                    }
                    
                    Account newAccount = null;
                    Case c = new Case();

                    //8.Ricerca sul CRM il cliente per codice OCS
                    newAccount = findAccountFromCodiceCliente(codiceCliente);
                    if(newAccount!=null){
                        //a.Se lo trova prosegue al punto 9.Crea case “E/A x Retention” 
                        c = createCase(esito,valore,codicePratica,fasciaDiRicontatto,responseDatiRetention,newAccount);
                    }else{
                        //b.Altrimenti richiama il servizio “recuperaDatiPostvendita” per recuperare i dati del cliente e lo censisce
                        
                        //OCSRecuperaDatiPostvenditaResponse recuperaDatiPostvendita = OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV(codiceCliente);
                        //recuperaDatiPostvendita.cliente.get(0).getMap().get('');
                        
                        //Account newAccount = null;
                        try {
                            // verifica se esiste account: se non esiste lo crea sul CRM
                            if(!System.Test.isRunningTest()){
                                //newAccount = IVRUtil.checkCreateAccount(codiceCliente);
                                newaccount = XCSGestioneAnagrafica.ricercaOCSUpdateCRM(codiceCliente);
                                c = createCase(esito,valore,codicePratica,fasciaDiRicontatto,responseDatiRetention,newAccount);
                            }
                            
                        }catch (IVRUtil.BatchException be) {
                            // errore creazione account
                            system.debug('@@@ errore creazione account');
                            return 1;
                        }
                    }

                    //TODO: qui si ha anche l'account a cui associare il record rispetto all'else del punto 6
                    //se non esiste una retention su CRM_Retention__c la creo come descritta nel punto 4
                    //10.Inserisce nella tabella equilon.retention_requested (CRM_Retention__c) la retention appena creata 
                    addRecordOnCRMRetention(responseDatiRetention, newAccount, c); 
                    
                    //11.Inserisce la nota anche su OCS
                    //String codicePratica, String codiceTipoPratica, String codiceOcs, String nota
                    IVRUtil.sendNoteOCS(codicePratica,codiceTipoPratica,codiceCliente,getNote(esito,valore,codicePratica));
                    
                    //}
                    
                    
                    
                }
                
                //} END 5
                //system.debug('@@@ codiceTipoPratica: IS NOT CA but '+codiceTipoPratica);
                
                
                
            }//END 4
            
            
            //}catch(Exception ex){
            //return 1;
            //}
        }
        
        return 0;
        
    }
    
    //1.Se i parametri Codice Pratica e Codice tipo pratica non sono valorizzati, restituisce a IVR il codice errore “1”
    private static Boolean isValidRequest(RetentionRequest request) {
        if (request==null) {
            return false;
        }
        if (request.codicePratica==null || String.isBlank(request.codicePratica)) {
            return false;
        }
        if (request.codiceTipoPratica==null || String.isBlank(request.codiceTipoPratica)) {
            return false;

        }else if(String.isNotBlank(request.codiceTipoPratica)){
            String fasciaToWrite = IVRUtil.getFasciaDiRicontatto(request.fasciaDiRicontatto);
            if(fasciaToWrite.equals(IVRUtil.FASCIA_DEFAULT)){
                return false;
            }
        }

        return true;
    }
    
    //2.Verifica sulla tabella equilon.retention_requested se esiste una richiesta per quel 
    //Codice Pratica e con user_name <> NULL e disposition = NULL
    /*private static Boolean findRequestForCodicePratica(String codicePratica){
        Integer retentions = [
            SELECT count() 
            FROM CRM_Retention__c 
            WHERE Case__r.NumeroPratica__c =: codicePratica 
            AND Utente__c != null 
            AND Disposition__c = null
        ];
        
        if(retentions>0){
            return true;
        }
        return false;
        
    }*/
    private static Id findRequestForCodicePratica(String codicePratica){
        List<CRM_Retention__c> retentions = [
            SELECT Case__c 
            FROM CRM_Retention__c 
            WHERE Case__r.NumeroPratica__c =: codicePratica 
            AND Utente__c != null 
            AND Disposition__c = null
        ];
        
        if(retentions.size()>0){
            return retentions.get(0).Case__c;
        }
        return null;
        
    }
    
    //6.Verifica quindi che non esista nella tabella equilon.retention_requested (CRM_Retention__c) una richiesta per il 
    //cliente (codice OCS restituito dal servizio “recuperaDatiRetention”) su quella tipologia di pratica 
    //che sia stata creata meno di due giorni prima della data corrente e per cui user_name <> NULL.
    private static Boolean findRequestForCodiceCliente(String codiceCliente, String codiceTipoPratica){//codiceTipoPratica
        Integer retentions = [
            SELECT count() 
            FROM CRM_Retention__c 
            WHERE Customer__r.OCS_External_Id__c =: codiceCliente 
            AND Case__r.Tipo_Pratica__c =: codiceTipoPratica 
            AND Utente__c != null 
            AND CreatedDate >= LAST_N_DAYS:2
        ];
        
        if(retentions > 0){
            return true;
        }
        return false;
        
    }
    
    /*private static void addRecordOnCRMRetention(OCSRecuperaDatiRetentionResponse responseDatiRetention){

        CRM_Retention__c crmRet = new CRM_Retention__c();
        //crmRet.Case__r.TipoPratica__c = responseDatiRetention.recuperaDatiRetentionResponse.elencoPratiche.get(0).tipoPratica;
        //crmRet.Case__r.NumeroPratica__c = responseDatiRetention.recuperaDatiRetentionResponse.elencoPratiche.get(0).numPratica;
        //crmRet.Case__r.Stato_Pratica__c = responseDatiRetention.recuperaDatiRetentionResponse.elencoPratiche.get(0).statoPratica;
        //crmRet.Case__r.Attributi_Pratica__c = responseDatiRetention.recuperaDatiRetentionResponse.elencoPratiche.get(0).attributoPratica;
        crmRet.FirstDueDate__c = IVRUtil.parseStringToDate(responseDatiRetention.recuperaDatiRetentionResponse.elencoPratiche.get(0).dataPrimaScadenza);
        crmRet.LastDueDate__c = IVRUtil.parseStringToDate(responseDatiRetention.recuperaDatiRetentionResponse.elencoPratiche.get(0).dataUltimaScadenza);
        crmRet.ProductCode__c = responseDatiRetention.recuperaDatiRetentionResponse.elencoPratiche.get(0).codProdotto;
        crmRet.ProductDescription__c = responseDatiRetention.recuperaDatiRetentionResponse.elencoPratiche.get(0).desProdotto;
        crmRet.RepaymentMode__c = responseDatiRetention.recuperaDatiRetentionResponse.elencoPratiche.get(0).modalitaPagamento;
        crmRet.FinancedAmount__c = Decimal.valueOf(responseDatiRetention.recuperaDatiRetentionResponse.elencoPratiche.get(0).importoFinanziato);
        //crmRet.NOME_CAMPO = responseDatiRetention.recuperaDatiRetentionResponse.elencoPratiche.get(0).montante;
        crmRet.TotalAmount__c = Decimal.valueOf(responseDatiRetention.recuperaDatiRetentionResponse.elencoPratiche.get(0).saldoPratica);
        crmRet.ExtinctionDate__c = IVRUtil.parseStringToDate(responseDatiRetention.recuperaDatiRetentionResponse.elencoPratiche.get(0).dataEstinzione);
        crmRet.LiquidDate__c = IVRUtil.parseStringToDate(responseDatiRetention.recuperaDatiRetentionResponse.elencoPratiche.get(0).dataLiquidazione);
        //crmRet.Customer__r.OCS_External_Id__c = responseDatiRetention.recuperaDatiRetentionResponse.elencoPratiche.get(0).codCliente;
        //crmRet.NOME_CAMPO = responseDatiRetention.recuperaDatiRetentionResponse.elencoPratiche.get(0).agente;
        crmRet.Source__c = CODICE_IVR;
        
        insert crmRet;
        
        }*/
    
    private static void addRecordOnCRMRetention(OCSRecuperaDatiRetentionResponse responseDatiRetention, Account newAccount, Case c){
        
        OCSRecuperaDatiRetentionResponse.PraticheResponse responseRetention = responseDatiRetention.recuperaDatiRetentionResponse.elencoPratiche.get(0);
        
        CRM_Retention__c crmRet = new CRM_Retention__c();
        //crmRet.Case__r.TipoPratica__c = responseRetention.tipoPratica!=null ? responseRetention.tipoPratica : null;
        //crmRet.Case__r.NumeroPratica__c = responseRetention.numPratica!0null ? responseRetention.numPratica : null;
        //crmRet.Case__r.Stato_Pratica__c = responseRetention.statoPratica!=null ? responseRetention.statoPratica : null;
        //crmRet.Case__r.Attributi_Pratica__c = responseRetention.attributoPratica!=null ? responseRetention.attributoPratica : null;

        crmRet.Case__c = c!=null ? c.Id : null;

        crmRet.FirstDueDate__c = responseRetention.dataPrimaScadenza!=null ? IVRUtil.parseStringToDate(responseRetention.dataPrimaScadenza) : null;
        crmRet.LastDueDate__c = responseRetention.dataUltimaScadenza!= null ? IVRUtil.parseStringToDate(responseRetention.dataUltimaScadenza) : null;
        crmRet.ProductCode__c = responseRetention.codProdotto!=null ? responseRetention.codProdotto : null;
        crmRet.ProductDescription__c = responseRetention.desProdotto!=null ? responseRetention.desProdotto : null;
        crmRet.RepaymentMode__c = responseRetention.modalitaPagamento!=null ? responseRetention.modalitaPagamento : null;
        crmRet.FinancedAmount__c = responseRetention.importoFinanziato!=null ? Decimal.valueOf(responseRetention.importoFinanziato) : null;
        //crmRet.NOME_CAMPO = responseRetention.montante!0null ? responseRetention.montante : null;
        crmRet.TotalAmount__c = responseRetention.saldoPratica!=null ? Decimal.valueOf(responseRetention.saldoPratica) : null;
        crmRet.ExtinctionDate__c = responseRetention.dataEstinzione!=null ? IVRUtil.parseStringToDate(responseRetention.dataEstinzione) : null;
        crmRet.LiquidDate__c = responseRetention.dataLiquidazione!=null ? IVRUtil.parseStringToDate(responseRetention.dataLiquidazione) : null;
        crmRet.Customer__c = newAccount != null ? newAccount.Id : null;
        //crmRet.NOME_CAMPO = responseRetention.agente!=null ? responseRetention.agente : null;
        crmRet.Source__c = CODICE_IVR;
        crmRet.Utente__c = IVR;

        insert crmRet;
    }
    
    
    //7.Recupera le informazioni di retention dalla tabella equilon.retention
    //  a.Se l’esito è BAD -> codice errore a IVR = “1” (non è possibile effettuare retention)
    //  b.Se per il cliente il flag partner sulla tabella (colonna partner) = ‘SI’ (cioè il cliente ha pratiche con un partner di Compass)
    //      i.Recupera i valori delle pratiche presenti nella tabella e verifica il flag associato alla pratica in esame (Codice Pratica)
    //      ii.Se il flag  = SI -> codice errore a IVR = “1” (significa che la pratica è una pratica associata al partner e quindi non si può effettuare retention)
    
    private static Account_Retention__c retrieveInfoAccountRetention(String codiceCliente){
        
        Account_Retention__c retentionAcc = null;
        codiceCliente='C'+codiceCliente;
        
        Integer existAccount = [
            SELECT count() FROM Account_Retention__c
            WHERE Customer__r.OCS_External_Id__c =: codiceCliente LIMIT 1
        ];
        
        if(existAccount > 0){
            
            retentionAcc =  [
                SELECT Customer__c,Esito__c,Id,Name,Offerta__c,Partner__c,Valore__c,
                Prt1__c,Prt2__c,Prt3__c,Prt4__c,Prt5__c,Prt6__c,Prt7__c,Prt8__c 
                FROM Account_Retention__c
                WHERE Customer__r.OCS_External_Id__c =: codiceCliente LIMIT 1
            ];
            /*
            if(retentionAcc!=null){
            
                if(ESITO_BAD.equalsIgnoreCase(retentionAcc.Esito__c)){
                	return null;
                
                }else if(retentionAcc.Partner__c){
                    //i.Recupera i valori delle pratiche presenti nella tabella e verifica il flag associato alla pratica in esame (Codice Pratica)
                    //ii.Se il flag  = SI -> codice errore a IVR = “1” (significa che la pratica è una pratica associata al partner e quindi non si può effettuare retention)
                    if(findPratichePartner(retentionAcc)){
                    	return null;
                    }
                
                }
            }*/
        }
        return retentionAcc;
        
    } 
    
    public static Boolean findPratichePartner(Account_Retention__c retentionAcc){
        
        sObject obj = retentionAcc;
        Boolean valueToReturn = false;
        
        for(Integer i=1; i<=8;i++){ 
            String prt = 'Prt'+i+'__c'; //Prt1__c
            String pratica = (String)obj.get(prt); //Ex. NO|18005991
            
            if(String.isNotBlank(pratica)){
                valueToReturn = pratica.mid(0, 2).equalsIgnoreCase(PRATICA_PARTNER_SI);
                if(valueToReturn){
                    break;
                }
                
            }
            
        }
        return valueToReturn;
        
    }
    
    //8.Ricerca sul CRM il cliente per codice OCS
    /*private static Boolean findAccountFromCodiceCliente(String codeOCS) {
        //da verificare se codeOCS è completo, ossia è comprensivo della C iniziale come in dev
        codeOCS='C'+codeOCS;
        Integer accNumber = [SELECT count() FROM Account WHERE OCS_External_Id__c =: codeOCS LIMIT 1];
        if (accNumber > 0) {
            return true;
        }
        return false;
    }*/
    private static Account findAccountFromCodiceCliente(String codeOCS) {
        //da verificare se codeOCS è completo, ossia è comprensivo della C iniziale come in dev
        codeOCS='C'+codeOCS;
        List<Account> accList = [SELECT Id FROM Account WHERE OCS_External_Id__c =: codeOCS LIMIT 1];
        if (accList.size() > 0) {
            return accList.get(0);
        }
        return null;
    }    
    
    //9.Crea case “E/A x Retention”
    private static Case createCase(String esito, String valore, String codicePratica, Integer fasciaDiRicontatto, OCSRecuperaDatiRetentionResponse responseDatiRetention, Account newAccount){
        
        //XCS_Categoria__c categoria = [SELECT Id FROM XCS_Categoria__c WHERE Name =: CAT_BKOFFICE_INBOUND LIMIT 1];
        XCS_Categoria__c categoria = [SELECT Id FROM XCS_Categoria__c WHERE External_Id__c =: CAT_BKOFFICE_INBOUND LIMIT 1];
        //XCS_Disposition__c disposition = [SELECT Id FROM XCS_Disposition__c WHERE Name =: DIS_RETENTION_INSERITA LIMIT 1];
        XCS_Disposition__c disposition = [SELECT Id FROM XCS_Disposition__c WHERE External_Id__c =: DIS_RETENTION_INSERITA LIMIT 1];
        
        DateTime dueDateTime = IVRUtil.setDueDate(fasciaDiRicontatto);
        //Date dueDate = Date.newInstance(dueDateTime.year(),dueDateTime.month(),dueDateTime.day());

        OCSRecuperaDatiRetentionResponse.PraticheResponse responseRetention = responseDatiRetention.recuperaDatiRetentionResponse.elencoPratiche.get(0);
        
        Case newCase = new Case();

        newCase.Tipo_Pratica__c = responseRetention.tipoPratica!=null ? responseRetention.tipoPratica : null;
        newCase.NumeroPratica__c = responseRetention.numPratica!=null ? responseRetention.numPratica : null;
        newCase.Stato_Pratica__c = responseRetention.statoPratica!=null ? responseRetention.statoPratica : null;
        newCase.Attributi_Pratica__c = responseRetention.attributoPratica!=null ? responseRetention.attributoPratica : null;

        newCase.Subject = CASE_RETENTION_SUBJECT;
        newCase.Status = NUOVO; 
        newCase.Priority = MEDIUM; 
        newCase.Categoria_Riferimento__c = categoria.id;
        newCase.Disposition__c = disposition.id;
        //--newCase.Note__c = getNote(esito,valore,codicePratica);
        //newCase.DueDate__c = dueDate;
        newCase.RecallDate__c = dueDateTime;
        
        //Id queueId = [SELECT Id, DeveloperName FROM Group WHERE Name =: GROUP_RETENTION_EA LIMIT 1].Id;
        Id queueId = [SELECT Id, DeveloperName FROM Group WHERE DeveloperName =: GROUP_RETENTION_EA LIMIT 1].Id;
        newCase.OwnerId = queueId; 

        //recod type RETENTIONCLIENTE
        newCase.RecordTypeId = RecordtypeUtil.getCaseRecordType(RecordtypeUtil.RETENTIONCLIENTE);  

        //Prodotto
        Product2 product = [SELECT Id FROM Product2 WHERE RSS_External_Id__c =: NESSUN_PRODOTTO];
        newCase.Product__c = product.Id; 
        
        //Account
        newCase.AccountId = newAccount.Id;
        insert newCase;
        
        if(newCase.Id != null){
            //creazione Note su oggetto (Note) standard
            XCSNoteUtils.postANote(newCase.id,CASE_RETENTION_SUBJECT,getNote(esito,valore,codicePratica));
        }
        
        return newCase;
    }
    
    private static String getNote(String esito,String valore, String codicePratica){
        String nota = CASE_RETENTION_NOTE;
        switch on esito {
            when 'ALL' { 
                nota += NOTA_ALL;
            }
            when 'ESP' { 
                nota += NOTA_ESP;
            }
            when 'GIO' { 
                nota += NOTA_GIO;
            }
            when 'RIN' { 
                nota += NOTA_RIN;
            }
            when 'UPS' { 
                nota += NOTA_UPS;
            }
            when 'CON' { 
                nota += NOTA_CON;
            }
        }  
        nota += ' Valore cliente '+valore+' Pratica '+codicePratica;
        return nota;
    }
    
    //13.Verifica il parametro Fascia Ricontatto e 
    //15.Aggiorna la fascia di contatto con il valore impostato e inserisce la nota “Fascia di ricontatto <valore_fascia_scelta>”
    private static Boolean checkFasciaRicontatto(String codicePratica, Integer fasciaDiRicontatto, Id caseId){
        
        String fasciaToWrite = IVRUtil.getFasciaDiRicontatto(fasciaDiRicontatto);
        if(fasciaToWrite.equals(IVRUtil.FASCIA_DEFAULT)){
            return false;
        }
        Case caseToUpdate = [SELECT Id, Note__c FROM Case WHERE Id =: caseId];
        
        if(caseToUpdate != null){
            String nota = ' Fascia di ricontatto '+fasciaToWrite;
            //START MODIFICA 21/08: la nota del case al momento viene sovrascritta
            /*
            if(String.isNotBlank(caseToUpdate.Note__c)){
                caseToUpdate.Note__c += nota;
            }else{
                caseToUpdate.Note__c = nota;
            }
            */
            caseToUpdate.Note__c = nota;
            //END MODIFICA 21/08
            update caseToUpdate;
            return true;
        }
        
        return false;
        
    }
    
}