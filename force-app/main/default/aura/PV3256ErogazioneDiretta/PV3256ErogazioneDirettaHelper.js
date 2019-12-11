/**
 * @File Name          : PV3256ErogazioneDirettaHelper.js
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 30/10/2019, 11:36:32
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-6-19 13:41:32   Andrea Vanelli     Initial Version
**/
({

    /********************/
    /* EVENTI           */
    /********************/


    onPraticaSelected: function (cmp) {
        console.log("ONPRATICA SELECTED");
        this.clearFields(cmp);
        var pratica = cmp.get("v.PVForm.pratica");

        // verifico che la pratica sia attiva
        this.checkPraticaAttiva(cmp);

        //se attiva, recupero i dati finanziari da esporre in pagina
        if (cmp.get('v.isPraticaAttiva')) {

            this.mostraClessidra(cmp);
            var action = cmp.get('c.recuperaDatiFinanziari');
            action.setParams({
                "numeroCarta": pratica.numPratica
            });
            // Imposto la Callback
            action.setCallback(this, function (response, helper) {
                 //console.log("recuperaDatiFinanziari : State(): " + response.getState());
                 //console.log("recuperaDatiFinanziari : result : " + JSON.stringify(response.getReturnValue()));
                if (response.getState() == 'SUCCESS') {
                    var result = response.getReturnValue();
                
                    cmp.set('v.cartaDatiFinanziariData', result);
                    this.showCartaDatiFinanziari(cmp, true);

                    if (cmp.get('v.cartaDatiFinanziariData.statoRinnovoCustom') != 'RINNOVO DA ATTIVARE') {
                        // se la pratica è attiva e il metodo di pagamento è di tipo RID devo chiamare un B2BSOAP x verificare che il RID sia attivo
                        if (cmp.get('v.cartaDatiFinanziariData.pagamento') == 'RI') {
                            this.checkRid(cmp);
                        }

                        this.calcolaCordinateBancarie(cmp);
                        this.composizioneDinamicaScript(cmp);
                        this.getMinErogabile(cmp);
                    } else {
                        var messaggi = "La carta " + pratica.numPratica + " non è attiva";
                        this.mostraErrori(cmp, messaggi);
                        this.showMarkup(cmp, false);
                        cmp.set('v.isPraticaAttiva', false);
                    }
                }
                else {
                    console.log("*** Result : "+JSON.stringify(response));
                    console.log("*** GET ERROR : "+JSON.stringify(response.getError()));
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
        var messaggi = "";


        messaggi += this.checkPraticaSelezionata(cmp);

        if (messaggi == "") {

            var PVForm = cmp.get("v.PVForm");
            PVForm.modalitaErogazione = "";
            PVForm.codiceInternoBanca = "";
            PVForm.iban = "";
            PVForm.destErogazione = "CL";

            PVForm.smsConsenso = cmp.find('SMScheckbox').get('v.checked');
            PVForm.testoSMS = cmp.get("v.scriptSMS");
            PVForm.numeroCliente = cmp.get("v.PVForm.cliente.telCellulare");
            PVForm.canale = cmp.get("v.PVForm.pratica.canale");
            PVForm.intermediario = "12";
            PVForm.emettitore = cmp.get("v.cartaDatiFinanziariData.emettitore");
            PVForm.dataScadenza = cmp.get("v.cartaDatiFinanziariData.dataScadenzaUnslashed");



            var ContoFlag = true;
            var CpayFlag = cmp.find('flagCpayMatrix').get('v.checked');
            var smsConsenso = cmp.find('SMScheckbox').get('v.checked');
            var contoSelezionato = cmp.get('v.contoSelezionato');
            var testoSMS = cmp.get("v.scriptSMS");
            var numeroCliente = cmp.get("v.PVForm.cliente.telCellulare");
            var canale = cmp.get("v.PVForm.pratica.canale");

            var dataScadenza = cmp.get("v.cartaDatiFinanziariData.dataScadenzaUnslashed");


            if ($A.util.isUndefinedOrNull(numeroCliente)) {
                PVForm.numeroCliente = "";
            }
            if ($A.util.isUndefinedOrNull(testoSMS)) {
                PVForm.testoSMS = "";
            }

            if (CpayFlag == false) {
                if (cmp.get("v.cartaDatiFinanziariData.pagamento") == 'RI') {
                    ContoFlag = cmp.find('confermaConto').get('v.checked');
                }
            }

            // controlli e settaggio variabili

            if ($A.util.isUndefinedOrNull(canale)) {
                PVForm.canale = "";
            }

            if ($A.util.isUndefinedOrNull(dataScadenza)) {
                messaggi += "La carta selezionata non ha la data scadenza valorizzata\n"
            }
            if (!(cmp.find("importo").checkValidity())) {
                messaggi += "Valorizzare il campo importo\n";
            }
            else {
                var importo = parseFloat(cmp.get("v.PVForm.importo"));
                var importoEgorabile = parseFloat(cmp.get("v.importoErogabile"));

                if (importo < importoEgorabile) {
                    messaggi += "Importo inferiore al minimo\n";
                }
            }

            if (ContoFlag == false) {
                messaggi += "Non è stato confermato il conto\n";
            }
            if (cmp.get('v.cartaDatiFinanziariData.emettitore') == '3') {
                if (!(cmp.find("numeroRate").checkValidity())) {
                    messaggi += "Valorizzare il campo Numero Rate\n";
                }

            } else {
                PVForm.numRate = "0";
            }
            if (CpayFlag == true) {
                if ($A.util.isUndefinedOrNull(contoSelezionato)) {
                    messaggi += "Selezionare il conto CPAY su cui effettuare l'erogazione o rimuovere il flag";
                }
            }
            // questo set su tutto l'oggetto PVFORM non andrebbe fatto. è da considerarsi come anomalia rispetto ai normali PV, quindi da NON replicare.
            cmp.set("v.PVForm", PVForm);

        }

        return messaggi;
    },

    completaPVForm: function (cmp, event, helper, PVForm) {
        console.log("compelata PV FORM");
        // arricchisco il PVForm con dati specifici del PV
        var contoSelezionato = cmp.get('v.contoSelezionato');
        var commissione = cmp.get("v.parametriEsterni.commissioneEDI0C");
        var CpayFlag = cmp.find('flagCpayMatrix').get('v.checked');

        if ($A.util.isUndefinedOrNull(commissione)) {
            PVForm.flagCommissioniErogazione = "S";
        }
        else {
            if (commissione != "0") {
                PVForm.flagCommissioniErogazione = "S";
            }
            else {
                PVForm.flagCommissioniErogazione = "N";
            }
        }


        if ($A.util.isUndefinedOrNull(contoSelezionato)) {
            PVForm.iban = "";
            PVForm.canale = "";
        }
        else {
            if (CpayFlag == true) {
                PVForm.iban = cmp.get("v.contoSelezionato.iban");
            }
            else {
                PVForm.iban = "";
                PVForm.canale = "";
            }
        }
        //to do -- verificare se è checked CPAY
        if (PVForm.iban != "") {
            PVForm.modalitaErogazione = "D";
            PVForm.canale = "CP3"
            PVForm.codiceInternoBanca = "";
        }
        else {
            if (cmp.get('v.cartaDatiFinanziariData.pagamento') == 'RI') {
                PVForm.modalitaErogazione = "B";
                PVForm.codiceInternoBanca = "025";
            }
            else {
                PVForm.modalitaErogazione = "P";
                PVForm.codiceInternoBanca = "9100";
            }
        }


        return PVForm;
    },



    /*********************************/
    /* metodi CUSTOM del singolo PV */
    /*********************************/



    // calcola le coordinate bancarie e concatena una stringa che viene poi mostrata in pagina come ulteriore domanda da porre al cliente
    // poichè è necessario interrogare il DB viene invocato un APEX che effettua tutta la logica e restituisce la stringa finale
    calcolaCordinateBancarie: function (cmp) {

    },

    composizioneDinamicaScript: function (cmp) {
        var script = '';
        var scriptCommissione = '';
        var scriptSMS = '';

        var sDataAddebito = this.setDates(cmp);
        var CpayFlag = cmp.find('flagCpayMatrix').get('v.checked');
        var date_1 = cmp.get('v.date_1');
        var date_2 = cmp.get('v.date_2');
        var date_3 = cmp.get('v.date_3');
        var importo = cmp.get('v.PVForm.importo');
        console.log("CpayFlag " + CpayFlag);
        // script che l'operatore legge al cliente
        if (CpayFlag) {
            script = "Le ricordo che la somma da lei richiesta sarà disponibile entro 24 ore";
        }
        else if (cmp.get('v.cartaDatiFinanziariData.pagamento') == 'RI') {
            script = "Le ricordo che la somma da lei richiesta sarà disponibile sul suo conto corrente in 2 giorni lavorativi dalla data della liquidazione della operazione e cioè a partire dal " + date_1;
        }
        else if (cmp.get('v.cartaDatiFinanziariData.pagamento') == 'BP') {
            script = "Le ricordo che a partire dal " + date_3 + " ed entro il " + date_2 + " dovrà semplicemente recarsi presso un qualsiasi ufficio postale e chiedere all'operatore di poter ritirare il \"bonifico domiciliato\" che è stato predisposto a suo nome. E' importante che indichi all'operatore dell'ufficio postale la dicitura 'bonifico domiciliato'. Per il ritiro dovrà esibire un documento di riconoscimento e il codice fiscale.";
        }

        cmp.set('v.parteDinamicaScript', script);

        // script relativo alla commissione
        var EDI0C = cmp.get('v.parametriEsterni.commissioneEDI0C');
        if ($A.util.isUndefinedOrNull(EDI0C)) {
            scriptCommissione = "La commissione relativa al servizio corrisponde all' 1% della somma trasferita.";
        }
        else {
            if (cmp.get('v.parametriEsterni.commissioneEDI0C') == '0') {
                scriptCommissione = "La commissione relativa al servizio, solo per questa operazione, è pari a zero euro anziché l’1% dell’importo trasferito.";
            }
            else {
                scriptCommissione = "La commissione relativa al servizio corrisponde all' 1% della somma trasferita.";
            }
        }
        // CPAY e BP+ --> no commissione
        if (CpayFlag || cmp.get('v.cartaDatiFinanziariData.emettitore') == '3') {
            scriptCommissione = "";
        }


        cmp.set('v.parteDinamicaScriptCommissione', scriptCommissione);

        // script che verrà inviato via SMS
        // se BANCOPOSTA ha solo RID
        if (cmp.get('v.cartaDatiFinanziariData.emettitore') == '3') {
            scriptSMS = "BancoPosta: Le confermiamo che il bonifico di " + importo + " euro sara' disp. sul suo CC a partire dal " + date_1 + ". L'operazione le verra' addebitata il " + sDataAddebito + ".";
        }
        // se COMPASS
        else {
            if (cmp.get('v.cartaDatiFinanziariData.pagamento') == 'RI') {
                scriptSMS = "Compass: Le confermiamo che il bonifico di " + importo + " euro sara' disp. sul suo CC a partire dal " + date_1 + ". L'operazione le verra' addebitata nel prossimo EC";
            }
            else if (cmp.get('v.cartaDatiFinanziariData.pagamento') == 'BP') {
                scriptSMS = "Compass: Le confermiamo che il bonifico di " + importo + " euro sara' disp. in posta dal " + date_3 + ". L'operazione le verra' addebitata nel prossimo EC";
            }
        }

        cmp.set('v.scriptSMS', scriptSMS);
    },

    setDates: function (cmp) {
        this.oggiPiuDue(cmp);
        this.oggiPiuTre(cmp);
        this.fineMese(cmp);
        var sDataAddebito = this.dataAddebito(cmp);
        return sDataAddebito;
    },

    oggiPiuDue: function (cmp) {
        var today = new Date();

        var weekday = new Array(7);
        weekday[0] = "Sunday";
        weekday[1] = "Monday";
        weekday[2] = "Tuesday";
        weekday[3] = "Wednesday";
        weekday[4] = "Thursday";
        weekday[5] = "Friday";
        weekday[6] = "Saturday";

        var n = weekday[today.getDay()];

        // oggi + 2 giorni lavorativi
        if (n == "Thursday") {
            today.setDate(today.getDate() + 4);
        }
        else if (n == "Friday") {
            today.setDate(today.getDate() + 4);
        }
        else if (n == "Saturday") {
            today.setDate(today.getDate() + 3);
        }
        else {
            today.setDate(today.getDate() + 2);
        }

        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!

        var yyyy = today.getFullYear();
        if (dd < 10) {
            dd = '0' + dd;
        }
        if (mm < 10) {
            mm = '0' + mm;
        }
        var today = dd + '/' + mm + '/' + yyyy;
        cmp.set("v.date_1", today);
    },

    fineMese: function (cmp) {
        var today = new Date();

        // fine Mese successivo

        today.setDate(today.getMonth() + 1);
        var lastDayOfMonth = new Date(today.getFullYear(), today.getMonth() + 1, 0);

        var dd = lastDayOfMonth.getDate();
        var mm = today.getMonth() + 1; //January is 0!

        var yyyy = today.getFullYear();
        if (dd < 10) {
            dd = '0' + dd;
        }
        if (mm < 10) {
            mm = '0' + mm;
        }
        var today = dd + '/' + mm + '/' + yyyy;
        cmp.set("v.date_2", today);
    },


    dataAddebito: function (cmp) {
        // il 12 del Mese successivo
        var today = new Date();
        today.setDate(today.getMonth() + 1);

        var dd = 12;
        var mm = today.getMonth() + 2; //January is 0!

        var yyyy = today.getFullYear();
        if (dd < 10) {
            dd = '0' + dd;
        }
        if (mm < 10) {
            mm = '0' + mm;
        }
        var today = dd + '/' + mm + '/' + yyyy;
        return today;
    },


    oggiPiuTre: function (cmp) {
        var today = new Date();

        var weekday = new Array(7);
        weekday[0] = "Sunday";
        weekday[1] = "Monday";
        weekday[2] = "Tuesday";
        weekday[3] = "Wednesday";
        weekday[4] = "Thursday";
        weekday[5] = "Friday";
        weekday[6] = "Saturday";

        var n = weekday[today.getDay()];


        // oggi + 3 giorni lavorativi
        if (n == "Thursday") {
            today.setDate(today.getDate() + 5);
        }
        else if (n == "Wednesday") {
            today.setDate(today.getDate() + 5);
        }
        else if (n == "Friday") {
            today.setDate(today.getDate() + 5);
        }
        else if (n == "Saturday") {
            today.setDate(today.getDate() + 4);
        }
        else {
            today.setDate(today.getDate() + 3);
        }

        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!

        var yyyy = today.getFullYear();
        if (dd < 10) {
            dd = '0' + dd;
        }
        if (mm < 10) {
            mm = '0' + mm;
        }
        var today = dd + '/' + mm + '/' + yyyy;
        cmp.set("v.date_3", today);
    },

    checkPraticaAttiva: function (cmp) {
        var pratica = cmp.get("v.PVForm.pratica");

        //verifica se la carta è attiva
        if (pratica != null && pratica != undefined && pratica != '') {
            console.log("pratica.desStatoPratica.toUpperCase(): " + pratica.desStatoPratica.toUpperCase());
            if ((pratica.statoPratica == '50' || pratica.statoPratica == '50XX') &&
                pratica.desStatoPratica.toUpperCase() != 'RINNOVO DA ATTIVARE') {
                cmp.set('v.isPraticaAttiva', true);
                this.mostraErrori(cmp, '');
            } else {
                var messaggi = "La carta " + pratica.numPratica + " non è attiva";
                this.mostraErrori(cmp, messaggi);
                this.showMarkup(cmp, false);
                cmp.set('v.isPraticaAttiva', false);
            }
        } else {
            cmp.set('v.isPraticaAttiva', false);
        }
    },

    checkRid: function (cmp) {
        var pratica = cmp.get("v.PVForm.pratica");
        this.mostraClessidra(cmp);
        var action = cmp.get('c.verificaMandatoSDDAttivo');
        action.setParams({
            "tipoPratica": pratica.tipoPratica,
            "numeroCarta": pratica.numPratica
        });
        // Imposto la Callback
        action.setCallback(this, function (response, helper) {
            console.log("verificaMandatoSDDAttivo : State(): " + response.getState());
            console.log("verificaMandatoSDDAttivo : result : " + JSON.stringify(response.getReturnValue()));
            if (response.getState() == 'SUCCESS') {
                var result = response.getReturnValue();

                cmp.set('v.OCSGenericRecuperaDati', result);
                //qui mettere codice se c'è altro da fare in caso di SUCCESS

                if ((result != null && result != undefined && result != '') && (result.out_1 != null && result.out_1 != undefined && result.out_1 != '') && (result.out_1 == '10')) {
                    console.log("verificaMandatoSDDAttivo : result : " + result);
                } else {
                    var messaggi = 'Mandato SDD non attivo. Impossibile procedere.';
                    this.mostraErrori(cmp, messaggi);
                    this.showMarkup(cmp, false);
                }
            }
            else {
                this.mostraToast(cmp, '', response.getError(), 'error', '');
            }
            this.nascondiClessidra(cmp);
        });
        $A.enqueueAction(action);


    },

    clearFields: function (cmp) {

        cmp.set("v.isPraticaAttiva", "");
        cmp.set("v.importoErogabile", "");
        // cmp.set("v.PVForm.importo", "");
        // cmp.set("v.PVForm.codiceCampagna", "");
        // cmp.set("v.PVForm.numRate", "");
        cmp.set("v.parteDinamicaScript", "");
        cmp.set("v.parteDinamicaScriptCommissione", "");
        cmp.set("v.commissioneSuImportoBP", "");
        cmp.set("v.scriptSMS", "");
        cmp.set("v.date_1", "");
        cmp.set("v.date_2", "");
        cmp.set("v.date_3", "");
        cmp.set("v.cpayLoaded", false);
        this.showCartaDatiFinanziari(cmp, false);
        this.showMarkup(cmp, true);

    },

    mostraMatrixCPAY: function (cmp) {
        console.log("v.CpayFlag " + cmp.get("v.CpayFlag"));
        if ((cmp.get("v.cpayLoaded")) == false) {


            cmp.set("v.cpayLoaded", true);
            cmp.set('v.praticheListCPAY', []);
            cmp.set('v.contoSelezionato', null);

            var codCliente = cmp.get("v.PVForm.cliente.codCliente");
            this.mostraClessidra(cmp);
            var action = cmp.get('c.getCpayMatrix');
            action.setParams({
                "codCliente": codCliente
            });
            action.setCallback(this, function (response) {
                if (response.getState() == 'SUCCESS') {
                    if (response.getReturnValue()['clienti'].length == 1) {
                        cmp.set('v.praticheListCPAY', response.getReturnValue()['clienti'][0]['pratiche']);

                        // prendo solo i CPAY
                        var review = cmp.get('v.praticheListCPAY');
                        var index = response.getReturnValue()['clienti'][0]['pratiche'].length;
                        index = index - 1;

                        while (index >= 0) {
                            if (review[index].statoPratica != '50') {
                                review.splice(index, 1);
                            }
                            else if (review[index].tipoPratica != 'CP') {
                                review.splice(index, 1);
                            }
                            index -= 1;
                        }

                        if (review.length == 0) {

                            cmp.set('v.praticheListCPAY', review);
                        }
                        else {
                            cmp.set('v.praticheListCPAY', review);
                        }

                    }
                    else {

                        this.mostraToast(cmp, '', response.getError(), 'error', '');
                    }
                }
                this.nascondiClessidra(cmp);
            });

            $A.enqueueAction(action);

        }
        else {
            console.log("matrice già popolata");
        }
        this.composizioneDinamicaScript(cmp);

    },

    selectConto: function (cmp, event) {
        cmp.set('v.contoSelezionato', event.getParam('selectedRows')[0]);
    },

    calcolaCommissione: function (cmp) {
        if (isNaN(cmp.get("v.PVForm.importo"))) {
            console.log("non è un numero " + cmp.get("v.PVForm.importo"));
        }
        else {
            var numero = +(cmp.get("v.PVForm.importo"));
            numero = numero * 0.005;
            numero = parseFloat(numero).toFixed(2);
            cmp.set("v.commissioneSuImportoBP", numero);
        }
    },

    getMinErogabile: function (cmp) {
        //chiamo APEX per estrarre il minimo erogabile sulla base dell'emettitore
        var emettitore = cmp.get('v.cartaDatiFinanziariData.emettitore');
        var action = cmp.get('c.getMinimoErogabile');
        action.setParams({
            "emettitore": emettitore
        });
        action.setCallback(this, function (response, helper) {
            // console.log("getMinimoErogabile : State(): " + response.getState());
            // console.log("getMinimoErogabile : result : " + JSON.stringify(response.getReturnValue()));
            if (response.getState() == 'SUCCESS') {
                cmp.set("v.importoErogabile", response.getReturnValue());
                if (cmp.get('v.importoErogabile') == '-1') {
                    var messaggi = "Emettitore non abilitato all'erogazione";
                    this.mostraErrori(cmp, messaggi);
                    this.showMarkup(cmp, false);
                }

            }
            else if (response.getState() === "ERROR") {
                cmp.set("v.importoErogabile", "-1");
                console.log("chiamata non eseguita correttamente");
                var messaggi = "Emettitore non abilitato all'erogazione";
                this.mostraErrori(cmp, messaggi);
                this.showMarkup(cmp, false);
            }
        });
        $A.enqueueAction(action);
    },


})