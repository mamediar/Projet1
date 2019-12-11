({
	handleManageContact : function(component, event, helper) {
        
        helper.handleManageContact(component, event, helper);
    },
    chiama : function(component, event, helper) {
        helper.chiama(component, event, helper);
    },
    creaTicketAltriUffici : function(component, event, helper) {
        helper.creaTicketAltriUffici(component, event, helper);
    },
    creaTicketFiliale : function(component, event, helper) {
        helper.creaTicketFiliale(component, event, helper);
    },
    creaTicketCompassAffari : function(component, event, helper) {
        helper.creaTicketCompassAffari(component, event, helper);
    },
    callCampagna : function(component, event, helper){
        helper.callCampagna(component, event, helper);
    },
    closeModel : function(component, event, helper){
        component.set('v.isOpenModel',false);
    }
})