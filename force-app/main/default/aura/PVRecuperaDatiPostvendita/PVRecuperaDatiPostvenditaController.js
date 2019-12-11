/**
 * @File Name          : PVRecuperaDatiPostvenditaController.js
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 10/10/2019, 12:51:34
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-7-1 12:25:25   Andrea Vanelli     Initial Version
**/
({
    init: function (cmp, event, helper) {

        var inputOCSCliente = cmp.get('v.inputOCSCliente');
        var inputOCSPratica = cmp.get('v.inputOCSPratica');
        if (!$A.util.isUndefinedOrNull(inputOCSPratica) && inputOCSPratica != '') {
            cmp.set('v.numPratica', inputOCSPratica);
            helper.doRicercaHelper(cmp, event, helper);
        } else if (!$A.util.isUndefinedOrNull(inputOCSCliente) && inputOCSCliente != '') {
            cmp.set('v.codCliente', inputOCSCliente);
            helper.doRicercaHelper(cmp, event, helper);
        }

    },

    keyCheckRicerca: function (cmp, event, helper) {
        if (event.which == 13) {
            helper.doRicercaHelper(cmp, event, helper);
            //event.preventDefault();
        }
    },


    doRicerca: function (cmp, event, helper) {
        helper.doRicercaHelper(cmp, event, helper);
    },

    selectCliente: function (cmp, event, helper) {
        console.log("**** selectCliente *** ");
        helper.selectClienteHelper(cmp, event, helper);

    },

    selectPratica: function (cmp, event, helper) {
        // AV TODO non dovremmo gestire la selezione multipla??
        cmp.set('v.praticaSelezionata', event.getParam('selectedRows')[0]);
        console.log('v.praticaSelezionata' + cmp.get('v.praticaSelezionata'));
    },


    resetRicerca: function (cmp, event, helper) {
        // svuoto i campi di ricerca
        cmp.set('v.cognomeCliente', '');
        cmp.set('v.nomeCliente', '');
        cmp.set('v.codFiscaleCliente', '');
        cmp.set('v.dataNascitaCliente', '');
        cmp.set('v.numPratica', '');
        cmp.set('v.pan', '');
        cmp.set('v.codCliente', '');


        // svuoto le liste e selezioni
        cmp.set('v.OCSClienti', null);
        cmp.set('v.praticheList', []);
        cmp.set('v.praticaSelezionata', null);

        cmp.set('v.idOCSClienteSelezionato', []);
        cmp.set('v.OCSClienteSelezionato', null);
    }


})