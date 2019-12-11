public class CRMReclamiGestioneRisLetMailCtrl {
    /*
    @AuraEnabled
    public static OutputObj getInitValues(String societa){
        OutputObj res=new OutputObj();
        res.destinatari=[SELECT Id, IsDeleted,External_Id__c, First_Name__c, Last_Name__c, Email__c, Notes__c, Societa__c 
                         FROM XCS_Destinatario__c
                         WHERE Societa__c=:societa and IsDeleted=false];
        System.debug('CRMReclamiGestioneRisLetMailCtrl getInitValues res: '+res);
        return res;
    }
    */

    @AuraEnabled
    public static List<destinatari__mdt> getInitValues(String societa){
        return [SELECT Id, Label, Email__c, Name__c, Societa__c, DeveloperName FROM destinatari__mdt WHERE Societa__c =: societa order by Name__c asc];
    }
    
    @AuraEnabled
    public static Boolean inviaRispostaApex(String a, String cc, String bcc, String body, List<Attachment> listaAllegati, Case campiCase, OCSCliente clienteSelezionato, String praticaSelezionata) {
        System.debug('pratica selezionata = ' + praticaSelezionata);
        if(clienteSelezionato == null)
            clienteSelezionato = new OCSCliente();
        praticaSelezionata = null;
        System.debug('***************** ');
        System.debug('campiCase = ' + campiCase);
        System.debug('CRMReclamiGestioneRisLetMailCtrl inviaRispostaApex input: a: ' + a + '\n cc :' + cc + '\n bcc :' + bcc + '\n body : ' + body + '\n listaAllegati : ' + listaAllegati);
        List<String> toAddressList = a.split(';');
        List<String> ccList = (String.isNotEmpty(cc))? cc.split(';'):null;
        List<String> bccList = (String.isNotEmpty(bcc))? bcc.split(';'):null;
        List<id> idsAllegati = new List<id>();
        for(Attachment allegato:listaAllegati) {
            List<String> lst = new List<String>();
            for(String spl : allegato.Description.split('=')){
                lst.add(spl);
            }
            //idsAllegati.add(allegato.Id);
            idsAllegati.add(lst.get(0));
            
        }

        List<Id> docVersionId = new List<Id> ();
        if(!idsAllegati.isEmpty()){
            List<ContentVersion> idDocument = [SELECT ContentDocumentId,FileType,Id FROM ContentVersion WHERE ContentDocumentId IN: idsAllegati];
            system.debug('idDocument: '+idDocument);
            for(ContentVersion cv : idDocument){
                docVersionId.add(cv.Id);
            }
        }


        String subject = 'Reclamo n.';
        if(campiCase != null){
            subject += campiCase.Numero_Reclamo__c;
        }
        //subject += ' - ';
        subject += ( String.isNotEmpty(clienteSelezionato.nome) ? ( clienteSelezionato.denominazione != null ? ' - ' + clienteSelezionato.denominazione : ( clienteSelezionato.denominazioneAzienda != null ? ' - '+clienteSelezionato.denominazioneAzienda : '')) : '');
        if (praticaSelezionata != null) {
            subject += ' - Pratica n. ';
            if (!campiCase.Referenced_Company__c.equals(XCSCompassConstants.FUTURO)) {
               subject +=((OCSPratica)(JSON.deserialize(praticaSelezionata, OCSPratica.class))).numPratica;
            } else {
               subject +=((OCSPraticaFuturo)(JSON.deserialize(praticaSelezionata, OCSPraticaFuturo.class))).numPratica; 
            }
        }
        System.debug('Stampo lista');
   		System.debug(toAddressList);
           /*
        EmailUtils.sendEmail(EmailUtils.generateEmailReclami(toAddressList, ccList, bccList, body, idsAllegati, subject));
        CaseUtils.changeStatus(campiCase.id,'F&T Sent');
        */
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        //TO Do Creazione Corrispondenza
        XCSReclamiUtils.creaCorrispondenza(campiCase, body, listaAllegati);
        //Inserimento F&T
        List<XCS_CompassParameters__c> siteUrlList = [SELECT Id, Value__c FROM XCS_CompassParameters__c WHERE Name = 'forwardandtrack.baseurl'];
        String crmUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/cmp/c__CRMReclamiFrodeForwardAndTrack?c__objectid=' + campiCase.Id;
        
        String messaggio = '';
        //SELECT Id, objectId__c, ComponentApp__c, ComponentName__c, token__c FROM XCS_Sites_Token__c where componentname__c = 'c:CRMReclamiInvioRichiesteFeT'
        String siteUrl = siteUrlList[0].Value__c+'?token='+SitesTokenUtil.generateToken(datetime.now().addMinutes(400),'c:CRMReclamiInvioRichiesteFeT','c:CRMReclamiFrodeForwardAndTrackApp', campiCase.id, body);
        
        body+='\n\n Cliccare qui per rispondere.\n\n';
        body+=siteUrl;
        
        //Fine F&T
        
        
        message = EmailUtils.generateEmailReclami(toAddressList, ccList, bccList, body, docVersionId, subject);
        system.debug('Messaging.SingleEmailMessage message: '+message);
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        System.debug('@@@ after email sent: '+results);
        if (results[0].success) {
            System.debug('The email was sent successfully.');
            CaseUtils.changeStatus(campiCase.id,'F&T Sent');
            return true;
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
            return false;
        }

    }
    
    public class OutputObj{
        @AuraEnabled
        public List<XCS_Destinatario__c> destinatari;
    }
}