/**
 * @File Name          : PV1772DaCustomerServAFilialeGestioneController.js
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 31/10/2019, 14:03:30
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    28/10/2019   Federico Negro     Initial Version
**/
({
    doInit : function(component, event, helper) {
        helper.doInitHelper(component, event, helper);
    },
    
    //metodo richiamato dal bottone conferma del contenitore PVInserimento
    save : function (cmp, event, helper) {
        helper.save(cmp, event, helper);
    }, 
})