({
	Init: function (cmp, event, helper) {
		cmp.set('v.today', $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"));
		this.clearFields(cmp);
	},


	/********************/
	/* EVENTI           */
	/********************/

	onPraticaSelected: function (cmp, event, helper) {
		this.clearFields(cmp);
		this.showMarkup(cmp, true);
		var messaggi = "";
		if (this.checkPraticaSelezionata(cmp) == "") {
			var pratica = cmp.get("v.PVForm.pratica");
			var scadutoPratiche = 1000;
			if (pratica.tipoPagamento != "BP") {
				messaggi = "E' possibile chiedere il ripristino RID solo per le pratiche a BP";
			}
			else if (pratica.iban == undefined || pratica.iban == null || pratica.iban == '') {
				//non ci sono ripristini da fare
				messaggi = "Non risulta un precedente iban da ripristinare, eventuali variazioni di modalità di pagamento sono di vostra competenza";
			} else if (pratica.tipoPratica == "CO") {
				//se pratica a consumo verifico se ha rate scadute con importo maggiore di 2,50
				this.mostraClessidra(cmp);
				var action = cmp.get('c.recuperaSaldoCliente');
				action.setParams({
					"codCliente": cmp.get("v.PVForm.cliente.codCliente")
				});
				// Imposto la Callback
				action.setCallback(this, function (response, helper) {
					if (response.getState() == 'SUCCESS') {
						var result = response.getReturnValue();
						console.log("response : " + response);
						scadutoPratiche = 0;
						for (var i = 0; i < result.elencoPratiche.length; i++) {
							if (result.elencoPratiche[i].scaduto != null && result.elencoPratiche[i].scaduto != "") {
								scadutoPratiche += parseFloat(result.elencoPratiche[i].scaduto);
								console.log("scadutoPratiche : " + scadutoPratiche);
							}
						}
						console.log("scadutoPratiche tot: " + scadutoPratiche);
						if (scadutoPratiche > 250) {
							console.log("scaduto");
							messaggi = "Pratica non regolare. Richiesta non inseribile. Se il cliente ha effettuato un pagamento attendere la contabilizzazione in e/c, successivamente inserire nuova richiesta.";
							console.log("messaggi :"+messaggi);
						} else {
							//visualizzo iban
							cmp.set("v.msgIban", "<FONT color=red><B>l’iban su cui verrà ripristinato l’addebito SDD è il seguente: " + pratica.iban + ". Se tale iban è stato inserito a seguito di vostra variazione, vi invitiamo ad acquisire la documentazione per la variazione dell’iban/della modalità di pagamento.</B></FONT>");
							//visualizzo data
							cmp.set("v.msgDataRipristino", "<font color=red><b>Da indicare solamente se il ripristino dev'essere eseguito dopo la prossima scadenza utile</b></font>");
						}
					} else if (response.getState() === "ERROR") {
					}
					if (messaggi != "") {
						this.mostraErrori(cmp, messaggi);
						this.showMarkup(cmp, false);
					}
					this.nascondiClessidra(cmp);
				});
				$A.enqueueAction(action);
			} else {
				//CA //visualizzo iban
				cmp.set("v.msgIban", "<FONT color=red><B>l’iban su cui verrà ripristinato l’addebito SDD è il seguente: " + pratica.iban + ". Se tale iban è stato inserito a seguito di vostra variazione, vi invitiamo ad acquisire la documentazione per la variazione dell’iban/della modalità di pagamento.</B></FONT>");
			}
			if (messaggi != "") {
				this.mostraErrori(cmp, messaggi);
				this.showMarkup(cmp, false);
			}
		}
	},

	/************************/
	/* Gestione Inserimento */
	/************************/

	validateUserInput: function (cmp, event, helper) {
		var messaggi = "";
		messaggi = this.checkPraticaSelezionata(cmp);
		if (messaggi == "") {
			//Indicizzo le variabili necessarie al test di validazione
			/*if (!cmp.find("regolareOk").checkValidity()) {
				cmp.find('regolareOk').showHelpMessageIfInvalid();
				messaggi += "Specificare se la pratica è regolare in E/C.\n";
			} else if (cmp.find("regolareOk").get("v.value") != 'SI') {
				messaggi += "La pratica non è regolare in E/C. Impossibile proseguire con la richiesta.\n";
			}*/
			if (!$A.util.isUndefinedOrNull(cmp.find("checkbox"))) { //esiste il markup
				if (!cmp.find("checkbox").checkValidity()) {
					cmp.find("checkbox").showHelpMessageIfInvalid();
					messaggi += "Spuntare la presa visione per proseguire\n";
				}
			}
		}
		return messaggi;
	},

	completaPVForm: function (cmp, event, helper, PVForm) {
		// arricchisco il PVForm con dati specifici del PV
		var dataRipristino = "";
		var pratica = cmp.get("v.PVForm.pratica");

		if (!$A.util.isUndefinedOrNull(cmp.find("dataRipristino")) && cmp.find("dataRipristino").get("v.value") != "") {
			dataRipristino = $A.localizationService.formatDate(cmp.find("dataRipristino").get("v.value"), "YYYYMMdd")
		} else if (pratica.tipoPratica == "CO" && cmp.find("dataRipristino").get("v.value") == "") {
			dataRipristino = $A.localizationService.formatDate(cmp.get("v.today"), "YYYYMMdd");
		}

		PVForm.dataRipristino = dataRipristino;
		return PVForm;
	},

	/*********************************/
	/* metodi CUSTOM del singolo PV */
	/*********************************/

	clearFields: function (cmp) {
		this.mostraErrori(cmp, "");
		cmp.set("v.msgDataRipristino", "");
		cmp.set("v.msgIban", "");
	},

})