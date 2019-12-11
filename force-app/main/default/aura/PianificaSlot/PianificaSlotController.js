({
	init : function(component, event, helper) {
		helper.initApex(component,event,helper);
	},

    onChangeRegionSelect: function(component, event, helper) {
		helper.onChangeRegionSelect(component, event, helper);
	},

	onChangeAreaSelect: function(component, event, helper) {
		helper.onChangeAreaSelect(component, event, helper);
	},
    
	onChangeBranchSelect: function(component, event, helper) {
		helper.onChangeBranchSelect(component, event, helper);
	},

	submitNewTargetDate: function(component, event, helper) {
		helper.submitNewTargetDate(component, event, helper,false);
	},
    
	saveSlotList: function(component, event, helper) {
		helper.saveSlotList(component, event, helper);
	},
	
	cancelFun: function(component, event, helper){
		helper.submitNewTargetDate(component, event, helper);
	},
	
	sendMessageHandler: function(component, event, helper){
		helper.sendMessageHandler(component, event, helper);
	},
})