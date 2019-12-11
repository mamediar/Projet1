/**
 * @File Name          : PV1760CopiaContrattoHelper.js
 * @Description        : 
 * @Author             : Lorenzo Marzocchi
 * @Group              : 
 * @Last Modified By   : Lorenzo Marzocchi
 * @Last Modified On   : 2019-9-23 14:19:35
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-8-29 12:08:06   Lorenzo Marzocchi     Initial Version
**/
({

    /********************/
    /* EVENTI           */
    /********************/

    onClienteSelected: function (cmp) {
        this.mostraErrori(cmp, "");
        this.showMarkup(cmp, true);
        console.log("pratica: " + cmp.get("v.PVForm.pratica"));
    },

    onPraticaSelected: function (cmp) {

        var pratica = cmp.get("v.PVForm.pratica");
        if (pratica != null) {
            //se attiva, recupero i dati finanziari da esporre in pagina
            this.mostraClessidra(cmp);
            var action = cmp.get('c.recuperaDatiStampaPratica');
            action.setParams({
                "numPratica": pratica.numPratica,
                "tipoPratica": pratica.tipoPratica
            });
            // Imposto la Callback
            action.setCallback(this, function (response, helper) {
                console.log("recuperaDatiStampaPratica : State(): " + response.getState());
                console.log("recuperaDatiStampaPratica : result : " + JSON.stringify(response.getReturnValue()));
                if (response.getState() == 'SUCCESS') {
                    var result = response.getReturnValue();
                    if (result != "") {
                        cmp.set("v.PVForm.FEA", result);
                    }
                    else {
                        cmp.set("v.PVForm.FEA", "Cartacea")
                    }
                }
                else {
                    this.mostraToast(cmp, '', response.getError(), 'error', '');
                }
                this.nascondiClessidra(cmp);
            });
            $A.enqueueAction(action);

            if (cmp.get("v.PVForm.FEA") != 'FEA') {
                this.getStatoLotto(cmp);
            }

        }
    },

    /*********************************/
    /* metodi CUSTOM del singolo PV */
    /*********************************/

    aggiungiZeri: function (numPratica) {

        var my_string = '' + numPratica;
        while (my_string.length < 12) {
            my_string = '0' + my_string;
        }

        return my_string;

    },

    getStatoLotto: function (cmp) {
        //chiamo APEX per estrarre stato del lotto e capire a chi indirizzare la richiesta   
        var pratica = cmp.get("v.PVForm.pratica");
        pratica.numPratica = this.aggiungiZeri(pratica.numPratica);
        console.log("numerpratica con zeri: " + pratica.numPratica);

        this.mostraClessidra(cmp);
        var action = cmp.get('c.recuperaStatoLotto');
        action.setParams({
            "numPratica": pratica.numPratica
        });
        action.setCallback(this, function (response, helper) {
            console.log("recuperaStatoLotto : State(): " + response.getState());
            console.log("recuperaStatoLotto : result : " + JSON.stringify(response.getReturnValue()));
            if (response.getState() == 'SUCCESS') {
                cmp.set("v.PVForm.statoLotto", response.getReturnValue());

                // se il lotto non è censito nelle tabelle Contract e SFALot la richiesta viene indirizzata comunque ad IDM 
                if (cmp.get('v.PVForm.statoLotto') == '3' || cmp.get('v.PVForm.statoLotto') == '4' || cmp.get('v.PVForm.statoLotto') == '5' || cmp.get('v.PVForm.statoLotto') == 'NON IN ARCHIVIO') {
                    cmp.set('v.PVForm.statoLotto', 'IDM');
                }
                //funzionalita stralciata
                /* else if  (cmp.get('v.PVForm.statoLotto') == '3') {
                     cmp.set('v.PVForm.statoLotto','WAIT');
                 }*/
                else {
                    cmp.set('v.PVForm.statoLotto', 'FILIALE');
                }

            }
            else if (response.getState() === "ERROR") {
                this.mostraToast(cmp, '', response.getError(), 'error', '');
            }
            this.nascondiClessidra(cmp);
        });
        $A.enqueueAction(action);
    },


    /************************/
    /* Gestione Inserimento */
    /************************/

    validateUserInput: function (cmp, event, helper) {
        var messaggi = "";
        messaggi += this.checkPraticaSelezionata(cmp);
        if (messaggi == "") {
            var dest = cmp.get("v.PVForm.destinatario");
            if ($A.util.isUndefinedOrNull(dest)) {
                messaggi += "Selezionare il Destinatario della richiesta";
            }
        }
        return messaggi;
    },

    completaPVForm: function (cmp, event, helper, PVForm) {
        // arricchisco il PVForm con dati specifici del PV
        var indirizzo = '';
        indirizzo = PVForm.cliente.indirizzo + " " + PVForm.cliente.cap + " " + PVForm.cliente.provincia + " " + PVForm.cliente.localita + " ";
        console.log("indirizzo " + indirizzo);
        PVForm.indirizzo = indirizzo;
        return PVForm;
    },
})