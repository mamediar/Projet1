({

	doInit: function(component, event, helper) {
		helper.callGetPratica(component, event);
		helper.callGetEsiti(component, event);
	},

	handleSelezionaEsito: function (component, event, helper) {
		var esitoSelezionato = component.find("listaEsitiId").get("v.value");
		component.set("v.esitoSelezionato", esitoSelezionato);
		console.log("*** esitoSelezionato :: " + esitoSelezionato);
	},

    handleCompletaButton: function(component, event, helper) {
		var action = component.get("c.updatePratica");
		var objectId = component.get("v.objectId");
		var esito = component.get("v.esitoSelezionato");
		var nota = component.get("v.notaAgenziaItalia");

		action.setParams({
			praticaId: objectId,
			esito: esito,
			nota: nota
		}); 

		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
				//helper.openModalOK(component, event);
				helper.finish(component, event);
				console.log("*** OK!");	
			}
			else {
				console.log("*** KO!");
			}
		});
		
		$A.enqueueAction(action);
	},
	
	closesModals: function (component, event) {
		component.set("v.isModalOKOpen", false);
		component.set("v.isModalKOOpen", false);
		component.set("v.isComponentOpen", false);
		component.set("v.isBlankPageOpen", true);
	}

})