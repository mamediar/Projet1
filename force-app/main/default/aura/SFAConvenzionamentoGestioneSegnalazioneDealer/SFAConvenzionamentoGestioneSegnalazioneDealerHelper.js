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
                filterName: 'Segnalazione_Dealer'
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

	callGetDealerSegnalato: function (component, event) {
		var action = component.get("c.getDealerSegnalato");
		var caseId = component.get("v.recordId");

		var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();

		action.setParams({
			caseId: caseId
		}); 

		action.setCallback(this, function(response){
			spinner.decreaseCounter();
			if (response.getState() == 'SUCCESS'){
				var dealerSegnalato = response.getReturnValue();
				component.set("v.dealerId", dealerSegnalato.dealerId);
				component.set("v.dealerRecordTypeId", dealerSegnalato.recordTypeId);
				component.set("v.ragioneSociale", dealerSegnalato.ragioneSociale);
				component.set("v.indirizzo", dealerSegnalato.indirizzo);
				component.set("v.codiceFiscale", dealerSegnalato.codiceFiscale);
				component.set("v.partitaIVA", dealerSegnalato.partitaIva);
				component.set("v.codiceAccordo", dealerSegnalato.codiceAccordo);
				component.set("v.email", dealerSegnalato.email);
				component.set("v.bancaSegnalatrice", dealerSegnalato.bancaSegnalatrice);
				component.set("v.macroarea", dealerSegnalato.macroarea);
				component.set("v.prodottoDominante", dealerSegnalato.prodottoDominante);
				component.set("v.prodottoDominanteBackup", dealerSegnalato.prodottoDominante);
				component.set("v.telefonoFisso", dealerSegnalato.telefonoFisso);
				component.set("v.telefonoCellulare", dealerSegnalato.telefonoCellulare);
				console.log('*** dealerSegnalato :: ' + JSON.stringify(dealerSegnalato));
			}
		});

		$A.enqueueAction(action);

	},

	callManageCaseWithNewDisposition: function (component, event) {
		var macroarea = component.get("v.macroarea");
		var prodottoDominante = component.get("v.prodottoDominante");
		var note = component.get("v.nota");

		var action = component.get("c.manageCaseWithNewDisposition");

		action.setParams({
			caseId: component.get("v.recordId"),
			disposition: component.get("v.disposition"),
			macroarea: macroarea,
			prodottoDominante: prodottoDominante,
			note: note
		});

		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
				var activityType = response.getReturnValue();
				console.log("*** activityType :: " + activityType);
				if (activityType == 'AT0111') 
					this.goToListaCase(component, event);
				else
					window.location.reload(true);
			}
		});

		if (macroarea == null || macroarea == undefined || macroarea == '' || macroarea == ' ' ||
		prodottoDominante == null || prodottoDominante == undefined || prodottoDominante == '' || prodottoDominante == ' ')

		{
			console.log('*** macroarea :: ' + macroarea);
			console.log('*** prodottoDominante :: ' + prodottoDominante);

			this.showToastKOmacroareaProdottoDominante(component, event);
		}

		else {
			
			$A.enqueueAction(action);

		}

	},    
 
	
	showToastOK: function(component, event) {
		var toastEvent = $A.get("e.force:showToast");
        console.log('Tutto OK');
		toastEvent.setParams({
			title: "Operazione completata",
			type: "success",
			message: "Dati aggiornati con successo!"
		});
		toastEvent.fire();
	},
	
	showToastKO: function(component, event) {
		var toastEvent = $A.get("e.force:showToast");
        console.log('Errore');
		toastEvent.setParams({
			title: "Errore",
			type: "error",
			message: "Si è verificato un errore durante il salvataggio"
		});
		toastEvent.fire();
	},

	showToastKOmacroareaProdottoDominante: function(component, event) {
		var toastEvent = $A.get("e.force:showToast");
        console.log('Errore');
		toastEvent.setParams({
			title: "Errore",
			type: "error",
			message: "Valorizzare macroarea e prodotto dominante"
		});
		toastEvent.fire();
	}
})