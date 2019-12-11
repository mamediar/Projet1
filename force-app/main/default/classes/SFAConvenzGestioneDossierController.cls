public class SFAConvenzGestioneDossierController {

	private static final String AT = 'AT';
	private static final String FL = 'FL';
	private static final String IS = 'IS';
	private static final String CH = 'CH';
	private static final String PV = 'PV';

	private static final Integer STATUS_NOT_AT_FL = -1;
	private static final Integer ACTIVATION_DATE_TOO_OLD = -2;
	private static final Integer DEALER_IS_PV = -3;
	private static final Integer CREA_ACCOLLO = -4;
	private static final Integer GESTIONE_ALTRO_UFFICIO = -5;
	private static final Integer DOSSIER_PRECEDENTE_ATTIVAZIONE = -6;
	private static final Integer STATUS_NOT_GESTITO = -7;

	private static final String NOT_ALL_MANDATORY_DOCS_SELECTED = 'M01';
	private static final String NOT_ALL_IDENTITY_DOCS_SELECTED = 'I01';
	private static final String NOT_ALL_ADDITIONAL_QUESTIONS_ANSWERED = 'A01';
	private static final String DEFAULT_ANSWER = '(Seleziona)';

	@AuraEnabled
	public static InitData checkDossierEsistente(String caseId) {

		System.debug('*** SFAConvenzGestioneDossierController - checkDossierEsistente()');

		InitData initData = new InitData();
        initData.isInManoAFiliale = true;

		Case currentCase = [SELECT Id, AccountId, Account.OCS_External_Id__c, CaseNumber FROM Case WHERE Id = :caseId][0];

		String dealerId = currentCase.AccountId;
		String dealerOCSExternalId = currentCase.Account.OCS_External_Id__c;

		System.debug('*** dealerId :: ' + dealerId);
		System.debug('*** dealerOCSExternalId :: ' + dealerOCSExternalId);

		initData.dealerId = dealerId;

		// da vedere
		StatoAttributoData sad = getStatoAttributoData(dealerOCSExternalId);
		System.debug('*** sad :: ' + JSON.serialize(sad));

		if (sad.errorCode < 0) {
			initData.errorCode = sad.errorCode; return initData; 
		}

		String tipoChecklist = getTipoChecklist(dealerId);
		System.debug('*** tipoChecklist :: ' + tipoChecklist);
		initData.tipoChecklist = tipoChecklist;

		if ('Q_PV'.equals(tipoChecklist)) {
			initData.errorCode = DEALER_IS_PV;  return initData;
		}

		aggiornaCollegati(dealerId, dealerOCSExternalId.Substring(1));

		Id queueMDId = GroupUtils.getQueue(SFAConvenzionamento.queueMD).Id;

		String utenteId = UserInfo.getUserId();
		String filialeQueue = [SELECT Id, DefaultQueueId__c FROM User WHERE Id = :utenteId][0].DefaultQueueId__c;
		System.debug('*** filialeQueue :: ' + filialeQueue);

		Id queueFilialeId = GroupUtils.getQueue(filialeQueue).Id;

		// eseguo la logica fino al punto 3 poi eseguo il punto 4, come segue
		XCS_Categoria__c categoria = XCS_CategoriaUtil.getCategoryForExternalId(XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_GESTIONE_DOSSIER_DEALER);

		System.debug('*** categoria :: ' + JSON.serialize(categoria));

		List<Case> lstDossierCaseEsistente = 
			[SELECT Id, CaseNumber, Categoria_Riferimento__r.External_Id__c, Status, StepAttivitaConvenzionamento__c
			FROM Case 
			WHERE AccountId = :dealerId AND Categoria_Riferimento__r.External_Id__c = :categoria.External_Id__c AND Status != :CaseUtils.ANNULLATO AND Status != :CaseUtils.CHIUSO
			ORDER BY CreatedDate DESC];

		for (Case c : lstDossierCaseEsistente) {
			if ( SFAConvenzionamento.GDD_DocumentiCollegati.equals(c.StepAttivitaConvenzionamento__c) || 
			     SFAConvenzionamento.GDD_DocumentiAddizionali.equals(c.StepAttivitaConvenzionamento__c) || 
			     SFAConvenzionamento.GDD_RiepilogoDocumentiMancanti.equals(c.StepAttivitaConvenzionamento__c) ) {

				c.StepAttivitaConvenzionamento__c = SFAConvenzionamento.GDD_DocumentiObbligatori;

			}
		}

		update lstDossierCaseEsistente;

		System.debug('*** lstDossierCaseEsistente :: ' + JSON.serialize(lstDossierCaseEsistente));

		Date today = Date.today();
		String numeroRiferimento = DateUtils.formatDateYYMMDD(today)+'-'+currentCase.CaseNumber;

		if (lstDossierCaseEsistente.size() == 1) {
			List<Dossier__c> lstDossierCorrente = [SELECT Id, Name, DataRiferimento__c, IdAttivita__r.AccountId FROM Dossier__c WHERE IdAttivita__c = :caseId ORDER BY CreatedDate DESC];
			if (lstDossierCorrente.size() == 0) {
				Dossier__c dossier = new Dossier__c();
				dossier.IdAttivita__c = caseId;
				dossier.Tipo__c = 'Dossier';
				dossier.TipoChecklist__c = tipoChecklist;
				dossier.DataRiferimento__c = sad.dataRiferimento;
				dossier.Name = numeroRiferimento;
				insert dossier; 
				initData.dossier = dossier;
			}
			else {
				initData.dossier = lstDossierCorrente[0];
			}
		}
		else if (lstDossierCaseEsistente.size() > 1) {
			
			Case dossierCaseEsistente = lstDossierCaseEsistente[1];
			List<Dossier__c> lstDossierEsistente = [SELECT Id, Name, DataRiferimento__c, IdAttivita__r.AccountId, IsCaseDossierEsistente__c FROM Dossier__c WHERE IdAttivita__c = :dossierCaseEsistente.Id ORDER BY CreatedDate DESC];
			if (lstDossierEsistente.size() > 0) {
				Dossier__c dossierEsistente = lstDossierEsistente.get(0);
				if (CaseUtils.GESTITO.equals(dossierCaseEsistente.status)) {
					System.debug('*** riga 88');
					if (sad.dataRiferimento > dossierEsistente.DataRiferimento__c) {
						Dossier__c dossier = new Dossier__c();
						dossier.IdAttivita__c = caseId;
						dossier.Tipo__c = 'Dossier';
						dossier.TipoChecklist__c = tipoChecklist;
						dossier.DataRiferimento__c = sad.dataRiferimento;
						dossier.Name = numeroRiferimento;
						insert dossier; 
						Case c = new Case();
						c.Id = caseId;
						c.ParentId = dossierCaseEsistente.Id;
						update c;
						initData.dossier = dossier;
					}
					else {
						initData.errorCode = CREA_ACCOLLO;
					}
				}
				else if ((CaseUtils.INOLTRATO.equals(dossierCaseEsistente.status) || CaseUtils.LAVORATA.equals(dossierCaseEsistente.status) || CaseUtils.SOSPESO.equals(dossierCaseEsistente.status)) && dossierCaseEsistente.ownerId == queueMDId) {
					Case c = new Case();
					c.Id = caseId;
					c.Status = CaseUtils.CHIUSO;
					update c;
					initData.errorCode = GESTIONE_ALTRO_UFFICIO;
				}
				else if ((CaseUtils.RICEVUTO.equals(dossierCaseEsistente.status) || CaseUtils.SOSPESO.equals(dossierCaseEsistente.status)) && dossierCaseEsistente.ownerId == queueFilialeId) {
					Case c = new Case();
					c.Id = caseId;
					c.Status = CaseUtils.CHIUSO;
					update c;
					if (sad.dataRiferimento > dossierEsistente.DataRiferimento__c) {
						initData.errorCode = DOSSIER_PRECEDENTE_ATTIVAZIONE;
					}
					else {
						// fai la navigazione al case esistente
						initData.nuovoCaseId = dossierCaseEsistente.Id;

						// Aggiorno il case mettendo quello già esistente e il suo dossier settando IsCaseDossierEsistente__c = true 
						dossierEsistente.IsCaseDossierEsistente__c = true;
						dossierEsistente.TipoChecklist__c = tipoChecklist;
						update dossierEsistente;

						initData.dossier = dossierEsistente;

					}
					
				}
			}
			
		}

		String utenteLavorazione = [SELECT Id, Utente_Lavorazione__c FROM Case WHERE Id = :caseId][0].Utente_Lavorazione__c;

		System.debug('*** utenteLavorazione :: ' + utenteLavorazione);

		if (utenteLavorazione == queueFilialeId || String.isBlank(utenteLavorazione))
			initData.isInManoAFiliale = true;
		else
			initData.isInManoAFiliale = false;

		System.debug('*** initData :: ' + JSON.serialize(initData));
		return initData;
	}
	
	@AuraEnabled
	public static StatoAttributoData getStatoAttributoData(String dealerOCSExternalId) {

		System.debug('*** dealerOCSExternalId :: ' + dealerOCSExternalId);

		StatoAttributoData sad = new StatoAttributoData();

		String codiceIntermediario = dealerOCSExternalId.Substring(1);

		OCSRecuperaLogAzioniIntermedResponse response = OCSRecuperaLogAzioniIntermedInvoker.recuperaLogAzioniIntermediario(codiceIntermediario);

		System.debug('*** getStatoAttributoData - response :: ' + JSON.serialize(response));

		List<OCSRecuperaLogAzioniIntermedResponse.Elenco> listaStati = response.recuperaLogAzioniIntermediarioResponse.elenco;

		if (listaStati != null) {
			for (Integer i=0; i<listaStati.size(); i++) {
				if (i == 0) {
					sad.stato = listaStati.get(i).stato;
					sad.attributo = listaStati.get(i).attributo;
					if (!AT.equals(sad.stato) && !FL.equals(sad.stato)) {
						sad.errorCode = STATUS_NOT_AT_FL;
						System.debug('*** riga 126');
						System.debug('*** getStatoAttributoData - sad :: ' + JSON.serialize(sad));
						return sad;
					}
					if (AT.equals(sad.stato)) {
						sad.dataRiferimento = DateUtils.parseFromYYYYMMDDString(listaStati.get(i).dataRiferimento);
						System.debug('*** getStatoAttributoData - sad :: ' + JSON.serialize(sad));
						System.debug('*** riga 131');
					}
				}
				else {
					String stato = listaStati.get(i).stato;
					if (AT.equals(stato))
						sad.dataRiferimento = DateUtils.parseFromYYYYMMDDString(listaStati.get(i).dataRiferimento);
					else if (IS.equals(stato))
						break;
				}
			}
		}

		/*Account dealer = [SELECT Id, DataRiferimento__c FROM Account WHERE OCS_External_Id__c = :dealerOCSExternalId][0];

		System.debug('*** dealer :: ' + JSON.serialize(dealer));

		dealer.DataRiferimento__c = sad.dataRiferimento;
		update dealer;*/

		if (sad.dataRiferimento.daysBetween(Date.today()) > 120)
			sad.errorCode = ACTIVATION_DATE_TOO_OLD;

		System.debug('*** getStatoAttributoData - sad :: ' + JSON.serialize(sad));
		return sad;

	}

	@AuraEnabled
	public static String getTipoChecklist(String dealerId) {
		String codiceAgente = 
			[SELECT Id, CodiceAgente__c, OCS_External_Id__c 
			FROM Account 
			WHERE RecordType.Name = 'Dealer' AND Id = :dealerId][0].CodiceAgente__c;
		List<SFA_Convenzionam_CanaleAgenti__mdt> lstTipoChecklist = [SELECT Id, DeveloperName, MasterLabel, Label, QualifiedApiName, Canale__c, nome_abbr__c, Codice_agente__c, tipo_quest__c FROM SFA_Convenzionam_CanaleAgenti__mdt WHERE Codice_agente__c = :codiceAgente];
		if (lstTipoChecklist.size() > 0 && String.isNotBlank(lstTipoChecklist.get(0).tipo_quest__c))
			return lstTipoChecklist.get(0).tipo_quest__c;
		else 
			return 'Q_CV';
	}

	/*@AuraEnabled
	public static Dossier__c getDossier(String caseId) {
		List<Dossier__c> lstDossier = 
			[SELECT Id, CreatedDate, IdAttivita__c, IdAttivita__r.AccountId
			FROM Dossier__c 
			WHERE IdAttivita__c = :caseId 
			ORDER BY CreatedDate DESC];

		if (lstDossier.size() == 0) {
			// crea nuovo dossier e lo torna
			Dossier__c dossier = new Dossier__c();
			dossier.IdAttivita__c = caseId;
			insert dossier;
			return dossier;
		}
		else {
			// ritorna il dossier più recente ordinato per CreatedDate
			return lstDossier[0];
		}

	}*/

	@AuraEnabled
	public static void aggiornaCollegati(String dealerId, String codiceCliente) {
		OCSCollegatiDealerRuoliResponse response = OCSCollegatiDealerRuoliInvoker.retrieveCollegatiDealerRuoli(codiceCliente);

        System.debug('*** OCSCollegatiDealerRuoliResponse :: ' + response);
		if (response.isOK() && response != null) {
			List<OCSCollegatiDealerRuoliResponse.DatiCollegatiDealerRuoliDTO> lstCollegati = response.datiCollegatiDealerRuoli;
			System.debug('*** OCSCollegatiResponse :: ' + lstCollegati);
			System.debug('*** lstCollegati :: ' + JSON.serialize(lstCollegati));

			List<AccountContactRelation> listACR = 
				[SELECT Id, isCollegatoEliminato__c
				FROM AccountContactRelation
				WHERE AccountId = :dealerId];

			for (AccountContactRelation acr : listACR) {
				acr.isCollegatoEliminato__c = true;
			}

			update listACR;

			List<String> lstCollegatiDaServizioOCSExternalId = new List<String>();

			/*List<String> lstCollegatiEsistentiOCSExternalId = new List<String>();
			List<Contact> lstCollegatiEsistenti = 
				[SELECT Id, OCS_External_Id__c 
				FROM Contact
				WHERE IsContactDiRiferimentoDealer__c = false];

			for (Contact collegatoEsistente : lstCollegatiEsistenti) {
				lstCollegatiEsistentiOCSExternalId.add(collegatoEsistente.OCS_External_Id__c);
			}*/

			List<Contact> lstNuoviCollegati = new List<Contact>();

			for (OCSCollegatiDealerRuoliResponse.DatiCollegatiDealerRuoliDTO collegato : lstCollegati) {
				Contact nuovoCollegato = new Contact();
				if (nuovoCollegato.AccountId == null)
					nuovoCollegato.AccountId = dealerId;
				nuovoCollegato.LastName = String.isNotBlank(collegato.cognome) ? collegato.cognome : 'N/A';
				nuovoCollegato.FirstName = collegato.nome;
				nuovoCollegato.OCS_External_Id__c = collegato.codCliente;
				lstNuoviCollegati.add(nuovoCollegato);
				lstCollegatiDaServizioOCSExternalId.add(collegato.codCliente);
			}

			System.debug('*** lstNuoviCollegati :: ' + JSON.serialize(lstNuoviCollegati));

			if (lstNuoviCollegati.size() > 0)
				upsert lstNuoviCollegati OCS_External_Id__c;

			List<Contact> lstAggiornataCollegatiEsistenti = [SELECT Id, OCS_External_Id__c FROM Contact WHERE OCS_External_Id__c IN :lstCollegatiDaServizioOCSExternalId];

			List<AccountContactRelation> lstNuovoACR = new List<AccountContactRelation>();

			List<AccountContactRelation> lstACRDirect = 
				[SELECT Id, AccountId, Contact.AccountId, Contact.OCS_External_Id__c, ContactId, Roles, CreatedDate, isCollegatoEliminato__c, IsDirect
				 FROM AccountContactRelation 
				 WHERE AccountId = :dealerId AND IsDirect = true];

			System.debug('*** lstACRDirect :: ' + JSON.serialize(lstACRDirect));

			Map<String, String> mapACRDirectIdOCSExternalId = new Map<String, String>();

			for (AccountContactRelation acr : lstACRDirect) {
				if (acr.Contact.OCS_External_Id__c != null)
					mapACRDirectIdOCSExternalId.put(acr.Contact.OCS_External_Id__c, acr.Id);
			}

			System.debug('*** mapACRDirectIdOCSExternalId :: ' + JSON.serialize(mapACRDirectIdOCSExternalId));

			for (Contact collegato : lstAggiornataCollegatiEsistenti) {
				for (OCSCollegatiDealerRuoliResponse.DatiCollegatiDealerRuoliDTO collegatoDaServizio : lstCollegati) {
					if (collegato.OCS_External_Id__c == collegatoDaServizio.codCliente) {


							List<String> lstRoles = new List<String>();

							AccountContactRelation nuovoACR = new AccountContactRelation();

							if (mapACRDirectIdOCSExternalId.containsKey(collegato.OCS_External_Id__c))
								nuovoACR.Id = mapACRDirectIdOCSExternalId.get(collegato.OCS_External_Id__c);
							else {
								nuovoACR.AccountId = dealerId;
								nuovoACR.ContactId = collegato.Id;
							}

							nuovoACR.isCollegatoEliminato__c = false;

							if (collegatoDaServizio.firmatario == 'S')
								lstRoles.add('FIR');
							if (collegatoDaServizio.rappresentante == 'S')
								lstRoles.add('RPP');
							if (collegatoDaServizio.referente == 'S')
								lstRoles.add('REF');
							if (collegatoDaServizio.socio == 'S')
								lstRoles.add('SOC');
							if (collegatoDaServizio.titolare == 'S')
								lstRoles.add('TIT');
							if (collegatoDaServizio.responsabileISVAP == 'S')
								lstRoles.add('REI');

							nuovoACR.Roles = String.join(lstRoles, ';');

							nuovoACR.isCollegatoEliminato__c = false;

							System.debug('*** nuovoACR.Roles :: ' + nuovoACR.Roles);

							System.debug('*** lstRoles.size() :: ' + lstRoles.size());

							if (lstRoles.size() > 0)
								lstNuovoACR.add(nuovoACR);


					}
				}
			}

			System.debug('*** lstNuovoACR :: ' + JSON.serialize(lstNuovoACR));

			upsert lstNuovoACR Id;
		}

	}

	@AuraEnabled
	public static DatiListaDocumenti getListeDocumenti(String caseId, Dossier__c dossier, String tipoConv) {

		System.debug('*** getListeDocumenti()');

		System.debug('*** caseId :: ' + caseId);
		System.debug('*** dossier :: ' + JSON.serialize(dossier));
		System.debug('*** tipoConv :: ' + tipoConv);

		String step = [SELECT Id, StepAttivitaConvenzionamento__c FROM Case WHERE Id = :caseId][0].StepAttivitaConvenzionamento__c;

		Date today = Date.today();

		String dealerId = dossier.IdAttivita__r.AccountId;
		String dossierId = dossier.id;
        
        System.debug('*** dossier.IdAttivita__c :: ' + dossier.IdAttivita__c);
        System.debug('*** dossierId :: ' + dossierId);

		List<SFAConvenzDealerDocumentsList__c> lstDocumenti = [SELECT Name, Id, IdDocument__c, CodDocument__c, Document__c, FlgEsclusione__c FROM SFAConvenzDealerDocumentsList__c];
		Map<String, String> mapDocumentiId = new Map<String, String>();

		for (SFAConvenzDealerDocumentsList__c documento : lstDocumenti) {
			mapDocumentiId.put(documento.IdDocument__c, documento.Id);
		}

		DatiListaDocumenti datiListaDocumenti = new DatiListaDocumenti();

		List<SFADossierDocumento__c> lstDossierDocumentoPresente = 
			[SELECT Id, Name 
			FROM SFADossierDocumento__c
			WHERE Dossier__c = :dossierId];

		List<String> lstRuoliCollegati = new List<String> {'FIR', 'RPP', 'TIT'};

		List<Contact> lstCollegati = SFAConvenzionamento.getCollegatiNonCancellati(dealerId, lstRuoliCollegati);
	
		if (lstDossierDocumentoPresente.size() == 0 || dossier.IsCaseDossierEsistente__c == true) {

			System.debug('*** lstDossierDocumentoPresente.size() == 0');

			XCSNoteUtils.postANote(caseId,SFAConvenzionamento.TITLE_NOTE_EVENTO,SFAConvenzionamento.NOTA_EVENTO_DOSSIER_INIZIOFILIALE);

			if (dossier.IsCaseDossierEsistente__c == true) {
				dossier.IsCaseDossierEsistente__c = false;
				update dossier;
				delete lstDossierDocumentoPresente;
			}

			List<SFAConvenzDealerDocumentsTipoConvCO__c> lstDocumentiObbligatori = 
				[SELECT Name, Id, IdDocumentTipoConv__c, IdxDocument__c, TipoConv__c, DateStart__c, DocumentType__c, DocumentDetails__c, DateEnd__c 
				FROM SFAConvenzDealerDocumentsTipoConvCO__c
				WHERE TipoConv__c = :tipoConv AND DocumentType__c = 'mandatory' AND DateStart__c <= today AND DateEnd__c >= today];

			System.debug('*** lstDocumentiObbligatori :: ' + JSON.serialize(lstDocumentiObbligatori));

			List<SFAConvenzDealerDocumentsTipoConvCO__c> lstDocumentiCollegati = 
				[SELECT Name, Id, IdDocumentTipoConv__c, IdxDocument__c, TipoConv__c, DateStart__c, DocumentType__c, DocumentDetails__c, DateEnd__c 
				FROM SFAConvenzDealerDocumentsTipoConvCO__c
				WHERE TipoConv__c = :tipoConv AND DocumentType__c = 'identity' AND DateStart__c <= today AND DateEnd__c >= today];

			System.debug('*** lstDocumentiCollegati :: ' + JSON.serialize(lstDocumentiCollegati));

			List<SFAConvenzDealerDocumentsTipoConvCO__c> lstDocumentiAddizionali = 
				[SELECT Name, Id, IdDocumentTipoConv__c, IdxDocument__c, TipoConv__c, DateStart__c, DocumentType__c, DocumentDetails__c, DateEnd__c 
				FROM SFAConvenzDealerDocumentsTipoConvCO__c
				WHERE TipoConv__c = :tipoConv AND DocumentType__c = 'additional' AND DateStart__c <= today AND DateEnd__c >= today];

			System.debug('*** lstDocumentiAddizionali :: ' + JSON.serialize(lstDocumentiAddizionali));

			List<SFADossierDocumento__c> lstDossierDocumento = new List<SFADossierDocumento__c>(); 

			for (SFAConvenzDealerDocumentsTipoConvCO__c documento : lstDocumentiObbligatori) {
				SFADossierDocumento__c dossierDocumento = new SFADossierDocumento__c();
				dossierDocumento.Dossier__c = dossierId;
				dossierDocumento.SFAConvenzDealerDocumentsList__c = mapDocumentiId.get(documento.IdxDocument__c);
				dossierDocumento.TipoConv__c = tipoConv;
				dossierDocumento.DocumentType__c = 'mandatory';
				lstDossierDocumento.add(dossierDocumento);
			}

			/*for (Contact collegato : lstCollegati) {
				datiListaDocumenti.mapDossierDocumentoCollegati.put(collegato.Id, new List<SFADossierDocumento__c>());
				for (SFAConvenzDealerDocumentsTipoConvCO__c documento : lstDocumentiCollegati) {
					SFADossierDocumento__c dossierDocumento = new SFADossierDocumento__c();
					dossierDocumento.Dossier__c = dossierId;
					dossierDocumento.SFAConvenzDealerDocumentsList__c = mapDocumentiId.get(documento.IdxDocument__c);
					dossierDocumento.Collegato__c = collegato.Id;
					dossierDocumento.TipoConv__c = tipoConv;
					dossierDocumento.DocumentType__c = 'identity';
					lstDossierDocumento.add(dossierDocumento);

					datiListaDocumenti.mapDossierDocumentoCollegati.get(collegato.Id).add(dossierDocumento);
				}
			}*/

			for (Contact collegato : lstCollegati) {
				for (SFAConvenzDealerDocumentsTipoConvCO__c documento : lstDocumentiCollegati) {
					SFADossierDocumento__c dossierDocumento = new SFADossierDocumento__c();
					dossierDocumento.Dossier__c = dossierId;
					dossierDocumento.SFAConvenzDealerDocumentsList__c = mapDocumentiId.get(documento.IdxDocument__c);
					dossierDocumento.Collegato__c = collegato.Id;
					dossierDocumento.TipoConv__c = tipoConv;
					dossierDocumento.DocumentType__c = 'identity';
					lstDossierDocumento.add(dossierDocumento);
				}
			}

			for (SFAConvenzDealerDocumentsTipoConvCO__c documento : lstDocumentiAddizionali) {
				SFADossierDocumento__c dossierDocumento = new SFADossierDocumento__c();
				dossierDocumento.Dossier__c = dossierId;
				dossierDocumento.SFAConvenzDealerDocumentsList__c = mapDocumentiId.get(documento.IdxDocument__c);
				dossierDocumento.TipoConv__c = tipoConv;
				dossierDocumento.DocumentDetails__c = documento.DocumentDetails__c;
				dossierDocumento.DocumentType__c = 'additional';
				lstDossierDocumento.add(dossierDocumento);

			}

			System.debug('*** lstDossierDocumento :: ' + JSON.serialize(lstDossierDocumento));

			insert lstDossierDocumento;

		}

		List<SFADossierDocumento__c> lstDossierDocumentoObbligatori = 
			[SELECT Id, Document__c, TipoConv__c, Dossier__c, Collegato__c, IsDocumentoSelezionato__c, DocumentType__c, DocumentDetails__c, SFAConvenzDealerDocumentsList__c 
			 FROM SFADossierDocumento__c
			 WHERE Dossier__c = :dossierID AND DocumentType__c = 'mandatory'];
		
		for (SFADossierDocumento__c documento : lstDossierDocumentoObbligatori) {
			datiListaDocumenti.lstDossierDocumentoObbligatori.add(documento);
			if (documento.IsDocumentoSelezionato__c == true)
				datiListaDocumenti.lstSelectedRowsObbligatori.add(documento.Id);
		}

		List<SFADossierDocumento__c> lstDossierDocumentoCollegati = 
			[SELECT Id, Document__c, TipoConv__c, Dossier__c, Collegato__c, NomeCollegato__c, IsDocumentoSelezionato__c, DocumentDetails__c, DocumentType__c, SFAConvenzDealerDocumentsList__c 
			 FROM SFADossierDocumento__c 
			 WHERE Dossier__c = :dossierID AND DocumentType__c = 'identity'];

		for (SFADossierDocumento__c documento : lstDossierDocumentoCollegati) {
			datiListaDocumenti.lstDossierDocumentoCollegati.add(documento);
			if (documento.IsDocumentoSelezionato__c == true)
				datiListaDocumenti.lstSelectedRowsCollegati.add(documento.Id);
		}

		List<SFADossierDocumento__c> lstDossierDocumentoAddizionali = 
			[SELECT Id, Document__c, TipoConv__c, Dossier__c, Collegato__c, IsDocumentoSelezionato__c, DocumentType__c, DocumentDetails__c, SFAConvenzDealerDocumentsList__c, RispostaDocumentiAddizionali__c 
			 FROM SFADossierDocumento__c 
			 WHERE Dossier__c = :dossierID AND DocumentType__c = 'additional'];

		for (SFADossierDocumento__c documento : lstDossierDocumentoAddizionali) {
			datiListaDocumenti.lstDossierDocumentoAddizionali.add(documento);
			if (documento.IsDocumentoSelezionato__c == true)
				datiListaDocumenti.lstSelectedRowsAddizionali.add(documento.Id);
		}

		/*for (Contact collegato : lstCollegati) {
			datiListaDocumenti.mapDossierDocumentoCollegati.put(collegato.Id, new List<SFADossierDocumento__c>());
			for (SFADossierDocumento__c documento : lstDossierDocumentoCollegati) {
				if (collegato.Id == documento.Collegato__c) {
					SFADossierDocumento__c dossierDocumento = new SFADossierDocumento__c();
					dossierDocumento.Dossier__c = documento.Dossier__c;
					dossierDocumento.SFAConvenzDealerDocumentsList__c = documento.SFAConvenzDealerDocumentsList__c;
					dossierDocumento.Collegato__c = documento.Collegato__c;
					dossierDocumento.TipoConv__c = documento.TipoConv__c;
					dossierDocumento.DocumentType__c = documento.DocumentType__c;

					datiListaDocumenti.mapDossierDocumentoCollegati.get(collegato.Id).add(dossierDocumento);

					if (documento.IsDocumentoSelezionato__c == true)
						datiListaDocumenti.lstSelectedRows.add(documento.Id);
				}
			}
		}*/ 

		datiListaDocumenti.step = step;

		// ritornarmi le tre liste di documenti
		System.debug('*** datiListaDocumenti :: ' + JSON.serialize(datiListaDocumenti));
		return datiListaDocumenti;
		
	}

	@AuraEnabled
	public static void salvaSelezioneDocumenti(String dossierId, String caseId, List<String> lstIdDocumento, String step) {

		System.debug('*** lstIdDocumento :: ' + JSON.serialize(lstIdDocumento));
		System.debug('*** stepSalva :: ' + step);

		if (SFAConvenzionamento.GDD_DocumentiObbligatori.equals(step)) {
			List<SFADossierDocumento__c> lstDossierDocumentoObbligatori = 
				[SELECT Id, Document__c, TipoConv__c, Dossier__c, Collegato__c, IsDocumentoSelezionato__c, DocumentType__c, SFAConvenzDealerDocumentsList__c, RispostaDocumentiAddizionali__c 
				 FROM SFADossierDocumento__c 
				 WHERE Dossier__c = :dossierId AND DocumentType__c = 'mandatory'];

			for (SFADossierDocumento__c documento : lstDossierDocumentoObbligatori) {
                if (lstIdDocumento.contains(documento.Id)) {
					documento.IsDocumentoSelezionato__c = true;   documento.RispostaDocumentiAddizionali__c = 'Si';
                }
                else {
					documento.IsDocumentoSelezionato__c = false;
                }
			}

			update lstDossierDocumentoObbligatori;

			SFAConvenzionamento.updateStepLavorazione(caseId, step);
		}

		else if (SFAConvenzionamento.GDD_DocumentiCollegati.equals(step)) {
			List<SFADossierDocumento__c> lstDossierDocumentoCollegati = 
			[SELECT Id, Document__c, TipoConv__c, Dossier__c, Collegato__c, NomeCollegato__c, IsDocumentoSelezionato__c, DocumentType__c, SFAConvenzDealerDocumentsList__c, RispostaDocumentiAddizionali__c 
			 FROM SFADossierDocumento__c 
			 WHERE Dossier__c = :dossierId AND DocumentType__c = 'identity'];

			for (SFADossierDocumento__c documento : lstDossierDocumentoCollegati) {
                if (lstIdDocumento.contains(documento.Id)) {
					documento.IsDocumentoSelezionato__c = true;
                    documento.RispostaDocumentiAddizionali__c = 'Si';
                }
                else {
					documento.IsDocumentoSelezionato__c = false;
                }
			}

			update lstDossierDocumentoCollegati;

			SFAConvenzionamento.updateStepLavorazione(caseId, step);
		}

	}

	@AuraEnabled
	public static void salvaRisposteDocumentiAddizionali(String dossierId, String caseId, Map<String, String> mapIdRispostaDocumentoAddizionali, String step) {

		System.debug('*** mapIdRispostaDocumentoAddizionali :: ' + JSON.serialize(mapIdRispostaDocumentoAddizionali));
		System.debug('*** step :: ' + step);

		if (SFAConvenzionamento.GDD_DocumentiAddizionali.equals(step)) {
			List<SFADossierDocumento__c> lstDossierDocumentoAddizionali = 
				[SELECT Id, Document__c, TipoConv__c, Dossier__c, Collegato__c, IsDocumentoSelezionato__c, DocumentType__c, SFAConvenzDealerDocumentsList__c, RispostaDocumentiAddizionali__c
				 FROM SFADossierDocumento__c 
				 WHERE Dossier__c = :dossierId AND DocumentType__c = 'additional'];

			for (SFADossierDocumento__c documento : lstDossierDocumentoAddizionali) {
				if (mapIdRispostaDocumentoAddizionali.containsKey(documento.Id))
					documento.RispostaDocumentiAddizionali__c = mapIdRispostaDocumentoAddizionali.get(documento.Id);
			}

			update lstDossierDocumentoAddizionali;

			SFAConvenzionamento.updateStepLavorazione(caseId, step);
		}
	}

	@AuraEnabled
	public static String generaCoverDossierUrl(String dossierId) {
		String res='/apex/SFAConvenzGestioneDossierGeneraCover?dossierId='+dossierId;
        return res;
	}

	@AuraEnabled  
	public static void assignToIDM(string dossierId, string caseId){

		XCSNoteUtils.postANote(caseId,SFAConvenzionamento.TITLE_NOTE_EVENTO,SFAConvenzionamento.NOTA_EVENTO_DOSSIER_COMPLETAMENTOFILIALE);

		Date today = Date.today();
        Dossier__c dossier= SFAConvenzionamento.getDossier(dossierId);
		dossier.DataCompletamentoFiliale__c = today;
		update dossier;

		Case caseAttivita= SFAConvenzionamento.getCase(caseId);
		caseAttivita.Status=CaseUtils.INOLTRATO;
		caseAttivita=CaseUtils.aggiornaDispositionCase(caseAttivita,XCS_DispositionUtils.DOSSIER_COMPLETO_INSPEDIZIONE,false);
		caseAttivita=SFAConvenzionamento.utenteLavorazione(caseAttivita,GroupUtils.IDM_RITORNIPOSTALI,false,false);
		caseAttivita=CaseShareUtil.appendStringToCaseShare(caseAttivita,SFAConvenzionamento.sharingToIDM);
		update caseAttivita;
	}

	@AuraEnabled
	public static UpdateStepLavorazioneData updateStepLavorazione(String dossierId, String caseId) {
		System.debug('*** caseId :: ' + caseId);

		String step = [SELECT Id, StepAttivitaConvenzionamento__c FROM Case WHERE Id = :caseId][0].StepAttivitaConvenzionamento__c;
		
		UpdateStepLavorazioneData usld = new UpdateStepLavorazioneData();
		
		if (SFAConvenzionamento.GDD_DocumentiObbligatori.equals(step)) {
			System.debug('*** UpstepObli :: ' + step);

			List<SFADossierDocumento__c> lstDossierDocumentoObbligatori = 
				[SELECT Id, Document__c, TipoConv__c, Dossier__c, Collegato__c, IsDocumentoSelezionato__c, DocumentType__c, SFAConvenzDealerDocumentsList__c 
				 FROM SFADossierDocumento__c 
				 WHERE Dossier__c = :dossierId AND DocumentType__c = 'mandatory'];

			for (SFADossierDocumento__c documento : lstDossierDocumentoObbligatori) {
				if (documento.IsDocumentoSelezionato__c == false)
					usld.errorMessage = NOT_ALL_MANDATORY_DOCS_SELECTED;
			}

			usld.newStep = SFAConvenzionamento.GDD_DocumentiCollegati;
			
		}
		else if (SFAConvenzionamento.GDD_DocumentiCollegati.equals(step)) {
			System.debug('*** UpstepColl :: ' + step);

			List<SFADossierDocumento__c> lstDossierDocumentoCollegati = 
			[SELECT Id, Document__c, TipoConv__c, Dossier__c, Collegato__c, NomeCollegato__c, IsDocumentoSelezionato__c, DocumentType__c, SFAConvenzDealerDocumentsList__c 
			 FROM SFADossierDocumento__c 
			 WHERE Dossier__c = :dossierId AND DocumentType__c = 'identity'];

			for (SFADossierDocumento__c documento : lstDossierDocumentoCollegati) {
				if (documento.IsDocumentoSelezionato__c == false)
					usld.errorMessage = NOT_ALL_IDENTITY_DOCS_SELECTED;
			}

			usld.newStep = SFAConvenzionamento.GDD_DocumentiAddizionali;
			
		}
		else if (SFAConvenzionamento.GDD_DocumentiAddizionali.equals(step)) {
			System.debug('*** UpstepAd :: ' + step);

			List<SFADossierDocumento__c> lstDossierDocumentoAddizionali = 
				[SELECT Id, Document__c, TipoConv__c, Dossier__c, Collegato__c, IsDocumentoSelezionato__c, DocumentType__c, SFAConvenzDealerDocumentsList__c, RispostaDocumentiAddizionali__c
				 FROM SFADossierDocumento__c 
				 WHERE Dossier__c = :dossierId AND DocumentType__c = 'additional'];

			for (SFADossierDocumento__c documento : lstDossierDocumentoAddizionali) {
				if (DEFAULT_ANSWER.equals(documento.RispostaDocumentiAddizionali__c))
					usld.errorMessage = NOT_ALL_ADDITIONAL_QUESTIONS_ANSWERED;
			}

			
			usld.datiListaDocumenti = getRiepilogoDocumentiMancanti(dossierId);

			//Se tutte le liste di documenti mancanti sono vuote allora procedi a generare la cover
			if (usld.datiListaDocumenti.lstDossierDocumentoObbligatori.size() == 0 && 
				usld.datiListaDocumenti.lstDossierDocumentoCollegati.size() == 0 && 
				usld.datiListaDocumenti.lstDossierDocumentoAddizionali.size() == 0) {

				usld.newStep = SFAConvenzionamento.GDD_StampaCover;

			}
				
			//altrimenti vai alla pagina della lista documenti mancanti
			else {
				usld.newStep = SFAConvenzionamento.GDD_RiepilogoDocumentiMancanti;
			}

		}

		SFAConvenzionamento.updateStepLavorazione(caseId, usld.newStep);
		
		System.debug('*** usld :: ' + JSON.serialize(usld));
		return usld;
	}

	public static DatiListaDocumenti getRiepilogoDocumentiMancanti(String dossierId) {

		DatiListaDocumenti datiListaDocumenti = new DatiListaDocumenti();

		List<SFADossierDocumento__c> lstDossierDocumentoObbligatori = 
			[SELECT Id, Document__c, TipoConv__c, Dossier__c, Collegato__c, IsDocumentoSelezionato__c, DocumentType__c, DocumentDetails__c, SFAConvenzDealerDocumentsList__c 
			 FROM SFADossierDocumento__c
			 WHERE Dossier__c = :dossierID AND DocumentType__c = 'mandatory'];
		
		for (SFADossierDocumento__c documento : lstDossierDocumentoObbligatori) {
			
			if (documento.IsDocumentoSelezionato__c == false)
				datiListaDocumenti.lstDossierDocumentoObbligatori.add(documento);
		}

		List<SFADossierDocumento__c> lstDossierDocumentoCollegati = 
			[SELECT Id, Document__c, TipoConv__c, Dossier__c, Collegato__c, NomeCollegato__c, IsDocumentoSelezionato__c, DocumentDetails__c, DocumentType__c, SFAConvenzDealerDocumentsList__c 
			 FROM SFADossierDocumento__c 
			 WHERE Dossier__c = :dossierID AND DocumentType__c = 'identity'];

		for (SFADossierDocumento__c documento : lstDossierDocumentoCollegati) {
			
			if (documento.IsDocumentoSelezionato__c == false)
				datiListaDocumenti.lstDossierDocumentoCollegati.add(documento);
		}

		List<SFADossierDocumento__c> lstDossierDocumentoAddizionali = 
			[SELECT Id, Document__c, TipoConv__c, Dossier__c, Collegato__c, IsDocumentoSelezionato__c, DocumentType__c, DocumentDetails__c, SFAConvenzDealerDocumentsList__c, RispostaDocumentiAddizionali__c 
			 FROM SFADossierDocumento__c 
			 WHERE Dossier__c = :dossierID AND DocumentType__c = 'additional'];

		for (SFADossierDocumento__c documento : lstDossierDocumentoAddizionali) {
			
			if (DEFAULT_ANSWER.equals(documento.RispostaDocumentiAddizionali__c))
				datiListaDocumenti.lstDossierDocumentoAddizionali.add(documento);
		}

		return datiListaDocumenti;

	}

	public class StatoAttributoData {
		@AuraEnabled
		public Date dataRiferimento {get; set;}
		@AuraEnabled
		public String stato {get; set;}
		@AuraEnabled
		public String attributo {get; set;}
		@AuraEnabled
		public Integer errorCode {get; set;}
	}

	public class DatiListaDocumenti {
		@AuraEnabled
		public List<SFADossierDocumento__c> lstDossierDocumentoObbligatori {get; set;}
		@AuraEnabled
		public List<SFADossierDocumento__c> lstDossierDocumentoCollegati {get; set;}
		@AuraEnabled
		public List<SFADossierDocumento__c> lstDossierDocumentoAddizionali {get; set;}
		@AuraEnabled
		public List<String> lstSelectedRowsObbligatori {get; set;}
		@AuraEnabled
		public List<String> lstSelectedRowsCollegati {get; set;}
		@AuraEnabled
		public List<String> lstSelectedRowsAddizionali {get; set;}
		@AuraEnabled
		public String step {get; set;}

		public DatiListaDocumenti() {
			this.lstDossierDocumentoObbligatori = new List<SFADossierDocumento__c>();
			this.lstDossierDocumentoCollegati = new List<SFADossierDocumento__c>();
			this.lstDossierDocumentoAddizionali = new List<SFADossierDocumento__c>();
			this.lstSelectedRowsObbligatori = new List<String>();
			this.lstSelectedRowsCollegati = new List<String>();
			this.lstSelectedRowsAddizionali = new List<String>();
		}

	}

	public class InitData {
		@AuraEnabled
		public Integer errorCode {get; set;}
		@AuraEnabled
		public String nuovoCaseId {get; set;}
		@AuraEnabled
		public Dossier__c dossier {get; set;}
		@AuraEnabled
		public String tipoChecklist {get; set;}
		@AuraEnabled
		public String dealerId {get; set;}
		@AuraEnabled
		public Boolean isInManoAFiliale {get; set;}
	}

	public class UpdateStepLavorazioneData {
		@AuraEnabled
		public String errorMessage {get; set;}
		@AuraEnabled
		public String newStep {get; set;}
		@AuraEnabled
		public DatiListaDocumenti datiListaDocumenti {get; set;}

		public UpdateStepLavorazioneData() {
			this.datiListaDocumenti = new DatiListaDocumenti();
		}
	}

}