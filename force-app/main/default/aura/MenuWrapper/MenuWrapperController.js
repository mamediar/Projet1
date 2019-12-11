({
    handleComponentEvent : function(component, event, helper) {
        
        var cmpName = event.getParam("cmpName");
        console.log('cmpName'+cmpName);
        component.set('v.nomeCmpSelezionato', cmpName);
        
	}
})