/**
 * @File Name          : PV1762CancellazioneDaOffertePromozionaliHelper.js
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 19/8/2019, 11:00:28
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    4/7/2019, 11:07:53   Andrea Vanelli     Initial Version
**/
({
    /********************/
    /* EVENTI           */
    /********************/





    /************************/
    /* Gestione Inserimento */
    /************************/

    validateUserInput: function(cmp, event, helper) {
        var messaggi = "";
        // cliente selezionato
        messaggi = this.checkClienteSelezionato(cmp);
        return messaggi;
    },

    completaPVForm: function (cmp, event, helper, PVForm) {
        // arricchisco il PVForm con dati specifici del PV
        return PVForm;
    },





    /*********************************/
	/* metodi CUSTOM del singolo PV */
	/*********************************/


    
})