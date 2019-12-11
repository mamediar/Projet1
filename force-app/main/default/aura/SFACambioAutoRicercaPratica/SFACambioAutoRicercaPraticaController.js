({
	handleVisualizzaPratica : function(component, event, helper) {
        
		var numeroPratica = component.get("v.numeroPratica");
		
		if (!numeroPratica || numeroPratica == '')
			helper.showToastKO(component, event, helper, "Inserire il numero di pratica.");
		else
			helper.callRecuperaPratica(component, event, helper, numeroPratica);
					
	},

	doInit: function (component, event, helper) {
		helper.callGetPratica(component, event);
		helper.initPageReference(component, event);
	},

    handleSelezionaEsito: function (component, event, helper) {
		var esitoSelezionato = component.find("listaEsitiId").get("v.value");
		component.set("v.esitoSelezionato", esitoSelezionato);
		console.log("*** esitoSelezionato :: " + esitoSelezionato);
	},
    
    handleProseguiButton: function (component, event, helper) {

		var caseId = component.get("v.recordId");
		var esitoSelezionato = component.get("v.esitoSelezionato");
		var numeroPratica = component.get("v.numeroPratica");
		var isDatiPraticaOpen = component.get("v.isDatiPraticaOpen");
		var dataLiquidazioneOcs = component.get("v.dataLiquidazioneOcs");
		var isDataLiquidazioneOcsRed = component.get("v.isDataLiquidazioneOcsRed");
		var assicurazioneOcs = component.get("v.assicurazioneOcs");
		var isAssicurazioneOcsRed = component.get("v.isAssicurazioneOcsRed");
		var targa = component.get("v.targa");
		var telaio = component.get("v.telaio");
		var annoImmatricolazione = component.get("v.annoImmatricolazione");
		var meseImmatricolazione = component.get("v.meseImmatricolazione");
		var modello = component.get("v.modello");
		var valore = component.get("v.valore");
		var isDoppiaAttivita;
		var isNotaObbligatoria = component.get("v.isNotaObbligatoria");
		var nota = component.get("v.nota");

		var codiceEsitoDiProvenienza = component.get("v.codiceEsitoDiProvenienza");

		if (!esitoSelezionato || esitoSelezionato == '') {
			helper.showToastKO(component, event, helper, "Selezionare un esito.");
			console.log("*** 1");
			return null;
		}
		
		if (!numeroPratica || numeroPratica == '') {
			helper.showToastKO(component, event, helper, "Inserire il numero di pratica.");
			console.log("*** 2");
			return null;
		}

		helper.callCheckDoppiaAttivita(component, event, helper, numeroPratica, caseId);
		isDoppiaAttivita = component.get("v.isDoppiaAttivita");
		console.log("*** isDoppiaAttivita :: " + isDoppiaAttivita);
		if (isDoppiaAttivita) {
			helper.showToastWarning(component, event, helper, "Attività di cambio auto già in corso: attendere l'esito della richiesta. Questa attività è stata chiusa.");
			console.log("*** 10");
			return null;
		}

		if (!isDatiPraticaOpen) {
			helper.showToastKO(component, event, helper, "Estrarre i dati della pratica prima di proseguire.");
			console.log("*** 3");
			return null;
		}

		if (!dataLiquidazioneOcs || !assicurazioneOcs) {
			helper.showToastKO(component, event, helper, "La pratica non è stata trovata, impossibile inserire la richiesta.");
			console.log("*** 4");
			return null;
		}

		if (!targa || !telaio) {
			helper.showToastKO(component, event, helper, "Inserire Targa e/o Telaio.");
			console.log("*** 5");
			return null;
		}

		if (!annoImmatricolazione) {
			helper.showToastKO(component, event, helper, "Inserire Anno di prima immatricolazione.");
			console.log("*** 6");
			return null;
		}

		if (!meseImmatricolazione) {
			helper.showToastKO(component, event, helper, "Inserire Mese di prima immatricolazione.");
			console.log("*** 7");
			return null;
		}

		if (!modello) {
			helper.showToastKO(component, event, helper, "Inserire Modello.");
			console.log("*** 8");
			return null;
		}

		if (!valore) {
			helper.showToastKO(component, event, helper, "Inserire Valore.");
			console.log("*** 9");
			return null;
		}

		if (isAssicurazioneOcsRed) {
			helper.callChiudiAttivita(component, event, helper, caseId, "GNLLYD");
			helper.showToastWarning(component, event, helper, "La pratica ha un'assicurazione che non consente di proseguire con il cambio auto. L' attività è stata chiusa.");
			console.log("*** 11");
			return null;
		}

		else {

			if (isDataLiquidazioneOcsRed && codiceEsitoDiProvenienza == "SEND" && esitoSelezionato == "SEND") {
				helper.showToastInfo(component, event, helper, "Sono trascorsi più di 4 mesi dalla data liquidazione della pratica.");
				console.log("*** codiceEsitoDiProvenienza :: " + codiceEsitoDiProvenienza);
				console.log("*** esitoSelezionato :: " + esitoSelezionato);
			}
				
			helper.callProcessaAttivita(component, event);
			/*var action = component.get("c.creaCase");

			action.setParams({
				dealerId: dealerId,
                developerNameAzioneSelezionata: azioneSelezionata
			}); 

			action.setCallback(this, function(response){
				if (response.getState() == 'SUCCESS'){
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						title : "Operazione completata",
						type : "success",
						message :"Attività creata con successo!",
					});
					toastEvent.fire();          
				}
			});
			$A.enqueueAction(action);*/

		}

	}
})