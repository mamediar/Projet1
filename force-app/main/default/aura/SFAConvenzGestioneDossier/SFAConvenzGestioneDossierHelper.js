({
	goToListaCase: function (component, event) {
		var navService = component.find("navService");
		var pageReference = component.get("v.pageReference");
		//event.preventDefault();
		navService.navigate(pageReference);
	},

	initPageReference : function(component, event) {
        var navService = component.find("navService");
        var pageReference = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Case',
                actionName: 'list'
            },
            state: {
                filterName: 'Gestione_Dossier'
            }
        };
        component.set("v.pageReference", pageReference);
        var defaultUrl = "#";
        navService.generateUrl(pageReference)
            .then($A.getCallback(function(url) {
                component.set("v.url", url ? url : defaultUrl);
            }), $A.getCallback(function(error) {
                component.set("v.url", defaultUrl);
            }));
	},

	callGetDossier: function (component, event) {
		var action = component.get("c.checkDossierEsistente");
		var caseId = component.get("v.recordId");

		var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();

		action.setParams({
			caseId: caseId
		}); 

		action.setCallback(this, function(response){
			spinner.decreaseCounter();
			if (response.getState() == 'SUCCESS'){
				var initData = response.getReturnValue();
				console.log("*** initData.errorCode :: " + initData.errorCode);
                console.log('*** component.get(inManoaFiliale) :: ' + component.get('v.isInManoAFiliale'));
				if (initData.isInManoAFiliale == false) {
					component.set("v.messageNonLavorazione", "Dossier completo - ora in mano a IDM.");
				}
				else {
                    if (initData.errorCode < 0) {
						component.set("v.errorCode", initData.errorCode);
					}
					else {
						component.set("v.dossier", initData.dossier);
						component.set("v.dealerId", initData.dealerId);
						component.set("v.tipoQuestionario", initData.tipoChecklist);
						console.log("*** initData :: " + JSON.stringify(initData));
						this.callGetListeDocumenti(component, event);
					}
				}
				component.set("v.isInManoAFiliale", initData.isInManoAFiliale);
			}
		});
		$A.enqueueAction(action);

	},

	callGetListeDocumenti: function (component, event) {
		console.log('*** callGetListeDocumenti');
		var action = component.get("c.getListeDocumenti");
		var caseId = component.get("v.recordId");
		var dossier = component.get("v.dossier");
		var tipoQuestionario = component.get("v.tipoQuestionario");
		console.log("*** dossier :: " + JSON.stringify(dossier));
		console.log("*** caseId :: " + caseId);
		console.log("*** tipoQuestionario :: " + tipoQuestionario);

		var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();

		action.setParams({
			caseId: caseId,
			dossier: dossier,
			tipoConv: tipoQuestionario
		}); 

		action.setCallback(this, function(response){
			spinner.decreaseCounter();
			if (response.getState() == 'SUCCESS'){
				var datiListaDocumenti = response.getReturnValue();
				if (datiListaDocumenti) {
					console.log("*** datiListaDocumenti :: " + JSON.stringify(datiListaDocumenti));
					component.set("v.lstDossierDocumentoObbligatori", datiListaDocumenti.lstDossierDocumentoObbligatori);
					component.set("v.lstDossierDocumentoCollegati", datiListaDocumenti.lstDossierDocumentoCollegati);
					component.set("v.lstDossierDocumentoAddizionali", datiListaDocumenti.lstDossierDocumentoAddizionali);
					component.set("v.lstSelectedRowsObbligatori", datiListaDocumenti.lstSelectedRowsObbligatori);
					component.set("v.lstSelectedRowsCollegati", datiListaDocumenti.lstSelectedRowsCollegati);
					component.set("v.lstSelectedRowsAddizionali", datiListaDocumenti.lstSelectedRowsAddizionali);
					component.set("v.mapIdRispostaDocumentoAddizionali", new Map());
					if (datiListaDocumenti.step == 'GestioneDossierDealer_StampaCover')
							this.callGeneraCoverDossierUrl(component, event);
					component.set("v.step", datiListaDocumenti.step);
				}
			}
		});

		$A.enqueueAction(action);

	},

	handleSalvaSelezione: function (component, event, selectedDocumentIds) {
		var action = component.get("c.salvaSelezioneDocumenti");
		var dossierId = component.get("v.dossier") ? component.get("v.dossier").Id : null;
		var caseId = component.get("v.recordId");
		var step = component.get("v.step");

		var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();

		action.setParams({
			dossierId: dossierId,
			caseId: caseId,
			lstIdDocumento: selectedDocumentIds,
			step: step
		}); 

		action.setCallback(this, function(response){
			console.log("*** response.getReturnValue() :: " + response.getReturnValue());
			console.log("*** lstDossierDocumentoCollegati :: " + JSON.stringify(component.get("v.lstDossierDocumentoCollegati")));
			spinner.decreaseCounter();
			if (response.getState() == 'SUCCESS'){
				this.showToastOK(component, event);
			}
			else {
				this.showToastKO(component, event, 'Si è verificato un errore durante il salvataggio.');
			}
		});
		
		$A.enqueueAction(action);

	},

	handleSalvaRisposte: function (component, event) {
		var action = component.get("c.salvaRisposteDocumentiAddizionali");
		var dossierId = component.get("v.dossier") ? component.get("v.dossier").Id : null;
		var caseId = component.get("v.recordId");
		var mapIdRispostaDocumentoAddizionali = component.get("v.mapIdRispostaDocumentoAddizionali");
		var step = component.get("v.step");

		var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();

		action.setParams({
			dossierId: dossierId,
			caseId: caseId,
			mapIdRispostaDocumentoAddizionali: mapIdRispostaDocumentoAddizionali,
			step: step
		}); 

		action.setCallback(this, function(response){
			console.log("*** response.getReturnValue() :: " + response.getReturnValue());
			spinner.decreaseCounter();
			if (response.getState() == 'SUCCESS'){
				this.showToastOK(component, event);
			}
			else {
				this.showToastKO(component, event, 'Si è verificato un errore durante il salvataggio.');
			}
		});
		
		$A.enqueueAction(action);

	},

	callGeneraCoverDossierUrl: function (component, event) {
		var action = component.get("c.generaCoverDossierUrl");
		var dossierId = component.get("v.dossier") ? component.get("v.dossier").Id : null;

		action.setParams({
			dossierId: dossierId
		}); 

		action.setCallback(this, function(response){
			console.log("*** response.getReturnValue() :: " + response.getReturnValue());
			if (response.getState() == 'SUCCESS'){
				var dossierURL = response.getReturnValue();
				component.set("v.dossierURL", dossierURL);
			}
		});
		
		$A.enqueueAction(action);

	},

	callAssignToIDM: function (component, event) {
		var action = component.get("c.assignToIDM");
		var dossierId = component.get("v.dossier") ? component.get("v.dossier").Id : null;
		var caseId = component.get("v.recordId");

		var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();

		action.setParams({
			dossierId: dossierId,
			caseId: caseId
		}); 

		action.setCallback(this, function(response){
			console.log("*** response.getReturnValue() :: " + response.getReturnValue());
			spinner.decreaseCounter();
			if (response.getState() == 'SUCCESS'){
				this.goToListaCase(component, event);
			}
		});
		
		$A.enqueueAction(action);

	},

	handleProcedi: function (component, event) {
		var dossierId = component.get("v.dossier") ? component.get("v.dossier").Id : null;
		var caseId = component.get("v.recordId");

		var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();

		console.log('*** caseId :: ' + caseId);
		console.log('*** step :: ' + component.get("v.step"));

		var action = component.get("c.updateStepLavorazione");

		action.setParams({
			dossierId: dossierId,
			caseId: caseId
		}); 

		action.setCallback(this, function(response){
			console.log("*** response.getReturnValue() :: " + response.getReturnValue());
			spinner.decreaseCounter();
			if (response.getState() == 'SUCCESS'){
				var result = response.getReturnValue();
				if (result) {
					console.log("*** lstDossierDocumentoCollegati :: " + JSON.stringify(component.get("v.lstDossierDocumentoCollegati")));
					if (result.errorMessage == 'M01' || result.errorMessage == 'I01') {
						this.showToastWarning(component, event, "E' necessario selezionare tutti i documenti.");
					}
					else if (result.errorMessage == 'A01') {
						this.showToastWarning(component, event, "E' necessario rispondere a tutte le domande.");
					}
					
					component.set("v.updateStepLavorazioneData", result.datiListaDocumenti);
					console.log("*** result.datiListaDocumenti :: " + JSON.stringify(result.datiListaDocumenti));
					
					if (result.newStep == 'GestioneDossierDealer_StampaCover') {
						this.callGeneraCoverDossierUrl(component, event);
					}						
					component.set("v.step", result.newStep);
				}
				else {
					this.showToastKO(component, event, 'Si è verificato un errore durante il salvataggio.');
				}
			}
			else {
				this.showToastKO(component, event, 'Si è verificato un errore durante il salvataggio.');
			}
		});
		
		$A.enqueueAction(action);
	},

	showToastOK: function(component, event) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Operazione completata",
			type: "success",
			message: "Salvataggio completato con successo!"
		});
		toastEvent.fire();
	},
	
	showToastKO: function(component, event, message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Errore",
			type: "error",
			message: message
		});
		toastEvent.fire();
	},

	showToastWarning: function(component, event, message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Attenzione",
			type: "warning",
			message: message
		});
		toastEvent.fire();
	},
})