({
	doInit: function(cmp, event, helper) {
		helper.doInit(cmp, event, helper);
		helper.disableCloseFocusedTab(cmp, event, helper);
	},
	
	recordUpdated: function(cmp, event, helper) {
        helper.recordUpdated(cmp, event, helper);
	},

	onChangeAccount: function(cmp, event, helper) {
        helper.onChangeAccount(cmp, event, helper);
	}
})