({
	init : function(component, event, helper) {
		helper.doInit(component, event, helper);
		helper.setHeaderColumns(component, event, helper);
	},
	openInternalModal : function(component, event, helper) {
		component.set('v.showInternalModal',true);
		component.set('v.hideBox',true);
	},
	esita : function(component, event, helper) {
		helper.esitaCase(component, event, helper);
	},
	goBack : function(component, event, helper) {
		component.set('v.showInternalModal',false);
	}
})