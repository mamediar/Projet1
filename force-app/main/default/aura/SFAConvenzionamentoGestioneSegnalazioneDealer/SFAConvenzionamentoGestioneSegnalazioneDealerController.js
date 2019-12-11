({
	doInit:	function(component, event, helper) {
		helper.initPageReference(component, event);
		helper.callGetDealerSegnalato(component, event);
	},

	handleDispositionReadyEvent: function(component, event, helper) {
        console.log('***handleDispositionReadyEvent');
		var nota = event.getParam("note");
		var disposition = event.getParam("disposition");
		component.set("v.nota", nota);
		component.set("v.disposition", disposition);
		helper.callManageCaseWithNewDisposition(component, event);
	},

	handleMacroarea: function(component, event, helper) {
		var macroarea = event.getSource().get("v.value");
		if (macroarea && macroarea != '' && macroarea != ' ')
			component.set("v.macroarea", macroarea);
		console.log("*** handleMacroarea - macroarea :: " + component.get("v.macroarea"));
	},

	handleProdottoDominante: function(component, event, helper) {
		var prodottoDominante = event.getSource().get("v.value");
		if (prodottoDominante != null && prodottoDominante != undefined && prodottoDominante != '' && prodottoDominante != ' ') {
			component.set("v.prodottoDominante", prodottoDominante);
			console.log("*** entrato nell if");
		
		}
		
		console.log("*** handleProdottoDominante - component.get('v.prodottoDominanteBackup') :: " + component.get("v.prodottoDominanteBackup"));
		console.log("*** handleProdottoDominante - prodottoDominante :: " + prodottoDominante);
		console.log("*** handleProdottoDominante - component.get('v.prodottoDominante') :: " + component.get("v.prodottoDominante"));
	}
})