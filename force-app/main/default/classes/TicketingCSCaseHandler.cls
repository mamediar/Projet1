public class TicketingCSCaseHandler {

    public TicketingCSCaseHandler(final TriggerData triggerData) {
        this.triggerData = triggerData;
        ticketingCsCaseList = (List<Case>) triggerData.itemList;
        final User user = [SELECT Alias, Branch_Or_Office__c FROM User WHERE Id = :UserInfo.getUserId()];
        userAlias = user.Alias;
        branch = user.Branch_Or_Office__c;
    }
    
    public String textDisposition(){
		String descDisposition;
        String cat1name;
        String cat2name;
        String cat3name;
        String Disp1Id;
        String Disp2Id;
        String Disp3Id;
        
		for (Case caseItem : ticketingCsCaseList) { 		 
            Disp1Id = caseItem.Categoria_TKTII__c== null ? '' : caseItem.Categoria_TKTII__c;
            Disp2Id = caseItem.Categoria2_TKTII__c== null ? '' : caseItem.Categoria2_TKTII__c;
            Disp3Id = caseItem.Categoria3_TKTII__c== null ? '' : caseItem.Categoria3_TKTII__c;
        }
        
        cat1name = Disp1Id!='' ? XCS_DispositionUtils.getDisposition(Disp1Id).name : '';
        cat2name = Disp2Id!='' ? XCS_DispositionUtils.getDisposition(Disp2Id).name : '';
        cat3name = Disp3Id!='' ? XCS_DispositionUtils.getDisposition(Disp3Id).name : '';
        descDisposition = 'Back Office Inbound/CS Evoluto/'+(cat1name!='' ? cat1name : '')
                                                           +(cat2name!='' ? '/'+cat2name : '')
                         								   +(cat3name!='' ? '/'+cat3name : '');
        
        return descDisposition;
    }

    public void gestisciClienteNonTrovatoByNum() {
        System.debug('---- gestisciClienteNonTrovatoByNum ----');
        
        for (Case caseItem : ticketingCsCaseList) {
            final Boolean ultimoTentativo = caseItem.TentativoNum__c >= MAX_NUM_TENTATIVO;
            gestisciClienteDaRichiamareByNum(caseItem, ultimoTentativo);
        }
        System.debug('---- gestisciClienteNonTrovatoByNum END ----');
    }

    public void gestisciRichiamaCliente() {
        System.debug('---- gestisciRichiamaCliente ----');
        
        for (Case caseItem : ticketingCsCaseList) {
            caseItem.Status = 'Pending';
            caseItem.TentativoNum__c = 0;
    
            XCS_Disposition__c dispToAssign = XCS_DispositionUtils.findDispositionByExternalID(CHIEDE_ESSERE_RICH_DISP);
            System.debug('XCS_Disposition: ' + dispToAssign);
            caseItem.Disposition__c = dispToAssign.Id;
    
            final String esito = textDisposition();    
    
            final String note = caseItem.Note__c == null ? '' : caseItem.Note__c;
            // Nota sul Case
            String ocsId = '';
            if (caseItem.AccountId <> null)
                ocsId = [SELECT Id, OCS_External_Id__c FROM Account WHERE Id =: caseItem.AccountId].OCS_External_Id__c;
    
            final String notaTemplate = 'cc-{0} - {1} - {2} - Note: {3}';
            final String notaCase = XCS_templateUtils.buildTemplate(notaTemplate, new List<String>{branch,userAlias,esito,note});
            System.debug('Inserisco nota sul Case: ' + notaCase);
            final Integer noteCount = XCSNoteUtils.getNoteCount(caseItem.Id);
            System.debug('noteCount: ' + noteCount);
            XCSNoteUtils.postANote(caseItem.Id, 'Nota - ' + String.valueOf(noteCount + 1), notaCase);
    
            // Nota su OCS
            final String ocsTemplate = 'Ticket CS II livello, richiesta CRM {0} - il cliente chiede di essere richiamato';
            final String notaOCS = XCS_templateUtils.buildTemplate(ocsTemplate, new List<String>{caseItem.CaseNumber});
            System.debug('Inserisco nota su OCS: ' + notaOCS);
            OCSGestioneNoteInvoker.filtraNote(userAlias, ocsId, caseItem.NumeroPratica__c, '', 'A', 'P', notaOCS);
        }
        System.debug('---- gestisciRichiamaCliente END ----');
    }

    public void gestisciChiusuraCase() {
        System.debug('---- gestisciChiusuraCase ----');
        
        for (Case caseItem : ticketingCsCaseList) {
            System.debug('Case in chiusura');
    
            final XCS_Disposition__c dispToAssign = [SELECT Id, External_Id__c, Name, Parent__c FROM XCS_Disposition__c WHERE Id =: caseItem.Disposition__c];
            final String esito = textDisposition();
    
            // Nota sul Case
            String ocsId = '';
            if (caseItem.AccountId <> null) {
                Account acc  = [SELECT Id, OCS_External_Id__c, Privacy_SMS__pc, PersonMobilePhone FROM Account WHERE Id =: caseItem.AccountId];
                ocsId = acc.OCS_External_Id__c;
            }
    
            final String notaTemplate = 'cc-{0} - {1} - {2}';
            final String notaCase = XCS_templateUtils.buildTemplate(notaTemplate, new List<String>{branch,userAlias,esito});
            System.debug('Inserisco nota sul Case: ' + notaCase);
            final Integer noteCount = XCSNoteUtils.getNoteCount(caseItem.Id);
            System.debug('noteCount: ' + noteCount);
            XCSNoteUtils.postANote(caseItem.Id, 'Nota - ' + String.valueOf(noteCount + 1), notaCase);
    
            // Nota su OCS
            final String ocsTemplate = 'Chiuso ticket CS II livello, richiesta CRM {0}. Esito {1}, Note: {2}';
            final String notaOCS = XCS_templateUtils.buildTemplate(ocsTemplate, new List<String>{caseItem.CaseNumber, esito, caseItem.Note__c == null ? '' : caseItem.Note__c});
            System.debug('Inserisco nota su OCS: ' + notaOCS);
            OCSGestioneNoteInvoker.filtraNote(userAlias, ocsId, caseItem.NumeroPratica__c, '', 'A', 'P', notaOCS);
        }
        System.debug('---- gestisciChiusuraCase END ----');
    }

    private void gestisciClienteDaRichiamareByNum(final Case caseItem, final Boolean ultimoTentativo) {
        System.debug('Ultimo tentativo: ' + ultimoTentativo);
        if (!ultimoTentativo) {
            Datetime tm = System.Now().addHours(1).addMinutes(30);
            System.debug('Imposto richiamata alle ' + tm);
            caseItem.RecallDate__c = tm;
        }
        
        final ConfigCaseCommonAction__c configCase = CaseUtils.getRecordByRecordtypeAndRange('Ticketing2', caseItem.TentativoNum__c.intValue());

        if (configCase == null) {
            System.debug('ConfigCaseCommonAction non trovato!');
            return;
        }
        caseItem.Status = configCase.CaseStatusToAssign__c;

        System.debug('Stato da assegnare: ' + configCase.CaseStatusToAssign__c);
        System.debug('Disposition da assegnare: ' + configCase.DispositionToAssign__c);

        XCS_Disposition__c dispToAssign = XCS_DispositionUtils.findDispositionByExternalID(configCase.DispositionToAssign__c);
        if (dispToAssign == null) {
            System.debug('Disposition da assegnare non trovata!');
            return;
        }
        System.debug('XCS_Disposition: ' + dispToAssign);
        caseItem.Disposition__c = dispToAssign.Id;

        final String noteTemplate = configCase.NoteTemplateDeveloperName__c;
        final String smsTemplate = configCase.SMSTemplateDeveloperName__c;
        final String ocsTemplate = configCase.OCSTemplateDeveloperName__c;

        String ocsId = '';
        Boolean privacySms = false;
        String personMobilePhone = '';
        if (caseItem.AccountId <> null) {
            Account acc  = [SELECT Id, OCS_External_Id__c, Privacy_SMS__pc, PersonMobilePhone FROM Account WHERE Id =: caseItem.AccountId];
            ocsId = acc.OCS_External_Id__c;
            privacySms = acc.Privacy_SMS__pc;
            personMobilePhone = acc.PersonMobilePhone;
        }

        if (String.isNotBlank(noteTemplate)) {
            System.debug('noteTemplate: ' + noteTemplate);
            List<XCS_Template__c> templates = XCS_TemplateUtils.getRecordByExternalIdList(new List<String>{noteTemplate});
            if (templates != null && templates.size() == 1) {
                XCS_Template__c templ = templates.get(0);
                System.debug('XCS_Template: ' + templ);
                
                final String dispHierarchy = textDisposition();
                final String nota = XCS_templateUtils.buildTemplate(templ.Body__c, new List<String>{branch,userAlias,dispHierarchy,String.valueOf(caseItem.TentativoNum__c.intValue())});
                System.debug('Inserisco nota sul Case: ' + nota);
                final Integer noteCount = XCSNoteUtils.getNoteCount(caseItem.Id);
                System.debug('noteCount: ' + noteCount);
                XCSNoteUtils.postANote(caseItem.Id, 'Nota - ' + String.valueOf(noteCount + 1), nota);
            }
            else {
                System.debug('Errore nel recupero della nota da inserire su Case');
            }
        }

        String messaggioSMS = null;

        if (privacySms && personMobilePhone <> null) {
            System.debug('Provo a inviare SMS');
            String smsTmpl = smsTemplate;
            if (ultimoTentativo) {
                smsTmpl = caseItem.TKTCSTipoProdotto__c == 'Carte' ? 'SMS5' : 'SMS4';
            }
            List<XCS_Template__c> templates = XCS_TemplateUtils.getRecordByExternalIdList(new List<String>{smsTmpl});
            if (templates != null && templates.size() == 1) {
                XCS_Template__c templ = templates.get(0);
                messaggioSMS = templ.Body__c;

                gestisciInvioSMS(caseItem, messaggioSMS, personMobilePhone, ocsId);
            }
            else {
                System.debug('Errore nel recupero del testo SMS da inviare');
            }
        }

        if (String.isNotBlank(ocsTemplate)) {
            System.debug('ocsTemplate: ' + ocsTemplate);
            List<XCS_Template__c> templates = XCS_TemplateUtils.getRecordByExternalIdList(new List<String>{ocsTemplate});
            if (templates != null && templates.size() == 1) {
                XCS_Template__c templ = templates.get(0);
                final String smsText = messaggioSMS != null ? messaggioSMS : '-- NESSUNO --';
                final String nota = XCS_templateUtils.buildTemplate(templ.Body__c, new List<String>{caseItem.CaseNumber, smsText});
                System.debug('Inserisco nota su OCS: ' + nota);
                OCSGestioneNoteInvoker.filtraNote(userAlias, ocsId, caseItem.NumeroPratica__c, '', 'A', 'P', nota);
            }
            else {
                System.debug('Errore nel recupero della nota OCS da inserire');
            }
        }
    }
       
    public void updateDispositionAndCategory() {
        XCS_Disposition__c dispToAssign = XCS_DispositionUtils.findDispositionByExternalID('DP1919');
        system.debug('DP dispToAssign: '+dispToAssign);
        XCS_Categoria__c catToAssign = XCS_CategoriaUtil.findCategoryByExternalID('1036');
        system.debug('DP catToAssign: '+catToAssign);

        for (Case caseItem : ticketingCsCaseList) { 
			caseItem.Disposition__c = dispToAssign.Id;            
            caseItem.Categoria_Riferimento__c = catToAssign.Id;
        }
    }
    
    public void updateSuPrimoInserimento() {
        System.debug('---- updateSuPrimoInserimento ----');

        Database.DMLOptions dmlOpts = new Database.DMLOptions();
   		dmlOpts.assignmentRuleHeader.useDefaultRule= true;
     
        List<Case> cases = new List<Case>();
        final Map<Account,Account> accountMap = new Map<Account,Account>();
        List<Id> accountIds = new List<Id>();

        for (Case caseItem : ticketingCsCaseList) { 
            Case cs = new Case(id=caseItem.Id);
            cs.setOptions(dmlOpts);
            cases.add(cs);

            Account acc = null;
        
            if (caseItem.PrivacyAccount__c)
                acc = new Account(Id=caseItem.AccountId, PersonMobilePhone=caseItem.SuppliedPhone, PersonEmail=caseItem.SuppliedEmail, Privacy_SMS__pc = true);
            else
                acc = new Account(Id=caseItem.AccountId, Privacy_SMS__pc = false);
            System.debug('Account:' + acc);

            accountMap.put(acc, acc);
            accountIds.add(caseItem.AccountId);
        }
        
        Database.upsert(cases);
        XCSGestioneAnagrafica.execute(accountMap, false, false);
        
        final List<Account> accounts = [SELECT Id, OCS_External_Id__c FROM Account WHERE Id IN :accountIds];
        final Map<Id, String> accountIdOcsIdMap = new Map<Id, String>();

        for (Account acc : accounts) {
            accountIdOcsIdMap.put(acc.Id, acc.OCS_External_Id__c);
        }

        final String descDisposition = textDisposition();
        final String notaTemplate = 'cc - {0} - {1} - Back Office Inbound / {2} / Ticket CS 2 Livello inserito - Consenso al ricontatto via Sms – Email: {3} - Categoria: {4}. Note: {5}';
        final String ocsTemplate = 'Generato ticket CS II livello, richiesta postvendita CRM {0} Fornito consenso al ricontatto via Sms – Email: {1} Categoria: {2}. Note: {3}';  

        for (Case caseItem : ticketingCsCaseList) { 
            final String flagPrivacy = caseItem.PrivacyAccount__c == false ? 'NO' : 'SI';

            //Nota sul Case
            final String notaCase = XCS_templateUtils.buildTemplate(notaTemplate, new List<String>{branch,
                                                                                                userAlias,
                                                                                                caseItem.TKTCSTipoProdotto__c,
                                                                                                flagPrivacy,
                                                                                                descDisposition,
                                                                                                caseItem.Description});
            
            XCSNoteUtils.postANote(caseItem.Id, 'Nota - 1 ' , notaCase);

            // Nota su OCS
            String ocsId = accountIdOcsIdMap.get(caseItem.AccountId);
            
            System.debug('OCS ID: '+ ocsId);

            if (ocsId != null) {
                System.debug('INSERISCO NOTA OCS IN INSERT');
                final String notaOCS = XCS_templateUtils.buildTemplate(ocsTemplate, new List<String>{caseItem.Id,
                                                                                                    flagPrivacy,
                                                                                                    descDisposition,
                                                                                                    caseItem.Description
                                                                                                    });
                System.debug('DP Inserisco nota su OCS: ' + notaOCS);
                OCSGestioneNoteInvoker.filtraNote(userAlias, ocsId, caseItem.NumeroPratica__c, '', 'A', 'P', notaOCS);
            }
        }

        System.debug('---- updateSuPrimoInserimento END ----');
    }
    
    public void handleInviaSMS() {
        System.debug('---- START handleInviaSMS ----');
        
        List<Case> cases = new List<Case>();
        List<Id> accIds = new List<Id>();
        
        for (Case caseItem : ticketingCsCaseList) {
            accIds.add(caseItem.AccountId);
        }
        
        List<Account> accs = [SELECT Id, PersonMobilePhone, OCS_External_Id__c FROM Account where Id IN :accIds];
        Map<Id, String> accIdPhoneMap = new Map<Id, String>();
        final Map<Id, String> accountIdOcsIdMap = new Map<Id, String>();
        
        for (Account acc : accs) {
            accIdPhoneMap.put(acc.Id, acc.PersonMobilePhone);
            accountIdOcsIdMap.put(acc.Id, acc.OCS_External_Id__c);
        }
         
        for (Case caseItem : ticketingCsCaseList) { 
            Case c = new Case(Id=caseItem.Id);
            if (accIdPhoneMap.get(caseItem.AccountId) <> null)
            	c.SuppliedPhone = accIdPhoneMap.get(caseItem.AccountId);
            
            cases.add(c);
            String ocsId = accountIdOcsIdMap.get(caseItem.AccountId);
            String smsTesto = caseItem.UltimoSMSInviato__c;
            gestisciInvioSMS(caseItem, smsTesto, c.SuppliedPhone, ocsId);
        }
        update cases;
        
        System.debug('---- END handleInviaSMS ----');
    }

    private void gestisciInvioSMS(Case caseItem, String smsTesto, String personMobilePhone, String ocsId) {
        
        final String flagPrivacy = caseItem.PrivacyAccount__c == false ? 'NO' : 'SI';

        if(personMobilePhone <> null) {
            System.debug('Invio al numero ' + personMobilePhone + ' SMS: ' + smsTesto);
            OCSInviaSMSInvoker.inviaSMS('', personMobilePhone, '', '', smsTesto);
        }
        else {
            System.debug('personMobilePhone null: nessun SMS da inviare');
        }
        
        // Nota sul Case
        final String nota = XCS_templateUtils.buildTemplate(notaTemplateSMS, new List<String>{branch,userAlias,smsTesto,flagPrivacy});
        System.debug('Inserisco nota sul Case: ' + nota);
        final Integer noteCount = XCSNoteUtils.getNoteCount(caseItem.Id);
        System.debug('noteCount: ' + noteCount);
        XCSNoteUtils.postANote(caseItem.Id, 'Nota - ' + String.valueOf(noteCount + 1), nota);
        
        // Nota OCS
        System.debug('OCS ID: '+ ocsId);
        if (ocsId != null) {
            final String notaOcs = XCS_templateUtils.buildTemplate(ocsTemplateSMS, new List<String>{caseItem.Id,smsTesto,flagPrivacy});
            System.debug('Inserisco nota su OCS: ' + notaOcs);
            OCSGestioneNoteInvoker.filtraNote(userAlias, ocsId, caseItem.NumeroPratica__c, '', 'A', 'P', notaOcs);
        }    
    }

    private TriggerData triggerData;
    private final List<Case> ticketingCsCaseList;
    private static final Integer MAX_NUM_TENTATIVO = 5;
    private final static String NON_RISP_AL_TEL_DISP = 'DP1989';
    private final static String CHIEDE_ESSERE_RICH_DISP = 'DP1990';
    private final static String IRREPER_DISP = 'DP1991';
    private final String notaTemplateSMS = 'cc - {0} - {1} - {2} - Consenso al ricontatto via SMS: {3}';
    private final String ocsTemplateSMS = 'Richiesta CRM {0}, inviato SMS {0}. Fornito consenso al ricontatti via Sms: {0}';
    
    private String userAlias;
    private String branch;
}