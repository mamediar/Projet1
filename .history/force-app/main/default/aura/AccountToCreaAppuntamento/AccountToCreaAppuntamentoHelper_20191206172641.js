({
    openCreaAppuntamento : function(component, event, helper) {
        component.set('v.openmodel',true);
    },
    closeModal : function(component, event, helper) {
        component.set('v.openmodel',false);
        window.closed();
    },
    
})