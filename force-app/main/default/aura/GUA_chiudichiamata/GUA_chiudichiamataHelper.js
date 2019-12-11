({
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", false);
    },

    closeModel: function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },

    submitDetails: function(component, event, helper) {
        component.set("v.isModalOpen", true);
    },
})