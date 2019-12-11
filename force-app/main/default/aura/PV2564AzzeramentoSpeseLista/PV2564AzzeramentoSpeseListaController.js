/**
 * @File Name          : PV2564AzzeramentoSpeseListaController.js
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 14/8/2019, 11:08:51
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    3/8/2019, 22:50:39   Andrea Vanelli     Initial Version
**/
({ 
	init : function(cmp, event, helper) {
        helper.init(cmp,event,helper);
	},  

    aggiornaSpeseMostrate: function(cmp, event, helper) {
        helper.aggiornaSpeseMostrate(cmp,event,helper);
    },   

    handleRowAction: function (cmp, event, helper) {
        helper.handleRowAction(cmp, event, helper);
    },    
    loadSpese: function (cmp, event, helper) {
        helper.loadSpese(cmp, event, helper);
    },    
    
})