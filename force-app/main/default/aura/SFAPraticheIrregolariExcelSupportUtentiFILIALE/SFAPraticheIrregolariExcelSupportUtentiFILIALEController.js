({
    doInit: function(component, event, helper) {   
        var profUrl = $A.get('$Resource.TabellaEsitiAGITA');
        component.set("v.url", profUrl);		
	}
})