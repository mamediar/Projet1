({

	goToListaCase: function (component, event) {
		var navService = component.find("navService");
		var pageReference = component.get("v.pageReference");
		event.preventDefault();
		navService.navigate(pageReference);
	},

	initPageReference : function(component, event) {
        var navService = component.find("navService");
        var pageReference = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Case',
                actionName: 'list'
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

	callGetEsiti: function (component, event) {
		var action = component.get("c.getEsiti");
		var caseId = component.get("v.recordId");

		action.setParams({
			caseId: caseId
		}); 

		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
				var listaEsiti = response.getReturnValue();
				component.set("v.listaEsiti", listaEsiti);
				console.log("*** listaEsiti :: " + JSON.stringify(listaEsiti));
			}
		});
		$A.enqueueAction(action);

	},

	callGetPratica : function(component, event) { 

		var action = component.get("c.getPratica");
		var caseId = component.get("v.recordId");

        action.setParams({
			caseId: caseId
		}); 

		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
				var pratica = response.getReturnValue();

				if (pratica) {

					component.set("v.isProseguiButtonDisabled", (pratica.caseStatus == 'Closed'));
					component.set("v.esitoDiProvenienza", pratica.esitoDiProvenienza);

					component.set("v.numeroPratica", pratica.numeroPratica);
					component.set("v.codiceEsitoDiProvenienza", pratica.codiceEsitoDiProvenienza);

					component.set("v.dataLiquidazioneOcs", pratica.dataLiquidazione);
					component.set("v.isDataLiquidazioneOcsRed", pratica.isDataLiquidazioneRed);
					component.set("v.prodottoOcs", pratica.prodotto);
					component.set("v.assicurazioneOcs", pratica.assicurazione);
					component.set("v.isAssicurazioneOcsRed", pratica.isAssicurazioneRed);
					component.set("v.clienteOcs", pratica.cliente);
					component.set("v.descrizioneBeneOcs", pratica.descrizioneBene);
					component.set("v.modelloOcs", pratica.modello);
					component.set("v.targaOcs", pratica.targa);
					component.set("v.telaioOcs", pratica.telaio);
					var val = pratica.valore;
					console.log("*** val :: " + val);
					var valore = [val.slice(0, (val.length)-2), ".", val.slice((val.length)-2)].join('');
					console.log("*** valore :: " + valore);
					component.set("v.valoreOcs", valore);
					component.set("v.dataImmatricolazioneOcs", pratica.dataImmatricolazione);

					component.set("v.targa", pratica.targaNew);
					component.set("v.telaio", pratica.telaioNew);
					component.set("v.annoImmatricolazione", pratica.annoImmatricolazioneNew);
					component.set("v.meseImmatricolazione", pratica.meseImmatricolazioneNew);
					component.set("v.modello", pratica.modelloNew);
					component.set("v.valore", pratica.valoreNew);
					component.set("v.importoStorno", pratica.importoStorno);

					// Inserire le note?

					component.set("v.isDatiPraticaOpen", true);
					component.set("v.isVisualizzaButtonShown", false);

					this.callGetEsiti(component, event);

				}
				else {
					component.set("v.isDatiPraticaOpen", false);
					component.set("v.isVisualizzaButtonShown", true);
				}
				
			}
		});
		
		$A.enqueueAction(action);

	},

	callRecuperaPratica : function(component, event, helper, numeroPratica) {

		var action = component.get("c.recuperaPratica");
		var caseId = component.get("v.recordId");
        
        action.setParams({
			numeroPratica: numeroPratica,
			caseId: caseId
		}); 

		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
				var pratica = response.getReturnValue();

				component.set("v.dataLiquidazioneOcs", pratica.dataLiquidazione);
				component.set("v.isDataLiquidazioneOcsRed", pratica.isDataLiquidazioneRed);
                component.set("v.prodottoOcs", pratica.prodotto);
				component.set("v.assicurazioneOcs", pratica.assicurazione);
				component.set("v.isAssicurazioneOcsRed", pratica.isAssicurazioneRed);
                component.set("v.clienteOcs", pratica.cliente);
				component.set("v.descrizioneBeneOcs", pratica.descrizioneBene);
                component.set("v.modelloOcs", pratica.modello);
                component.set("v.targaOcs", pratica.targa);
				component.set("v.telaioOcs", pratica.telaio);
				var val = pratica.valore;
				console.log("*** val :: " + val);
				var valore = [val.slice(0, (val.length)-2), ".", val.slice((val.length)-2)].join('');
				console.log("*** valore :: " + valore);
				component.set("v.valoreOcs", valore);
                component.set("v.dataImmatricolazioneOcs", pratica.dataImmatricolazione);
				
				component.set("v.isDatiPraticaOpen", true);
				component.set("v.isVisualizzaButtonShown", false);

				component.set("v.codiceEsitoDiProvenienza", pratica.codiceEsitoDiProvenienza);
				console.log("*** v.codiceEsitoDiProvenienza :: " + component.get("v.codiceEsitoDiProvenienza"));

				this.callGetEsiti(component, event);
				
			}
			else {

				this.showToastKO(component, event, helper, "Si è verificato un errore. Riprovare con un diverso numero di pratica");
				
			}
		});

		$A.enqueueAction(action);
		
	},

	callProcessaAttivita : function(component, event) {

		var action = component.get("c.processaAttivita");
		var numeroPratica = component.get("v.numeroPratica");
		var codiceEsitoDiProvenienza = component.get("v.codiceEsitoDiProvenienza");
		var codiceEsitoSuccessivo = component.get("v.esitoSelezionato");
		var targaNew = component.get("v.targa");
		var telaioNew = component.get("v.telaio");
		var annoImmatricolazioneNew = component.get("v.annoImmatricolazione");
		var meseImmatricolazioneNew = component.get("v.meseImmatricolazione");
		var modelloNew = component.get("v.modello");
		var valoreNew = component.get("v.valore");
		var importoStorno = component.get("v.importoStorno");
		//var importoStorno = component.get("v.recordId");
		var note = component.get("v.nota");

		/*String caseId, String numeroPratica, String codiceEsitoDiProvenienza, String codiceEsitoSuccessivo, String labelCodiceEsitoSuccessivo, String targaNew, String telaioNew, String annoImmatricolazioneNew, String meseImmatricolazioneNew, String modelloNew, String valoreNew, String importoStorno, String note*/
        
        action.setParams({
			numeroPratica: numeroPratica,
			codiceEsitoDiProvenienza: codiceEsitoDiProvenienza,
			codiceEsitoSuccessivo: codiceEsitoSuccessivo,
			targaNew: targaNew,
			telaioNew: telaioNew,
			annoImmatricolazioneNew: annoImmatricolazioneNew,
			meseImmatricolazioneNew: meseImmatricolazioneNew,
			modelloNew: modelloNew,
			valoreNew: valoreNew,
			importoStorno: importoStorno,
			note: note
		}); 

		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){

				this.goToListaCase(component, event);

				var toastEvent = $A.get("e.force:showToast");
				toastEvent.setParams({
					title : "Operazione completata",
					type : "success",
					message : "Operazione completata con successo",
				});
				toastEvent.fire();
			}
		});

		$A.enqueueAction(action);

	},

	showToastKO : function(component, event, helper, message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title : "Attenzione",
			type : "error",
			message : message,
		});
		toastEvent.fire();
	},

	showToastWarning : function(component, event, helper, message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title : "Attenzione",
			type : "warning",
			message : message,
		});
		toastEvent.fire();
	},

	showToastInfo : function(component, event, helper, message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title : "Messaggio informativo",
			type : "info",
			message : message,
		});
		toastEvent.fire();
	},

	callCheckDoppiaAttivita : function(component, event, helper, numeroPratica, caseId) {
		console.log("*** (helper) numeroPratica :: " + numeroPratica);

		var action = component.get("c.checkDoppiaAttivita");
        
        action.setParams({
			numeroPratica: numeroPratica,
			caseId: caseId
		}); 

		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
				var isDoppiaAttivita = response.getReturnValue();
				console.log("*** (helper) isDoppiaAttivita :: " + isDoppiaAttivita);
				component.set("v.isDoppiaAttivita", isDoppiaAttivita);
			}
		});

		$A.enqueueAction(action);
	},

	callChiudiAttivita : function(component, event, helper, caseId, esito) {
		var action = component.get("c.chiudiAttivita");
        
        action.setParams({
			caseId: caseId,
			esito: esito
		}); 

		$A.enqueueAction(action);
	}
})