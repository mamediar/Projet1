({
	doInit: function(component, event, helper) {
		var caseId = component.get("v.recordId");

		var action = component.get("c.init");
		var scadenziario; 

		action.setParams({
			caseId: caseId
		});

		action.setCallback(this, function(response){
		  if (response.getState() == 'SUCCESS'){
			scadenziario = response.getReturnValue();
			component.set("v.isCasePending", scadenziario.caseStatus == 'Pending');
			component.set("v.dataTermineLavoro", scadenziario.dataTermineLavoro);
			component.set("v.dataCaricamento", scadenziario.dataCaricamento);

			component.set("v.inizioDecade1", scadenziario.inizioDecade1);
			component.set("v.fineDecade1", scadenziario.fineDecade1);
			component.set("v.dataTermineScadenziarioDecade1", scadenziario.dataTermineScadenziarioDecade1);

			component.set("v.inizioDecade2", scadenziario.inizioDecade2);
			component.set("v.fineDecade2", scadenziario.fineDecade2);
			component.set("v.dataTermineScadenziarioDecade2", scadenziario.dataTermineScadenziarioDecade2);

			component.set("v.inizioDecade3", scadenziario.inizioDecade3);
			component.set("v.fineDecade3", scadenziario.fineDecade3);
			component.set("v.dataTermineScadenziarioDecade3", scadenziario.dataTermineScadenziarioDecade3);
		  }
		});
	
		$A.enqueueAction(action);
	},

	callUpdateScadenze: function(component, event, helper) {

		var inizioDecade1 = component.get("v.inizioDecade1");
		var fineDecade1 = component.get("v.fineDecade1");
		var dataTermineScadenziarioDecade1 = component.get("v.dataTermineScadenziarioDecade1");

		var inizioDecade2 = component.get("v.inizioDecade2");
		var fineDecade2 = component.get("v.fineDecade2");
		var dataTermineScadenziarioDecade2 = component.get("v.dataTermineScadenziarioDecade2");

		var inizioDecade3 = component.get("v.inizioDecade3");
		var fineDecade3 = component.get("v.fineDecade3");
		var dataTermineScadenziarioDecade3 = component.get("v.dataTermineScadenziarioDecade3");

		console.log(" *** dataTermineScadenziarioDecade1 :: " + dataTermineScadenziarioDecade1);
		console.log(" *** dataTermineScadenziarioDecade2 :: " + dataTermineScadenziarioDecade2);
		console.log(" *** dataTermineScadenziarioDecade3 :: " + dataTermineScadenziarioDecade3);

		if (inizioDecade1 && fineDecade1 && dataTermineScadenziarioDecade1 && 
			inizioDecade2 && fineDecade2 && dataTermineScadenziarioDecade2 &&
			inizioDecade3 && fineDecade3 && dataTermineScadenziarioDecade3) {

			var caseId = component.get("v.recordId");

			var action = component.get("c.updateScadenze");

			action.setParams({
				caseId: caseId,
				inizioDecade1: inizioDecade1,
				fineDecade1: fineDecade1,
				dataTermineDecade1: dataTermineScadenziarioDecade1,
				inizioDecade2: inizioDecade2,
				fineDecade2: fineDecade2,
				dataTermineDecade2: dataTermineScadenziarioDecade2,
				inizioDecade3: inizioDecade3,
				fineDecade3: fineDecade3,
				dataTermineDecade3: dataTermineScadenziarioDecade3
			})

			action.setCallback(this, function(response){
				if (response.getState() == 'SUCCESS'){
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
					  "type": "success",
					  "title": "Operazione completata",
					  "message": "Date di scadenza aggiornate con successo!"
					});
					toastEvent.fire();
				}
			});

			$A.enqueueAction(action);
		}
		else {
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
			  "type": "error",
			  "title": "Scadenze non aggiornate",
			  "message": "Valorizzare tutti i campi"
			});
			toastEvent.fire();
		}

	}
})