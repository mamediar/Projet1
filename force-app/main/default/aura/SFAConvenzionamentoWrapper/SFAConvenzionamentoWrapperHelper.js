({
	doInit: function (component, event) {
        console.log('WRAPPER');
		var action = component.get("c.getCategoriaEStepLavorazione");
		var caseId = component.get("v.recordId");
		action.setParams({
			caseId: caseId
		}); 

		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                console.log('RESPONSE SUCCESS');
				var dati = response.getReturnValue();
				component.set("v.categoria", dati.categoria);
                component.set("v.stepLavorazione", dati.stepLavorazione);
                console.log('stepLavorazione: '+component.get("v.stepLavorazione"));
                console.log('categoria: '+component.get("v.categoria"));
            } else {
                console.log('RESPONSE NOT SUCCESS');
            }
		});
		
		$A.enqueueAction(action);

	},
})