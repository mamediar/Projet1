({
    init: function(component, event, helper) {
            
        
        var vAction = component.get("c.getAllPratiche");
        var recordId = component.get('v.recordId');
        vAction.setParams(
        {
            recordId : recordId
        });
        vAction.setCallback(this, function(pResponse) {
            var vState = pResponse.getState();
            if (vState === "SUCCESS") { 
                component.set('v.pratiche', pResponse.getReturnValue());
                if (pResponse.getReturnValue())
                    component.set('v.listaPraticheSize', pResponse.getReturnValue().length);
                console.log(pResponse.getReturnValue());
                console.log('v.pratiche: '+ component.get('v.pratiche'));
            } else {
                var vErrors = pResponse.getError();
                if (vErrors) {
                    if (vErrors[0] && vErrors[0].message) {
                        console.log("Error message: " + vErrors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(vAction);        
    }


})