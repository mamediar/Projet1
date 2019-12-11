@RestResource(urlMapping='/ivr_customerCollectorData/*')
global with sharing class GestioneIVRCustomerCollectorData {

    global final static String OK = 'OK';
    global final static Integer MAX_NUMBER_CALL = 2;
    global final static String OPERAZIONE_ESEGUITA = 'Operazione Eseguita Correttamente';
    global final static String ERROR = 'ERROR';
    global final static String ERROR_NO_DATO = 'Impossibile Recuperare il dato';
    global final static String MOVIMENTAZIONE_INDIVIDUATA = 'Operazione Eseguita Correttamente, Movimentazione individuata';   
    global final static String SOGLIA_RAGGIUNTA = 'Operazione Eseguita Correttamente, Soglia Raggiunta';
    global final static String ERROR_PARAMETERS = 'PARAMETRI NON CORRETTI';
    
    global class CustomerCollectorDataRequest {
        global String callUUID;
        global String codicePratica;
        global String codiceTipoPratica;
        global String codiceCliente;
        global String codiceEER;
        global String flagMossa;
        public CustomerCollectorDataRequest(String callUUID, String codicePratica,String codiceTipoPratica,String codiceCliente,String codiceEER,String flagMossa){
            this.callUUID = callUUID;
            this.codicePratica = codicePratica;
            this.codiceTipoPratica = codiceTipoPratica;
            this.codiceCliente = codiceCliente;
            this.codiceEER = codiceEER;
            this.flagMossa = flagMossa;
        }
    }

    global class CustomerCollectorDataResponse {
        global String codiceEsito = OK;
        global String descrizioneEsito;
        global Integer numeroChiamate;
        global String ragioneSociale;
        global String numeroTelefono;
        global Integer inoltroOperatore;       
    }


    // MODIFICA 23/08 custom settings non più utilizzato
    private static Integer getMaxNumberCalls() {
        //String maxCalls = [SELECT Id, Value__c FROM XCS_CompassParameters__c WHERE Name = 'ivr.maxcall'][0].Value__c;
        //return Integer.valueOf(maxCalls);
        return MAX_NUMBER_CALL;
    }

    private static Boolean isValidRequest(CustomerCollectorDataRequest request) {
        if (request==null) { return false; }
        if (request.callUUID==null || String.isBlank(request.callUUID)) { return false; }
        if (request.codicePratica==null || String.isBlank(request.codicePratica)) { return false;  }
        if (request.codiceTipoPratica==null || String.isBlank(request.codiceTipoPratica)) { return false;  }
        if (request.codiceCliente==null || String.isBlank(request.codiceCliente)) { return false;}
        if (request.codiceEER==null || String.isBlank(request.codiceEER)) {return false;}
        return true;
    }

/*
    private static Boolean isMovimentazioneIndividuata(CustomerCollectorDataRequest request) {
        List<IVR_CTI_Collector__c> ivrCollectors = [SELECT ID,Flag_Mossa__c from IVR_CTI_COLLECTOR__c WHERE Numero_Pratica__c =: request.codicePratica AND Tipo_Pratica__c =:request.codiceTipoPratica];
        if (ivrCollectors.size()>0) {
            for (IVR_CTI_Collector__c coll:ivrCollectors) {
                if (coll.Flag_Mossa__c!=null && (coll.Flag_Mossa__c)) {
                    System.debug('isMovimentazioneIndividuata Flag_Mossa__c TRUE IVR_CTI_Collector__c:'+coll.Id); 
                    return true;
                }
            }
        }
        return false;
    }
 */   

    private static Boolean isMovimentazioneIndividuata(CustomerCollectorDataRequest request) {
        if (String.isEmpty(request.flagMossa)) {
            return false;
        }
        if (!'0'.equals(request.flagMossa)) {
             return true;
        }
        return false;
    }

    private static Collectors__c getCollector(String codiceEER){
        System.debug('getCollector codiceEER:'+codiceEER);
        Collectors__c[] collectors = [SELECT Id, Ragione_Sociale__c, Telefono__c FROM Collectors__c WHERE Rnt_Code__c =:codiceEER];
        if (collectors.size() > 0) {
            return collectors[0];
        }
        return null;
    }


    private static void sendEmailAdminError(String callUUID, String codicePratica,String codiceTipoPratica,String codiceCliente,String codiceEER){
            String subject = 'Error IVR Collector';
            String body = 'Errore nella registrazione della chiamata al servizio \'ivr_customerCollectorData\'. UUID: '+callUUID+' Numero Pratica: '+codicePratica;
            body+= '  Tipo Pratica: '+codiceTipoPratica+' Codice OCS: '+codiceCliente+' Codice EER: '+codiceEER;
 
            // manda email
            List<String> listEmail = EmailUtils.listEmailAdmin();
            if (listEmail!=null && listEmail.size()>0) {
                EmailUtils.sendEmail(EmailUtils.generateEmailReclamiFandT(listEmail, body, subject));
            }
    }
    
    @HttpPost
    global static void doPost(String callUUID, String codicePratica,String codiceTipoPratica,String codiceCliente,String codiceEER,String flagMossa) {
        CustomerCollectorDataResponse collectorResponse = customerCollectorData(callUUID,codicePratica,codiceTipoPratica,codiceCliente,codiceEER,flagMossa);
        ApiUtils.serializeResponse(RestContext.response,RestContext.request,collectorResponse);
    }


    private static void insertNewIvrCtiCollector(CustomerCollectorDataRequest request,CustomerCollectorDataResponse response){
       try {
            // AccountUtils.makeAccounts prevede un prefisso con la 'C'
            String ocsCustomerCodeExt='C'+request.codiceCliente;
            Account[] acc = [SELECT Id FROM Account WHERE OCS_External_id__c=:ocsCustomerCodeExt LIMIT 1];
            system.debug('@@@ insertNewIvrCtiCollector bafore trows Exception');
            if (acc.size() == 0) {
                throw new DmlException('Account Non Esiste sul CRM');
            }
            // ocsCustomerCode lookUP verso Account
            system.debug('@@@ insertNewIvrCtiCollector after trows Exception');
            String ocsCustomerCode = acc[0].Id;
            String codEsito = response.codiceEsito;
            if(codEsito!=null && codEsito.length()>2) {
                // Codice_Esito__c is TEXT 2
                codEsito = codEsito.substring(0, 2);
            }
            IVR_CTI_Collector__c ivr_cti_collector = new IVR_CTI_Collector__c(Phone_call_UUID__c = request.callUUID, Numero_Pratica__c = request.codicePratica, Tipo_Pratica__c = request.codiceTipoPratica, Codice_EER__c = request.codiceEER, Codice_Esito__c = codEsito, Desc_Esito__c = response.descrizioneEsito, 	Flag_Operatore__c = String.valueOf(response.inoltroOperatore) , Numero_Chiamata__c = (response.numeroChiamate+1), OCS_Customer_Code__c =ocsCustomerCode, Stato__c = '1');
            ivr_cti_collector.Flag_Mossa__c = ('0'.equals(request.flagMossa))?false:true;
            ivr_cti_collector.Ragione_Sociale__c = response.ragioneSociale;
            ivr_cti_collector.Numero_Telefono__c = response.numeroTelefono;           
            insert ivr_cti_collector;
	    } catch(DmlException e) {
	        System.debug('The following exception has occurred: ' + e.getMessage());
            sendEmailAdminError(request.callUUID, request.codicePratica,request.codiceTipoPratica,request.codiceCliente,request.codiceEER);
            response.codiceEsito = ERROR;
            response.descrizioneEsito = e.getMessage();
	    }
    }

    private static CustomerCollectorDataResponse customerCollectorData(String callUUID, String codicePratica,String codiceTipoPratica,String codiceCliente,String codiceEER,String flagMossa) {
       CustomerCollectorDataRequest request = new CustomerCollectorDataRequest(callUUID,codicePratica,codiceTipoPratica,codiceCliente,codiceEER,flagMossa);
       System.debug('customerCollectorData start');
       CustomerCollectorDataResponse response = new CustomerCollectorDataResponse();
       // 1. verifica parametri input
       if (!isValidRequest(request)) {
            response.codiceEsito = ERROR;
            response.descrizioneEsito = ERROR_PARAMETERS;
            return response;
       }
       // 2. conta chiamate
       Integer countCalls = database.countQuery('select count() from IVR_CTI_COLLECTOR__c WHERE Numero_Pratica__c =\''+codicePratica+'\' AND Tipo_Pratica__c = \''+codiceTipoPratica+'\'');
       System.debug('customerCollectorData countCalls:'+countCalls);
       response.numeroChiamate = countCalls;
       // 3. verifica la presenza del flag mossa per vedere pagamenti del cliente
       if (isMovimentazioneIndividuata(request)) {      
           // verificare codice Esito 'OK' (default)
            response.descrizioneEsito = MOVIMENTAZIONE_INDIVIDUATA;
            response.inoltroOperatore = 1;
            // 7. inserisce record
            insertNewIvrCtiCollector(request,response);
            return response;      
       }
       // 5a. controlla soglia
       if (countCalls>getMaxNumberCalls()) {
           // verificare codice Esito 'OK' (default)
            response.descrizioneEsito = SOGLIA_RAGGIUNTA;
            response.inoltroOperatore = 1;
            // 7. inserisce record
            insertNewIvrCtiCollector(request,response);
            return response;
       } 
       // 6. verifica codice codiceEER e recupera info collector
       Collectors__c collector = getCollector(codiceEER);
       if (collector ==null) {
            response.codiceEsito = ERROR;
            response.descrizioneEsito = ERROR_NO_DATO;
            // 7. inserisce record
            insertNewIvrCtiCollector(request,response);
            return response;
       }
       response.numeroTelefono = collector.Telefono__c;
       response.ragioneSociale = collector.Ragione_Sociale__c;
       response.descrizioneEsito = OPERAZIONE_ESEGUITA;
       response.inoltroOperatore = 0;
       if (countCalls==getMaxNumberCalls()) {
           // 6b	Se numero chiamate >= al parametro soglia info (è parametrica e attualmente pari a 3) allora  ivr_collector_inoltro_operatore = 2 
            response.inoltroOperatore = 2;
       }
       // 7. inserisce record
       insertNewIvrCtiCollector(request,response);
       return response;
    }

}