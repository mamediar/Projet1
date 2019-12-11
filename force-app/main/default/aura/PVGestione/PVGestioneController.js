/**
 * @File Name          : PVGestioneController.js
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 2019-6-17 15:39:17
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-6-17 15:38:43   Andrea Vanelli     Initial Version
**/
({
	doInit : function(cmp,event,helper) {
       helper.doInitHelper(cmp,event,helper);
    },
    callChildMethod : function(cmp, event, helper) {
        helper.callChildMethodHelper(cmp, event, helper);
	},

    
	//funzioni comuni del PV *****************************************************************************
    showToast: function(cmp,event,helper) {
        helper.doShowToast(cmp,event);
    },
    showWaitComponent: function(cmp,event,helper) {
        helper.showWaitComponent(cmp);
    },
    hideWaitComponent: function(cmp,event,helper) {
        helper.hideWaitComponent(cmp);
    },
    
})