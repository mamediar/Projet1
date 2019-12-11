({
	callGetPratica : function(component, event) {
		var action = component.get("c.getPratica");
		var objectId = component.get("v.objectId");

		action.setParams({
			praticaId: objectId
		}); 

		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
				var pratica = response.getReturnValue();
				component.set("v.numeroPratica", pratica.numeroPratica);
				component.set("v.targa", pratica.targa);
				component.set("v.dataLiquidazione", pratica.dataLiquidazione);
				component.set("v.notaFiliale", pratica.notaFiliale);
				component.set("v.cliente", pratica.cliente);
				component.set("v.descrizioneBene", pratica.descrizioneBene);
				component.set("v.telaio", pratica.telaio);

				console.log("*** pratica :: " + JSON.stringify(pratica));

				var esitoAgenziaItalia = pratica.esitoAgenziaItalia;

				if (esitoAgenziaItalia && esitoAgenziaItalia != "") {
					this.openModalKO(component, event);
					console.log("***helper - riga 27");
				}
				else {
					this.openComponent(component, event);
				}
			}
		});
		$A.enqueueAction(action);
	},

	callGetEsiti : function(component, event) {
		var action = component.get("c.getEsiti");

		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
				var listaEsiti = response.getReturnValue();
				component.set("v.listaEsiti", listaEsiti);
			}
		});
		$A.enqueueAction(action);
	},

	finish: function(component, event) { 
        var sendMsgEvent = $A.get("e.ltng:sendMessage"); 
        sendMsgEvent.setParams({
            "message": "Finish", 
            "channel": "toVisualForcePage" 
        }); 
        sendMsgEvent.fire(); 
	},

	openModalOK: function (component, event) {
		component.set("v.isModalOKOpen", true);
		component.set("v.isModalKOOpen", false);
		component.set("v.isComponentOpen", false);
		component.set("v.isBlankPageOpen", false);
	},

	openModalKO: function (component, event) {
		component.set("v.isModalOKOpen", false);
		component.set("v.isModalKOOpen", true);
		component.set("v.isComponentOpen", false);
		component.set("v.isBlankPageOpen", false);
	},

	openComponent: function (component, event) {
		component.set("v.isModalOKOpen", false);
		component.set("v.isModalKOOpen", false);
		component.set("v.isComponentOpen", true);
		component.set("v.isBlankPageOpen", false);
	}
})