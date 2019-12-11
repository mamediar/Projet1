({
	doInit: function (component, event, helper) {
		var id = component.get('v.recordId');
		var action = component.get("c.getInfos");
		action.setParam("id", id);
		action.setCallback(this,
			function (response) {
				var state = response.getState();
				if (state === "SUCCESS") {
					console.log(response.getReturnValue());
					var data = response.getReturnValue();
					if (data.error) {
						console.log("1-Error Calling the Server Controller! >>", response.getError());
					} else {
						component.set("v.RagioneSocialeDealer__c", data.RagioneSocialeDealer__c);
						component.set("v.CodiceOCSDealer__c", data.CodiceOCSDealer__c);
						component.set("v.PartitaIVADealer__c", data.PartitaIVADealer__c);
						component.set("v.Autonomia__c", data.Autonomia__c);
						component.set("v.Motivo__c", data.Motivo__c);
						component.set("v.DataRiferimento__c", data.DataRiferimento__c);
						component.set("v.getCodice_Cliente__c", data.getCodice_Cliente__c);
						component.set("v.name", data.name);
						component.set("v.DealerPersonaRiferimento__c", data.DealerPersonaRiferimento__c);
						component.set("v.DealerPersonaRiferimentoCellulare__c", data.DealerPersonaRiferimentoCellulare__c);
						component.set("v.Dealership_Code__c", data.Dealership_Code__c);
						component.set("v.Last_Status__c", data.Last_Status__c);
					}
				} else {
					console.log("2-Error Calling the Server Controller! >>", response.getError());
				}
			});
		$A.enqueueAction(action);
	},
	handleDettaglioConvenzionatoClick: function (component, event, helper) {
		var showDetaglioConvenzionamento = component.get("v.showDetaglioConvenzionamento");
		if (showDetaglioConvenzionamento) {
			component.set("v.showDetaglioConvenzionamento", false);	
		}
		else{
			component.set("v.showDetaglioConvenzionamento", true);	
		}
	},
})