/**
 * @File Name          : PV1760CopiaContrattoGestioneController.js
 * @Description        : 
 * @Author             : Lorenzo Marzocchi
 * @Group              : 
 * @Last Modified By   : Lorenzo Marzocchi
 * @Last Modified On   : 2019-9-20 14:39:18
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    2019-9-17   Lorenzo Marzocchi     Initial Version
**/
({
    doInit: function (component, event, helper) {
        helper.init(component, event, helper);
    },

    //metodo richiamato dal bottone conferma del contenitore PVInserimento
    save: function (cmp, event, helper) {
        helper.save(cmp, event, helper);
    },

    mostraAnomalie: function (component, event, helper) {
        helper.mostraAnomalie(component, event, helper);
    },

    handleRowAction: function (component, event, helper) {
        helper.handleRowAction(component, event, helper);
    },
})