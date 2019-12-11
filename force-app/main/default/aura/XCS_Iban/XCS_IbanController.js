({
    actionButtonCalcolaIBAN : function(component, event, helper) {
		helper.calcolaIBAN(component, event);
	},
    
    actionButtonVerificaIBAN : function(component, event, helper) {
		helper.verificaIBAN(component, event);
	},
    
    
    onSubmitFormCC : function(component, event, helper) {
        helper.evaluateIfSaveCC(component,event);
	},
    
	handleSuccess: function(component, event, helper) {
        var CC = event.getParams().response;
        component.set("v.CCId",CC.id);
        if(component.get("v.CCId")){
            helper.inserisciAggiornaCC(component, event);
        }
	},  
    
    handleError: function(component, event, helper) {
        helper.showToast(component,event,"error","Errore nel salvataggio dei dati.","500");
    },
})