({  
	onChangeCase : function(cmp, event, helper) {
        var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
		var action = cmp.get("c.getLastCase");
        action.setParams({ CaseRecord : cmp.get("v.CaseRecord") });
		action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.LastCase",response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            spinner.decreaseCounter();
        });
      $A.enqueueAction(action);
  
	}
})