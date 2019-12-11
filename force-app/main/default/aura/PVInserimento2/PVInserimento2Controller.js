/**
 * @File Name          : PVInserimento2Controller.js
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 19/8/2019, 13:32:00
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    11/8/2019, 16:58:25   Andrea Vanelli     Initial Version
**/
({
	inizializzaDatiBase : function(cmp,event,helper) {
        helper.inizializzaDatiBase(cmp,event,helper);
    },
	onRender : function(cmp,event,helper) {
        helper.onRender(cmp,event,helper);
    },
    inserisciCase : function(cmp, event, helper) {
        helper.inserisciCase(cmp, event, helper);
	},    
    getListaSottotipologie : function(cmp, event, helper){
        helper.getListaSottotipologie(cmp, event, helper);
    },       
    getListaCategorie : function(cmp, event, helper){
        helper.getListaCategorie(cmp, event, helper);
	},
    getListaReasons : function(cmp, event, helper){
        helper.getListaReasons(cmp, event, helper);
        helper.callChild_onParentChange(cmp,'psvSubtype');

    }, 
    
    selezionaReason : function(cmp, event, helper){
        helper.selezionaReason(cmp, event, helper);
        helper.callChild_onParentChange(cmp,'psvReason');
    }, 

    inizializzaDatiCategoria : function(cmp,event,helper){
        helper.inizializzaDatiCategoria(cmp,event,helper);
    },
   
    onPraticaSelezionata : function(cmp,event,helper){
        helper.callChild_onParentChange(cmp,'ocsPratica');
    },
    onClienteSelezionato : function(cmp,event,helper){
        helper.callChild_onParentChange(cmp, 'ocsCliente');
    },        
    
    
    
	//funzioni comuni del PV *****************************************************************************
    
    handlePVSubComponentEvents : function(cmp, event,helper) {
        var method = event.getParam("method");
        var params = event.getParam("arguments");
        if (method == 'mostraClessidra') {
            helper.mostraClessidra(cmp);
        } else if (method == 'nascondiClessidra') {
            helper.nascondiClessidra(cmp);
        } else if (method == 'mostraErrori') {
            cmp.set('v.messaggiErrore', params.message);
        } else if (method == 'mostraToast') {
            helper.mostraToast(cmp,event);
        } else if (method == 'gestisciRispostaInserimento') {
            helper.gestisciRispostaInserimento(cmp,event);
        } else if (method == 'showCartaDatiFinanziari') {
            helper.showCartaDatiFinanziari(cmp,event);
        }
    },    
    
    mostraToast: function(cmp,event,helper) {
        helper.mostraToast(cmp,event);
    },
    mostraErrori: function(cmp,event,helper) {
        var params = event.getParam('arguments');
        cmp.set('v.messaggiErrore', params.message);
    },    
    gestisciRispostaInserimento: function(cmp,event,helper) {
        helper.gestisciRispostaInserimento(cmp,event);
    },    
    mostraClessidra: function(cmp,event,helper) {
        helper.mostraClessidra(cmp);
    },
    nascondiClessidra: function(cmp,event,helper) {
        helper.nascondiClessidra(cmp);
    },
    
    getExternalAttachments: function(cmp,event,helper) {
        return helper.getExternalAttachments(cmp);
    },

    showCartaDatiFinanziari: function(cmp,event,helper) {
        helper.showCartaDatiFinanziari(cmp,event);
    },    
        
})