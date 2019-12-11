({
	doInit : function(component, event, helper) {
		helper.doInit(component, event);
	},
    
    handleChangeCaseStepEvent: function(component, event, helper) {
		var dispositionExternalId = event.getParam("dispositionExternalId");
		component.set("v.dispositionExternalId", dispositionExternalId);
	},
})