({
	doInit : function(component, event, helper) {
		helper.doInit(component, event);
	},
    
    handleChangeCaseStepEvent: function(component, event, helper) {
		var categoria = event.getParam("categoria");
		var stepLavorazione = event.getParam("stepLavorazione");
		component.set("v.categoria", categoria);
		component.set("v.stepLavorazione", stepLavorazione);		
	},
})