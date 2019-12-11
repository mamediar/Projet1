({
    doInit : function(component, event, helper) {
        helper.getQueus(component, event, helper);
    },
    handleManageContact : function(component, event, helper) {
        var queueContact = event.getParam("queueContact");
        component.set('v.queueContact',queueContact);        
        helper.handleManageContact(component, queueContact);
    },
    first : function(component, event, helper) {
        helper.first(component, event, helper);
    },
    next : function(component, event, helper) {
        helper.next(component, event, helper);
    },
    previous : function(component, event, helper) {
        helper.previous(component, event, helper);
    },
    last : function(component, event, helper) {
        helper.last(component, event, helper);
    },
    filterContactCase : function(component, event, helper) {
        helper.filterContactCase(component, event, helper);
    },
    closeModel: function(component, event, helper) {
        helper.closeModel(component, event, helper);
    },
    showFilter: function(component, event, helper) {
        helper.showFilter(component, event, helper);
    },
    getCampagna : function(component, event, helper) {
        helper.getCampagna(component, event, helper);
    },
    getCriterion : function(component, event, helper) {
        helper.getCriterion(component, event, helper);
    },
    cntSelected : function(component, event, helper){
        var qSelected = event.getSource().get('v.value');
        console.log('qSelected '+JSON.stringify(qSelected));
        helper.cntSelected(component, event, qSelected);
    }, 
    handleCaseSearch: function(component, event, helper){
        alert('############### ');
        helper.handleCaseSearchDealer(component, event);
    },
    queuSelected : function(component, event, helper){
        helper.queuSelected(component, event, helper);
    }
})