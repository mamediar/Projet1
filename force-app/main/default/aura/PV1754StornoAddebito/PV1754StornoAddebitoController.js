({
    
        doInit: function(component, event, helper) {
            console.log('[PV1754StornoAddebito - dotInit] PVForm:', JSON.stringify(component.get("v.PVForm")));
            console.log('[PV1754StornoAddebito - dotInit] parametriEsterni:', JSON.stringify(component.get("v.parametriEsterni")));
            console.log('[PV1754StornoAddebito - dotInit] cartaDatiFinanziariData:', JSON.stringify(component.get("v.cartaDatiFinanziariData")));
            component.set("v.showDetails", helper.isValid(component));
        },
    
        onChangeBloccoCarte: function(component, event, helper) {
            console.log('[PV1754StornoAddebito - onChangeBloccoCarte]');
            helper.clearErrors(component);
        }
    
})