/**
 * @File Name          : PV1772DaCustomerServAFilialeHelper.js
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 31/10/2019, 17:14:58
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    28/10/2019   Federico Negro     Initial Version
**/
({

    /********************/
    /*      EVENTI      */
    /********************/
    
    onClienteSelected: function (cmp, event, helper) {
        this.mostraErrori(cmp, "");
        this.recuperaFilialiJS(cmp);
        this.showMarkup(cmp, true);
    },

    onPraticaSelected: function (cmp, event, helper) {

        this.mostraErrori(cmp, "");
        this.setFilialeCombo(cmp);

    },

    /*********************************/
    /* metodi CUSTOM del singolo PV */
    /*********************************/
//, event, helper
    recuperaFilialiJS: function (cmp) {
        var action = cmp.get('c.recuperaFiliali');
        this.mostraClessidra(cmp);
        action.setCallback(this, function (response, helper) {
            //console.log("getStep : State(): " + response.getState());
            //console.log("getStep : result : " + JSON.stringify(response.getReturnValue()));
            if (response.getState() == 'SUCCESS') {
                var elencoFil = response.getReturnValue();
                var i;
                var opts = new Array();
                    for(i=0; i<elencoFil.length; i++){
                        opts.push({value: elencoFil[i].OCS_External_Id__c, label: elencoFil[i].Name});
                        //console.log("Value: "+elencoFil[i].getCodice_Cliente__c+" - Label : "+elencoFil[i].Name);
                    }
                    cmp.set("v.options", opts);
            } else {
                console.log("Chiamata non eseguita correttamente");
                var messaggi = "FILIALI NON RECUPERATE";
                this.mostraErrori(cmp, messaggi);
                this.showMarkup(cmp, false);
            }
            this.nascondiClessidra(cmp);
        });

        $A.enqueueAction(action);
    },

    setFilialeCombo: function(cmp){
        console.log("F"+cmp.get("v.PVForm.pratica.filiale"));
        cmp.set("v.selectedValue","F"+cmp.get("v.PVForm.pratica.filiale"));
    },

    /************************/
    /* Gestione Inserimento */
    /************************/

    validateUserInput: function (cmp, event, helper) {
        var messaggi = "";
        messaggi = this.checkPraticaSelezionata(cmp);
        if (messaggi == "") {
            //controllo selezione filiale
            if (!cmp.find("elenco_filiali").checkValidity()) {
                cmp.find("elenco_filiali").showHelpMessageIfInvalid();
                messaggi += "Selezionare una filiale di destinazione.\n";
            }
        }

        return messaggi;
    },

    completaPVForm: function (cmp, event, helper, PVForm) {
        //arricchisco il PVForm con dati specifici del PV
        //console.log("fil finale: "+cmp.get("v.selectedValue"));
        PVForm.codFiliale = cmp.get("v.selectedValue");

        return PVForm;
    },

})