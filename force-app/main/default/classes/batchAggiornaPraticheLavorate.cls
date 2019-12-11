global class batchAggiornaPraticheLavorate implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    
    global final integer MAX_RECORDS = 800;
    global String strUserAlias;
    global RecordType rt;
    global List<OCSSbloccaRitorniPostaliRequest.SbloccoRitornoPostaleDTO> ritorniPostali = new List<OCSSbloccaRitorniPostaliRequest.SbloccoRitornoPostaleDTO>();
    global List<RitorniPostali__c> rits = new List<RitorniPostali__c>();
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        strUserAlias = [select Alias from User where Id=:UserInfo.getUserId()].Alias;
        rt = [Select id from RecordType where DeveloperName = 'Note' and SobjectType = 'XCS_Messaggio__c' ];
        String query = 'Select Id, CasoCorrispondente__r.DispositionName__c, CasoCorrispondente__r.Disposition__r.External_Id__c, OCSAnag__c, QueueId__c, OcsUpdated__c, CallDispCode__c, processato__c, LetterId__c, CallDispDate__c, OriginalAddress__c, SentAddress__c, OriginalCap__c, SentCap__c, OriginalCity__c, SentCity__c, OriginalProv__c, SentProv__c  from RitorniPostali__c where QueueId__c = null and OcsUpdated__c = 0 and processato__c = 1 and CallDispCode__c != null limit :MAX_RECORDS';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<RitorniPostali__c> ritorniDaProcessare) {
        
        if (ritorniDaProcessare.size() > 0) {
            
            final String EMPTY_STRING = '';
            final String DATE_FORMAT = 'yyyyMMdd';
            final String TIME_FORMAT = 'HHmmss';
            final String FLAG_CONTATTATO_S = 'S';
            final String FLAG_CONTATTATO_N = 'N';
            final String MENO_UNO = '-1';
            final String ZERO = '0';
            final String DA_NON_CONTATTARE = 'da non contattare.';
            
            for (RitorniPostali__c ritorno : ritorniDaProcessare) {
                
                OCSSbloccaRitorniPostaliRequest.SbloccoRitornoPostaleDTO sblocco = new OCSSbloccaRitorniPostaliRequest.SbloccoRitornoPostaleDTO();
                sblocco.codLettera = ritorno.LetterId__c;
                Datetime dtEsito = (ritorno.CallDispDate__c == Null)? Datetime.now() : ritorno.CallDispDate__c;
                sblocco.dataEsito = dtEsito.format(DATE_FORMAT);
                DateTime oraEsito = (ritorno.CallDispDate__c == Null)? Datetime.now() : ritorno.CallDispDate__c; 
                sblocco.oraEsito = oraEsito.format(TIME_FORMAT);
                
                Boolean flagContattato = false;
                
                if (!(RitorniPostaliUtils.ESITO_DA_NON_CONTATTARE.equalsIgnoreCase(ritorno.CallDispCode__c))) {
                    
                    if ((fieldsHaveSameValue(ritorno.OriginalAddress__c, ritorno.SentAddress__c)) && 
                        (fieldsHaveSameValue(ritorno.OriginalCap__c, ritorno.SentCap__c)) && 
                        (fieldsHaveSameValue(ritorno.OriginalCity__c, ritorno.SentCity__c)) && 
                        (fieldsHaveSameValue(ritorno.OriginalProv__c, ritorno.SentProv__c))) {
                            
                            flagContattato = true; 
                            
                        }
                }
                
                sblocco.flagContattato = (flagContattato) ? FLAG_CONTATTATO_S:FLAG_CONTATTATO_N;
                
                sblocco.flagVerificato = EMPTY_STRING;
                String dispCodeFound = EMPTY_STRING;
                for (RitorniPostaliUtils.ESITI_CONTATTO esitoNegativo : RitorniPostaliUtils.ESITI_CONTATTO.values()) {
                    
                    if (esitoNegativo.name().equalsIgnoreCase(ritorno.CallDispCode__c)) {
                        dispCodeFound = RitorniPostaliUtils.ESITO_NEGATIVO_GENERICO;
                        break;
                    }                 
                }
                sblocco.esitoContatto = ((EMPTY_STRING.equals(dispCodeFound))? ritorno.CallDispCode__c : dispCodeFound).substring(2);    
                ritorniPostali.add(sblocco);
                rits.add(ritorno);
            }           
            
        }
        
    }
    
    global void finish(Database.BatchableContext BC) {
        
        final Integer MAX_NUMBER_RECORD_LIMIT = 1501;
        
        if ((ritorniPostali != null) && (ritorniPostali.size() > 0)) {
            
            final String EMPTY_STRING = '';
            final String MENO_UNO = '-1';
            final String ZERO = '0';
            final String DA_NON_CONTATTARE = 'da non contattare.';
            String strCodVerifica;
            String strFlagError;
            List<Messaging.SingleEmailMessage> emailToSend = new List<Messaging.SingleEmailMessage>();
            
            integer subindex = 0;
            List<OCSSbloccaRitorniPostaliRequest.SbloccoRitornoPostaleDTO> subsetRitorniPostali = new List<OCSSbloccaRitorniPostaliRequest.SbloccoRitornoPostaleDTO>();
            OCSSbloccaRitorniPostaliResponse objEsito;           
            //for (integer index = 0;index<=ritorniPostali.size() - 1;index++) {
            //subsetRitorniPostali.add(ritorniPostali.get(index));
            //subindex++;
            //if ((subindex == MAX_NUMBER_RECORD_LIMIT) || (index == (ritorniPostali.size() - 1))) {                   
            strCodVerifica = MENO_UNO;
            strFlagError = EMPTY_STRING;
            try {
                objEsito = OCSSbloccaRitorniPostaliInvoker.sbloccaRitorniPostali(ritorniPostali);
                strCodVerifica = (String.isEmpty(objEsito.numRigheElaborate))? MENO_UNO : objEsito.numRigheElaborate; 
                System.debug('DM - ************************************** - ' + strCodVerifica);
            } catch (exception e) {                       
                strFlagError = e.getMessage();
            } 
            
            if (MENO_UNO.equals(strCodVerifica)) {
                if (String.isEmpty(strFlagError)) {
                    strFlagError = 'errore sconosciuto.';
                }
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[]{'crm@compass.it'};
                    mail.setToAddresses(toAddresses);
                mail.setSubject('Compass: Sblocco Ritorni Postali ERRORE');
                mail.setPlainTextBody('errore cod verifica = -1 :' + strFlagError);
                emailToSend.add(mail);                          
            } else {
                if ((ZERO.equals(strCodVerifica))) {
                    //if (index == (ritorniPostali.size() - 1)) {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String[] toAddresses = new String[]{'crm@compass.it'};
                        mail.setToAddresses(toAddresses);
                    mail.setSubject('Compass: Sblocco Ritorni Postali TERMINATO');
                    mail.setPlainTextBody('Ritorni Aggiornati: ' + ritorniPostali.size());
                    emailToSend.add(mail); 
                    //}                           
                } else {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String[] toAddresses = new String[]{'crm@compass.it'};
                        mail.setToAddresses(toAddresses);
                    mail.setSubject('Compass: Sblocco Ritorni Postali ERRORE');
                    mail.setPlainTextBody('Ritorni da aggiornare: '+ ritorniPostali.size() + ' . Ultima lettera valida: ' + strCodVerifica);
                    emailToSend.add(mail); 
                }
            }
            //subsetRitorniPostali.clear();
            //subindex = 0;
            //}
            //}
            if ((emailToSend != null) && (emailToSend.size() > 0)) {
                EmailUtils.sendEmail(emailToSend);
            }
            
            if (!(MENO_UNO.equals(strCodVerifica))) {
                Long ritorniProcessati = 0;
                List<XCS_Messaggio__c> listaOCSNote = new List<XCS_Messaggio__c>();
                for (RitorniPostali__c ritorno : rits) {
                    
                    if (checkFlagVerifica(ritorno.LetterId__c, strCodVerifica)) {
                        
                        ritorno.OcsUpdated__c = 1;                         
                        String strDispDescription;
                        String strExternalCustomerID = ritorno.OCSAnag__c;
                        if (RitorniPostaliUtils.ESITO_DA_NON_CONTATTARE.equalsIgnoreCase(ritorno.CasoCorrispondente__r.Disposition__r.External_Id__c)) {
                            strDispDescription = DA_NON_CONTATTARE;
                        } else {
                            strDispDescription = ritorno.CasoCorrispondente__r.DispositionName__c;
                        }
                        String strNotaOCS = 'Gestito ritorno postale con codice invio ' + ritorno.LetterId__c;
                        strNotaOCS += ', esito ' + strDispDescription;
                        listaOCSNote.add(OCSGestioneNoteInvoker.createOCSNote(rt, strUserAlias, 
                                                                              strExternalCustomerID, 
                                                                              '', 
                                                                              '', 
                                                                              'A', 
                                                                              'P', 
                                                                              strNotaOCS));
                        
                        ritorniProcessati ++;
                        
                    }                   
                    
                }
                
                update rits;
                insert listaOCSNote; 
            } 
            
            
        }
        
    }
    
    private Boolean fieldsHaveSameValue(String field_1, String field_2) {
        
        Boolean retValue = false;
        if (field_1 == Null) {
            if (field_2 == Null) {
                retValue = true;
            }
        } else {
            if (field_1.equalsIgnoreCase(field_2)) {
                retValue = true;
            }
        }
        
        return retValue;
        
    }
    
    private Boolean checkFlagVerifica(String strCodLettera, String strCodVerifica) {
        
        Boolean flagCodVerificaMaggiore = false;
        try {
            
            Long codVerifica = Long.valueOf(strCodVerifica);
            Long codLettera = Long.valueOf(strCodLettera);
            if(codVerifica == 0) {
                flagCodVerificaMaggiore = true;
            } else if (codVerifica > codLettera) {
                flagCodVerificaMaggiore = true;
            }           
            
        } catch (exception e) {
            
        }
        
        return flagCodVerificaMaggiore;
        
    }
    
}