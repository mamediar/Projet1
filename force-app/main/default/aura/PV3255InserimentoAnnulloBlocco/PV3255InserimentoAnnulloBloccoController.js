({
    doInit: function(component, event, helper) {
        console.log('[PV3255InserimentoAnnulloBlocco - dotInit] PVForm:', JSON.stringify(component.get("v.PVForm")));
        console.log('[PV3255InserimentoAnnulloBlocco - dotInit] parametriEsterni:', JSON.stringify(component.get("v.parametriEsterni")));
        console.log('[PV3255InserimentoAnnulloBlocco - dotInit] cartaDatiFinanziariData:', JSON.stringify(component.get("v.cartaDatiFinanziariData")));
        component.set("v.showDetails", helper.isValid(component));
    },

    onChangeBloccoCarte: function(component, event, helper) {
        console.log('[PV3255InserimentoAnnulloBlocco - onChangeBloccoCarte]');
        helper.clearErrors(component);
    }
});