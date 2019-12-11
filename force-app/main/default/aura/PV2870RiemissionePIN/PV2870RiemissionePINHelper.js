/**
 * @File Name          : PV2870RiemissionePINHelper.js
 * @Description        : 
 * @Author             : Lorenzo Marzocchi
 * @Group              : 
 * @Last Modified By   : Lorenzo Marzocchi
 * @Last Modified On   : 2019-10-2 17:29:20
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    2019-10-2   Lorenzo Marzocchi     Initial Version
**/
({
    /********************/
    /* EVENTI           */
    /********************/

    onClienteSelected: function (cmp) {
		this.clearFields(cmp);
		this.showMarkup(cmp,true);
		this.recuperaIndirizzoCliente(cmp);
    },

	onPraticaSelected: function (cmp) {
		this.clearFields(cmp);
		this.showMarkup(cmp,true);
		// verifico che la pratica sia attiva
		this.checkPraticaAttiva(cmp);
    },


	/*********************************/
	/* metodi CUSTOM del singolo PV */
    /*********************************/


	recuperaIndirizzoCliente: function (cmp) {
		var messaggi = this.checkClienteSelezionato(cmp);
		if (messaggi == "") {
			var action = cmp.get('c.recuperaIndirizzoCompleto');
			action.setParams({
				"codCliente": cmp.get("v.PVForm.cliente.codCliente")
			});
			// Imposto la Callback
			action.setCallback(this, function (response, helper) {
				if (response.getState() == 'SUCCESS') {
					cmp.set('v.indirizzoCompleto', response.getReturnValue());
				}
				else if (response.getState() === "ERROR") {
					this.mostraToast(cmp, '', response.getError(), 'error', '');
				}
			});
			$A.enqueueAction(action);
		}
	},

    checkPraticaAttiva: function (cmp) {
		//verifica se la carta è attiva
		var messaggi = this.checkPraticaSelezionata(cmp);
		if (messaggi == "") {
			var pratica = cmp.get("v.PVForm.pratica");
			if (pratica.statoPratica == '50' ){
				//recupero lo stato rinnovo
				var action = cmp.get('c.recuperaDatiFinanziari');
				action.setParams({
					"numeroCarta": pratica.numPratica
				});
				// Imposto la Callback
				action.setCallback(this, function (response, helper) {
					console.log("recuperaDatiFinanziari : result : " + JSON.stringify(response.getReturnValue()));
					if (response.getState() == 'SUCCESS') {
						var result = response.getReturnValue();
						if(result.statoRinnovoCustom.toUpperCase() == ('RINNOVO ATTIVO').toUpperCase() ||
							result.statoRinnovoCustom.toUpperCase() == ('-').toUpperCase()) {
							/********************************************/
							//recupero info carta
							var action2 = cmp.get('c.recuperaInfoCarta');
							action2.setParams({
								"numeroCarta": pratica.numPratica
							});
							// Imposto la Callback
							action2.setCallback(this, function (response2, helper) {
								console.log("recuperaInfoCarta : result : " + JSON.stringify(response2.getReturnValue()) + " - " + response2.getState());
								if (response2.getState() == 'SUCCESS') {
									cmp.set("v.infoCartaData",response2.getReturnValue());
								}else if (response2.getState() === "ERROR") {
									this.mostraToast(cmp, '', response2.getError(), 'error', '');
								}
							});
							$A.enqueueAction(action2);			
						}else{
							messaggi += "La carta non è attiva. Non è possibile chiedere la riemissione del pin.";
						}			
					}else if (response.getState() === "ERROR") {
						this.mostraToast(cmp, '', response.getError(), 'error', '');
					}
				});
				$A.enqueueAction(action);			

            }else {
                messaggi += "La carta non è attiva. Non è possibile chiedere la riemissione del pin.";
			}
			if(messaggi != ""){
				this.mostraErrori(cmp, messaggi);
				this.showMarkup(cmp,false);
			}
        }
    },


    /************************/
    /* Gestione Inserimento */
    /************************/

    validateUserInput: function(cmp, event, helper) {
        var messaggi = "";
        messaggi = this.checkPraticaSelezionata(cmp);
        if(messaggi == ""){
			//Indicizzo le variabili necessarie al test di validazione
            if(!cmp.find("indirizzoOk").checkValidity()){
                cmp.find('indirizzoOk').showHelpMessageIfInvalid();
                messaggi += "Specificare se l'indirizzo è corretto.\n";
			}else if(cmp.find("indirizzoOk").get("v.value") != 'SI'){
				messaggi += "Impossibile procedere.\n Per effettuare la modifica indirizzo selezionare Gestione Cliente - Variazione Indirizzi.\n";
			}
        }    
		return messaggi;
	},

    completaPVForm: function(cmp, event, helper, PVForm) {
        // arricchisco il PVForm con dati specifici del PV
        return PVForm;
    },

    clearFields: function (cmp) {
		this.mostraErrori(cmp, "");
		cmp.set("v.infoCartaData", "");
    },

})