({
	InitHelper : function(component) 
    {
		var action = component.get("c.getDispositions");
        console.log('visibilityOption cmp figlio:: '+component.get('v.visibilityOption'));
        action.setParams({
            "parentExternalId": component.get('v.parentExternalId'),    
            "visibilityOption": component.get('v.visibilityOption'),
            "usesCategory": component.get('v.usesCategory')
        });
        action.setCallback(this, function(response) {
            if ( response.getState() == 'SUCCESS' ) {
                var mapDispositions=response.getReturnValue();
                var listaDispositions = [];
                for(var key in mapDispositions){
                    listaDispositions.push({value:mapDispositions[key], key:key});
                }                
                component.set('v.listaDispositions',listaDispositions);
                component.set('v.mapDispositions',mapDispositions);
            }
        });
        $A.enqueueAction(action);
        
	}
})