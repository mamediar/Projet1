@RestResource(urlMapping='/ivr_customerSatisfaction/*')
global with sharing class GestioneIVRCustomerSatisfactionEsito {

    private final static String NESSUN_DATO = 'Impossibile Recuperare il dato';
    private final static String CASE_SATISFACTION_SUBJECT = 'Customer Satisfaction';
    private final static String CASE_SATISFACTION_NOTE = 'IVR - Recall Outbound / Customer Satisfaction / Recall su esito negativo';
    private final static String CASE_SATISFACTION_NOTE_QUEST_1 = 'Alla fine di questa sua telefonata, Lei ha ottenuto le informazioni che le servivano o ha risolto il suo problema?';
    private final static String CASE_SATISFACTION_NOTE_QUEST_2 = 'Pensando all’ultimo operatore con cui ha parlato lei ritiene che sia stato disponibile e cortese?';
    private final static String CASE_SATISFACTION_NOTE_QUEST_3 = 'Complessivamente si ritiene soddisfatto dell’assistenza ricevuta in questa sua ultima telefonata? ';
    private final static String CASE_SATISFACTION_NOTE_QUEST_4 = 'Riesce ad indicarci brevemente il motivo per cui è insoddisfatto?';
    global final static String QUEUE_SATISFATCION = 'Q229';
    global final static String CATEG_BACKOFFICE_INBOUND = '1036';
    global final static String DISP_RECALL_ESITO_NEG = 'DP3715';
    global final static String ID_NESSUN_PRODOTTO = '1414';

    global class CustomerSatistfactionRequest {
        global String callUUID;
        global String codicePratica;
        global String codiceTipoPratica;
        global String outsourcer;
        global Integer voto1;
        global Integer voto2;
        global Integer voto3;
        global Integer voto4;
        public CustomerSatistfactionRequest(String callUUID, String codicePratica,String codiceTipoPratica,String outsourcer,Integer voto1,Integer voto2,Integer voto3,Integer voto4){
            this.callUUID = callUUID;
            this.outsourcer = outsourcer;
            this.codicePratica = codicePratica;
            this.codiceTipoPratica = codiceTipoPratica;
            this.voto1 = voto1;
            this.voto2 = voto2;
            this.voto3 = voto3;
            this.voto4 = voto4;
        }
       
    }


    private static Boolean isValidRequest(CustomerSatistfactionRequest request) {
        if (request==null) {
            return false;
        }
        if (request.callUUID==null || String.isBlank(request.callUUID)) {
            return false;
        }
        if (request.codicePratica==null || String.isBlank(request.codicePratica)) {
            return false;
        }
        if (request.codiceTipoPratica==null || String.isBlank(request.codiceTipoPratica)) {
            return false;
        }
        if (request.outsourcer==null || String.isBlank(request.outsourcer)) {
            return false;
        }
        return true;
    }


/*
    // recupero codice cliente (codice OCS) facendo la query sulla tabella 'IVR_CTI_Collector' per callUUID
    private static String getCodiceCliente(CustomerSatistfactionRequest request) {
        List<IVR_CTI_Collector__c> ivrCTICollector = [SELECT Id,Phone_call_UUID__c,OCS_Customer_Code__c FROM IVR_CTI_Collector__c WHERE Phone_call_UUID__c=:request.callUUID];
        if (ivrCTICollector.size() > 0 && ivrCTICollector[0].OCS_Customer_Code__c!=null) {
           String  ocsCustomerCodeAcc = 'C'+ivrCTICollector[0].OCS_Customer_Code__c;
           Account[] acc = [SELECT Id, CodiceClienteFilled__c FROM Account WHERE OCS_External_Id__c =:ocsCustomerCodeAcc];
            if (acc.size() > 0 && acc[0].CodiceClienteFilled__c!=null) {
                return acc[0].CodiceClienteFilled__c;
            }
             
        }
        return 'fake';

    }
*/

   
    // recupero codice cliente (codice OCS) con chiamata al WS OCS_RecuperaDatiPostVendita
    private static String getCodiceCliente(CustomerSatistfactionRequest request) {
        Map<String,String> data = new Map<String,String> ();
        data.put('numPratica',request.codicePratica);
        data.put('filtroTipoPratica',request.codiceTipoPratica);
        OCSRecuperaDatiPostvenditaResponse response = OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV(data);
        if (response!=null  && response.cliente.size() > 0) {
            return response.cliente[0].codCliente;             
        }
        return 'fake';

    }


    // invio Note a OCS
    // devo fare una future perchè dopo creazione Case
    private static void invioNoteOCS(String codicePratica, String codiceTipoPratica, String codiceOcs){
        String nota = 'Intervista Customer satisfaction';
        IVRUtil.sendNoteOCS(codicePratica, codiceTipoPratica, codiceOcs, nota);
    }


    private static Case createCase(CustomerSatistfactionRequest request, Account acc){
        system.debug('@@@ createCase');
        XCS_Categoria__c categoria = [SELECT ID FROM XCS_Categoria__c WHERE External_Id__c =: CATEG_BACKOFFICE_INBOUND LIMIT 1];
        XCS_Disposition__c disposition = [SELECT Id FROM XCS_Disposition__c WHERE External_Id__c =: DISP_RECALL_ESITO_NEG LIMIT 1];
        Case caso = new Case(Subject = CASE_SATISFACTION_SUBJECT, Status = 'New', Priority = 'Medium', Categoria_Riferimento__c = categoria.id,Disposition__c = disposition.id);
        caso.NumeroPratica__c = request.codicePratica;
        caso.Tipo_Pratica__c = request.codiceTipoPratica;
        // 7 di default mette fascia oraria 9-18

        caso.RecallDate__c = IVRUtil.setDueDate(0); 
        Id queueId = [SELECT Id FROM Group WHERE DeveloperName =: QUEUE_SATISFATCION LIMIT 1].Id;
        caso.OwnerId = queueId;    
        Product2 product = [SELECT Id FROM Product2 WHERE RSS_External_Id__c =: ID_NESSUN_PRODOTTO];
        caso.Product__c = product.Id;
        //--- MODIFICA 20/08 PUNTO 8. se non inserisce il case ritorna codice errore = 1

        //recod type CUSTOMER_SATISFACTION_ESITO
        caso.RecordTypeId = RecordtypeUtil.getCaseRecordType(RecordtypeUtil.CUSTOMER_SATISFACTION_ESITO); 
        caso.AccountId = acc!=null ? acc.id : null;

        //insert caso; 

        try{
            insert caso;
        }catch(Exception e){
            return null;
        }
        //END MODIFICA 20/80

        return caso;
    }


    private static String decodeOutsourcer(String outsource) {
        if ('02'.equals(outsource)) {
            return 'NET';
        } 
        if ('03'.equals(outsource)) {
            return 'Visiant';
        } 
        if ('05'.equals(outsource)) {
            return 'Numero Blu';
        }         
        return '';
    }


    private static String decodeVoto(Integer voto) {
        switch on voto {
            when 0 {
              return 'Nessuna risposta';   
            }
            when 1 {
                 return 'SI';   
            }
            when 2 {
                 return 'NO';   
            }
        } 
        return ''+voto;
    }

    private static String decodeVoto4(Integer voto) {
        switch on voto {
            when 1 {
              return 'PROCEDURE';   
            }
            when 2 {
                 return 'CADUTA LINEA';   
            }
            when 3 {
                 return 'OPERATORE';   
            }
            when 4 {
                 return 'ALTRO';   
            }
        } 
        return ''+voto;
    }

    private static String getNote(CustomerSatistfactionRequest request){
        String nota = CASE_SATISFACTION_NOTE+' Pratica '+request.codiceTipoPratica+' '+request.codicePratica;
        nota+=' Outsourcer: '+decodeOutsourcer(request.outsourcer);
        nota+=' '+CASE_SATISFACTION_NOTE_QUEST_1+' '+decodeVoto(request.voto1);
        nota+=' '+CASE_SATISFACTION_NOTE_QUEST_2+' '+decodeVoto(request.voto2);
        nota+=' '+CASE_SATISFACTION_NOTE_QUEST_3+' '+decodeVoto(request.voto3);
        if (request.voto4!=null) {
            nota+=' '+CASE_SATISFACTION_NOTE_QUEST_4+' '+decodeVoto4(request.voto4);
        }
        return nota;
    }


    global class CustomerSatisfationResponse {
        global Integer codiceErrore = 0; 
    }

    @HttpPost 
    global static void doPost(String callUUID, String codicePratica,String codiceTipoPratica,String outsourcer,Integer voto1,Integer voto2,Integer voto3,Integer voto4) {
        CustomerSatisfationResponse response = customerSatistfaction(callUUID,codicePratica,codiceTipoPratica,outsourcer,voto1,voto2,voto3,voto4);
        ApiUtils.serializeResponse(RestContext.response,RestContext.request,response);
    }


    private static CustomerSatisfationResponse customerSatistfaction(String callUUID, String codicePratica,String codiceTipoPratica,String outsourcer,Integer voto1,Integer voto2,Integer voto3,Integer voto4) {
        CustomerSatistfactionRequest request = new CustomerSatistfactionRequest(callUUID,codicePratica,codiceTipoPratica,outsourcer,voto1,voto2,voto3,voto4);
        CustomerSatisfationResponse response = new CustomerSatisfationResponse();
        System.debug('customerCollectorData start');
        if (!isValidRequest(request)) {
            response.codiceErrore = 1;
            return response;
        }
        // 1. Richiama il WS "recuperaDatiPostvendita per recuperare codice cliente
        String codCliente = getCodiceCliente(request);
        //modifica del controllo dell'esistenza -- @@ modifica 03/09 @@ --
        if(codCliente.equals('fake')){
        	response.codiceErrore = 1;
            return response;
        }
        system.debug('@@@ codice cliente WS recuperaDatiPostVendita: '+codCliente);
        Account acc = null;
        try {
            // 3. verifica se esiste account: se non esiste lo crea sul CRM
            //MODIFICA 22/08
            //acc = XCSGestioneAnagrafica.ricercaOCSInsert(codCliente)[0];
            //modifica 03/09
            acc = XCSGestioneAnagrafica.ricercaOCSUpdateCRM(codCliente);
        } catch (IVRUtil.BatchException be) {
            // errore creazione account
            response.codiceErrore = 1;
            return response;
        }
        // 5 procede alla creazione dell incident
        Case caso = createCase(request, acc);
        system.debug('@@@case creato = '+caso);
        //--- MODIFICA 20/08 PUNTO 8. se non inserisce il case ritorna codice errore = 1
        if(caso == null){
            response.codiceErrore = 1;
            return response;
        }
        //END MODIFICA 20/80

        // 6 crea nota per l'incident
        String nota = getNote(request);
        XCSNoteUtils.postANote(caso.id,'IVR Customer Satisfaction Esito',nota);
        // 9 scrive su OCS la nota per la pratica 
        invioNoteOCS(request.codicePratica,request.codiceTipoPratica,codCliente);
        return response;
    }

}