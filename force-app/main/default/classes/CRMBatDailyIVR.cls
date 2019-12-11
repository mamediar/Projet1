//----------------------------------------------------------------------
//-- - Class Name   : CRMBatDailyIVR
//-- - Autor        : Mauro Dotti(Lynx)
//-- - Date         : 22/07/2019
//-- - Description  : Batch per allineamento IVR
//-- - Version      : 1.0
//----------------------------------------------------------------------
global class CRMBatDailyIVR implements Database.AllowsCallouts, Database.Batchable<SObject>, Database.Stateful, Schedulable {
 
   
    global virtual class NoteOCSException extends Exception {}

    global Integer countProcessed = 0;
    global Integer countError = 0;
   

    private final static String CASE_ACQUISIZIONE_IVR_SUBJECT = 'Acquisizione Inbound IVR Dinamico';
    private final static String EMAIL_TEMPLATE_ERROR_CONTACT = 'IVR_ERROR_CONTACT';
    private final static String EMAIL_TEMPLATE_ERROR_REQUEST = 'IVR_ERROR_REQUEST';
    global final static String CATEG_IVR_DINAMICO_COLLECTOR = '5863';
    global final static String DISP_INFO_COLLECTOR = 'DP5861';
    global final static String DISP_OPERATORE = 'DP5862';
    global final static String PRODOTTO_CARTA_CREDITO = '1076';
    global final static String PRODOTTO_PRESTITO_PERSONALE = '1073';
    global final static String ID_NESSUN_PRODOTTO = '1414'; 

    global List<EmailParameters> emailParameters = new List<EmailParameters>();


    global Database.QueryLocator start(Database.BatchableContext bc){
        String query = 'SELECT Id, Codice_Esito__c, Desc_Esito__c, OCS_Customer_Code__c, Flag_Operatore__c, Numero_Pratica__c, Tipo_Pratica__c, Ragione_Sociale__c, Numero_Chiamata__c, Numero_Telefono__c, Codice_EER__c, Flag_Mossa__c, Phone_call_UUID__c FROM IVR_CTI_Collector__c WHERE Stato__c = \'1\'';
        return Database.getQueryLocator(query);
    }

    global void finish(Database.BatchableContext bc){
         System.debug('CRMBatDailyIVR finish');
         System.debug('Records processed:'+countProcessed);
         System.debug('Records error:'+countError);
         sendEmailAdminError(emailParameters);
        
//        CRMBatDailyIVR bDelete = new CRMBatDailyIVR();
        
//        String hour = String.valueOf(Datetime.now().hour());
//        String min = String.valueOf(Datetime.now().minute()+15);
//        String ss = String.valueOf(Datetime.now().second());

//		String nextTime = ss + ' ' + min + ' ' + 8-22 + ' * * ?';    
        
//		String jobID = System.schedule('DailyIVR', nextTime, bDelete);        
    }

    global void execute(SchedulableContext sc) {
        CRMBatDailyIVR b = new CRMBatDailyIVR(); 
        Database.executebatch(b);
    }     
    private class EmailParameters {
        public String codiceOCS;
        public String phoneCallUUID;
        public String type;
        public EmailParameters(String codiceOCS, String phoneCallUUID,String type) {
            this.codiceOCS = codiceOCS;
            this.phoneCallUUID = phoneCallUUID;
            this.type = type;
        }

    }

    private class CaseNote {
        public String note;
        public Case caso;
        public CaseNote(Case caso, String note) {
            this.note = note;
            this.caso = caso;
        }

    }
 


    // crea descrizione con riferimenti alla chiamata IVR
    private String getDescription(IVR_CTI_Collector__c ctiCollector){
        String descr = 'Pratica:'+ctiCollector.Numero_Pratica__c+':tipo:'+ctiCollector.Tipo_Pratica__c+':UUID:'+ctiCollector.Phone_call_UUID__c+':flag mossa:'+ctiCollector.Flag_Mossa__c;
        descr+=':codiceEER:'+ctiCollector.Codice_EER__c+':inoltro:'+ctiCollector.Flag_Operatore__c+':chiamate:'+ctiCollector.Numero_Chiamata__c+':esito:'+ctiCollector.Codice_Esito__c;
        return descr;
    }

    // creazione Case di acquisizione IVR
    private Case createCase(IVR_CTI_Collector__c ctiCollector){
        String description = getDescription(ctiCollector);
        XCS_Disposition__c disposition = [SELECT Id FROM XCS_Disposition__c WHERE External_Id__c =: DISP_OPERATORE LIMIT 1];
        if ('0'.equals(ctiCollector.Flag_Operatore__c)) {
             disposition = [SELECT Id FROM XCS_Disposition__c WHERE External_Id__c =: DISP_INFO_COLLECTOR LIMIT 1];
        }
        XCS_Categoria__c categoria = [SELECT ID FROM XCS_Categoria__c WHERE External_Id__c =: CATEG_IVR_DINAMICO_COLLECTOR LIMIT 1];
        Case caso = new Case(Subject = CASE_ACQUISIZIONE_IVR_SUBJECT, Status = 'Closed', Categoria_Riferimento__c = categoria.id, Disposition__c = disposition.id,Description=description,NumeroPratica__c = ctiCollector.Numero_Pratica__c, Tipo_Pratica__c = ctiCollector.Tipo_Pratica__c);
        caso.flag_mossa__c = ctiCollector.Flag_Mossa__c;
        caso.codice_eer__c = ctiCollector.Codice_EER__c;
        caso.codice_uid_chiamata__c = ctiCollector.Phone_call_UUID__c;
        caso.inoltro_operatore__c = ctiCollector.Flag_Operatore__c;
        caso.numero_chiamate__c = ctiCollector.Numero_Chiamata__c;
        caso.Esito__c = ctiCollector.Codice_Esito__c;
        caso.AccountId = ctiCollector.OCS_Customer_Code__c;
        Product2 product = null;
        if ('CA'.equals(ctiCollector.Tipo_Pratica__c)) {
             product = [SELECT Id FROM Product2 WHERE RSS_External_Id__c =: PRODOTTO_CARTA_CREDITO];
        } else if ('CO'.equals(ctiCollector.Tipo_Pratica__c)) {
             product = [SELECT Id FROM Product2 WHERE RSS_External_Id__c =: PRODOTTO_PRESTITO_PERSONALE];
        } else {
             product = [SELECT Id FROM Product2 WHERE RSS_External_Id__c =: ID_NESSUN_PRODOTTO];
        }
        caso.Product__c = product.Id;
        return caso;
    }


 
   // invio Note a OCS
    private static void invioNoteOCS(IVR_CTI_Collector__c ctiCollector) {
        if (!'1'.equals(ctiCollector.Flag_Operatore__c)) {
            String nota = getNoteOCS(ctiCollector);
            String strUserAlias = [select Alias from User where Id=:UserInfo.getUserId()].Alias;
            OCSGestioneNoteResponse  respons =  OCSGestioneNoteInvoker.gestioneNote(strUserAlias, ctiCollector.OCS_Customer_Code__c, ctiCollector.Numero_Pratica__c, ctiCollector.Tipo_Pratica__c,  'A', 'P', nota);
            if (!respons.isOK()) {
                throw new NoteOCSException ('Errore invio note OCS');
            }    
        }
    }

    // 2d. genera note per l'incident (Case)
    private static String getNote(IVR_CTI_Collector__c ctiCollector){
        String nota = getNoteOCS(ctiCollector);
        nota+='Nota tecnica Esito: '+ctiCollector.Codice_Esito__c+' '+ctiCollector.Desc_Esito__c+'\n';
        nota+='Detail: '+ctiCollector.OCS_Customer_Code__c+','+ctiCollector.Numero_Pratica__c+','+ctiCollector.Tipo_Pratica__c+','+ctiCollector.Codice_EER__c+','+ctiCollector.Ragione_Sociale__c+','+ctiCollector.Numero_Telefono__c+'\n';
        nota+='Trasferimento operatore: '+ctiCollector.Flag_Operatore__c+'\n';
        nota+='Movimentazione: '+ctiCollector.Flag_Mossa__c;
        System.debug('getNote:'+nota);
        return nota;        
    }


    // genera note per OCS
    private static String getNoteOCS(IVR_CTI_Collector__c ctiCollector){
        String nota = 'Tel da cliente:';
        if ('2'.equals(ctiCollector.Flag_Operatore__c)) {
            nota+=': fornito recapito Società '+ctiCollector.Ragione_Sociale__c+' Tel. '+ctiCollector.Numero_Telefono__c+' / passaggo ope (tentativo '+ctiCollector.Numero_Chiamata__c+')\n';
        } else if ('1'.equals(ctiCollector.Flag_Operatore__c)) {
            nota+='passaggo ope (tentativo '+ctiCollector.Numero_Chiamata__c+')\n';
        } else {
            nota+=': fornito esclusivamente recapito Società '+ctiCollector.Ragione_Sociale__c+' Tel. '+ctiCollector.Numero_Telefono__c+' (tentativo '+ctiCollector.Numero_Chiamata__c+')\n';
        }
        System.debug('getNoteOCS:'+nota);
        return nota;
    }


    private static void sendEmailAdminError(List<EmailParameters> emailParameters){
            if (emailParameters!=null && emailParameters.size()>0) {
                String subject = 'Error IVR Batch Daily';
                String body = '';
                for (EmailParameters emailParameter:emailParameters) {
                    System.debug(' sendEmailAdminError emailParameter:'+emailParameter.phoneCallUUID);
                    if (EMAIL_TEMPLATE_ERROR_REQUEST.equals(emailParameter.type)) {
                        body+= 'Errore nella creazione della richiesta per la chiamata '+emailParameter.phoneCallUUID+' del cliente '+emailParameter.codiceOCS+'\n';
                    } else if (EMAIL_TEMPLATE_ERROR_CONTACT.equals(emailParameter.type)) {
                        body+= 'Errore nella creazione del contatto per il cliente  '+emailParameter.codiceOCS+' e per la chiamata  '+emailParameter.phoneCallUUID+'\n';
                    }
                }
                // manda email
                List<String> listEmail = EmailUtils.listEmailAdmin();
                System.debug('sendEmailAdminError body:'+body);
                if (listEmail!=null && listEmail.size()>0) {
                    EmailUtils.sendEmail(EmailUtils.generateEmailReclamiFandT(listEmail, body, subject));
                }
            }
    }


    global void execute(Database.BatchableContext bc,List<IVR_CTI_Collector__c> listCTICollectors) {
        System.debug('CRMBatDailyIVR executing');
        if (listCTICollectors!=null) {
            List<CaseNote> casesNote = new List<CaseNote>();
            List<Case> cases = new List<Case>();
            for (IVR_CTI_Collector__c ctiCollector : listCTICollectors) {
                try {
                    countProcessed++;
                    // 2d invia note a OCS (anticipato per stare prima della creazione account)
                    invioNoteOCS(ctiCollector);
                    // 2b. verifica se esiste account: deve esistere per forza
                    Id accId = ctiCollector.OCS_Customer_Code__c;   
                    if (accId==null) {
                        throw new IVRUtil.BatchException('Account non trovato');
                    }               
                    // 2c. creazione Case di acquisizione IVR
                    Case caso = createCase(ctiCollector);
                    cases.add(caso);
                    String notes = getNote(ctiCollector); 
                    casesNote.add(new CaseNote(caso,notes));
                    // 2e. Se non ci sono stati errori lo stato del record verrà impostato a 2
                    ctiCollector.Stato__c = '2';
                } catch (IVRUtil.BatchException be) {
                    // errore creazione account
                    System.debug(Logginglevel.ERROR,'execute BatchException:' + be.getMessage());
                    emailParameters.add(new EmailParameters(ctiCollector.OCS_Customer_Code__c,ctiCollector.Phone_call_UUID__c,EMAIL_TEMPLATE_ERROR_CONTACT));
                    countError++;
                }  catch (Exception ex) {
                    // errore generico
                    System.debug(Logginglevel.ERROR,'execute Exception:' + ex.getMessage());
                    emailParameters.add(new EmailParameters(ctiCollector.OCS_Customer_Code__c,ctiCollector.Phone_call_UUID__c,EMAIL_TEMPLATE_ERROR_REQUEST));
                    countError++;
                }
            }
            insert cases;
            if (cases.size()>0) {
                for (CaseNote caseNote:casesNote) {
                    XCSNoteUtils.postANote(caseNote.caso.id,'CRMBatDailyIVR',caseNote.note);
                }
            }
            update listCTICollectors;
        }
    }

}