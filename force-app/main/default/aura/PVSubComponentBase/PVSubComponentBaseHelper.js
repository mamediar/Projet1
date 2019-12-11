/**
 * @File Name          : PVSubComponentBaseHelper.js
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 6/11/2019, 12:27:03
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    15/8/2019, 19:12:27   Andrea Vanelli     Initial Version
**/
({

    // AV non rimuovere, sono i prototype

    onSubtypeSelected: function (cmp, event, helper) {
    },
    onReasonSelected: function (cmp, event, helper) {
    },
    onClienteSelected: function (cmp, event, helper) {
    },
    onPraticaSelected: function (cmp, event, helper) {
    },


    //metodo richiamato dal bottone conferma del contenitore PVInserimento
    inserisciCase: function (cmp, event, helper) {
        //console.log(" inserisciCase START");
        var messaggi = this.validateUserInput(cmp, event, helper);
        // converto gli \n to <br>
        messaggi = this.replaceNtoBR(messaggi);
        this.mostraErrori(cmp,messaggi);
        if (messaggi == '') {
            this.conferma(cmp, event, helper);
        }
        //console.log(" inserisciCase END");
    },

    conferma: function (cmp, event, helper) {
        //console.log(" conferma START");
        this.mostraClessidra(cmp);

        var PVForm = cmp.get("v.PVForm");
        // metodo del child PV per inserire i dati specifici nel PVForm        
        PVForm = this.completaPVForm(cmp, event, helper, PVForm);
        
        // chiamo il metodo confermo APEX
        var action = cmp.get('c.conferma');
        action.setParam('datiForm', PVForm);
        // Imposto la Callback
        action.setCallback(this, function (response, helper) {
            if (response.getState() == 'SUCCESS') {
            }
            else if (response.getState() === "ERROR") {
            }
            this.gestisciRispostaInserimento(cmp,response,'','');
            this.nascondiClessidra(cmp);
        });
        $A.enqueueAction(action);
        //console.log(" conferma END");
    },


    mostraClessidra: function (cmp) {
        var compEvent = cmp.getEvent("PVSubComponentEvents");
        compEvent.setParams({
            "method": "mostraClessidra"
        });
        compEvent.fire();
    },
    nascondiClessidra: function (cmp) {
        var compEvent = cmp.getEvent("PVSubComponentEvents");
        compEvent.setParams({
            "method": "nascondiClessidra"
        });
        compEvent.fire();
    },
    mostraErrori: function (cmp, message) {
        var compEvent = cmp.getEvent("PVSubComponentEvents");
        compEvent.setParams({
            "method": "mostraErrori",
            "arguments": {
                "message": message
            }
        });
        compEvent.fire();
    },
    gestisciRispostaInserimento: function (cmp, response, header, message) {
        var compEvent = cmp.getEvent("PVSubComponentEvents");
        compEvent.setParams({
            "method": "gestisciRispostaInserimento",
            "arguments": {
                "response": response,
                "header": header,
                "message": message,
            }

        });
        compEvent.fire();
    },
    mostraToast: function (cmp, header, message, type, duration) {
        var compEvent = cmp.getEvent("PVSubComponentEvents");
        console.log("*** Header : "+header);
        console.log("*** Message : "+JSON.stringify(message));
        console.log("*** Type : "+type);
        console.log("*** Duration : "+duration);

        //controllo se message è un array o è una stringa
        if(Array.isArray(message)){
            var msg_errori = "";
            for(var i = 0; i<message.length; i++){
                msg_errori += message[i].message+"\n";
            }
            message=msg_errori;
        }

        compEvent.setParams({
            "method": "mostraToast",
            "arguments": {
            "header": header,
            "message": message,
            "type": type,
            "duration": duration,
            }
        });
        compEvent.fire();

    },
    showCartaDatiFinanziari: function (cmp, valore) {
        var compEvent = cmp.getEvent("PVSubComponentEvents");
        compEvent.setParams({
            "method": "showCartaDatiFinanziari",
            "arguments": {
                "valore": valore
            }
        });
        compEvent.fire();
    },


    replaceNtoBR: function(str) {
        return str.replace(/(?:\r\n|\r|\n)/g, '<br>');
    },

    checkClienteSelezionato: function(cmp) {
        var codCliente = cmp.get('v.PVForm.cliente.codCliente');
        if (!$A.util.isUndefinedOrNull(codCliente) &&  codCliente != ''){
            return "";
        } else {
            return "Selezionare un cliente\n";
        }
    },
    checkPraticaSelezionata: function(cmp) {
        var numPratica = cmp.get('v.PVForm.pratica.numPratica');
        if (!$A.util.isUndefinedOrNull(numPratica) &&  numPratica != ''){
            return "";
        } else {
            return "Selezionare una pratica\n";
        }
    },

    showMarkup: function(cmp, valore) {
        cmp.set("v.showMarkup", valore);
        var cmpTarget = cmp.getSuper().find('showMarkupDiv');
        if (valore) {
           $A.util.removeClass( cmpTarget,'hideme');
        } else {
           $A.util.addClass( cmpTarget,'hideme');
        }
    }
})