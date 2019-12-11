public class SFAConvenzionamentoGestSegnDealerCtrller {

    @AuraEnabled
    public static DatiDealerSegnalato getDealerSegnalato(String caseId) {

		DatiDealerSegnalato datiDealerSegnalato = new DatiDealerSegnalato();

		String dealerSegnalatoId = 
			[SELECT Id, AccountId 
			FROM Case 
			WHERE Id = :caseId][0].AccountId;

		Account dealerSegnalato = 
			[SELECT Id, Codice_Fiscale__c, Partita_IVA__c, BancaSegnalatrice__c, Macroarea__c, ProdottoDominanteMacroarea__c, Name, ShippingStreet, ShippingPostalCode, ShippingState, ShippingCity, Dealership_Code__c, RecordTypeId
			FROM Account 
			WHERE Id = :dealerSegnalatoId AND RecordType.Name = 'Dealer'][0];

		List<Contact> lstContattiDealerSegnalato = 
			[SELECT Email, MobilePhone, Phone FROM Contact WHERE AccountId = :dealerSegnalatoId];

		datiDealerSegnalato.dealerId = dealerSegnalato.Id;
		datiDealerSegnalato.recordTypeId = dealerSegnalato.RecordTypeId;
		datiDealerSegnalato.ragioneSociale = dealerSegnalato.Name;
		datiDealerSegnalato.indirizzo = dealerSegnalato.ShippingStreet + ' - ' + dealerSegnalato.ShippingPostalCode + ' - ' + dealerSegnalato.ShippingCity + ' - ' + dealerSegnalato.ShippingState;
		datiDealerSegnalato.codiceFiscale = dealerSegnalato.Codice_Fiscale__c;
		datiDealerSegnalato.partitaIva = dealerSegnalato.Partita_IVA__c;
		datiDealerSegnalato.codiceAccordo = String.valueOf(dealerSegnalato.Dealership_Code__c);
		datiDealerSegnalato.bancaSegnalatrice = dealerSegnalato.BancaSegnalatrice__c;
		datiDealerSegnalato.macroarea = dealerSegnalato.Macroarea__c;
		datiDealerSegnalato.prodottoDominante = dealerSegnalato.ProdottoDominanteMacroarea__c;
		if (lstContattiDealerSegnalato.size() > 0) {
			datiDealerSegnalato.email = lstContattiDealerSegnalato[0].Email;
			datiDealerSegnalato.telefonoFisso = lstContattiDealerSegnalato[0].Phone;
			datiDealerSegnalato.telefonoCellulare = lstContattiDealerSegnalato[0].MobilePhone;
		}

		return datiDealerSegnalato;
		
	}

	@AuraEnabled
    public static String manageCaseWithNewDisposition(String caseId, XCS_Disposition__c disposition, String macroarea, String prodottoDominante, String note) {

		System.debug('*** note :: ' + note);
		System.debug('*** disposition :: ' + JSON.serialize(disposition));
		System.debug('*** macroarea :: ' + macroarea);
		System.debug('*** prodottoDominante :: ' + prodottoDominante);

		Case c = [SELECT Id, AccountId, ActivityType__c, Status, Esito__c, Subject, Disposition__c, Note__c FROM Case WHERE Id = :caseId][0];

		String dealerSegnalatoId = c.AccountId;

		Account dealerSegnalato = 
			[SELECT Id, Codice_Fiscale__c, Partita_IVA__c, BancaSegnalatrice__c, Macroarea__c, ProdottoDominanteMacroarea__c, Name, ShippingStreet, ShippingPostalCode, ShippingState, ShippingCity, Dealership_Code__c
			FROM Account 
			WHERE Id = :dealerSegnalatoId AND RecordType.Name = 'Dealer'][0];

		dealerSegnalato.Macroarea__c = macroarea;
		dealerSegnalato.ProdottoDominanteMacroarea__c = prodottoDominante;

		update dealerSegnalato;

		if ('AO310'.equals(disposition.External_Id__c) || 'AO311'.equals(disposition.External_Id__c) || 'AO312'.equals(disposition.External_Id__c) || 'AO313'.equals(disposition.External_Id__c) || 'AO316'.equals(disposition.External_Id__c)) {

			c.Status = CaseUtils.CHIUSO;

		}
		
		else if ('AO314'.equals(disposition.External_Id__c)) {
			c.Status = CaseUtils.APERTO;
		}

		else if ('AO315'.equals(disposition.External_Id__c)) {
			c.ActivityType__c = CaseUtils.SFA_NEW_DEALER_PROSPECT;
            c.Categoria_Riferimento__r=XCS_CategoriaUtil.getCategoryForExternalId(XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_NEW_DEALER_PROSPECT);
			c.Status = CaseUtils.APERTO;
			c.Subject = CaseUtils.SFA_SUBJECT_NEW_DEALER_PROSPECT;
			c.StepAttivitaConvenzionamento__c = SFAConvenzionamento.NewDealerProspect_StepIniziale;
		}

		c.Disposition__c = disposition.Id;

		if(!String.isEmpty(note)) {
			c.Note__c = note;
            XCSNoteUtils.postANote(caseId,'Nota - '+disposition.Name,!String.isEmpty(note)?note:'');
        }

		update c;

		Case updatedCase = [SELECT Id, Categoria_Riferimento__r.External_Id__c FROM Case WHERE Id = :caseId][0];

		return updatedCase.Categoria_Riferimento__r.External_Id__c;

	}

	public class DatiDealerSegnalato {

        @AuraEnabled
		public String dealerId {get; set;}
		@AuraEnabled
		public String recordTypeId {get; set;}
		@AuraEnabled
		public String ragioneSociale {get; set;}
        @AuraEnabled
		public String indirizzo {get; set;}
		@AuraEnabled
		public String codiceFiscale {get; set;}
        @AuraEnabled
		public String partitaIva {get; set;}
        @AuraEnabled
		public String codiceAccordo {get; set;}
        @AuraEnabled
		public String email {get; set;}
		@AuraEnabled
		public String bancaSegnalatrice {get; set;}
        @AuraEnabled
		public String macroarea {get; set;}
		@AuraEnabled
		public String prodottoDominante {get; set;}
        @AuraEnabled
		public String telefonoFisso {get; set;}
		@AuraEnabled
		public String telefonoCellulare {get; set;}

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