({
	doInit : function(cmp, event, helper) {
		helper.initNotaSpeseList(cmp, event, helper);
	},

	handleRowAction : function(cmp, event, helper) {
		helper.handleRowAction(cmp, event, helper);
	},

	stepChange: function(cmp, event, helper) {
		if((event.getParam("oldValue") == 'step2' || event.getParam("oldValue") == 'step1') && event.getParam("value") == 'step0')
			helper.initNotaSpeseList(cmp, event, helper);
	}
})