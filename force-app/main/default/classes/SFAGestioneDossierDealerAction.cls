public class SFAGestioneDossierDealerAction extends XCSMenuAction {

	public static final String AT = 'AT';
	public static final String FL = 'FL';
	public static final String IS = 'IS';
	public static final String CH = 'CH';
	public static final String PV = 'PV';

	public final String STATUS_NOT_AT_FL = 'STATUS_NOT_AT_FL';
	public final String ACTIVATION_DATE_TOO_OLD = 'ACTIVATION_DATE_TOO_OLD';
	public final String DEALER_IS_PV = 'DEALER_IS_PV';
	public final String CREA_ACCOLLO = 'CREA_ACCOLLO';
	public final String STATUS_NOT_GESTITO = 'STATUS_NOT_GESTITO';

	public override XCSMenuActionResult preRedirect() {

		XCSMenuActionResult res = new XCSMenuActionResult('standard__recordPage');

		String dealerId = getAccount().Id;

		//InitData initData = new InitData();
		//XCSMenuActionResult.DatiConvenzionamento datiConvenzionamento =  new XCSMenuActionResult.DatiConvenzionamento();

		String tipoChecklist = SFAConvenzGestioneDossierController.getTipoChecklist(dealerId);
		System.debug('*** tipoChecklist :: ' + tipoChecklist);
		//datiConvenzionamento.tipoChecklist = tipoChecklist;

		if ('Q_PV'.equals(tipoChecklist)) {
			//datiConvenzionamento.errorCode = DEALER_IS_PV;
			res.getAttributes().setIsOk(false);
            res.getAttributes().setErrorMessage('Per i punti vendita è necessario creare un accollo. Aprire un ticket agli uffici di sede per la chiusura dell\'attività SFA.');
			return res;
		}

		String dealerOCSExternalId = [SELECT Id, CodiceAgente__c, OCS_External_Id__c 
			FROM Account 
			WHERE RecordType.Name = 'Dealer' AND Id = :dealerId][0].OCS_External_Id__c;

		StatoAttributoData sad = getStatoAttributoData(dealerOCSExternalId);
		System.debug('*** sad :: ' + JSON.serialize(sad));

		if (sad.errorCode != null) {
			//datiConvenzionamento.errorCode = sad.errorCode;
			res.getAttributes().setIsOk(false);
            if (sad.errorCode == 'STATUS_NOT_AT_FL'){
				res.getAttributes().setErrorMessage('Per creare un\'attività di gestione dossier lo stato deve essere settato con AT o FL');
            }
            else if(sad.errorCode == 'OSC_CODE_NULL'){
                res.getAttributes().setErrorMessage('Codice OCS non presente');
            }
            else{
				res.getAttributes().setErrorMessage('Non è possibile gestire il dossier: è necessario inserire un accollo.');
            }    
        	
			return res; 
		}

		/*List<Case> lstCase = [SELECT Id, AccountId, Account.OCS_External_Id__c, CaseNumber FROM Case WHERE AccountId = :dealerId];

		String caseId = currentCase.AccountId;
		String dealerOCSExternalId = currentCase.Account.OCS_External_Id__c;

		System.debug('*** dealerId :: ' + dealerId);
		System.debug('*** dealerOCSExternalId :: ' + dealerOCSExternalId);

		initData.dealerId = dealerId;

		// da vedere
		StatoAttributoData sad = getStatoAttributoData(dealerOCSExternalId);
		System.debug('*** sad :: ' + JSON.serialize(sad));

		if (sad.errorCode < 0) {
			initData.errorCode = sad.errorCode;
			return initData; 
		}

		aggiornaCollegati(dealerId, dealerOCSExternalId.Substring(1));*/

		Id queueMDId = GroupUtils.getQueue(SFAConvenzionamento.queueMD).Id;

		String utenteId = UserInfo.getUserId();
		String filialeQueue = [SELECT Id, DefaultQueueId__c FROM User WHERE Id = :utenteId][0].DefaultQueueId__c;
		System.debug('*** filialeQueue :: ' + filialeQueue);

        if(filialeQueue != null)
			Id queueFilialeId = GroupUtils.getQueue(filialeQueue).Id;

		// eseguo la logica fino al punto 3 poi eseguo il punto 4, come segue
		XCS_Categoria__c categoria = XCS_CategoriaUtil.getCategoryForExternalId(XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_GESTIONE_DOSSIER_DEALER);

		System.debug('*** categoria :: ' + JSON.serialize(categoria));

		List<Case> lstDossierCaseEsistente = 
			[SELECT Id, CaseNumber, Categoria_Riferimento__r.External_Id__c, Status
			FROM Case 
			WHERE AccountId = :dealerId AND Categoria_Riferimento__r.External_Id__c = :categoria.External_Id__c AND Status != 'Annullato' AND Status != 'Closed'
			ORDER BY CreatedDate DESC];

		System.debug('*** lstDossierCaseEsistente :: ' + JSON.serialize(lstDossierCaseEsistente));

		Date today = Date.today();

		if (lstDossierCaseEsistente.size() == 0) {

			// creo il case, creo il dossier e ci lego il case



			Case nuovoCaseDossier = CaseUtils.getCase(RecordTypeUtil.SFA_CONVENZIONAMENTO,XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_GESTIONE_DOSSIER_DEALER);
            nuovoCaseDossier = XCS_DispositionUtils.aggiungiDispositionCase(nuovoCaseDossier, XCS_DispositionUtils.NUOVO_DOSSIER);
			nuovoCaseDossier.AccountId = dealerId;
			nuovoCaseDossier.StepAttivitaConvenzionamento__c=SFAConvenzionamento.GDD_DocumentiObbligatori;   
			nuovoCaseDossier.ActivityType__c=CaseUtils.SFA_GESTIONE_DOSSIER_DEALER;   //new activity di Gestione Dossier
			nuovoCaseDossier.Subject=CaseUtils.SFA_SUBJECT_GESTIONE_DOSSIER;
			nuovoCaseDossier.DataCreazioneDossier__c=datetime.now();
            nuovoCaseDossier.OCSExternalFilialeConvenzionato__c = filialeQueue;
			insert nuovoCaseDossier;

			String caseNumber = [SELECT Id, CaseNumber FROM Case WHERE Id = :nuovoCaseDossier.Id][0].CaseNumber;

			Dossier__c dossier = new Dossier__c();
			dossier.IdAttivita__c = nuovoCaseDossier.Id;
			dossier.Tipo__c = 'Dossier';
			dossier.TipoChecklist__c = tipoChecklist;
			dossier.DataRiferimento__c = sad.dataRiferimento;
			dossier.Name = DateUtils.formatDateYYMMDD(today)+'-'+caseNumber;
			insert dossier;

			res.getAttributes().setRecordId(nuovoCaseDossier.Id);
			//datiConvenzionamento.dossier = dossier;
		}
		else if (lstDossierCaseEsistente.size() > 0) {
			
			Case dossierCaseEsistente = lstDossierCaseEsistente[0];
            system.debug('DossierAction - dossierCaseEsistente: '+dossierCaseEsistente);
			List<Dossier__c> lstDossierEsistente = [SELECT Id, Name, DataRiferimento__c, IdAttivita__r.AccountId, IsCaseDossierEsistente__c FROM Dossier__c WHERE IdAttivita__c = :dossierCaseEsistente.Id ORDER BY CreatedDate DESC];
		system.debug('DossierAction - lstDossierEsistente: '+lstDossierEsistente);
            if (lstDossierEsistente.size() > 0) {
				Dossier__c dossierEsistente = lstDossierEsistente.get(0);
				if ('Gestito'.equals(dossierCaseEsistente.status)) {
					System.debug('*** riga 257');
					if (sad.dataRiferimento > dossierEsistente.DataRiferimento__c) {

						Case nuovoCaseDossier = CaseUtils.getCase(RecordTypeUtil.SFA_CONVENZIONAMENTO,XCS_CategoriaUtil.SFA_CONVENZIONAMENTO_GESTIONE_DOSSIER_DEALER);
                        nuovoCaseDossier = XCS_DispositionUtils.aggiungiDispositionCase(nuovoCaseDossier, XCS_DispositionUtils.NUOVO_DOSSIER);
						nuovoCaseDossier.AccountId = dealerId;
						nuovoCaseDossier.StepAttivitaConvenzionamento__c=SFAConvenzionamento.GDD_DocumentiObbligatori;   
						nuovoCaseDossier.ActivityType__c=CaseUtils.SFA_GESTIONE_DOSSIER_DEALER;   //new activity di Gestione Dossier
						nuovoCaseDossier.Subject=CaseUtils.SFA_SUBJECT_GESTIONE_DOSSIER;
						nuovoCaseDossier.DataCreazioneDossier__c=datetime.now();
                        nuovoCaseDossier.OCSExternalFilialeConvenzionato__c = filialeQueue;
						insert nuovoCaseDossier;

						String caseNumber = [SELECT Id, CaseNumber FROM Case WHERE Id = :nuovoCaseDossier.Id][0].CaseNumber;

						Dossier__c dossier = new Dossier__c();
						dossier.IdAttivita__c = nuovoCaseDossier.Id;
						dossier.Tipo__c = 'Dossier';
						dossier.TipoChecklist__c = tipoChecklist;
						dossier.DataRiferimento__c = sad.dataRiferimento;
						dossier.Name = DateUtils.formatDateYYMMDD(today)+'-'+caseNumber;
						insert dossier;

						Case c = new Case();
						c.Id = nuovoCaseDossier.Id;
						c.ParentId = dossierCaseEsistente.Id;
						update c;

						res.getAttributes().setRecordId(c.Id);
						//datiConvenzionamento.dossier = dossier;
					}
					else {
						System.debug('*** CREA_ACCOLLO');
						res.getAttributes().setIsOk(false);
            			res.getAttributes().setErrorMessage('Il dossier è stato già gestito, creare un accollo.');
						//datiConvenzionamento.errorCode = CREA_ACCOLLO;
						//res.getAttributes().setDatiConvenzionamento(datiConvenzionamento);
						return res;
					}
				}
				else {
					System.debug('*** STATUS_NOT_GESTITO');
					res.getAttributes().setIsOk(false);
            		res.getAttributes().setErrorMessage('Esiste un dossier attualmente in lavorazione. Richiederne la chiusura se la posizione è rimasta aperta per errore.');
					//datiConvenzionamento.errorCode = STATUS_NOT_GESTITO;
					//res.getAttributes().setDatiConvenzionamento(datiConvenzionamento);
					return res;
				}
			}
			
		}

        res.getAttributes().setObjectApiName(res.CASEAPINAME);	
        res.getAttributes().setActionName(res.VIEWACTION);
		//res.getAttributes().setDatiConvenzionamento(datiConvenzionamento);

		System.debug('*** res :: ' + JSON.serialize(res));
		return res;

	}

	@AuraEnabled
	public static StatoAttributoData getStatoAttributoData(String dealerOCSExternalId) {

		System.debug('*** dealerOCSExternalId :: ' + dealerOCSExternalId);

		StatoAttributoData sad = new StatoAttributoData();
		if(dealerOCSExternalId != null)
        {    
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
                            sad.errorCode = 'STATUS_NOT_AT_FL';
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
                sad.errorCode = 'ACTIVATION_DATE_TOO_OLD';
        }
        else{
            sad.errorCode = 'OSC_CODE_NULL';
            
        }
		System.debug('*** getStatoAttributoData - sad :: ' + JSON.serialize(sad));
		return sad;

	}

	public class StatoAttributoData {
		@AuraEnabled
		public Date dataRiferimento {get; set;}
		@AuraEnabled
		public String stato {get; set;}
		@AuraEnabled
		public String attributo {get; set;}
		@AuraEnabled
		public String errorCode {get; set;}
	}

}