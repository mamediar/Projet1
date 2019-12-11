({
    
    actionButtonAvanti : function (cmp, event, helper) {
        helper.changeAttivitaStepAndType(cmp, event, cmp.get('v.newDispositionExternalIdAvanti'), cmp.get('v.newStepAvanti'),cmp.get('v.assignCaseInButtonAvanti'),cmp.get("v.newCategoriaAvanti"),cmp.get("v.newOggettoAvanti"));
    },    

    actionButtonIndietro : function (cmp, event, helper) {
        helper.changeAttivitaStepAndType(cmp, event, cmp.get('v.newDispositionExternalIdIndietro'), cmp.get('v.newStepIndietro'),cmp.get('v.assignCaseInButtonIndietro'),cmp.get("v.newCategoriaIndietro"),cmp.get("v.newOggettoIndietro"));
    }    
    
    
})