({
	init : function(cmp, event, helper) {
        helper.Init(cmp,event,helper);
	},

    verifyCheckPresaVisione: function (cmp, event, helper) {
        cmp.find('checkbox').showHelpMessageIfInvalid();
    },

})