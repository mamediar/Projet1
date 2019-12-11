({
	doInit: function (component, event) {
        console.log('WRAPPER');
		var action = component.get("c.getDispositionExternalIdFromDossier");
		action.setParams({
			dossierId: component.get("v.dossierId")
		}); 

		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                console.log('RESPONSE SUCCESS');
				var dati = response.getReturnValue();
				component.set("v.dispositionExternalId", dati);
                console.log('dispositionExternalId: '+component.get("v.dispositionExternalId"));
            } else {
                console.log('RESPONSE NOT SUCCESS');
            }
		});
		$A.enqueueAction(action);

	},
})