/**
 * @File Name          : PV2564AzzeramentoSpeseHelper.js
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 24/9/2019, 14:47:27
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    29/7/2019, 09:51:59   Andrea Vanelli     Initial Version
**/
({

    /********************/
    /* EVENTI           */
    /********************/

    onSubtypeSelected: function (cmp) {
        // ricarico i dati per autoselezionare le spese se necessario
        // AV migliorabile
        this.onPraticaSelected(cmp);
    },
    

    onPraticaSelected: function (cmp) {
        this.mostraClessidra(cmp);
        var childComponent = cmp.find('cmpListaSpese');
        if (!$A.util.isUndefinedOrNull(childComponent)) {
            if (cmp.get('v.PVForm.sottotipologiaMdt.uniqueId__c') == 18) {
                childComponent.set("v.modalita", "AZZTOT");
            } else {
                childComponent.set("v.modalita", "") ;
            }
            childComponent.loadSpese();
        }
        this.nascondiClessidra(cmp);
    },


    /************************/
    /* Gestione Inserimento */
    /************************/

    validateUserInput: function(cmp, event, helper) {
        var messaggi = "";
        // almeno una selezionata
        if (cmp.get("v.speseListSelezionate").length == 0) {

            if (cmp.get('v.PVForm.sottotipologiaMdt.uniqueId__c') == 18) {
                // tutte le spese
                messaggi += "Non sono presenti spese da azzerare in questa pratica. Impossibile proseguire\n";
            } else {
                messaggi += "Selezionare almeno una spesa per proseguire.\n";
            }
        }

        if(!cmp.find("destinatario").checkValidity()){	//auraMethod checkValidity
            cmp.find("destinatario").showHelpMessageIfInvalid();
            messaggi+=  "Selezionare l'ufficio destinatario.\n";
        }
        
        return messaggi;
    },

    completaPVForm: function (cmp, event, helper, PVForm) {
        // arricchisco il PVForm con dati specifici del PV
        PVForm.ufficioDestinazione = cmp.get('v.destinatarioSelezionato');
        PVForm.speseList = cmp.get('v.speseListSelezionate');
        return PVForm;
    },



    /*********************************/
	/* metodi CUSTOM del singolo PV */
    /*********************************/
    
    
    
})