/**
 * @File Name          : PV3260AumentoFidoHelper.js
 * @Description        : 
 * @Author             : Lorenzo Marzocchi
 * @Group              : 
 * @Last Modified By   : Lorenzo Marzocchi
 * @Last Modified On   : 2019-10-15 17:02:26
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-6-26 12:18:30   Lorenzo Marzocchi     Initial Version
**/
({

    /********************/
    /* EVENTI           */
    /********************/


    onPraticaSelected: function (cmp) {
        this.clearFields(cmp);
        var pratica = cmp.get("v.PVForm.pratica");

        // verifico che la pratica sia attiva
        this.checkPraticaAttiva(cmp);

        //se attiva, recupero i dati finanziari da esporre in pagina
        if (cmp.get('v.isPraticaAttiva')) {
            console.log("pratica.numPratica :" +pratica+" "+pratica.numPratica);
            this.mostraClessidra(cmp);
            var action = cmp.get('c.recuperaDatiFinanziari');
            action.setParams({
                "numeroCarta": pratica.numPratica
            });
            // Imposto la Callback
            action.setCallback(this, function (response, helper) {
                console.log("recuperaDatiFinanziari : State(): " + response.getState());
                console.log("recuperaDatiFinanziari : result : " + JSON.stringify(response.getReturnValue()));
                if (response.getState() == 'SUCCESS') {
                    var result = response.getReturnValue();

                    cmp.set('v.cartaDatiFinanziariData', result);
                    //chiamo la util che effettua tutti i controlli centralizzati per AF
                    this.verificheAF(cmp);
                    // chiamo il server per recuperare lo step

                }
                else {
                    this.mostraToast(cmp, '', response.getError(), 'error', '');
                }
                this.nascondiClessidra(cmp);
            });
            $A.enqueueAction(action);
        }

    },

    /************************/
    /* Gestione Inserimento */
    /************************/

    validateUserInput: function (cmp, event, helper) {

        //Indicizzo le variabili necessarie al test di validazione
        var messaggi = "";

        var nextStep = cmp.get('v.nuovoFidoDaAbbinare');
        var FAXRequired = cmp.get("v.FAXRequired");

        // valori della carta calcolati o imputati per il B2BSOAP
        var riservaPrincipale = "";
        var riservaSalvadanaio = "";
        var fidoTotale = 0; // campo che viene calcolato sommando le riserve
        var rataMinima = "";// cmp.get('v.rataModificabile');

        //valori della carta recuperati da servizio
        var riservaPrincipaleOld = cmp.get('v.cartaDatiFinanziariData.riservaPrincipale');
        var riservaSalvadanaioOld = cmp.get('v.cartaDatiFinanziariData.riservaSalvadanaio');
        var fidoTotaleOld = cmp.get('v.cartaDatiFinanziariData.fidoTotale');
        var rataMinimaAssegnata = cmp.get('v.cartaDatiFinanziariData.pagamentoMinimo');
        var modCalcoloRataOld = cmp.get('v.cartaDatiFinanziariData.modCalcoloRata');
        var riservaInternetFido = cmp.get('v.cartaDatiFinanziariData.riservaInternetFido');
        var riservaMulticontoFido = cmp.get('v.cartaDatiFinanziariData.riservaMulticontoFido');

        //inizio le verifiche di validazione
        messaggi += this.checkPraticaSelezionata(cmp);
        if (messaggi == "") {
            //controllo se il FAX era obbligatorio e se è stato flaggato
            if (FAXRequired) {
                var FAXChecked = cmp.find('FAXcheckbox').get('v.checked');
                if (!FAXChecked) {
                    messaggi += "Confermare la ricezione del FAX \n";
                }
            }

            // controllo che in campi in maschera siano stati valorizzati correttamenrte
            if (!(cmp.find("rataModificabile").checkValidity())) {
                messaggi += "Valorizzare il campo rata\n";
            } else {
                var rataMinima = cmp.get('v.rataModificabile');
            }
            if (!(cmp.find("riservaSalvadanaio").checkValidity())) {
                messaggi += "Valorizzare il campo riserva salvadanaio\n";
            } else {
                var riservaSalvadanaio = cmp.get('v.riservaSalvadanaio');
            }
            if (!(cmp.find("riservaPrincipale").checkValidity())) {
                messaggi += "Valorizzare il campo riserva principale\n";
            } else {
                var riservaPrincipale = cmp.get('v.riservaPrincipale');
            }

            // la RATA MINIMA ASSEGNATA è QUELLA recuperta da B2BSOAP mentre la RATA MINIMA è quella immessa a schermo
            // verifico che la rata minima assegnata non sia nulla, non sia vuota, non sia T e non sia R la mod
            // se la rata minima assegnata è > della rata minima allora msg di errore
            if (rataMinimaAssegnata != null && !rataMinimaAssegnata == "" && !modCalcoloRataOld == "T" && !modCalcoloRataOld == "R") {
                if (rataMinimaAssegnata > rataMinima) {
                    messaggi += "La rata minima è troppo bassa. Inserita:" + rataMinima + " - Assegnata: " + rataMinimaAssegnata;
                }
            }


            if ($A.util.isUndefinedOrNull(riservaPrincipale)) {
                riservaPrincipale = "";
            }
            else {
                if (riservaPrincipale == "0") {
                    riservaPrincipale = "";
                }
                else {
                    fidoTotale += riservaPrincipale*1;
                }
            }

            //se la riserva principale è uguale al totale, la carta non è a riserve, quindi passo le riserve vuote
            if (riservaPrincipaleOld == fidoTotaleOld) {
                riservaPrincipale = "";
                riservaSalvadanaio = "";
                riservaInternetFido = "";
                riservaMulticontoFido = "";
            }

            // calcolo del fido totale
            else {
                if ($A.util.isUndefinedOrNull(riservaSalvadanaio)) {
                    riservaSalvadanaio = "";
                }
                else {
                    if (riservaSalvadanaio == "0" || riservaSalvadanaio == "") {
                        riservaSalvadanaio = "";
                    }
                    else {
                        fidoTotale += riservaSalvadanaio*1;
                    }
                }

                if ($A.util.isUndefinedOrNull(riservaInternetFido)) {
                    riservaInternetFido = "";
                }
                else {
                    if (riservaInternetFido == "0" || riservaInternetFido == "") {
                        riservaInternetFido = "";
                    }
                    else {
                        fidoTotale += riservaInternetFido*1;
                    }
                }

                if ($A.util.isUndefinedOrNull(riservaMulticontoFido)) {
                    riservaMulticontoFido = "";
                }
                else {
                    if (riservaMulticontoFido == "0" || riservaMulticontoFido == "") {
                        riservaMulticontoFido = "";
                    }
                    else {
                        fidoTotale += riservaMulticontoFido*1;
                    }
                }
            }

            console.log ("nextStep & FidoTotale" + nextStep + " "+ fidoTotale);
            if (nextStep != fidoTotale) {
                messaggi += "Gli importi inseriti non corrispondono al nuovo fido assegnato. Inserito:" + fidoTotale + " - Assegnato: " + nextStep;
            }

            

            var PVForm = cmp.get("v.PVForm");
            PVForm.riservaPrincipale = riservaPrincipale;
            PVForm.riservaSalvadanaio = riservaSalvadanaio;
            PVForm.rataMinima = rataMinima;
            PVForm.fidoTotale = fidoTotale;
            PVForm.riservaInternetFido = riservaInternetFido;
            PVForm.riservaMulticontoFido = riservaMulticontoFido;
            cmp.set("v.PVForm", PVForm);

            console.log("v.PVForm " + PVForm);
        }
        return messaggi;
    },

    completaPVForm: function (cmp, event, helper, PVForm) {

        return PVForm;
    },

    /*********************************/
    /* metodi CUSTOM del singolo PV */
    /*********************************/

    checkPraticaAttiva: function (cmp) {
        var pratica = cmp.get("v.PVForm.pratica");
        console.log("v.praticaSelezionata" + JSON.stringify(cmp.get("v.PVForm.pratica")));
        //verifica se la carta è attiva
        if (pratica != null && pratica != undefined && pratica != '') {

            if ((pratica.statoPratica == '50' || pratica.statoPratica == '50XX' || pratica.statoPratica == '60XX' || pratica.statoPratica == '60H' || pratica.statoPratica == '60' || pratica.statoPratica == '60PE')
            ) {
                cmp.set('v.isPraticaAttiva', true);
                this.mostraErrori(cmp, '');
            } else {
                var messaggi = "La carta " + pratica.numPratica + " non è attiva o ha dei blocchi diversi da H, PE o XX. Impossibile eseguire l'aumento";
                this.mostraErrori(cmp, messaggi);
                this.showMarkup(cmp, false);
                cmp.set('v.isPraticaAttiva', false);
            }
        } else {
            cmp.set('v.isPraticaAttiva', false);
        }
    },




    verificheAF: function (cmp) {
        var numPratica = cmp.get('v.PVForm.pratica.numPratica');
        var codCliente = cmp.get('v.PVForm.cliente.codCliente');
        var action = cmp.get('c.verificheAF');
        action.setParams({
            "numPratica": numPratica,
            "codCliente": codCliente
        });
        this.mostraClessidra(cmp);
        action.setCallback(this, function (response, helper) {
            console.log("verificheAF : State(): " + response.getState());
            console.log("verificheAF : result : " + JSON.stringify(response.getReturnValue()));
            if (response.getState() == 'SUCCESS') {
                var verificaResult = response.getReturnValue();
                console.log("verificaResult.tipoErrore + verificaResult.messaggioErrore : " + verificaResult.toastType + verificaResult.messaggioErrore);
                if (verificaResult.toastType == 'Error') {
                    var messaggi = verificaResult.messaggioErrore;
                    this.mostraErrori(cmp, messaggi);
                    this.showMarkup(cmp, false);
                }
                else {
                    cmp.set("v.nuovoFidoDaAbbinare", verificaResult.actualStep);
                    if (verificaResult.FXRequired == 'FX') {
                        cmp.set("v.FAXRequired", true);
                    }
                    else {
                        cmp.set("v.FAXRequired", false);
                    }
                    this.getStep(cmp);
                    console.log("attivo la carta dati");
                    this.showCartaDatiFinanziari(cmp, true);
                    //prevalorizzo i campi
                    cmp.set("v.riservaPrincipale",cmp.get("v.cartaDatiFinanziariData.riservaPrincipaleFido"));
                    cmp.set("v.riservaSalvadanaio",cmp.get("v.cartaDatiFinanziariData.riservaSalvadanaioFido"));
                    cmp.set("v.rataModificabile",cmp.get("v.cartaDatiFinanziariData.pagamentoMinimo"));
                }

            }
            else {
                var messaggi = "chiamata al Server non eseguita correttamente";
                this.mostraErrori(cmp, messaggi);
                this.showMarkup(cmp, false);
            }
            this.nascondiClessidra(cmp);
        });

        $A.enqueueAction(action);

    },

    getStep: function (cmp) {

        var emettitore = cmp.get('v.cartaDatiFinanziariData.emettitore');
        var action = cmp.get('c.getStep');
        this.mostraClessidra(cmp);
        action.setParams({
            "emettitore": emettitore
        });
        action.setCallback(this, function (response, helper) {
            console.log("getStep : State(): " + response.getState());
            console.log("getStep : result : " + JSON.stringify(response.getReturnValue()));
            if (response.getState() == 'SUCCESS') {
                var credit_limit_row = response.getReturnValue();

                if (credit_limit_row.Step_di_aumento__c == '-1') {
                    var messaggi = "Emettitore non abilitato";
                    this.mostraErrori(cmp, messaggi);
                    this.showMarkup(cmp, false);
                } else {
                    cmp.set("v.StepAbbinati", credit_limit_row.Step_di_aumento__c);
                }

            }
            else {
                cmp.set("v.importoErogabile", "-1");
                console.log("chiamata non eseguita correttamente");
                var messaggi = "Emettitore non abilitato all'erogazione";
                this.mostraErrori(cmp, messaggi);
                this.showMarkup(cmp, false);
            }
            this.nascondiClessidra(cmp);
        });

        $A.enqueueAction(action);

    },


    clearFields: function (cmp) {

        cmp.set("v.FAXRequired", false);
        cmp.set("v.isPraticaAttiva", "");
        cmp.set("v.scriptSMS", "");
        cmp.set("v.riservaPrincipale", "");
        cmp.set("v.riservaSalvadanaio", "");
        cmp.set("v.rataModificabile", "");
        cmp.set("v.StepAbbinati", "");
        cmp.set("v.nuovoFidoDaAbbinare", "");
        this.showCartaDatiFinanziari(cmp, false);
        this.showMarkup(cmp, true);
    },


})