/**
 * @File Name          : PVInserimento2Helper.js
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 23/8/2019, 11:29:32
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    11/8/2019, 17:20:04   Andrea Vanelli     Initial Version
**/
({
    inizializzaDatiBase: function (cmp, event, helper) {
        this.mostraClessidra(cmp, helper);

        // preparo gli allegati esterni
        var attachmentsIDs = cmp.get("v.parametriEsterni.attachmentsIDs");
        // imposto il form iniziale
        cmp.set('v.PVForm', {
            'sobjectype': 'PVForm',
            'attachmentsIDs': cmp.get("v.parametriEsterni.attachmentsIDs"),
            'attachmentList' : []
        });



        //recupero i dati User
        var actionU = cmp.get("c.getUserData");
        actionU.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.PVForm.userData", response.getReturnValue());
            } else {
                console.log("Utente non riconosciuto");
            }
        });
        $A.enqueueAction(actionU);

        // AV se viene passata da fuori la categoria carico solo quel PV
        var parametriEsterni = cmp.get("v.parametriEsterni");
        console.log("parametriEsterni : " + JSON.stringify(parametriEsterni));
        if ((!$A.util.isUndefinedOrNull(parametriEsterni)) && (!$A.util.isUndefinedOrNull(parametriEsterni.codCategoria)) && (parametriEsterni.codCategoria != '')) {
            // valorizzo la lista tipologia con un dato fittizzio
            var listTipologia = [{ label: '', value: null }];
            listTipologia.push({ label: "PostVendita", value: "9999999" });
            cmp.set("v.listTipologia", listTipologia);

            //carico la sottotipologia fissa
            var action = cmp.get("c.loadFixedSottotipologia");
            action.setParams({ "postVenditaId": parametriEsterni.codCategoria });
            action.setCallback(this, function (response) {

                var state = response.getState();
                if (state === "SUCCESS") {
                    cmp.set("v.listSottotipologia", response.getReturnValue());
                    // seleziono la prima voce
                    console.log("prima voce:" + response.getReturnValue()[0].PostvenditaId__c);
                    if (!$A.util.isUndefinedOrNull(response.getReturnValue()[0])) {
                        // AV TODO selezionare la prima voce
                        cmp.find("sottotipologia").set("v.value", response.getReturnValue()[0].PostvenditaId__c);
                        //cmp.set("v.PVForm.categoriaPV.External_Id__c", response.getReturnValue()[0].PostvenditaId__c);
                        this.inizializzaDatiCategoria(cmp, event, helper);
                    }
                }
                this.nascondiClessidra(cmp, helper);
            });
            $A.enqueueAction(action);

        } else {
            // valorizzo la lista tipologia
            var listTipologia = [{ label: '', value: null }];
            var action = cmp.get("c.loadListaTipologia");
            action.setCallback(this, function (response) {

                var state = response.getState();
                if (state === "SUCCESS") {
                    var list = response.getReturnValue();
                    list.forEach(function (element) {
                        listTipologia.push({ label: element.MasterLabel__c, value: element.UniqueId__c });
                    });
                    cmp.set("v.listTipologia", listTipologia);
                }
                this.nascondiClessidra(cmp, helper);
            });
            $A.enqueueAction(action);

        }




    },
    onRender: function (cmp, event, helper) {
        // AV potrebbe non servire
        var childComponent = cmp.find('child');
        if ($A.util.isUndefinedOrNull(childComponent)) {
            cmp.set("v.isChildLoaded", false);
        } else {
            cmp.set("v.isChildLoaded", true);
            // blocco slezione PV
            try {

                var button = cmp.find('tipologia');
                button.set('v.disabled', true);
                button = cmp.find('sottotipologia');
                button.set('v.disabled', true);

                var button = cmp.find('btnInserisci');
                if (cmp.get("v.showMarkup")) {
                    button.set('v.disabled', false);
                } else {
                    button.set('v.disabled', true);
                }
            } catch (error) {

            }

        }



    },


    inserisciCase: function (cmp, event, helper) {
        var childComponent = cmp.find('child');
        var messaggi = "";

        // controllo selezione obbligatoria subtype e/o motivo

        if (!cmp.find("pvsubtype").checkValidity()) {
            cmp.find("pvsubtype").showHelpMessageIfInvalid();
            messaggi += "Selezionare la sottotipologia.<br>";
        }

        if (!cmp.find("psvreason").checkValidity()) {
            cmp.find("psvreason").showHelpMessageIfInvalid();
            messaggi += "Selezionare il motivo.<br>";
        }


        var allegatoOpt = cmp.get("v.PVForm.categoriaPV.Flag_Mostra_Allegati__c");
        if (allegatoOpt == "REQUIRED") {
            var invioViaFax = cmp.find("checkFax").get('v.checked');
            //var quantiAllegati = cmp.get('v.PVForm.attachmentList').length;
            //#sabry
            var quantiAllegati = 0
            if (!$A.util.isUndefinedOrNull(cmp.get('v.PVForm.attachmentList'))){
                quantiAllegati = cmp.get('v.PVForm.attachmentList').length;
            }
            if (invioViaFax == false && quantiAllegati == 0) {
                messaggi += "Allegare un documento o inviare via fax";
            }
        }
        cmp.set("v.messaggiErrore", messaggi);
        if (messaggi == '') {
            childComponent.inserisciCase();
        }


    },



    //valorizzo la lista sottoTipologia
    getListaCategorie: function (cmp, event, helper) {
        this.mostraClessidra(cmp, helper);

        cmp.set("v.PVForm.categoriaPV", {});	//svuoto sottotipologia
        //svuoto i valori della ricerca cliente/pratica
        cmp.set("v.listPsvreason", []);
        cmp.set("v.listPvsubtype", []);

        var childComponent = cmp.find('ricercaOCS');
        if (!$A.util.isUndefinedOrNull(childComponent)) {
            childComponent.resetRicerca();
        }

        var action = cmp.get("c.loadListaSottotipologia");
        action.setParams({
            "tipologiaSelezionata": cmp.find("tipologia").get("v.value"),
            "branchOrOffice": cmp.get("v.PVForm.userData.user.Branch_Or_Office__c")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.listSottotipologia", response.getReturnValue());

            }
            this.nascondiClessidra(cmp, helper);
        });
        $A.enqueueAction(action);
    },

    selezionaReason: function (cmp, event, helper) {
        var psvreasonSelezionata = cmp.find("psvreason").get("v.value");
        // imposto anche il PVForm
        cmp.set("v.PVForm.reasonMdt",
            cmp.get('v.listPsvreason').find(x => {
                return x.uniqueId__c == psvreasonSelezionata;
            })
        );

    },

    //valorizzo la lista MOTIVI
    getListaReasons: function (cmp, event, helper) {
        this.mostraClessidra(cmp, helper);
        var pvsubtypeSelezionata = cmp.find("pvsubtype").get("v.value");

        // imposto anche il PVForm
        cmp.set("v.PVForm.sottotipologiaMdt",
            cmp.get('v.listPvsubtype').find(x => {
                return x.uniqueId__c == pvsubtypeSelezionata;
            })
        );

        // carico i SUBTYPE
        var action = cmp.get("c.loadListaReasons");
        action.setParams({
            "sottotipologiaSelezionata": cmp.get("v.PVForm.categoriaPV.External_Id__c"),
            "pvsubtypeSelezionata": pvsubtypeSelezionata,
            //"branchOrOffice": cmp.get("v.branchOrOffice")
            "branchOrOffice": cmp.get("v.PVForm.userData.user.Branch_Or_Office__c")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.listPsvreason", response.getReturnValue());
                // controllo se ho una lista
                if (response.getReturnValue().length == 0) {
                    // non obbligatorio senza ho una lista
                    cmp.set("v.psvreasonRequired", false);
                } else {
                    // rendo obbligatorio se ho una lista
                    cmp.set("v.psvreasonRequired", true);
                }

            }
            this.nascondiClessidra(cmp, helper);
        });
        $A.enqueueAction(action);

    },

    getListaSottotipologie: function (cmp, event, helper) {
        this.mostraClessidra(cmp, helper);

        // carico i subtypes

        var action = cmp.get("c.loadListaSubtypes");
        action.setParams({
            "sottotipologiaSelezionata": cmp.get("v.PVForm.categoriaPV.External_Id__c"),
            //"branchOrOffice": cmp.get("v.branchOrOffice")
            "branchOrOffice": cmp.get("v.PVForm.userData.user.Branch_Or_Office__c")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.listPvsubtype", response.getReturnValue());

                // controllo se ho una lista
                if (response.getReturnValue().length == 0) {
                    // non obbligatorio senza ho una lista
                    cmp.set("v.pvsubtypeRequired", false);
                    this.getListaReasons(cmp, event, helper);
                } else {
                    // rendo obbligatorio se ho una lista
                    cmp.set("v.pvsubtypeRequired", true);
                    // svuoto per attendere la selezione della subtype
                    cmp.set("v.psvreasonSelezionata", "");
                    cmp.set("v.listPsvreason", []);
                }

                this.nascondiClessidra(cmp, helper);
            } else {
                this.nascondiClessidra(cmp, helper);
            }
        });
        $A.enqueueAction(action);

    },

    inizializzaDatiCategoria: function (cmp, event, helper) {

        this.mostraClessidra(cmp, helper);
        var postvendita = cmp.find("sottotipologia").get("v.value");
        // imposto il form iniziale
        //    cmp.set("v.PVForm.categoriaPV", {});	//svuoto sottotipologia
        // AV TODO dovrei svuotare alcuni dati ???
        cmp.set("v.listPsvreason", []);
        cmp.set("v.listPvsubtype", []);


        /*********************************************
         * SET UP FILTRI
         */

        // AV imposto il filtro del PV se necessario 
        // AV TODO per evitare di metterlo qua sarebbe da mettere nello specifico PV Init
        // ma per lanciare l'init dello specifico pv dobbiamo mostrarlo prima che venga effettuata una ricerca,
        // brutto per brutto... ai posteri

        var childComponent = cmp.find('ricercaOCS');
        if (!$A.util.isUndefinedOrNull(childComponent)) {
            childComponent.set("v.PVRecuperaDatiPVfiltroClassName", "");
            childComponent.set("v.PVRecuperaDatiPVfiltroParametriMap", []);
            childComponent.resetRicerca();

            if (postvendita == "1766") {
                //  AV TODO WORKING HERE (finire di provare la mappa filtri)
                if (cmp.get("v.PVForm.userData.user.Branch_Or_Office__c") == 'FIL') {
                    childComponent.resetRicerca();
                    childComponent.set("v.PVRecuperaDatiPVfiltroClassName", "PV1766CancellazionePraticaInserimento.RecuperaDatiPVFiltro");
                    var filtroParametriMap = { "filiale": cmp.get("v.PVForm.userData.codiceFiliale") };
                    childComponent.set("v.PVRecuperaDatiPVfiltroParametriMap", filtroParametriMap); // AV DOTO MAPPA con canale per provare
                    console.log("filtroParametriMap: " + filtroParametriMap);
                    console.log("PVRecuperaDatiPVfiltroParametriMap: " + childComponent.get("v.PVRecuperaDatiPVfiltroParametriMap"));
                }

            }

        }
        /*
        ***********************************************/



        var action = cmp.get("c.getCommonComponents");
        action.setParams({ "postVenditaId": postvendita });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var postvenditaCategoria = response.getReturnValue();
                cmp.set("v.PVForm.categoriaPV", postvenditaCategoria);
                //  AV se è un ticketing devo fare altro... ATTESA Matalone
                if ($A.util.isUndefinedOrNull(postvenditaCategoria.Visibility__c)) {
                    // ticketing
                    // this.fireToast("PV", "Categoria Ticketing. Attesa dettagli per implementazione", "info", 60000);
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef: "c:TicketingCreazione",
                        componentAttributes: {
                            'CatId': postvenditaCategoria.External_Id__c
                        }
                    });
                    evt.fire();
                } else {
                    this.getListaSottotipologie(cmp, event, helper);
                    // creo il PV child
                    // AV TODO il nome del componenete dovrei prenderlo dalla categoria
                    this.creaComponenetePV(cmp, helper, postvenditaCategoria.External_Id__c);

                }

            }
            this.nascondiClessidra(cmp, helper);

        });
        $A.enqueueAction(action);

        //lo sposto nel success : si accavallano i contatori dello spinner 
        //this.loadSubtypesHelper(cmp,event,helper);
    },



    //funzioni comuni del PV *****************************************************************************

    fireToast: function (header, message, type, duration) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: header,
            message: message,
            duration: duration,
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire();
    },

    mostraToast: function (cmp, event) {
        var params = event.getParam('arguments');

        var header = params.header == "" ? "" : params.header;
        var message = params.message;
        var duration = params.duration == "" ? "10000" : params.duration;
        var type = params.type == "" ? "info" : params.type;

        this.fireToast(header, message, type, duration);

    },


    gestisciRispostaInserimento: function (cmp, event) {
        var params = event.getParam('arguments');
        if (params) {
            var response = params.response;
            var header = params.header;
            var message = params.message;
            var duration = 10000;

            var type = "success";
            if (response.getState() == 'SUCCESS') {
                header = "Postvendita";
                message = "Richiesta inserita correttamente. " + message;
                cmp.set("v.isDaLavorare", "false");
            }
            else {
                type = "error";
                message = "Errore generico. " + message;
                header = "Postvendita";
                var duration = 10000;
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                        message = message + errors[0].message;
                    }
                }
            }
            this.fireToast(header, message, type, duration);

            // gestione uscita
            if (response.getState() == 'SUCCESS') {
                // gestione uscita al termine dell'operatività
                var exitMethod = cmp.get("v.exitMethod");

                if (exitMethod == "refresh") {
                    $A.get('e.force:refreshView').fire();
                } else if (exitMethod == "") {
                    // nulla
                } else {
                    // qualsiasi altro valore signifiva vai a quella pagina
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        'url': exitMethod
                    });
                    urlEvent.fire();
                }
            }

        }
    },
    mostraClessidra: function (cmp) {
        var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
    },

    nascondiClessidra: function (cmp) {
        var spinner = cmp.find('spinnerComponent');
        spinner.decreaseCounter();
    },

    showCartaDatiFinanziari: function (cmp, event) {
        var params = event.getParam('arguments');
        if (params) {
            cmp.set("v.showCartaDatiFinanziari", params.valore);
        }
    },

    callChild_onParentChange: function (cmp, whatIsChanged) {
        var childComponent = cmp.find('child');
        if (!$A.util.isUndefinedOrNull(childComponent)) {
            childComponent.onParentChange(whatIsChanged);
        }
        /* VALORI 
        if (params.whatIsChanged == 'psvSubtype') {
        } else if (params.whatIsChanged == 'psvReason') {
        } else if (params.whatIsChanged == 'ocsCliente') {
        } else if (params.whatIsChanged == 'ocsPratica') {        
            */
    },

    /**/
    creaComponenetePV: function (cmp, helper, catId) {
        this.mostraClessidra(cmp);


        // AV TODO lo mettiamo comecampo aggiuntivo nella categoria??
        var myArray = {'2564': 'PV2564AzzeramentoSpese',
                     '1762': 'PV1762CancellazioneDaOffertePromozionali',
                      '1751': 'PV1751GirocontoIncasso',
                      '3260': 'PV3260AumentoFido',
                      '3256': 'PV3256ErogazioneDiretta',
                      '3388': 'PV3388VariazioneEmail',
                      '1768': 'PV1768RipristinoRID',
                      '1757': 'PV1757RimborsoClienteSaldoRosso',
                      '2870': 'PV2870RiemissionePIN',
                      '3481': 'PV3481AttivazioneCarta',
                      '1752': 'PV1752RiattribImportiSistemaPartitario',
                      '1763': 'PV1763VariazioneAnagrafica',
                      '3261': 'PV3261VariazioneTelefoni',
                      
        };

        var name = myArray[catId];


        if (name != '') {
            $A.createComponent(
                'c:' + name,
                {
                    "aura:id": "child",
                    "PVForm": cmp.getReference("v.PVForm"),
                    "parametriEsterni": cmp.getReference("v.parametriEsterni"),
                    "cartaDatiFinanziariData": cmp.getReference("v.cartaDatiFinanziariData"),
                    "showMarkup": cmp.getReference("v.showMarkup"),
                },
                function (element, status, errorMessage) {
                    if (cmp.isValid() && status == 'SUCCESS') {
                        var body = cmp.get('v.body');
                        body.push(element);
                        cmp.set('v.body', element);
                    }
                    helper.nascondiClessidra(cmp);
                }
            );
        } else {
            this.fireToast("Postvendita", "PV " + catId + " non implementato.", "info", 5000);
            this.nascondiClessidra(cmp);

        }
    }
})