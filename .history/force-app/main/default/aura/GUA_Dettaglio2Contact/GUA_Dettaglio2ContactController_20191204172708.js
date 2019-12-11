({
    doInit: function(component, event) {
        console.log('accId '+JSON.stringify(component.get('v.accId')))

    },
    dettaglioDealer: function(component, event, helper) {
        helper.showAction(component, event, helper);
        helper.dettaglioDealer(component, event, helper);
    },
    ultimeChiamate: function(component, event, helper) {
        helper.showAction(component, event, helper);
        helper.ultimeChiamate(component, event, helper);
    },
    produzione: function(component, event, helper) {
        helper.showAction(component, event, helper);
        helper.produzione(component, event, helper);
    },
    ultimePratiche: function(component, event, helper) {
        helper.showAction(component, event, helper);
        helper.ultimePratiche(component, event, helper);
    },
    ultimeCarte: function(component, event, helper) {
        helper.showAction(component, event, helper);
        helper.ultimeCarte(component, event, helper);
    },
    attivitaDealerSFA: function(component, event, helper) {
        helper.showAction(component, event, helper);
        helper.attivitaDealerSFA(component, event, helper);
    },
    chiudiEsitaChiamata: function(component, event, helper) {
        component.set('v.openModalChiuso', true); 
        var caseDetails = component.get("v.contactDetails");
        var compEvent = $A.get("e.c:GUA_CaseDataEvent");
        compEvent.setParams({ caseData: caseDetails });
        compEvent.fire();

        helper.showAction(component, event, helper);
        helper.chiudiEsitaChiamata(component, event, helper);
    },
    fAQ: function(component, event, helper) {
        helper.showAction(component, event, helper);
        helper.fAQ(component, event, helper);
    },
    
    refreshViewDetail: function(component, event, helper) {
        component.set('v.openModalChiuso', false);
    }
});