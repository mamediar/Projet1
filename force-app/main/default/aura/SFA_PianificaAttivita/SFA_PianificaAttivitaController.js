({
	doInit : function(component, event, helper) {
		helper.doInit(component, event, helper);
	},
    pianificaThisSlot : function(component, event, helper) {
		helper.pianificaThisSlot(component, event, helper);
	},
    pianificaNextSlot : function(component, event, helper) {
		helper.pianificaNextSlot(component, event, helper);
	},
    removePianifica : function(component, event, helper) {
		helper.removePianifica(component, event, helper);
	},
    openPianificaPopup : function(component, event, helper) {
        component.set('v.isRischedula',false);
		helper.openPianificaPopup(component, event, helper);
	},
    openRischedulaPopup : function(component, event, helper) {
        component.set('v.isRischedula',true);
		helper.openPianificaPopup(component, event, helper);
	},
    closePianificaPopup : function(component, event, helper) {
		helper.closePianificaPopup(component, event, helper);
	},
    goToHome : function(component, event, helper) {
		helper.goToHome(component, event, helper);
	}
})