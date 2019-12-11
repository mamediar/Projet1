({
	doInit:	function(component, event, helper) {
		helper.initPageReference(component, event);
		helper.callGetDealerProspect(component, event);
	},

	handleSubmit: function(component, event, helper) {

		var codiceFiscale = component.find("codiceFiscale").get("v.value");
		var partitaIva = component.find("partitaIva").get("v.value");

		console.log("*** handleSubmit() codiceFiscale :: " + codiceFiscale);
		console.log("*** handleSubmit() partitaIva :: " + partitaIva);
        
        helper.checkPartitaIva(component, event, partitaIva, false);
        helper.checkCodiceFiscale(component, event, codiceFiscale);
        
        var isPartitaIvaValida = component.get("v.isPartitaIvaValida");
        var isCodiceFiscaleValido = component.get("v.isCodiceFiscaleValido");

		if (isPartitaIvaValida && !isCodiceFiscaleValido) {
			event.preventDefault();       // stop the form from submitting
			helper.showToastKO(component, event, 'Codice Fiscale errato');
		}
        else if (!isPartitaIvaValida && isCodiceFiscaleValido) {
			event.preventDefault();       // stop the form from submitting
			helper.showToastKO(component, event, 'Partita IVA errata');
		}
        else if (!isPartitaIvaValida && !isCodiceFiscaleValido) {
			event.preventDefault();       // stop the form from submitting
			helper.showToastKO(component, event, 'Partita IVA e Codice Fiscale errati');
		}

	},

	handleSuccess: function(component, event, helper) {
		helper.showToastOK(component, event);
		helper.callCheckPresenzaReport(component, event);
	},

	handleError: function(component, event, helper) {
		helper.showToastKO(component, event, "Si è verificato un errore durante il salvataggio");
	},

	handleChange: function (component, event, helper) {
		var richiestaQRPvalue = component.get("v.richiestaQRPvalue");
		if (richiestaQRPvalue == 'true') {
			helper.callRichiediQuickReport(component, event);
		}
		else {
			helper.goToRichiediGlobalExpert(component, event);
		}
		console.log("*** richiestaQRPvalue " + richiestaQRPvalue);
	},

	handleAggiornaRichiestaQRP: function (component, event, helper) {
		helper.callRichiediQuickReport(component, event);
	},

	handleSubmitRichiediGE: function(component, event, helper) {

		var ragioneSociale = component.find("ragioneSocialeRichiediGE").get("v.value");
		var partitaIva = component.find("partitaIvaRichiediGE").get("v.value");
		var codiceFiscale = component.find("codiceFiscaleRichiediGE").get("v.value");
		var indirizzo = component.find("indirizzoRichiediGE").get("v.value");
		var cap = component.find("capRichiediGE").get("v.value");
		var provincia = component.get("v.provincia");
		var citta = component.get("v.citta");
        var naturaGiuridica = component.get("v.naturaGiuridica");

		console.log("*** handleSubmitRichiediGE() ragioneSociale :: " + ragioneSociale);
		console.log("*** handleSubmitRichiediGE() partitaIva :: " + partitaIva);
		console.log("*** handleSubmitRichiediGE() codiceFiscale :: " + codiceFiscale);
		console.log("*** handleSubmitRichiediGE() indirizzo :: " + indirizzo);
		console.log("*** handleSubmitRichiediGE() cap :: " + cap);
		console.log("*** handleSubmitRichiediGE() provincia :: " + provincia);
		console.log("*** handleSubmitRichiediGE() citta :: " + citta);
        console.log("*** handleSubmitRichiediGE() naturaGiuridica :: " + naturaGiuridica);

        helper.checkCodiceFiscale(component, event, codiceFiscale);
        
        var isPartitaIvaValida;
        var isCodiceFiscaleValido = component.get("v.isCodiceFiscaleValido");
        
        if (naturaGiuridica && (naturaGiuridica.includes('INDIVIDUALE') || naturaGiuridica.includes('LIBERO PROFESSIONISTA') 
            || naturaGiuridica.includes('PERSONA FISICA') || naturaGiuridica == 'PRIVATO')) {
            
            helper.checkPartitaIva(component, event, partitaIva, true);
            isPartitaIvaValida = component.get("v.isPartitaIvaValida");

            if (isPartitaIvaValida && !isCodiceFiscaleValido) {
                event.preventDefault();       // stop the form from submitting
                helper.showToastKO(component, event, 'Codice Fiscale errato');
            }
            else if (!isPartitaIvaValida && isCodiceFiscaleValido) {
                event.preventDefault();       // stop the form from submitting
                helper.showToastKO(component, event, 'Partita IVA errata');
            }
            else if (!isPartitaIvaValida && !isCodiceFiscaleValido) {
                event.preventDefault();       // stop the form from submitting
                helper.showToastKO(component, event, 'Partita IVA e Codice Fiscale errati');
            }
            
        }
        
        else {
            
            helper.checkPartitaIva(component, event, partitaIva, false);
            isPartitaIvaValida = component.get("v.isPartitaIvaValida");

            if (isPartitaIvaValida && !isCodiceFiscaleValido) {
                event.preventDefault();       // stop the form from submitting
                helper.showToastKO(component, event, 'Codice Fiscale errato');
            }
            else if (!isPartitaIvaValida && isCodiceFiscaleValido) {
                event.preventDefault();       // stop the form from submitting
                helper.showToastKO(component, event, 'Partita IVA errata');
            }
            else if (!isPartitaIvaValida && !isCodiceFiscaleValido) {
                event.preventDefault();       // stop the form from submitting
                helper.showToastKO(component, event, 'Partita IVA e Codice Fiscale errati');
            }
            
        }

	},

	handleSuccessRichiediGE: function(component, event, helper) {
		helper.showToastOK(component, event);
		helper.callRichiediGlobalExpert(component, event);
		helper.salvaProvinciaECitta(component, event);
	},

	handleErrorRichiediGE: function(component, event, helper) {
		helper.showToastKO(component, event, "Si è verificato un errore durante il salvataggio");
	},

	handleAvanti: function(component, event, helper) {
		helper.callVaiAEsitaCase(component, event);
	},

	handleDispositionReadyEvent: function(component, event, helper) {
        console.log('***handleDispositionReadyEvent');
		var nota = event.getParam("note");
		var disposition = event.getParam("disposition");
		component.set("v.nota", nota);
		component.set("v.disposition", disposition);
		helper.callEsitaCase(component, event);
	},
	
})