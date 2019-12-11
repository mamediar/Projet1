/**
 * @File Name          : PV3481AttivazioneCartaHelper.js
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Lorenzo Marzocchi
 * @Last Modified On   : 2019-10-3 12:17:50
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-6-19 14:27:49   Andrea Vanelli     Initial Version
**/
({
    /********************/
    /* EVENTI           */
    /********************/

    onPraticaSelected: function (cmp) {
        this.clearFields(cmp);
        var messaggi = this.checkPraticaSelezionata(cmp);
        if (messaggi == "") {
            var pratica = cmp.get("v.PVForm.pratica");
            if (pratica.statoPratica == '30' ||
                pratica.statoPratica == '50' || pratica.statoPratica == '50XX') {
                cmp.set('v.isPraticaAttivabile', true);
                var action = cmp.get('c.recuperaDatiFinanziari');
                action.setParams({
                    "numeroCarta": pratica.numPratica
                });
                // Imposto la Callback
                action.setCallback(this, function (response, helper) {
                    if (response.getState() == 'SUCCESS') {
                        cmp.set('v.cartaDatiFinanziariData', response.getReturnValue());
                        this.showCartaDatiFinanziari(cmp, true);
                        if ((pratica.statoPratica == '50' || pratica.statoPratica == '50XX') &&
                            (cmp.get('v.cartaDatiFinanziariData.statoRinnovoCustom') != 'RINNOVO DA ATTIVARE')) {
                            messaggi += "La carta " + pratica.numPratica + " non è attivabile/rinnovabile.";
                            cmp.set('v.isPraticaAttivabile', false);
                        }
                    }
                    else if (response.getState() === "ERROR") {
                        this.mostraToast(cmp, '', response.getError(), 'error', '');
                    }
                });
                $A.enqueueAction(action);
            } else {
                messaggi += "La carta " + pratica.numPratica + " non è attivabile/rinnovabile.";
                cmp.set('v.isPraticaAttivabile', false);
            }
            if (messaggi != "") {
                this.mostraErrori(cmp, messaggi);
                this.showMarkup(cmp, false);
            }
        } else {
            cmp.set('v.isPraticaAttivabile', false);
        }
    },


    /************************/
    /* Gestione Inserimento */
    /************************/

    validateUserInput: function (cmp, event, helper) {
        var messaggi = "";
        messaggi = this.checkPraticaSelezionata(cmp);
        return messaggi;
    },

    completaPVForm: function (cmp, event, helper, PVForm) {
        // arricchisco il PVForm con dati specifici del PV
        PVForm.datiFinanziari = cmp.get('v.cartaDatiFinanziariData');
        return PVForm;
    },

    /*********************************/
    /* metodi CUSTOM del singolo PV */
    /*********************************/

    clearFields: function (cmp) {
        this.mostraErrori(cmp, "");
        this.showMarkup(cmp, true);
        cmp.set('v.cartaDatiFinanziariData', "");
    },
})