({
	doInit : function(component, event, helper) {
        
		var action = component.get("c.getEvent");
        action.setParam('recordId',component.get('v.recordId'));
        action.setCallback(this, function(data) {
        	let retVal = data.getReturnValue();
            component.set("v.eventRecord", retVal);
            console.log('DP eventRecord: '+JSON.stringify(retVal))
            helper.getFiliale(component); 
            helper.getValuesProduct(component);
            
        });
        $A.enqueueAction(action);
        helper.setIconAndNameTab(component,event,helper); 
        
	}
})