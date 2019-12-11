({
	init : function(cmp, event, helper) {
        console.log('cieo evo');
		var action = cmp.get('c.doInit');
        action.setParams({
            'sTask' : cmp.get('v.task'),
            'sLinkage' : cmp.get('v.linkage'),
            'sUrlritorno' : cmp.get('v.urlritorno'),
            'CIP' : cmp.get('v.codiceCliente'),
            'numeroPratica' : cmp.get('v.numeroPratica'),
            'office' : cmp.get('v.office')
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var result = response.getReturnValue();
                cmp.set('v.evoUrl', result);
            }
        });
        $A.enqueueAction(action);
	}
})