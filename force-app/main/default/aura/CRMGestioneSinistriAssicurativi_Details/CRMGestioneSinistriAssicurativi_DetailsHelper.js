({
    doInit : function(component) {
        var action = component.get("c.isAlico");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                component.set("v.isAlico", response.getReturnValue());
            }
            component.set("v.spinner", false);
        });
        component.set("v.spinner", true);
        $A.enqueueAction(action);
        
	}
})