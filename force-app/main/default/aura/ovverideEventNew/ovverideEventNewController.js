({
	doInit : function(component, event, helper) {
		var action = component.get("c.getFiliale");

        action.setCallback(this, function(data) {
            let retVal = data.getReturnValue();

            if(data.getState()=='SUCCESS'){
                if(retVal!=' '){ 
                    component.set("v.filialeExist", true);
                    component.set("v.IdFiliale", retVal);
                    console.log('DP IdFiliale: '+retVal);
                }else{
                	console.log('Filiale non trovata.');
                    component.set("v.filialeExist", false);                    
                }
            }else{
                console.log('Errore nel controller.');
            }
            
        });
        $A.enqueueAction(action);
	}
})