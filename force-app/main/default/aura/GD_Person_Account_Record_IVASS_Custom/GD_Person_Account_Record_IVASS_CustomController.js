({
    doInit: function(component, event, helper) {
        helper.getDoInit(component, event);
    },
    handleRisposta: function(component, event, helper) {
        helper.getHandleRisposta(component, event);
    },
    onGroup: function(component, event, helper) {
        var selected = event.getSource().get("v.text");
        console.log('selected : ' + selected);
        component.set('v.myIscritto', selected);
    },
    openModal1: function(component, event, helper) {
        component.set('v.showModal1', true);
    },
    closeModal1: function(component, event, helper) {
        component.set('v.showModal1', false);
    },
    openModal2: function(component, event, helper) {
        helper.getNotesByPersonAccount(component);
    },
    closeModal2: function(component, event, helper) {
        component.set('v.showModal2', false);
    },
    saveRispostaSelected: function(component, event, helper) {
        helper.getSaveRispostaSelected(component, event);
    },
    changeRequiredSavePA: function(component, event, helper) {
        component.set('v.requiredSavePA', false);
    },
    savenote: function(component, event, helper) {
        helper.createNoteForPersonAccount(component);
    },

})