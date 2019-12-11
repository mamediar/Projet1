({
	handleManageContact : function(component, event, helper) {
        helper.handleManageContact(component, event, helper);
        console.log(' filialeCase +++++ '+component.get('v.filialeCase'))
    },
    callCampagna: function(component, event, helper) {
        helper.callCampagna(component, event, helper);
    },
    getFilialeCase: function(component, event, helper) {
        helper.getFilialeCase(component, event, helper);
    },
    closeScriptCampagna : function(component){
        component.set("v.showScript",false);
    }
})