({
	doInit : function(component, event, helper) {
        var action = component.get('c.loadOpzioniNuovoCaso');
        action.setParam('componentType','Nuovo Caso Cliente');        
        action.setCallback(this, function(response) {
            if ( response.getState() == 'SUCCESS' ){   
                component.set('v.itemList', response.getReturnValue());
            }
        });        
        $A.enqueueAction(action);
    },
    
    selezionaCaso : function(cmp, event, helper) {
        var item = cmp.get('v.itemList')[cmp.get('v.casoSelezionato')];
        //if(item != '' && item != undefined) helper.doAction(cmp, item);  
        if(item) helper.doAction(cmp, item);        
    }
})