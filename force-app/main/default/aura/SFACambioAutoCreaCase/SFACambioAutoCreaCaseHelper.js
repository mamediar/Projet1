({
	initHelper: function (component, event) {
		var action = component.get("c.getAzioniFilialeSuDealer");

		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
				var listaAzioniFilialeSuDealer = response.getReturnValue();
				component.set("v.listaAzioniFilialeSuDealer", listaAzioniFilialeSuDealer);
			}
		});
		$A.enqueueAction(action);

	},

	initPageReference : function(component, event) {
        var navService = component.find("navService");
		var pageReference = {
			"type": "standard__recordPage",
			"attributes": {
				"recordId": component.get("v.caseCreatoId"),
				"objectApiName": "Case",
				"actionName": "view"
			}
		};

		component.set("v.pageReference", pageReference);
		var defaultUrl = "#";
		navService.generateUrl(pageReference)
			.then($A.getCallback(function (url) {
				component.set("v.url", url ? url : defaultUrl);
			}), $A.getCallback(function (error) {
				component.set("v.url", defaultUrl);
			}));

		console.log("*** pageReference :: " + pageReference);
		console.log("*** JSON.stringify(pageReference) :: " + JSON.stringify(pageReference));

	},
	
	goToCaseCreato: function (component, event) {
		var navService = component.find("navService");
		// Uses the pageReference definition in the init handler
		var pageReference = component.get("v.pageReference");
		event.preventDefault();
		navService.navigate(pageReference);
	},
})