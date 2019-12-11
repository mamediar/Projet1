({
    openCreaAppuntamento : function(component, event, helper) {
        component.set('v.openmodel',true);
    },
    closeModal : function(component, event, helper) {
        component.set('v.openmodel',false);
        $A.get("e.force:closeQuickAction").fire();
    },
    
})