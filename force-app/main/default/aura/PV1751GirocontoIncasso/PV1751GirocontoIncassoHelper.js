({
	init : function(cmp, event, helper) {
		cmp.set('v.today', $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"));
	},

    /********************/
    /* EVENTI           */
    /********************/

    onPraticaSelected: function (cmp) {
		var messaggi = this.checkPraticaSelezionata(cmp);
		console.log("messaggio : " + messaggi);
		if (messaggi == "") {
			if(cmp.get("v.praticaOrigine").length == 0){
				//setto riga della pratica con tutti i dati che servono ad apex
				cmp.set("v.praticaOrigine", this.setRowPratica(cmp));  	
				//setto il cliente della pratica di origine
				cmp.set("v.OCSClienteOrigine",cmp.get("v.PVForm.cliente"));	
			}else if (cmp.get("v.praticheDestinazione").length < 3){
				this.setPraticaDestinazione(cmp);
			}
		}
    },


    /************************/
    /* Gestione Inserimento */
    /************************/

    validateUserInput: function(cmp, event, helper) {
		var messaggi = "";
		var errors = { rows: {} /*, table: {}*/ };
		var errorPraticheDest=false;

		var praticheDest = cmp.get("v.praticheDestinazione");
		
		if(praticheDest.length < 1 || cmp.get("v.praticaOrigine").length < 1){
			messaggi += "Selezionare almeno una pratica di origine e una di destinazione.\n";
		}
		for(var i=0;i<praticheDest.length;i++){
			if(praticheDest[i].importo == 0){
				errors.rows[praticheDest[i].numPratica] = { title: "pratica di destinazione", messages: ['importo obbligatorio'], fieldNames: ['importo'] };
				cmp.set("v.errors", errors);
				errorPraticheDest=true;
			}
		}
		if(errorPraticheDest){
			messaggi += "Valorizzare tutti gli importi delle pratiche di destinazione e salvare.\n";
		}
		if(cmp.find("importoTot").get("v.value") == 0 || !cmp.find("importoTot").checkValidity()){
			cmp.find("importoTot").showHelpMessageIfInvalid();
			messaggi += "Inserire l'importo totale.\n";
		}		
		if(!cmp.find("dataIncasso").checkValidity()){
			cmp.find("dataIncasso").showHelpMessageIfInvalid();
			messaggi += "Indicare la data di incasso.\n";
		}
		if(!cmp.find("rimborso").checkValidity()){
			cmp.find("rimborso").showHelpMessageIfInvalid();
			messaggi += "Selezionare se necessario un rimborso.\n";
		}	
		else if(cmp.get("v.rimborso") == 'true'){
			if(!cmp.find("importoTotRimborso").checkValidity()){
				cmp.find("importoTotRimborso").showHelpMessageIfInvalid();
				messaggi += "Inserire un importo da rimborsare al cliente.\n";
			}else{
				if(parseFloat(cmp.find("importoTotRimborso").get("v.value")) + parseFloat(cmp.find("importoTotGiroconto").get("v.value")) != parseFloat(cmp.find("importoTot").get("v.value"))){
					messaggi += "La somma degli importi da rimborsare/girocontare non corrisponde al totale.\n";
				}
			}	
			if(!$A.util.isUndefinedOrNull(cmp.get("v.modalitaRimborso"))){
				var child = cmp.find("modRimborso");
				child.doValidityCheck();
				messaggi += cmp.get("v.erroriModRimborso");
			}		
		}
        return messaggi;
	},

    completaPVForm: function(cmp, event, helper, PVForm) {
        // arricchisco il PVForm con dati specifici del PV
		var totRimborso;
		if(!$A.util.isUndefinedOrNull(cmp.find("importoTotRimborso"))){
			totRimborso = cmp.find("importoTotRimborso").get("v.value");
		}

		PVForm.cliente = cmp.get('v.OCSClienteOrigine');
		PVForm.modalitaRimborso = cmp.get("v.modalitaRimborso");
		PVForm.noteRimborso = cmp.get("v.notaModalitaRimborso");
		PVForm.dataIncasso = cmp.find("dataIncasso").get("v.value");
		PVForm.hasRimborso = cmp.get("v.rimborso");
		PVForm.totImporto = cmp.find("importoTot").get("v.value");
		PVForm.totRimborso = totRimborso;
		PVForm.pratica = cmp.get("v.praticaOrigine")[0];
		PVForm.praticheDestinazione = cmp.get("v.praticheDestinazione");
        return PVForm;
    },
	

    /*********************************/
	/* metodi CUSTOM del singolo PV */
    /*********************************/

    setPraticaDestinazione: function(cmp) {
		//verifico se la pratica non è già presente in lista
		var pratiche = cmp.get("v.praticheDestinazione");
		var newPratica = true;
		for (var i = 0; i < pratiche.length; i++) {
			if (cmp.get("v.PVForm.numPratica") == pratiche[i]['numPratica']) {
				newPratica = false; break;
			}
		}
		if (newPratica) {
			//setto riga della pratica con tutti i dati che servono ad apex
			cmp.set("v.praticheDestinazione", cmp.get("v.praticheDestinazione").concat(this.setRowPratica(cmp)));  				
		}
	},	
	
	setRowPratica: function(cmp){
		const data = [];
		var pratica = cmp.get("v.PVForm.pratica");
		var cliente = cmp.get("v.PVForm.cliente");
		data.push({
						numPratica: pratica.numPratica, 
						tipoPratica: pratica.tipoPratica, 
						statoPratica: pratica.statoPratica, 
						prodotto: pratica.prodotto, 
						tipoPagamento: pratica.tipoPagamento,
						convenzionato: pratica.venditore, 
						codCliente: cliente.codCliente, 
						ragioneSociale: cliente.denominazione, 
						dealerCode: pratica.dealerCode,
						//importo : 0
						importo : ""
				});

		return data;	
	},

	handleRowAction: function (cmp, event) {
        var action = event.getParam('action');
		var row = event.getParam('row');
        switch (action.name) {
            case 'deleteRecord':
                this.removeRow(cmp, row);
                break;
            default:
                break;
        }
    },

	handleRowActionOrig: function (cmp, event) {
        var action = event.getParam('action');
		var row = event.getParam('row');
        switch (action.name) {
            case 'deleteRecord':
                this.removeRowOrig(cmp, row);
                break;
            default:
                break;
        }
    },

    handleSave: function (cmp, event, helper) {
		var pratiche = cmp.get('v.praticheDestinazione');
		var errors = { rows: {} /*, table: {}*/ };
		var error=false;

        if (!$A.util.isUndefinedOrNull(event.getParam('draftValues'))) {
			//salvo gli importi
			var draftValues = event.getParam('draftValues');
			//ciclo sulle pratiche/importi e li salvo sulle pratiche
			for(var p=0;p<pratiche.length;p++){
				var found = false;
				for(var d=0;d<draftValues.length;d++){
					if(pratiche[p].numPratica == draftValues[d].numPratica){
						found = true;
						if(draftValues[d].importo == 0 || $A.util.isUndefinedOrNull(draftValues[d].importo)){
							errors.rows[pratiche[p].numPratica] = { title: "pratica di destinazione", messages: ['importo obbligatorio'], fieldNames: ['importo'] };
							error=true;
						}
						break;
					}
				}
				if(!found){
					errors.rows[pratiche[p].numPratica] = { title: "pratica di destinazione", messages: ['importo obbligatorio'], fieldNames: ['importo'] };
					error=true;
				}
				if(found && !error){
					cmp.get('v.praticheDestinazione')[p].importo = draftValues[d].importo;
				}
			}
			cmp.set("v.errors", errors);
		}
		if(!error){
			this.calcolaTotale(cmp);
		}
	},
	
    handleCancel: function (cmp, event, helper) {
		this.calcolaTotale(cmp)
    },

	removeRow: function(cmp, row){
		var rows = cmp.get('v.praticheDestinazione');
		var rowIndex = rows.indexOf(row);
        rows.splice(rowIndex, 1);
		cmp.set('v.praticheDestinazione', rows);		
		this.calcolaTotale(cmp);
	},

	/**/
	removeRowOrig: function(cmp, row){
		var rows = cmp.get('v.praticaOrigine');
		var rowIndex = rows.indexOf(row);
        rows.splice(rowIndex, 1);
		cmp.set('v.praticaOrigine', rows);		
	},

    calcolaTotale: function (cmp) {
		var totale = 0;
		for(var i=0;i<cmp.get('v.praticheDestinazione').length;i++){
			totale += parseFloat(cmp.get("v.praticheDestinazione")[i].importo);
		}
		cmp.find("importoTotGiroconto").set("v.value",totale);
	},

})