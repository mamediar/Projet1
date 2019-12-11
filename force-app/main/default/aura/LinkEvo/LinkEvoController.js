({
	navigate : function(cmp, event, helper) {
        console.log(cmp.get('v.numeroPratica'));
		var action = cmp.get('c.doInit');
        action.setParams({
            'sTask' : cmp.get('v.task'),
            'sLinkage' : cmp.get('v.linkage'),
            'sUrlritorno' : cmp.get('v.urlritorno'),
            'CIP' : cmp.get('v.codiceCliente'),
            'numeroPratica' : cmp.get('v.numeroPratica'),
            'office' : cmp.get('v.office'),
            'infoPre' : cmp.get('v.infoPre'),
            'infoPost' : cmp.get('v.infoPost'),
            'force' : cmp.get('v.force')
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var result = response.getReturnValue();
                cmp.set('v.evoUrl', result);
                var urlEvent = $A.get("e.force:navigateToURL");
                console.log( result )
                urlEvent.setParams({
                    "url": result
                });
                urlEvent.fire();
                
                
            }
        });
        $A.enqueueAction(action);
	}
    

})