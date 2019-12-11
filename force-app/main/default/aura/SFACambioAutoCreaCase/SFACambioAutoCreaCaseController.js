({
	/*init: function (component, event, helper) {
		var action = component.get("c.getDealers");

		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
				var listaDealer = response.getReturnValue();
				component.set("v.listaDealer", listaDealer);
			}
		});
		$A.enqueueAction(action);

	},

	handleSelezionaDealer: function (component, event, helper) {
		var dealerIdSelezionato = component.find("listaDealerId").get("v.value");
		component.set("v.dealerIdSelezionato", dealerIdSelezionato);
	},

	handleConfermaButton: function (component, event, helper) {

		var dealerIdSelezionato = component.get("v.dealerIdSelezionato");

		if (dealerIdSelezionato && dealerIdSelezionato != '') {
			var action = component.get("c.creaCase");

			action.setParams({
				dealerId: dealerIdSelezionato
			}); 

			action.setCallback(this, function(response){
				if (response.getState() == 'SUCCESS'){
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						title : "Operazione completata",
						type : "success",
						message :"Case creato con successo!",
					});
					toastEvent.fire();          
				}
			});
			$A.enqueueAction(action);
		}
		else {
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				title : "Attenzione",
				type : "error",
				message :"Selezionare un dealer.",
			});
			toastEvent.fire();
		}

	}*/

	doInit: function (component, event, helper) {
		helper.initHelper(component, event);
		//helper.initPageReference(component, event);
	},
    
    handleSelezionaAzione: function (component, event, helper) {
		var azioneSelezionata = component.find("listaAzioniFilialeSuDealerId").get("v.value");
		component.set("v.azioneSelezionata", azioneSelezionata);
	},
    
    handleConfermaButton: function (component, event, helper) {

		var azioneSelezionata = component.get("v.azioneSelezionata");
        var dealerId = component.get("v.recordId");

		if (azioneSelezionata && azioneSelezionata != '') {
			var action = component.get("c.creaCase");

			action.setParams({
				dealerId: dealerId,
                developerNameAzioneSelezionata: azioneSelezionata
			}); 

			action.setCallback(this, function(response){
				if (response.getState() == 'SUCCESS'){
					var caseCreatoId = response.getReturnValue();
					component.set("v.caseCreatoId", caseCreatoId);
					helper.initPageReference(component, event);
					helper.goToCaseCreato(component, event);

					/*var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						title : "Operazione completata",
						type : "success",
						message :"Attività creata con successo!",
					});
					toastEvent.fire();*/          
				}
			});
			$A.enqueueAction(action);
		}
		else {
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				title : "Attenzione",
				type : "error",
				message :"Selezionare un\'attività.",
			});
			toastEvent.fire();
		}

	}

})