({
	doInit : function(component, event, helper) {
		var recordId = component.get('v.recordId');
        console.log(recordId);
        var action = component.get("c.getScript");
        action.setParams({
            "recordId": recordId
        });
        
        action.setCallback(this, function(response) {
            if ( response.getState() == 'SUCCESS' ) {
                console.log('Il testo è: ' + response.getReturnValue());
                component.set('v.testoScript', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	},
    
    showScript : function(component, event, helper) {
        var scriptVisibility = component.get('v.mostraScript');
        if(scriptVisibility){
            component.set('v.mostraScript', false);
        }else{
            component.set('v.mostraScript', true);
        }        
    }
})