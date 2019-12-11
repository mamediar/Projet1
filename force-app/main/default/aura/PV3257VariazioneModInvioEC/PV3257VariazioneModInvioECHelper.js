/**
 * @File Name          : PV3257VariazioneModInvioECHelper.js
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 18/10/2019, 16:54:51
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    9/10/2019   Federico Negro     Initial Version
**/

({

    /********************/
    /*      EVENTI      */
    /********************/

    onPraticaSelected: function (cmp, event, helper) {

        this.mostraErrori(cmp, "");

        this.recuperaDatiFinanziariJS(cmp);
        this.recuperaInfoCarta(cmp);

        this.showMarkup(cmp, true);

    },

    /*********************************/
    /* metodi CUSTOM del singolo PV */
    /*********************************/

    //Recupero info carta
    recuperaInfoCarta: function (cmp) {
        var messaggi = this.checkPraticaSelezionata(cmp);
        if (messaggi == "") {
            var pratica = cmp.get("v.PVForm.pratica");
            var action = cmp.get('c.recuperaInfoCarta');
            action.setParams({
                "numeroCarta": pratica.numPratica
            });
            this.mostraClessidra(cmp);
            // Imposto la Callback
            action.setCallback(this, function (response, helper) {
                //console.log("recuperaInfoCarta : result : " + JSON.stringify(response.getReturnValue()) + " - " + response.getState());
                if (response.getState() == 'SUCCESS') {
                    cmp.set("v.infoCartaData", response.getReturnValue());
                    //set modalità di invio
                    this.valoreModalitaInvio(cmp);
                } else if (response.getState() === "ERROR") {
                    this.mostraToast(cmp, '', response.getError(), 'error', '');
                }
                this.nascondiClessidra(cmp);
            });
            $A.enqueueAction(action);
        }
    },

    recuperaDatiFinanziariJS: function (cmp) {
        var messaggi = this.checkPraticaSelezionata(cmp);
        if (messaggi == "") {
            var pratica = cmp.get("v.PVForm.pratica");
            var action = cmp.get('c.recuperaDatiFinanziari');
            action.setParams({
                "numeroCarta": pratica.numPratica
            });
            this.mostraClessidra(cmp);
            // Imposto la Callback
            action.setCallback(this, function (response, helper) {
                // console.log("recuperaDatiFinanziari : State(): " + response.getState());
                //console.log("recuperaDatiFinanziari : result : " + JSON.stringify(response.getReturnValue()));
                if (response.getState() == 'SUCCESS') {
                    var result = response.getReturnValue();
                    cmp.set('v.cartaDatiFinanziariData', result);
                    this.showCartaDatiFinanziari(cmp, true);
                } else {
                    this.mostraToast(cmp, '', response.getError(), 'error', '');
                }
                this.nascondiClessidra(cmp);
            });
            $A.enqueueAction(action);
        }
    },

    valoreModalitaInvio: function (cmp) {
        var valore = cmp.get("v.infoCartaData.modalitaInvioEC");
        cmp.find("mod_invio").set("v.value", valore);
    },

    /************************/
    /* Gestione Inserimento */
    /************************/

    validateUserInput: function (cmp, event, helper) {
        var messaggi = "";
        var modalita = cmp.find('mod_invio').get('v.value');
        messaggi = this.checkPraticaSelezionata(cmp);
        if (messaggi == "") {

            //verifica che la modalità sia diversa da quella precedente
            if (modalita == cmp.get("v.infoCartaData.modalitaInvioEC")) {
                messaggi = "Nessuna variazione da apportare.\n";
            } else {

                //controllo selezione modalità
                if (!cmp.find("mod_invio").checkValidity()) {
                    cmp.find("mod_invio").showHelpMessageIfInvalid();
                    messaggi += "Selezionare una modalità di invio.\n";
                } else {

                    //verifico che la mail sia valida
                    if (cmp.find("mod_invio").get("v.value") != "C") {
                        var re = /^[a-zA-Z0-9._|\\%#~`=?&amp;\/$^*!}{+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
                        var mail = cmp.find("mail_carta").get("v.value").trim();
                        cmp.set("v.infoCartaData.emailCarta", mail);

                        if (!re.test(mail)) {
                            cmp.find("mail_carta").showHelpMessageIfInvalid();
                            messaggi += "Email su carta non valida. Variare la mail o selezionare la modalità Cartaceo.\n";
                        }
                    }

                }

            }

        }
        return messaggi;
    },

    completaPVForm: function (cmp, event, helper, PVForm) {
        // arricchisco il PVForm con dati specifici del PV
        PVForm.modalitaNuova = cmp.find('mod_invio').get('v.value');
        PVForm.modalitaVecchia = cmp.get("v.infoCartaData.modalitaInvioEC");
        PVForm.emailCarta = cmp.get("v.infoCartaData.emailCarta");

        return PVForm;
    },

})