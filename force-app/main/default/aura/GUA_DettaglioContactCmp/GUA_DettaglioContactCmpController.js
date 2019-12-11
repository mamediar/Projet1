({
    handleManageContact: function(component, event, helper) {
        helper.getCaseByRecord(component);
    },
    cercaDealer: function(component, event, helper) {
        helper.cercaDealer(component, event, helper);
    },
    chiudichiamata: function(component, event, helper) {
        // Set isModalOpen attribute to true
        helper.chiudichiamata(component, event, helper);
    },
    creaTicketAltriUffici: function(component, event, helper) {
        helper.creaTicketAltriUffici(component, event, helper);
    },
    creaTicketFiliale: function(component, event, helper) {
        helper.creaTicketFiliale(component, event, helper);
    },
    creaTicketCompassAffari: function(component, event, helper) {
        helper.creaTicketCompassAffari(component, event, helper);
    },
    closeModel: function(component, event, helper) {
        component.set('v.isOpenModel', false);
    }
})