public class CRMReclamiGesInadContainerCtrl {
	
    @AuraEnabled
    public static Map<String,String> getInitValues(){
      Map<String,String> res=new Map<String,String>();
        
        Schema.DescribeFieldResult fieldResult = Case.Stage_Inadempimento__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry pickListVal:ple){
            res.put(pickListVal.getLabel(), pickListVal.getValue());
        }
       
        return res;
    }
    
    @AuraEnabled
    public static GestioneInadempimento getCurrentValue(String recordId){
        GestioneInadempimento gest = new GestioneInadempimento();
        //Case c = [Select Stage_Inadempimento__c, F_T_Sent_Count__c, F_T_Received_Count__c, Disposition__c, Reclamo_Completo__c 
        //          from Case where id =: recordId];
        List<Case> c = [Select Stage_Inadempimento__c,F_T_Sent_Count__c, F_T_Received_Count__c, Disposition__c, Reclamo_Completo__c,
                        Branch__r.Name from Case where id =: recordId];
        
        List<XCS_Disposition__c> disp = new List<XCS_Disposition__c>();
        
        if(c.size() > 0) {
            disp = [Select name from XCS_Disposition__c where id =: c[0].Disposition__c];        
            
            gest.stage = c[0].Stage_Inadempimento__c;
            gest.FAndTSent = c[0].F_T_Sent_Count__c;
            gest.FAndTReceived = c[0].F_T_Received_Count__c;
            gest.completo = c[0].Reclamo_Completo__c;
            gest.filiale = c[0].Branch__r.Name;
        }
        
        if(disp.size() > 0)
            gest.disposition = disp[0].name;
        System.debug('gest: '+gest);
        
        return gest;
    }
    
    @AuraEnabled
    public static void salvaReclamoInadempimentoApex(String recordId, String stageInadempimento, Double FTSent, Double FTReceived, String gravita){
        XCS_Disposition__c disp = [Select id, external_id__c from XCS_Disposition__c where external_id__c  =: gravita];
        Case c2 = [Select id,F_T_Received_Count__c,Numero_Reclamo__c, F_T_Sent_Count__c,Status,NumeroPratica__c , Stage_Inadempimento__c, Account.OCS_External_ID__c, Disposition__c, CaseNumber, Createddate,Account.FirstName, Account.LastName, Disposition__r.External_id__c, Referenced_Company__c from Case where id =:recordId];
        Boolean gravitaIsChanged = c2.Disposition__c != null && c2.Disposition__r.external_id__c != null && gravita!=null  &&  c2.Disposition__r.external_id__c != gravita;
		//4166 - Step 1 – Start
		//4165 - Step 0 – End
		String status = null;
     /*   if(stageInadempimento == '4166' && c2.Stage_Inadempimento__c=='4165'){
            status = 'F&T Sent';
        }
       */
        System.debug('***FUORI IF');
        // se è stato selezionato grave
        if('DP2208'.equals(gravita)){
            if(String.isBlank(c2.Stage_Inadempimento__c) || c2.Stage_Inadempimento__c == '4165'){ //Step 0 – End
                System.debug('*********** DENTRO PRIMO IF');
                sendEmailForwardAndTrackInadempimento(c2); 
                c2.F_T_Sent_Count__c = c2.F_T_Sent_Count__c != null ? c2.F_T_Sent_Count__c+2 : 2;
                c2.Status='F&T Sent';
                c2.Stage_Inadempimento__c = '4166';// Step 1 - Start
                Group filialeVerifica = [SELECT Type,DeveloperName FROM GROUP WHERE Type='Queue' AND DeveloperName = 'Q72']; // Q72 = 'INADEMPIMENTO VERIFICA FILIALI'
                c2.OwnerId = filialeVerifica.Id;
            }
            else if(c2.Stage_Inadempimento__c == '4164'){ //Step 0 – Start
                
            }
            else if(c2.Stage_Inadempimento__c == '4166'){ //Step 1 – Start
             /*   sendEmailForwardAndTrackInadempimento(c2); 
                c2.F_T_Sent_Count__c = c2.F_T_Sent_Count__c != null ? c2.F_T_Sent_Count__c+2 : 2;
                c2.Status='F&T Sent';
                Group filialeVerifica = [SELECT Type,DeveloperName FROM GROUP WHERE Type='Queue' AND DeveloperName = 'Q72']; // Q72 = 'INADEMPIMENTO VERIFICA FILIALI'
                c2.OwnerId = filialeVerifica.Id;*/
            }
            else if(c2.Stage_Inadempimento__c == '4167'){ //Step 1 – End
                if(c2.F_T_Sent_Count__c == c2.F_T_Received_Count__c){
                    	// FORWARD AND TRACK 2 GIRO 
                    //c2.F_T_Received_Count__c = FTReceived;
                    c2.F_T_Sent_Count__c = c2.F_T_Sent_Count__c != null ? c2.F_T_Sent_Count__c + 2 : 4;
                    c2.Stage_Inadempimento__c = '4169';
                    c2.Status = 'F&T Sent';
                }
                else
                {
                    //ERRORE NON POSSIBILE
                }
            }
            else if(c2.Stage_Inadempimento__c == '4168'){ //Step 2 – Start
                
            }
            else if(c2.Stage_Inadempimento__c == '6000'){ //Step 2 – F&T Sent
                
            }
            else if(c2.Stage_Inadempimento__c == '4170'){ //Step 2 – F&T Updated
                
            }
            else if(c2.Stage_Inadempimento__c == '4169'){ //Step 2 – F&T Waiting
                // mandare email gravita.
                /*
                sendEmailForwardAndTrackInadempimentoWaiting(c2); 
                c2.Status='F&T Sent';
                c2.F_T_Sent_Count__c = c2.F_T_Sent_Count__c != null ? c2.F_T_Sent_Count__c+2 : 2;
				*/
                //TODO: aggiungere creazione incidents, quando sarà chiarita la questione riguardante la filiale
            }
            else if(c2.Stage_Inadempimento__c == '4171'){ //End
                Group idmResponseStaff = [SELECT Type,DeveloperName FROM GROUP WHERE Type='Queue' AND DeveloperName = 'Q52']; // Reclami - IDM Response Staff 
                c2.OwnerId = idmResponseStaff.Id;
                c2.Inadempimento_Grave__c = false;
                c2.Status = 'Gestito';
                //String message = 'Chiusura Reclamo non Grave';
                //CollaborationGroup chatterGroup = [SELECT Id,Name FROM CollaborationGroup
			    //                               WHERE Name = 'Monitoraggio Dealer'
			    //                                            LIMIT 1];
                //metodo che invia un chatter feed a filiale e monitoraggio dealer
                //sendChatterMessWithTwoMentions(c.Id, c.Branch__c, chatterGroup.Id, message);
            }

            
        }
        else{
            c2.Stage_Inadempimento__c = '4171'; //End
            if(XCSCompassConstants.COMPASS.equals(c2.Referenced_Company__c))
                c2.OwnerId = [Select id from Group where developerName = 'Q52'].id;
            else if (XCSCompassConstants.FUTURO.equals(c2.Referenced_Company__c))
                c2.OwnerId = [Select id from Group where developerName = 'Q300'].id;
            else if (XCSCompassConstants.MBC.equals(c2.Referenced_Company__c))
                c2.OwnerId = [Select id from Group where developerName = 'Q343'].id;
        }
        /*
        Case c = new Case(Id = recordId,
                          Stage_Inadempimento__c = stageInadempimento,
                          F_T_Sent_Count__c = FTSent,
                          F_T_Received_Count__c = FTReceived,
                          Disposition__c = disp.id,
                          Inadempimento_Grave__c = gravita == 'DP2208'
                         );
        if(status != null) c.status = status; 
        */
        update c2;
        
        
        // e nel caso inviare la mail
        if(gravitaIsChanged){
            EmailTemplate email = [Select id, name, subject, body, developerName from EmailTemplate Where DeveloperName = 'Aggiornamento_inadempimento_scritto' limit 1];
            String esito = gravita == 'DP2208' ? ' NON GRAVE a GRAVE' : ' GRAVE a NON GRAVE';
            email.body = email.body.replace('{!esito}', esito);
            email.body = email.body.replace('{!riferimento}', c2.CaseNumber);
            email.body = email.body.replace('{!oggetto}', 'Aggiornamento inadempimento scritto');
            String dataCreazione = (c2.CreatedDate).format('d-MM-yyyy HH:mm');
            email.body = email.body.replace('{!dataCreazione}', dataCreazione);
            String dataUltimaModifica = (System.now()).format('dd-MM-yyyy HH:mm');
            email.body = email.body.replace('{!dataAggiornamento}', dataUltimaModifica);
            email.body = email.body.replace('{!Nome}', c2.Account.FirstName);
            email.body = email.body.replace('{!Cognome}', c2.Account.LastName);
            email.body = email.body.replace('{!CIP}', c2.Account.OCS_External_ID__c);
            email.body = email.body.replace('{!PraticaOCS}', c2.NumeroPratica__c );
            XCS_CompassParameters__c emailCambioGravita= [SELECT Id, Value__c, Name, CreatedDate FROM XCS_CompassParameters__c where name = 'inadempimento.cambioGravita' limit 1];
            String to = emailCambioGravita.Value__c;
            Messaging.SingleEmailMessage sendMail = new Messaging.SingleEmailMessage();
            List<String> listTo = new List<String>();
            if(to.contains(';')) listTo.addAll(to.split(';'));
            else listTo.add(to);
            sendMail.setToAddresses(listTo);
            sendMail.plaintextbody = email.Body;
            sendMail.setSubject(email.Subject);
         
            
            Messaging.SingleEmailMessage[] messages =  new List<Messaging.SingleEmailMessage> {sendMail};
              
            Messaging.sendEmail(messages);
            
        }
    }
    
    
    @AuraEnabled
    public static void sendEmailForwardAndTrackInadempimento(Case myCase){
        String fAndTbaseUrl = [SELECT Id, Value__c FROM XCS_CompassParameters__c WHERE Name = 'forwardandtrack.baseurl'][0].Value__c;
        String urlFAndTOscuro = fAndTbaseUrl+'?token='+SitesTokenUtil.generateToken(myCase.Id,datetime.now().addMinutes(400),'c:CRMReclamiInadempimentoForwardAndTrack','c:CRMReclamiInadempimentoForwardAndTrackApp', 'Oscuro');

        
        List<String> indirizzi = new List<String>();
        List<String> indirizzicc = new List<String>();
        String to = [SELECT Id, Value__c FROM XCS_CompassParameters__c WHERE name = 'reclami.inadempimento.oscuraPresenzaTO'].Value__c;	
       	String cc =  [SELECT Id, Value__c FROM XCS_CompassParameters__c WHERE name = 'reclami.inadempimento.oscuraPresenzaCC'].Value__c;
        EmailTemplate oscura = [SELECT Id, Name, Subject, body, DeveloperName FROM EmailTemplate Where DeveloperName='Aggiornamento_oscura_presenza'];
        if(to.contains(';')) indirizzi.addAll(to.split(';'));
        else    indirizzi.add(to);
        if(cc.contains(';')) indirizzicc.addAll(cc.split(';'));
        else    indirizzicc.add(cc);
        
         //to : reclami.out@compass.it // cc : monitoraggio.dealer@compass.it 
        //Case c = [SELECT Id, Numero_Reclamo__c FROM Case where id =: recordId];
        
        oscura.Subject = oscura.Subject.replace('{!numeroReclamo}', myCase.Numero_Reclamo__c);
        oscura.body = oscura.body.replace('{!link}', urlFAndTOscuro);
        
        Messaging.SingleEmailMessage email1 = new Messaging.SingleEmailMessage();       
        email1.setToAddresses(indirizzi);
        email1.setCcAddresses(indirizzicc);
        email1.setPlainTextBody(oscura.body);
        email1.setSubject(oscura.Subject);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email1});
        linkEmailToCase(email1, myCase.Id);
      
         
        
        // to : CentroRecuperoHome@compass.it cc : monitoraggio.dealer@compass.it 
        
    
        
        //EmailUtils.sendEmail(EmailUtils.generateEmailReclamiFandT(indirizzi, body_One, subject_One));
        //EmailUtils.sendEmail(EmailUtils.generateEmailReclamiFandT(indirizzi, body_Two, subject_Two));
        
        String urlFAndTSospeso = fAndTbaseUrl+'?token='+SitesTokenUtil.generateToken(myCase.Id,datetime.now().addMinutes(400),'c:CRMReclamiInadempimentoForwardAndTrack','c:CRMReclamiInadempimentoForwardAndTrackApp', 'Sospeso');

        EmailTemplate sospendere = [SELECT Id, Name, Subject, body, DeveloperName FROM EmailTemplate Where DeveloperName='Aggiornamento_Sospendere_Attivita'];
		sospendere.Subject = sospendere.Subject.replace('{!numeroReclamo}',myCase.Numero_Reclamo__c);
        sospendere.body = sospendere.body.replace('{!link}',urlFAndTSospeso);
        
        List<String> indirizzi2to = new List<String>();    
        List<String> indirizzi2cc = new List<String>();
        String to2 = [SELECT Id, Value__c FROM XCS_CompassParameters__c WHERE name = 'reclami.inadempimento.sospesoTO'].Value__c;	
        String cc2 =  [SELECT Id, Value__c FROM XCS_CompassParameters__c WHERE name = 'reclami.inadempimento.sospesoCC'].Value__c;
        
        if(to2.contains(';')) indirizzi2to.addAll(to2.split(';'));
        else    indirizzi2to.add(to2);
        if(cc2.contains(';')) indirizzi2cc.addAll(cc2.split(';'));
        else    indirizzi2cc.add(cc2);
        
        Messaging.SingleEmailMessage email2 = new Messaging.SingleEmailMessage();       
        email2.setToAddresses(indirizzi2to);
        email2.setCcAddresses(indirizzi2cc);
        email2.setPlainTextBody(sospendere.body);
        email2.setSubject(sospendere.Subject);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email2});
        linkEmailToCase(email2, myCase.Id);
        
        
        
    }
    
    @AuraEnabled
    public static void sendEmailForwardAndTrackInadempimentoWaiting(Case myCase){
        String fAndTbaseUrl = [SELECT Id, Value__c FROM XCS_CompassParameters__c WHERE Name = 'forwardandtrack.baseurl'][0].Value__c;
        String urlFAndT = fAndTbaseUrl+'?token='+SitesTokenUtil.generateToken(myCase.Id,datetime.now().addMinutes(400),'c:CRMReclamiInadempimentoForwardAndTrack','c:CRMReclamiInadempimentoForwardAndTrackApp');
        
        System.debug('urlFAndT = '+urlFAndT);
        
        List<String> indirizzi = new List<String>();
        String emailProva = 'daniele.segoloni@lynxspa.com';  //to : reclami.out@compass.it // cc : monitoraggio.dealer@compass.it 
        indirizzi.add(emailProva);
        //Case c = [SELECT Id, Numero_Reclamo__c FROM Case where id =: recordId];
        String subject_One = 'Reclamo '+myCase.Numero_Reclamo__c+' Procedere a cancellazione BD';
        String body_One = 'Cancellare dalle SIC le segnalazioni relative alla seguente pratica di finanziamento per la quale si è verificato un reclamo di inadempimento.'  
            + '\n' + 'Cliccare qui sotto per i dettagli e per confermare di aver gestito l attività.'
            + '\n' + urlFAndT;
        
        // to : CentroRecuperoHome@compass.it cc : monitoraggio.dealer@compass.it 
        String subject_Two = 'Reclamo '+myCase.Numero_Reclamo__c+' Bloccare definitivamente recupero';
        String body_Two = 'Bloccare definitivamente le azioni di recupero per la seguente pratica di finanziamento per la quale si è verificato un inadempimento.'
            + '\n' + 'Cliccare qui sotto per i dettagli e per confermare di aver gestito l attività.'
            + '\n' + urlFAndT;
        
        //EmailUtils.sendEmail(EmailUtils.generateEmailReclamiFandT(indirizzi, body_One, subject_One));
        //EmailUtils.sendEmail(EmailUtils.generateEmailReclamiFandT(indirizzi, body_Two, subject_Two));

        Messaging.SingleEmailMessage email1 = new Messaging.SingleEmailMessage();       
        email1.setToAddresses(indirizzi);
        email1.setPlainTextBody(body_One);
        email1.setSubject(subject_One);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email1});
        linkEmailToCase(email1, myCase.Id);

        Messaging.SingleEmailMessage email2 = new Messaging.SingleEmailMessage();       
        email2.setToAddresses(indirizzi);
        email2.setPlainTextBody(body_Two);
        email2.setSubject(subject_Two);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email2});
        linkEmailToCase(email1, myCase.Id);
        
    }
    public static void linkEmailToCase(Messaging.SingleEmailMessage email, Id caseId) {
        EmailMessage emailMsg = new EmailMessage(); // Created a EmailMessage and copy all details from above.
        emailMsg.ToAddress=(email.getToAddresses())[0];
        emailMsg.Subject=email.getSubject();
        emailMsg.HtmlBody=email.getHtmlBody();
        emailMsg.TextBody=email.getPlainTextBody();
        emailMsg.ParentId = caseId; //Attach with the case
        emailMsg.MessageDate = system.now();
        emailMsg.Status = '3'; // 3 = Sent
        insert emailMsg;
    }
    
    
    public class GestioneContainerDTO{
        @AuraEnabled
        public List<String> stageInadempimentoList=new List<String>();
    }
    
    public class GestioneInadempimento{
        @AuraEnabled
        public String gravita;
        @AuraEnabled
        public String stage;
        @AuraEnabled
        public Double FAndTSent;
        @AuraEnabled
        public Double FAndTReceived;
        @AuraEnabled
        public String filiale;
        @AuraEnabled
        public String disposition;
        @AuraEnabled
        public Boolean completo;
        
    }
    
    
}