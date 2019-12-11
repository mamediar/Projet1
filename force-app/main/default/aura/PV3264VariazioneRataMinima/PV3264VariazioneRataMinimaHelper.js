/**
 * @File Name          : PV3264VariazioneRataMinimaHelper.js
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 21/10/2019, 15:28:55
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    14/10/2019   Federico Negro     Initial Version
**/
({

    /********************/
    /*      EVENTI      */
    /********************/
    onPraticaSelected: function (cmp, event, helper) {

        this.mostraErrori(cmp, "");
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
                    this.recuperaDatiFinanziariJS(cmp);
                } else if (response.getState() === "ERROR") {
                    this.mostraToast(cmp, '', response.getError(), 'error', '');
                }
                this.nascondiClessidra(cmp);
            });
            $A.enqueueAction(action);
        }
    },

    //recupero dati finanziari
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
                //console.log("recuperaDatiFinanziari : State(): " + response.getState());
                //console.log("recuperaDatiFinanziari : result : " + JSON.stringify(response.getReturnValue()));
                if (response.getState() == 'SUCCESS') {
                    var result = response.getReturnValue();
                    cmp.set('v.cartaDatiFinanziariData', result);
                    this.showCartaDatiFinanziari(cmp, true);
                    this.salvoValori(cmp); //salva valori precedenti per le note
                    this.checkCartaMulti(cmp);
                } else {
                    this.mostraToast(cmp, '', response.getError(), 'error', '');
                }
                this.nascondiClessidra(cmp);
            });
            $A.enqueueAction(action);
        }
    },

    checkCartaMulti: function (cmp) {

        var messaggi = "";
        var modCalcoloRata = cmp.get("v.cartaDatiFinanziariData.modCalcoloRataCustom");

        if (cmp.get("v.infoCartaData.multifunzioneF") != "S") {

            if (cmp.get("v.infoCartaData.multifunzioneR") != "S") {

                if (cmp.get("v.infoCartaData.multifunzioneS") != "S") {

                    if (cmp.get("v.infoCartaData.multifunzioneT") != "S") {

                        if (modCalcoloRata == "F - FIDO/RATA" || modCalcoloRata == "R - PERCENTUALE SU SALDO") {
                            messaggi += "La carta non è multifunzione. Eseguire prima la modifica del prodotto";
                            this.mostraErrori(cmp, messaggi);
                            this.showMarkup(cmp, false);
                        }
                    }
                }
            }
        }

        if (modCalcoloRata != "R - PERCENTUALE SU SALDO") {
            messaggi += "La carta non è revolving con rata variabile. Impossibile procedere";
            this.mostraErrori(cmp, messaggi);
            this.showMarkup(cmp, false);
        }
        if (messaggi == "") {
            this.getRataMinima(cmp);
        }
    },

    //recupera la rata minima
    getRataMinima: function (cmp) {
        var emettitore = cmp.get('v.cartaDatiFinanziariData.emettitore');
        var action = cmp.get('c.getRataMinima');
        this.mostraClessidra(cmp);
        action.setParams({
            "emettitore": emettitore
        });
        action.setCallback(this, function (response, helper) {
            //console.log("getStep : State(): " + response.getState());
            //console.log("getStep : result : " + JSON.stringify(response.getReturnValue()));
            if (response.getState() == 'SUCCESS') {
                var credit_limit_row = response.getReturnValue();
                cmp.set("v.rataMinimaConsentita", credit_limit_row.Rata_minima__c);
            } else {
                console.log("Chiamata non eseguita correttamente");
                var messaggi = "Emettitore non abilitato all'erogazione";
                this.mostraErrori(cmp, messaggi);
                this.showMarkup(cmp, false);
            }
            this.nascondiClessidra(cmp);
        });

        $A.enqueueAction(action);
    },

    salvoValori: function (cmp) {
        var rata = cmp.get("v.cartaDatiFinanziariData.pagamentoMinimo");
        var perc = cmp.get("v.cartaDatiFinanziariData.pagamentoMinimoPerc");
        cmp.set("v.rata_OLD", rata);
        cmp.set("v.percentuale_OLD", perc);
    },

    /************************/
    /* Gestione Inserimento */
    /************************/

    validateUserInput: function (cmp, event, helper) {
        var messaggi = "";
        messaggi = this.checkPraticaSelezionata(cmp);
        if (messaggi == "") {

            var RataMinima = 0;
            var rataMinimaUtente = cmp.find("rata_minima").get("v.value");
            var rataMinAssegnata = parseInt(cmp.get("v.rataMinimaConsentita"));
            var percentuale = cmp.find("percentuale").get("v.value");

            //verifica che ci sia stata una variazione in almeno un campo
            if (percentuale == cmp.get("v.percentuale_OLD") && rataMinimaUtente == cmp.get("v.rata_OLD")) {

                messaggi = "Nessuna variazione da apportare.\n";

            } else {
                //verifica validità campo percentuale
                if (!cmp.find("percentuale").checkValidity()) {
                    cmp.find('percentuale').showHelpMessageIfInvalid();
                    if(percentuale == null || percentuale == ""){
                        messaggi+="Inserire percentuale su saldo.\n";
                    }else{
                        messaggi += "Percentuale su saldo non valida.\n";
                    }
                }else{
                    if (parseFloat(percentuale) == 0) {
                        percentuale = "";
                    }
                }

                //verifica validità campo rata minima
                if (!cmp.find("rata_minima").checkValidity()) {
                    cmp.find('rata_minima').showHelpMessageIfInvalid();
                    if(rataMinimaUtente==null || rataMinimaUtente==""){
                        messaggi+="Inserire rata minima.\n";
                    }else if(rataMinimaUtente<rataMinAssegnata && rataMinimaUtente>0){
                        messaggi+="La rata minima è troppo bassa. Inserita: "+rataMinimaUtente+". Assegnata: "+rataMinAssegnata+".\n";
                    }else if(rataMinimaUtente>1000){
                        messaggi+="La rata minima inserita è tropo alta. Il limite è 1000.";
                    }else{
                        messaggi += "Rata minima non valida.\n";
                    }
                }
            }

        }

        return messaggi;
    },

    completaPVForm: function (cmp, event, helper, PVForm) {
        //arricchisco il PVForm con dati specifici del PV

        PVForm.rataOld = cmp.get("v.rata_OLD");
        PVForm.rataNew = cmp.find('rata_minima').get('v.value') * 100;

        PVForm.percentualeOld = cmp.get("v.percentuale_OLD");
        PVForm.percentualeNew = cmp.find('percentuale').get('v.value') * 100;

        return PVForm;
    },

})