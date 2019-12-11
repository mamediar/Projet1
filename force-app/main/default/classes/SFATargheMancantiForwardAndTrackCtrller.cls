public class SFATargheMancantiForwardAndTrackCtrller {
	@AuraEnabled
    public static List<SelectOption> getEsiti() {
        
        List<TargheMancantiFandTEsitiConfig__mdt> lstEsiti = 
            [SELECT Id, DeveloperName, Label FROM TargheMancantiFandTEsitiConfig__mdt];
        
        List<SelectOption> lstSelectOption = new List<SelectOption>();

        SelectOption selectOption = new SelectOption('Seleziona l\'esito', '', 'true');
		lstSelectOption.add(selectOption);
        
        for (TargheMancantiFandTEsitiConfig__mdt esito : lstEsiti) {
			SelectOption so = new SelectOption(esito.Label, esito.DeveloperName, 'false');
			lstSelectOption.add(so);
		}
                                                                                                          
        return lstSelectOption;
    }

	@AuraEnabled
    public static DatiPratica getPratica(String praticaId) {
        
        SFATargaMancante__c targaMancante = 
            [SELECT Id, Name, NumeroPratica__c, DescrizioneCliente__c, Targa__c, Telaio__c, 					DataLiquidazione__c, DescrizioneBene__c, NotaFiliale__c, EsitoAgenziaItalia__c
			 FROM SFATargaMancante__c
			 WHERE Id = :praticaId][0];

		DatiPratica pratica = new DatiPratica();
		pratica.numeroPratica = targaMancante.NumeroPratica__c;
		pratica.dataLiquidazione = String.valueOf(targaMancante.DataLiquidazione__c);
		pratica.cliente = targaMancante.DescrizioneCliente__c;
		pratica.targa = targaMancante.Targa__c;
		pratica.telaio = targaMancante.Telaio__c;
		pratica.descrizioneBene = targaMancante.DescrizioneBene__c;
		pratica.notaFiliale = targaMancante.NotaFiliale__c;
		pratica.esitoAgenziaItalia = targaMancante.EsitoAgenziaItalia__c;

		//System.debug('*** pratica :: ' + JSON.serialize(pratica));
                                                                                                          
        return pratica;
    }

	@AuraEnabled
    public static void updatePratica(String praticaId, String esito, String nota) {
        
        SFATargaMancante__c targaMancante = 
            [SELECT Id, EsitoAgenziaItalia__c, NotaAgenziaItalia__c, DataAggiornamentoAgenziaItalia__c
			 FROM SFATargaMancante__c
			 WHERE Id = :praticaId][0];

		targaMancante.EsitoAgenziaItalia__c = esito;
		targaMancante.NotaAgenziaItalia__c = nota;
		targaMancante.DataAggiornamentoAgenziaItalia__c = DateTime.now();
		update targaMancante;

		String emailTemplate='SFA_TargheMancanti_ConfermaPraticaFandTPerGDV';
		List<String> lstEmail= new List<String>();
		String emailGDV = CompassParametersUtils.getValue('gdv.mail');
		String emailAgenziaItalia = CompassParametersUtils.getValue('agenziaitalia.mail');
		lstEmail.add(emailGDV);
		Messaging.SingleEmailMessage messageMail = EmailUtils.generateEmail(emailTemplate, lstEmail, Id.valueOf(praticaId));  
		messageMail.setSenderDisplayName(emailAgenziaItalia);
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] {messageMail});
                                                                                            
    }

	public class DatiPratica {
		@AuraEnabled
		public String numeroPratica {get; set;}
		@AuraEnabled
		public String dataLiquidazione {get; set;}
        @AuraEnabled
		public String cliente {get; set;}
		@AuraEnabled
		public String targa {get; set;}
        @AuraEnabled
		public String telaio {get; set;}
		@AuraEnabled
		public String descrizioneBene {get; set;}
        @AuraEnabled
		public String notaFiliale {get; set;}
		@AuraEnabled
		public String esitoAgenziaItalia {get; set;}
	}

    public class SelectOption {

		public SelectOption(String label, String text, String value) {
			this.label = label;
			this.text = text;
			this.value = value;
		}

		@AuraEnabled
		public String label { get; set; }
		@AuraEnabled
		public String text { get; set; }
		@AuraEnabled
		public String value { get; set; }
	} 
}