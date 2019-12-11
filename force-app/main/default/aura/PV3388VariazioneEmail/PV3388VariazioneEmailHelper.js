/**
 * @File Name          : PV3388VariazioneEmailHelper.js
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 4/7/2019, 11:06:30
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    4/7/2019, 10:43:18   Andrea Vanelli     Initial Version
**/
({

    /********************/
    /* EVENTI           */
    /********************/

    onClienteSelected: function (cmp) {
        this.mostraErrori(cmp, "");
        this.showMarkup(cmp,true);
        if(this.checkClienteSelezionato(cmp) == ""){
            this.mostraClessidra(cmp);
            var action = cmp.get('c.isAccountPresente');
            action.setParams({
                "codCliente": "C" + cmp.get('v.PVForm.cliente.codCliente')
            });
            action.setCallback(this, function(response, helper) {
                if (response.getState() == 'SUCCESS' && response.getReturnValue()) {
                    //esiste un account, verifico se ha un PostVendita Credenziali (2785) aperto
                    this.verificaCaseCredenziali(cmp, event, helper);
                }
                this.nascondiClessidra(cmp);
            });
            $A.enqueueAction(action);
        }
    },

    /*********************************/
	/* metodi CUSTOM del singolo PV */
    /*********************************/

    verificaCaseCredenziali: function(cmp, event, helper) {
        var action = cmp.get('c.isRecuperoCredenzialiPresente');
        action.setParams({
            "codCliente": "C" + cmp.get('v.PVForm.cliente.codCliente')
        });
        action.setCallback(this, function(response, helper) {
            if (response.getState() == 'SUCCESS' && response.getReturnValue()) {
                this.mostraErrori(cmp, "E' presente un ticket aperto per riemissione credenziali. Impossibile variare l'email");
                this.showMarkup(cmp,false);
            }
        });
        $A.enqueueAction(action);
    },
    

    /************************/
    /* Gestione Inserimento */
    /************************/

    validateUserInput: function(cmp, event, helper) {
        var messaggi = "";
        messaggi = this.checkClienteSelezionato(cmp);
        if(messaggi == ""){
            if(!cmp.find("checkbox").checkValidity()){
                cmp.find('checkbox').showHelpMessageIfInvalid();
                messaggi += "confermare di aver comunicato al cliente la PRIVACY.\n";
            }
            if(!cmp.find("newEmail").checkValidity()){
                cmp.find('newEmail').showHelpMessageIfInvalid();
                messaggi += "Inserire una nuova email.\n";
            }	
            if(cmp.find('oldEmail').get('v.value') == cmp.find('newEmail').get('v.value')){
                messaggi = "La mail inserita è uguale alla precedente. Nessuna variazione da apportare.\n";
            }
        }    
        return messaggi;
    },

    completaPVForm: function(cmp, event, helper, PVForm) {
        // arricchisco il PVForm con dati specifici del PV
		PVForm.mailNuova = cmp.find('newEmail').get('v.value');
		PVForm.mailVecchia = cmp.find('oldEmail').get('v.value');
        return PVForm;
    },
})