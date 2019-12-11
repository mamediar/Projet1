({
	goToListaCase: function (component, event) {
		var navService = component.find("navService");
		var pageReference = component.get("v.pageReference");
		event.preventDefault();
		navService.navigate(pageReference);
	},

	initPageReference : function(component, event) {
        var navService = component.find("navService");
        var pageReference = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Case',
                actionName: 'list'
            },
            state: {
                filterName: 'Gestione_Targhe_Mancanti'
            }
        };
        component.set("v.pageReference", pageReference);
        var defaultUrl = "#";
        navService.generateUrl(pageReference)
            .then($A.getCallback(function(url) {
                component.set("v.url", url ? url : defaultUrl);
            }), $A.getCallback(function(error) {
                component.set("v.url", defaultUrl);
            }));
	},

	callGetDateScadenza : function(component, event) {
        var praticaId = component.get("v.recordId");
        var dataTermineLavoro;
        var dataTermineScadenziario;
        var today = new Date();
        today.setHours(0,0,0,0);

		var action = component.get("c.getDateScadenza");

        action.setParams({
          praticaId: praticaId
        });

        action.setCallback(this, function(response){
            if (response.getState() == 'SUCCESS'){
                var dateScadenza = response.getReturnValue();
				if (dateScadenza) {
					component.set("v.numeroPratica", dateScadenza.numeroPratica);
					component.set("v.isCompletaButtonDisabled", (dateScadenza.caseStatus == 'Closed'));
                    dataTermineLavoro = new Date(dateScadenza.dataTermineLavoro);
                    dataTermineLavoro.setHours(0,0,0,0);
                    dataTermineScadenziario = new Date(dateScadenza.dataTermineScadenziario);
                    dataTermineScadenziario.setHours(0,0,0,0);
                    if (today <= dataTermineLavoro) {
                        component.set("v.ultimaDataUtile", dateScadenza.dataTermineLavoro);
                        component.set("v.casisticaScadenza", 1);
                    }
                    else if (today > dataTermineLavoro && today <= dataTermineScadenziario) {
                        component.set("v.ultimaDataUtile", dateScadenza.dataTermineScadenziario);
                        component.set("v.casisticaScadenza", 2);
                    }
                    else {
                        component.set("v.ultimaDataUtile", dateScadenza.dataTermineScadenziario);
                        component.set("v.casisticaScadenza", 3);
                    }
                }
            }
        });

        $A.enqueueAction(action);
    },
	
	showToastKO: function(component, event, helper, elementoNonCorretto) {
		if (elementoNonCorretto == 'targa') {
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				title: "Errore",
				type: "error",
				message: "Il formato della targa non è corretto"
			});
			toastEvent.fire();
		}
		else if (elementoNonCorretto == 'telaio') {
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				title: "Errore",
				type: "error",
				message: "Il formato del telaio non è corretto"
			});
			toastEvent.fire();
		}
		else if (elementoNonCorretto == 'webservice') {
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				title: "Errore",
				type: "error",
				message: "Si è verificato un errore durante l'aggiornamento su OCS"
			});
			toastEvent.fire();
		}
		else if (elementoNonCorretto == 'targaNote') {
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				title: "Errore",
				type: "error",
				message: "Il formato della targa non è corretto o la nota non è valorizzata"
			});
			toastEvent.fire();
		}
	},
	
	showToastOK: function(component, event, helper) {
		
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Operazione completata",
			type: "success",
			message: "Attività chiusa con successo"
		});
		toastEvent.fire();
    }
})