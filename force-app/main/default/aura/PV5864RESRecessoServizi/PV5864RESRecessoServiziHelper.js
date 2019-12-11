({

    /********************/
    /* EVENTI           */
    /********************/

    /*********************************/
	/* metodi CUSTOM del singolo PV */
    /*********************************/

    /************************/
    /* Gestione Inserimento */
    /************************/

    validateUserInput: function(cmp, event, helper) {
        var messaggi = "";
        messaggi = this.checkPraticaSelezionata(cmp);
        return messaggi;
    },

    completaPVForm: function(cmp, event, helper, PVForm) {
        // arricchisco il PVForm con dati specifici del PV
        return PVForm;
    },
})