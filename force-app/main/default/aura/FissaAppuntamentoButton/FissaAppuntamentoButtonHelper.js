({
	invokeFissaAppuntamento : function(cmp, event, helper) {
		
		var account = cmp.get("v.account");
		var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:creaAppuntamento",
            componentAttributes: {
                'idCliente' : account.Id
            }
        });
        evt.fire();
	},
})