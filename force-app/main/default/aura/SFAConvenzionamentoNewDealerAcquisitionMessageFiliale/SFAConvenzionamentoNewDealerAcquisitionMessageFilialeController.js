({
	doInit : function(component, event, helper) {
        
		var action = component.get("c.getMessage");
		var caseId = component.get("v.recordId");
		console.log('HELPER NDA:: '+caseId);
		action.setParams({
			caseId: caseId
		}); 

		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                console.log('RESPONSE SUCCESS');
				var message = response.getReturnValue();
				component.set("v.message", message);
            } else {
                console.log('RESPONSE NOT SUCCESS');
            }
		});
		
		$A.enqueueAction(action);
        
		
	}
})