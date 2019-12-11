({

	handleArchiviaButton : function(component, event, helper) {

		var action = component.get("c.setContractsArchived");
		action.setParams({
				contratti: component.get("v.selectedRows")
		});

		action.setCallback(this, function(r){
			var toastEvent = $A.get("e.force:showToast");
       	    toastEvent.setParams({
       		title : "Successo",
       		type : "success",
       		message :"Successo!",
    	});            
        toastEvent.fire();	
            setTimeout(function(){ $A.get('e.force:refreshView').fire(); }, 200);
		});

		$A.enqueueAction(action);
	}
})