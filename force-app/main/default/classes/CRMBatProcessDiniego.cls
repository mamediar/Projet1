global class CRMBatProcessDiniego implements  Database.AllowsCallouts, Database.Batchable<sObject>,  Database.Stateful  {


    global Integer numeroEstratti {get; set;}
    global Integer numeroCreati {get; set;}
    global Map<String, String> mandatiErrati;
    global XCS_Template__c noteTemplate;

    public CRMBatProcessDiniego(Integer numeroEst,Integer numeroCre,Map<String, String> mandatiErr){
        numeroEstratti = numeroEst;
        numeroCreati = numeroCre;
        mandatiErrati = mandatiErr;
    }

    private class MandatiSDDNote {
        public String note;
        public Mandati_SDD__c mandati_sdd;
        public ContentNote contentNote;
        public MandatiSDDNote(Mandati_SDD__c mandati_sdd, String note) {
            this.note = note;
            this.mandati_sdd = mandati_sdd;
        }
        public MandatiSDDNote(Mandati_SDD__c mandati_sdd, String note,ContentNote contentNote) {
            this.note = note;
            this.mandati_sdd = mandati_sdd;
            this.contentNote = contentNote;
        }

    }

    private static Messaging.SingleEmailMessage generateEmail(String emailTemplateDeveloperName, List<String> emailAddresses,String numeroEstratti,String numeroCreati,String listaErrori) {
        
        Messaging.SingleEmailMessage email = Emailutils.generateEmail('BatDinieghi', emailAddresses);
        String defaultContactId = [SELECT Id FROM Contact WHERE Account.OCS_External_Id__c = 'N00000'][0].Id;
        String q = 'SELECT Id, Name, DeveloperName, Subject, Body FROM EmailTemplate WHERE DeveloperName =: emailTemplateDeveloperName';
        EmailTemplate emailTemplate = (EmailTemplate)Database.query(q)[0];
        String body = emailTemplate.Body;
        body = body.replace('{numeroEstratti}', numeroEstratti);
        body = body.replace('{numeroCreati}', numeroCreati);
        body = body.replace('{listaErrori}', listaErrori);
        email.setSubject(emailTemplate.Subject);
        email.setTargetObjectId(defaultContactId);
        email.setTemplateId(emailTemplate.Id);
        email.setTreatTargetObjectAsRecipient(false);
        email.setToAddresses(emailAddresses);
        email.setPlainTextBody(body);
        email.saveAsActivity = false;
         
        return email;
    }   


    private static void sendEmail(String esito,String numeroEstratti,String numeroCreati,String listaErrori){
 	// SPEDISCO EMAIL
        List<String> listEmail = new List<String>();
        String gestoreDinieghiEmail = CompassParametersUtils.getValue('gestore.dinieghi.email');  
        System.debug('sendEmail gestoreDinieghiEmail:'+gestoreDinieghiEmail);  
        listEmail.add(gestoreDinieghiEmail);
        String emailTemplate='BatDinieghi';
        Messaging.SingleEmailMessage messageMail = generateEmail(emailTemplate,listEmail,numeroEstratti,numeroCreati,listaErrori);  
        messageMail.setSenderDisplayName('COMPASS');
        /*
        if (esito != 'OK') {
            subject = 'Presenza errori nel Recupero Dinieghi del : '+System.today().day() + '/' + System.today().month() + '/' + System.today().year() + ' ore : '+System.now().time() +'\n';
        }else{
            //se non ci sono stati errori, invio email esito OK
            subject = 'Riepilogo Recupero dinieghi del : '+System.today().day() + '/' + System.today().month() + '/' + System.today().year();
        }
        */
        EmailUtils.sendEmail(messageMail);
    }


    private String bodyMessageScarti(Map<String, String> mandatiErrati) {
        String message=null;
        if (mandatiErrati!=null && mandatiErrati.size()>0) {
            message='';
            for (String key:mandatiErrati.keySet()) {
                message+='Diniego con canomanProgreMan - canomanProgressivo '+key+' scartato per il seguente motivo: '+mandatiErrati.get(key)+ ' \n';
            }
        }
        return message;
    }


    private void aggiornaNote(List<MandatiSDDNote> listaMandatiNote,String title){
        List<ContentNote> listaContentNote = new List<ContentNote>();
        for(MandatiSDDNote mandatiNote: listaMandatiNote) {
            ContentNote cn=new ContentNote();
      		cn.Title=title;
      		cn.Content=Blob.valueOf(mandatiNote.note);
            listaContentNote.add(cn);
            mandatiNote.contentNote = cn;
		}
		insert listaContentNote;
        List<ContentDocumentLink> listaContentDocumentLink = new List<ContentDocumentLink>();
        for(MandatiSDDNote mandatiNote: listaMandatiNote){
			ContentDocumentLink link=new ContentDocumentLink();
      		link.ContentDocumentId=mandatiNote.contentNote.id;
            system.debug('link.ContentDocumentId:'+link.ContentDocumentId);
      		link.LinkedEntityId=mandatiNote.mandati_sdd.id;
      		link.ShareType='I';
     		link.Visibility='AllUsers';
            listaContentDocumentLink.add(link);
		}
		insert listaContentDocumentLink;
      
    }

    private  OCSGestioneNoteResponse invioNoteOCS(String notaOCS,String codiceCliente, String numPratica, String tipoMessaggio){
        String strUserAlias = [select Alias from User where Id=:UserInfo.getUserId()].Alias;
        return OCSGestioneNoteInvoker.gestioneNote(strUserAlias,codiceCliente,numPratica, tipoMessaggio, 'A','P',notaOCS ); // SCRIVO NOTA OCS 
    }

    global Database.QueryLocator start(Database.BatchableContext bc){
       noteTemplate = [SELECT Id, Name, Body__c FROM XCS_Template__c where name = 'Nota Diniego Mandato SDD' limit 1];
        // query limitata a 50 records perchè non si possono fare piu' di 50 chiamate a WS OCSgestioneNote
        String query = 'SELECT Id, Codice_Cliente__r.OCS_External_Id__c, Codice_Cliente__r.Lastname, Codice_Cliente__r.FirstName, PraticaNum__c, Tipo_Messaggio__c, Modalita_Pagamento__c, ';
        query+= 'Filiale__c, Motivo_Diniego__c, Codice_Cliente__c, ProgreMan__c, Progressivo__c, caseId__c, IsProcessato__c FROM Mandati_SDD__c WHERE IsProcessato__c = false  LIMIT 50000';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc,List<Mandati_SDD__c> listMandati) {
        System.debug('CRMBatProcessDiniego executing');
        List<MandatiSDDNote> listMandatiSDDNote = new List<MandatiSDDNote>();
     
        Mandati_SDD__c diniegoToDelete = null;
        List<Mandati_SDD__c> listDinieghiToDelete = new List<Mandati_SDD__c>();
         List<Mandati_SDD__c> listDinieghiToUpdate = new List<Mandati_SDD__c>();
        if (listMandati!=null) {
            for (Integer i =0; i<listMandati.size(); i++) {   
                 Mandati_SDD__c man = listMandati[i];
                 XCS_Template__c notaTemp = noteTemplate.clone();
                // CREO NOTA INCIDENT
                String codiceCliente = man.Codice_Cliente__r.OCS_External_Id__c;
                codiceCliente = codiceCliente.replace('C','');
                notaTemp.Body__c =notaTemp.Body__c.replace('{Cliente}', codiceCliente +' - '+  man.Codice_Cliente__r.Lastname + ' ' +  man.Codice_Cliente__r.FirstName);
                notaTemp.Body__c =notaTemp.Body__c.replace('{Pratica}', man.PraticaNum__c +' - '+ man.Tipo_Messaggio__c);
                String notaIncident;
                if(man.Modalita_Pagamento__c =='RI'){
                    notaIncident = '"RID"';
                }else if (man.Modalita_Pagamento__c =='BP'){
                    notaIncident = '"Bolletino Postale"';
                }else{
                    notaIncident = '""';
                }
                notaTemp.Body__c =notaTemp.Body__c.replace('{Modalita_Pagamento}',notaIncident);
                notaTemp.Body__c =notaTemp.Body__c.replace('{Filiale}', man.Filiale__c);
                notaTemp.Body__c = notaTemp.Body__c.replace('{Motivo}', man.Motivo_Diniego__c);
                
                String  notaOCS = 'Caricato Diniego Mandato SEPA su CRM in gestione a ufficio: Back Office';   
                OCSGestioneNoteResponse resp = invioNoteOCS(notaOCS,man.Codice_Cliente__c, man.PraticaNum__c, man.Tipo_Messaggio__c);    
                if (resp.isOK()) {
                    man.IsProcessato__c = true;
                    listMandatiSDDNote.add(new MandatiSDDNote(man, notaTemp.Body__c));
                    listDinieghiToUpdate.add(man);
                } else {
                    // c'è stato almeno un errore nell'invio note
                    String key = man.ProgreMan__c +'-'+ man.Progressivo__c;
                    String errorDetail = '';
                    if (resp.gestioneNoteResponse!=null && resp.gestioneNoteResponse.as400Errore!=null) {
                        errorDetail = resp.gestioneNoteResponse.as400Errore;
                    }
                    System.debug('Errore invioNoteOCS '+errorDetail+' per Diniego '+man.Id);
                    mandatiErrati.put(key,'Errore invioNoteOCS '+errorDetail);
                    listDinieghiToDelete.add(man);
                    numeroCreati--;                    
                }
            }
         }
        
        // aggiorna flag processato
        if (listDinieghiToUpdate!=null && listDinieghiToUpdate.size() >0 ) {
             update listDinieghiToUpdate;
        }
        // creazione note
        if (listMandatiSDDNote!=null && listMandatiSDDNote.size() >0 )  {
            aggiornaNote(listMandatiSDDNote,'Diniego Mandato SDD');    
        }
        // cancella case e diniego
        if (listDinieghiToDelete!=null && listDinieghiToDelete.size() >0 ) {
            delete listDinieghiToDelete;
        }
    }

     global void finish(Database.BatchableContext bc){
        if (!Test.isRunningTest()) {
            Id batchJobId = Database.executeBatch(new CRMBatDinieghiFlagLetto(), 50);
        }
        // invio email
        if (mandatiErrati!=null && mandatiErrati.size()>0) {
            sendEmail('KO',''+numeroEstratti,''+numeroCreati,bodyMessageScarti(mandatiErrati));
        } else {
            sendEmail('OK',''+numeroEstratti,''+numeroCreati,'');
        }
    }


}