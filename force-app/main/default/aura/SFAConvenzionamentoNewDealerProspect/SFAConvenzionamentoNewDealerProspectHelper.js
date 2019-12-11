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
                filterName: 'New_Dealer_Prospect'
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

	callGetDealerProspect: function (component, event) {
		var action = component.get("c.getDealerProspect");
		var caseId = component.get("v.recordId");

		action.setParams({
			caseId: caseId
		}); 

		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
				console.log("*** callGetDealerProspect() -> response.getReturnValue() :: " + JSON.stringify(response.getReturnValue()));
				var attivita = response.getReturnValue().attivita;
				var dealerProspect = response.getReturnValue().dealer;
				var reportUrl = response.getReturnValue().reportUrl;
				component.set("v.dealerProspectId", attivita.AccountId);
				component.set("v.step", attivita.StepAttivitaConvenzionamento__c);
				if (dealerProspect) {
					var indirizzo = dealerProspect.ShippingStreet + ' - ' + dealerProspect.ShippingCity + ' - ' + dealerProspect.ShippingState;

					component.set("v.ragioneSociale", dealerProspect.Name);
					component.set("v.indirizzo", indirizzo);
					component.set("v.naturaGiuridica", dealerProspect.DescriptionOfLegalEntityType__c);
					component.set("v.statoSocieta", dealerProspect.DescriptionOfBusinessStatus__c);
					component.set("v.codiceFiscale", dealerProspect.Codice_Fiscale__c);
					component.set("v.partitaIva", dealerProspect.Partita_IVA__c);
					component.set("v.nRea", dealerProspect.NumeroREA__c);
					component.set("v.iscrizioneCciaa", dealerProspect.IscrizioneCCIAA__c);
					component.set("v.attivita", dealerProspect.Desc_Ateco__c);

					component.set("v.citta", dealerProspect.ShippingCity);
					component.set("v.provincia", dealerProspect.ShippingState);

				}
				if (reportUrl)
					component.set("v.reportUrl", reportUrl);

				console.log("*** " + component.get("v.dealerProspectId"));
				console.log("*** " + component.get("v.ragioneSociale"));
				console.log("*** " + component.get("v.indirizzo"));
				console.log("*** " + component.get("v.naturaGiuridica"));
				console.log("*** " + component.get("v.codiceFiscale"));
				console.log("*** " + component.get("v.partitaIva"));
				console.log("*** " + component.get("v.nRea"));
				console.log("*** " + component.get("v.iscrizioneCciaa"));
				console.log("*** " + component.get("v.attivita"));
				console.log("*** " + component.get("v.statoSocieta"));

				console.log("*** reportUrl :: " + component.get("v.reportUrl"));

			}
		});

		$A.enqueueAction(action);

	},
	
	showToastOK: function(component, event) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Operazione completata",
			type: "success",
			message: "Dati aggiornati con successo!"
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

	callCheckPresenzaReport: function (component, event) {
		var action = component.get("c.checkPresenzaReport");

		var caseId = component.get("v.recordId");
		var dealerProspectId = component.get("v.dealerProspectId");

		console.log("*** step :: " + component.get("v.step"));

		var codiceFiscale = component.find("codiceFiscale").get("v.value");
		var partitaIva = component.find("partitaIva").get("v.value");

		console.log("*** callCheckPresenzaReport() codiceFiscale :: " + codiceFiscale);
		console.log("*** callCheckPresenzaReport() partitaIva :: " + partitaIva);
        
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();

		action.setParams({
			caseId: caseId,
			dealerProspectId: dealerProspectId,
			codiceFiscale: codiceFiscale,
			partitaIva: partitaIva
		}); 

		action.setCallback(this, function(response){
            spinner.decreaseCounter();
			if (response.getState() == 'SUCCESS'){
				this.callGetDealerProspect(component, event);
				var checkPresenzaReportResult = response.getReturnValue();
				if (checkPresenzaReportResult.step == null) {
					this.showToastKO(component, event, "Si è verificato un errore durante la ricerca dell'azienda nel registro imprese.");
				}
				else if (checkPresenzaReportResult.step == "NewDealerProspect_DealerInIscrizione") {
					component.set("v.step", "NewDealerProspect_StepIniziale");
					this.showToastWarning(component, event, "L'azienda è in fase di iscrizione alla CCIAA. Per il completamento dell'iscrizione occorrono circa 15 giorni.");
				}
				else {
					component.set("v.step", checkPresenzaReportResult.step);
					component.set("v.reportUrl", checkPresenzaReportResult.reportUrl);
				}
			}
		});

		$A.enqueueAction(action);

	},

	callRichiediQuickReport: function (component, event) {
		var action = component.get("c.richiediQuickReport");

		var caseId = component.get("v.recordId");
		var dealerProspectId = component.get("v.dealerProspectId");
		var codiceFiscale = component.get("v.codiceFiscale");
		var partitaIva = component.get("v.partitaIva");
        
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();

		console.log("*** callRichiediQuickReport() codiceFiscale :: " + codiceFiscale);
		console.log("*** callRichiediQuickReport() partitaIva :: " + partitaIva);

		if (!partitaIva && partitaIva != codiceFiscale) {
			partitaIva = codiceFiscale;
		}

		action.setParams({
			caseId: caseId,
			dealerProspectId: dealerProspectId,
			partitaIva: partitaIva
		}); 

		action.setCallback(this, function(response){

			console.log("*** callRichiediQuickReport() callback pre setTimeout");
            
            var self = this;

            setTimeout(
				function(){

					console.log("*** callRichiediQuickReport() callback post setTimeout");
					spinner.decreaseCounter();
					if (response.getState() == 'SUCCESS') {
						var checkPresenzaReportResult = response.getReturnValue();
						if (!checkPresenzaReportResult.errorCode && !checkPresenzaReportResult.errorMessage) {
							component.set("v.step", checkPresenzaReportResult.step);
							component.set("v.reportUrl", checkPresenzaReportResult.reportUrl);
						}
						else {
							self.showToastKO(component, event, checkPresenzaReportResult.errorMessage);
						}
					}
				
				},
				3000
			);

		});

		$A.enqueueAction(action);
	},

	callRichiediGlobalExpert: function (component, event) {
		var action = component.get("c.richiediGlobalExpert");

		var caseId = component.get("v.recordId");
		var dealerProspectId = component.get("v.dealerProspectId");

		var ragioneSociale = component.find("ragioneSocialeRichiediGE").get("v.value");
		var partitaIva = component.find("partitaIvaRichiediGE").get("v.value");
		var codiceFiscale = component.find("codiceFiscaleRichiediGE").get("v.value");
		var indirizzo = component.find("indirizzoRichiediGE").get("v.value");
		var cap = component.find("capRichiediGE").get("v.value");
		var provincia = component.get("v.provincia");
		var citta = component.get("v.citta");

		var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();

		console.log("*** callRichiediGlobalExpert() codiceFiscale :: " + codiceFiscale);
		console.log("*** callRichiediGlobalExpert() partitaIva :: " + partitaIva);

		if (!partitaIva && partitaIva != codiceFiscale) {
			partitaIva = codiceFiscale;
		}

		action.setParams({
			caseId: caseId,
			dealerProspectId: dealerProspectId,
			ragioneSociale: ragioneSociale,
			partitaIva: partitaIva,
			codiceFiscale: codiceFiscale,
			indirizzo: indirizzo,
			cap: cap,
			provincia: provincia,
			citta: citta
		}); 

		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
				spinner.decreaseCounter();
				var checkPresenzaReportResult = response.getReturnValue();
                if (checkPresenzaReportResult) {
					//component.set("v.step", checkPresenzaReportResult.step);
                    window.location.reload(true);
                }
				else
					this.showToastKO(component, event, "Si è verificato un errore la richiesta del Global Expert.");
			}
		});

		$A.enqueueAction(action);

	},

	callVaiAEsitaCase: function (component, event) {
		var action = component.get("c.vaiAEsitaCase");

		var caseId = component.get("v.recordId");

		action.setParams({
			caseId: caseId
		}); 

		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
				var step = response.getReturnValue();
				component.set("v.step", step);
			}
		});

		$A.enqueueAction(action);
	},

	callEsitaCase: function (component, event) {
		var action = component.get("c.esitaCase");

		action.setParams({
			caseId: component.get("v.recordId"),
			disposition: component.get("v.disposition")
		});

		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
				var activityType = response.getReturnValue();
				console.log("*** activityType :: " + activityType);
                if (activityType == '3127'){
					this.goToListaCase(component, event);
                }/*else {
                    window.location.reload(true);
                }*/
                window.location.reload(true);
			}
		});
		
		$A.enqueueAction(action);

	}, 

	salvaProvinciaECitta: function(component, event) {
		var action = component.get("c.salvaProvinciaECitta");
		console.log('HELPER salvaProvinciaECitta');

		action.setParams({
			dealerId: component.get("v.dealerProspectId"),
            provincia: component.get("v.provincia"),
            citta: component.get("v.citta"),                     
		}); 

		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                console.log('VERIFICA ANAGRAFICA citta e provincia salvati');
            } else {
                console.log('VERIFICA ANAGRAFICA citta e provincia non salvati');
            }
		});
		
		$A.enqueueAction(action);        
	},
	
	goToRichiediGlobalExpert: function(component, event) {
		var action = component.get("c.setRichiediGlobalExpert");
		console.log('HELPER setRichiediGlobalExpert');

		action.setParams({
			caseId: component.get("v.recordId")            
		}); 

		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
				var step = response.getReturnValue();
				component.set("v.step", step);
            } else {
                console.log('Case non aggiornato');
            }
		});

		$A.enqueueAction(action);    
	},
    
    checkPartitaIva: function(component, event, partitaIva, isGEandDIN) {
        if (isGEandDIN) {
            if ( !partitaIva || (partitaIva && ( partitaIva.length == 0 || partitaIva.length == 11 || partitaIva.length == 16 ) ) )
                component.set("v.isPartitaIvaValida", true);
            else
                component.set("v.isPartitaIvaValida", false);
        }
        else {
            if ( partitaIva && ( partitaIva.length == 11 || partitaIva.length == 16 ) )
                component.set("v.isPartitaIvaValida", true);
            else
                component.set("v.isPartitaIvaValida", false);
        }
	},
    
    checkCodiceFiscale: function(component, event, codiceFiscale) {
        if ( codiceFiscale && ( codiceFiscale.length == 11 || codiceFiscale.length == 16 ) )
            component.set("v.isCodiceFiscaleValido", true);
        else
            component.set("v.isCodiceFiscaleValido", false);
	}
    
})