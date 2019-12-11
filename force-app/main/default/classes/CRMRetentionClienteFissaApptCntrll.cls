public class CRMRetentionClienteFissaApptCntrll {
    
    @AuraEnabled
    public static boolean doRetentionSpecificAction(Event evento, String tasso, String obiezione,String caseId){
        
        List<String> listNoteValue = new List<String>();
        String tassoObiezioneNoteValue = '';
        String roleUserName = [select name from UserRole where id = :userInfo.getUserRoleId()].name;
        String aliasUser = [SELECT Alias FROM User Where Id = :userinfo.getUserId()].Alias;
        String noteCase = '';
        event evt = new event(id = evento.id,note__c = evento.note__c,case__c = caseId);
        Account acc = [SELECT FirstName,Lastname,getCodice_Cliente__c from Account where id = :evento.Customer__c ][0];
        Boolean checkSendEmail = false;
        Case caso = [Select id,ownerid,Retention_CodiceCausaleConteggio__c,Retention_DataConteggio__c from Case where Id = :caseId];
        String concatSegnapostoDueBody = '';
        Group codaCorrente = [Select id,Developername from Group where id = :caso.ownerId];
       	List<tfr_config_mail__mdt> tcmList = [Select queue_id__c,tasso__c from tfr_config_mail__mdt where queue_Id__c = :codaCorrente.DeveloperName];
        tfr_config_mail__mdt tcm;
        List<String> replaceSubject = new List<String>();
        if(!tcmList.isEmpty())
        {
            tcm = tcmList[0];
        }
        replaceSubject.add('Q368'.equals(codaCorrente.developername) ? 'CONTRASTO ALLE ESTINZIONI APT FISSATO Cliente' : 'Appuntamento retention');
        List<sObject> listObjectToUpdate = new list<sObject>();
        List<String> listFilialeOCSId = new List<String>();
      
        replaceSubject.add(acc.lastName);
        replaceSubject.add(acc.FirstName);
        if('Q368'.equals(codaCorrente.developername) && '101'.equals(caso.Retention_CodiceCausaleConteggio__c))
        {
            replaceSubject.add(acc.getCodice_Cliente__c + 'Cliente Banca.');
        }
        else
        {
            replaceSubject.add(acc.getCodice_Cliente__c);
        }
        List<String> replaceBody = new List<String>();
		replaceBody.add(evento.StartDateTime.format('dd/MM','Europe/Rome'));
		replaceBody.add(evento.StartDateTime.format('HH:mm','Europe/Rome'));        
        listFilialeOCSId.add([SELECT Branch__r.OCS_External_Id__c FROM XCS_Desk__c where id = :evento.Desk__c].Branch__r.OCS_External_Id__c);
        XCS_Disposition__c dispo = XCS_DispositionUtils.findDispositionByExternalID(XCS_DispositionUtils.APPUNTAMENTO_FISSATO_ESITO);
      //  NOTE_RETENTION_FISSA_APPUNTAMENTO
      	XCS_Template__c templateEmail = XCS_TemplateUtils.getRecordByName(CRMRetentionutil.EMAIL_RETENTION_FISSA_APPUNTAMENTO_FILIALE);
        Case caseRetention = new Case(
            							Id = caseId,
            							Status = CaseUtils.CHIUSO,
            							disposition__c = dispo.Id
        							 );
        Datetime dt;
        if('Q368'.equals(codaCorrente.developername) && caso.Retention_DataConteggio__c != null){
            dt = caso.Retention_DataConteggio__c;
            concatSegnapostoDueBody += 'Ricontattato a seguito emissione conteggio da parte vostra in data : ' + dt.format('dd/MM/yyyy','Europe/Rome') + '<br/>';
        }
        if('Q368'.equals(codaCorrente.developername) && '101'.equals(caso.Retention_CodiceCausaleConteggio__c))
        {
            concatSegnapostoDueBody += 'Trattasi di cliente bancario. <BR/>';
        }
        if(!'default'.equals(tasso))
        {
            system.debug('TASSO');
            caseRetention.Retention_Tasso__c = tasso;
            evt.Note__c += '\nTasso:+' + tasso +'% ';
            tassoObiezioneNoteValue += 'Tasso:+' + tasso + '% ';
            concatSegnapostoDueBody += 'comunicato tasso: ' + tasso + '%';
            checkSendEmail = true;
        }
        replaceBody.add(concatSegnapostoDueBody);

        if(!'default'.equals(obiezione))
        {
            system.debug('OBIEZIONE');
            caseRetention.Retention_Obiezione__c = obiezione;
            evt.Note__c += '\nObiezione del cliente=' + obiezione;
            tassoObiezioneNoteValue += 'Obiezione del cliente=' + obiezione;
            replaceBody.add('Obiezione del cliente= ' + obiezione);
        }
        else
        {
            replaceBody.add('');
        }
        listNoteValue.add(roleUserName);
        listNoteValue.add(aliasUser);
        listNoteValue.add(XCS_DispositionUtils.getParentHierarchy('', dispo ) + dispo.Name);
        listNoteValue.add(tassoObiezioneNoteValue);
        noteCase = XCS_TemplateUtils.buildTemplateByName(CRMRetentionUtil.NOTE_RETENTION_FISSA_APPUNTAMENTO,listNoteValue);
        listObjectToUpdate.add(caseRetention);
        listObjectToUpdate.add(evt);
        update listObjectToUpdate;
		XCSNoteUtils.postANote(caseId,XCSNoteUtils.SYSTEM_NOTE_TITLE,noteCase);
        if(checkSendEmail || (tcm != null && tcm.tasso__c)){
            String OCSIdFiliale = [SELECT Branch__r.OCS_External_Id__c FROM XCS_Desk__c where id = :evento.Desk__c].Branch__r.OCS_External_Id__c;
            RoleUtils.mapNomeIndirizziEmail mappaEmailFiliali = RoleUtils.recordMapExternalIdEmail(listFilialeOCSId);
            list<String> lS = new List<String>();
            String bccAddress = CompassParametersUtils.getValue('email.bccAppuntamentoFiliale');
            List<String> bccAddressList = String.isBlank(bccAddress) ? new List<String>() : bccAddress.split(';');
            //lS.add(CompassParametersUtils.getValue('email.bccAppuntamentoFiliale'));
            Messaging.SingleEmailMessage em = Emailutils.generateEmailNoEmailTemplate(new list<String>{mappaEmailFiliali.emailFiliali.get(OCSIdFiliale)}, new list<String>{mappaEmailFiliali.emailManagerFiliali.get(OCSIdFiliale)},(CompassParametersUtils.getValue('email.bccAppuntamentoFiliale').split(';')), XCS_TemplateUtils.buildTemplate(templateEmail.subject__c,replaceSubject), XCS_TemplateUtils.buildTemplate(templateEmail.body__c,replaceBody));
        	System.debug('Email :' + em);
            EmailUtils.sendEmail(em);
        }
        System.debug('event : ' + evento);
        System.debug('tasso : ' + tasso);
        System.debug('obiezione : ' + obiezione);
        System.debug('caseId : ' + caseId);
        System.debug('ACCOUNT :' + evento.Customer__r.OCS_External_Id__c);
        return true;
    }

}