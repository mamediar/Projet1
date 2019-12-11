({
	doInit: function (component, event, helper) {
		var selectedCampaign = component.get("v.selectedCampaign");
		console.log("campaign do init set to: " + selectedCampaign);
		//helper.getCampaignById(component, selectedCampaign);
	},

	setSelectedCampaign: function (component, event, helper) {
		var selectedCampaign = event.getParam("updateCampaign");
		console.log("campaign set to: " + selectedCampaign);
		component.set("v.selectedCampaign", selectedCampaign);
		helper.getCampaignById(component, selectedCampaign);
	},
	handleUpdateCampaign: function (component, event, helper) {
		helper.handleUpdateCampaign(component, event);
	},
	textChange: function (cmp, event, helper) {
		helper.textChange(cmp, event, helper);
	},
	removeDeletedRow: function (component, event, helper) {
		helper.removeDeletedRow(component, event, helper);
	},
	handleChange: function (component, event, helper) {
		helper.handleChange(component, event, helper);
	},
	datecheckChange: function (component, event, helper) {
		helper.datecheckChange(component, event, helper);
	},
	startdateChange: function (component, event, helper) {
		helper.startdateChange(component, event, helper);
	},
	cancelField: function (component, event, helper) {
		helper.cancelField(component, event, helper);
	},

})