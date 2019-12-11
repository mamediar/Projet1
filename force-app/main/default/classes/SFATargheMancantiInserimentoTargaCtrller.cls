public class SFATargheMancantiInserimentoTargaCtrller {
	
	@AuraEnabled
	public static DateScadenzaPratica getDateScadenza(String praticaId) {
		SFATargaMancante__c pratica = [SELECT Id, DataTermineLavoro__c, DataTermineScadenziario__c, NumeroPratica__c, IdAttivita__c 
									   FROM SFATargaMancante__c
									   WHERE Id = :praticaId][0];

		String idAttivita = pratica.IdAttivita__c;

		Case attivita = [SELECT Id, ActivityType__c, Status, Esito__c FROM Case WHERE Id = :idAttivita][0];

		DateScadenzaPratica dateScadenzaPratica = new DateScadenzaPratica();
		dateScadenzaPratica.dataTermineLavoro = pratica.DataTermineLavoro__c;
		dateScadenzaPratica.dataTermineScadenziario = pratica.DataTermineScadenziario__c;
		dateScadenzaPratica.numeroPratica = pratica.NumeroPratica__c;
		dateScadenzaPratica.caseStatus = attivita.Status;
		return dateScadenzaPratica;
	}

	@AuraEnabled
	public static OCS_OCS_COPSVDTA_V1Response callAggiornaDati(Integer numeroPratica, String targa, String telaio, String marca, String modello, Integer cilindrata, String dataImmatricolazione) {
		OCS_OCS_COPSVDTA_V1Response response = OCS_OCS_COPSVDTA_V1Invoker.callAggiornaDati(numeroPratica, targa, telaio, marca, modello, cilindrata, dataImmatricolazione);
		//System.debug('*** response :: ' + JSON.serialize(response));
		return response;
	}

	@AuraEnabled
	public static void completaPratica(String praticaId, String targa, String telaio, String notaFiliale){
		SFATargaMancante__c pratica = 
			[SELECT Id, IdAttivita__c, Targa__c, Telaio__c, NotaFiliale__c, DataAggiornamentoOCS__c
			 FROM SFATargaMancante__c
			 WHERE Id = :praticaId][0];

		String caseId = pratica.IdAttivita__c;

		pratica.Targa__c = targa;
		pratica.Telaio__c = telaio;
		pratica.NotaFiliale__c = notaFiliale;
		pratica.DataAggiornamentoOCS__c = Date.today();

		update pratica;

		Case case1 = [SELECT Id, Status, Esito__c FROM Case WHERE Id = :caseId][0];
		case1.Status = 'Closed';
		case1.Esito__c = 'Completato';

		update case1;
	}

	@AuraEnabled
	public static void completaPraticaEntroScadenziario(String praticaId, String targa, String telaio, String notaFiliale){

		SFATargaMancante__c pratica = 
			[SELECT Id, IdAttivita__c, Targa__c, Telaio__c, NotaFiliale__c, UrlFAndT__c, DataInvioFAndT__c
			 FROM SFATargaMancante__c
			 WHERE Id = :praticaId][0];

		String caseId = pratica.IdAttivita__c;
		String fAndTbaseUrl = [SELECT Id, Value__c FROM XCS_CompassParameters__c WHERE Name = 'forwardandtrack.baseurl'][0].Value__c;
		String urlFAndT = fAndTbaseUrl+'?token='+SitesTokenUtil.generateToken(Id.valueOf(praticaId),datetime.now().addMinutes(40),'c:SFATargheMancantiForwardAndTrack','c:SFATargheMancantiForwardAndTrackApp');

		pratica.Targa__c = targa;
		pratica.Telaio__c = telaio;
		pratica.NotaFiliale__c = notaFiliale;
		pratica.DataInvioFAndT__c = DateTime.now();
		pratica.UrlFAndT__c = urlFAndT;

		update pratica;

		Case case1 = [SELECT Id, Status, Esito__c FROM Case WHERE Id = :caseId][0];
		case1.Status = 'Closed';
		case1.Esito__c = 'Inoltrato Forward and Track';

		update case1;

		User u = [select DefaultQueueId__c from user where id=:userinfo.getuserid()][0]; 
        List<Account> filialeUser = [SELECT id, BusinessEmail__c 
                                  	 FROM Account WHERE RecordType.Name = 'Branch' AND OCS_External_Id__c = :u.DefaultQueueId__c];
          
        String emailTemplate='SFA_TargheMancanti_LavorazioneEntroScadenziario';
        List<String> lstToEmail= new List<String>();
		List<String> lstCcEmail= new List<String>();
        String emailAgenziaItalia= CompassParametersUtils.getValue('agenziaitalia.mail');
		String emailGDV= CompassParametersUtils.getValue('gdv.mail');
        lstToEmail.add(emailAgenziaItalia);
		lstCcEmail.add(emailGDV);
        Messaging.SingleEmailMessage messageMail = EmailUtils.generateEmail(emailTemplate,lstToEmail,lstCcEmail,praticaId); 
        messageMail.setSenderDisplayName(filialeUser[0].BusinessEmail__c);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {messageMail});
	  
	}

	@AuraEnabled
	public static void completaPraticaDopoScadenziario(String praticaId, String targa, String telaio, String notaFiliale){

		SFATargaMancante__c pratica = 
			[SELECT Id, IdAttivita__c, Targa__c, Telaio__c, NotaFiliale__c
			 FROM SFATargaMancante__c
			 WHERE Id = :praticaId][0];

		String caseId = pratica.IdAttivita__c;

		pratica.Targa__c = targa;
		pratica.Telaio__c = telaio;
		pratica.NotaFiliale__c = notaFiliale;

		update pratica;

		Case case1 = [SELECT Id, Status, Esito__c FROM Case WHERE Id = :caseId][0];
		case1.Status = 'Closed';
		case1.Esito__c = 'Inoltrato a GDV per termine scaduto';

		update case1;

		User u = [select DefaultQueueId__c from user where id=:userinfo.getuserid()][0]; 
        List<Account> filialeUser = [SELECT id, BusinessEmail__c 
                                  	 FROM Account WHERE RecordType.Name = 'Branch' AND OCS_External_Id__c = :u.DefaultQueueId__c];
          
        String emailTemplate='SFA_TargheMancanti_LavorazioneOltreScadenziario';
        List<String> lstEmail= new List<String>();
        String emailGDV= CompassParametersUtils.getValue('gdv.mail');
        lstEmail.add(emailGDV);
        Messaging.SingleEmailMessage messageMail = EmailUtils.generateEmail(emailTemplate,lstEmail,praticaId); 
        messageMail.setSenderDisplayName(filialeUser[0].BusinessEmail__c);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {messageMail});
	  
	}

	public class DateScadenzaPratica {
		@AuraEnabled
		public Date dataTermineLavoro {get; set;}
		@AuraEnabled
		public Date dataTermineScadenziario {get; set;}
		@AuraEnabled
		public String numeroPratica {get; set;}
		@AuraEnabled
		public String caseStatus {get; set;}
	}  
}