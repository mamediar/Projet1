({
    doInit: function(component, event, helper) {
        console.log('[PV2871DuplicatoCarta - dotInit] PVForm:', JSON.stringify(component.get("v.PVForm")));
        console.log('[PV2871DuplicatoCarta - dotInit] parametriEsterni:', JSON.stringify(component.get("v.parametriEsterni")));
        console.log('[PV2871DuplicatoCarta - dotInit] cartaDatiFinanziariData:', JSON.stringify(component.get("v.cartaDatiFinanziariData")));
        component.set("v.showDetails", helper.isValid(component));
    },

    modificaIndirizzo: function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },

    onChangeIsValidAddress: function(component, event, helper) {

    }
});