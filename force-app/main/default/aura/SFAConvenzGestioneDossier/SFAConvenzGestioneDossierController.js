({
	doInit: function (component, event, helper) {
		helper.initPageReference(component, event);
		helper.callGetDossier(component, event);
	},

	handleRowSelectionObbligatori: function (component, event, helper) {
		var selectedRows = event.getParam('selectedRows');
		var selectedDocumentIds = [];
		for (var i=0; i<selectedRows.length; i++) {
			selectedDocumentIds.push(selectedRows[i].Id);
		}

		component.set("v.lstSelectedRowsObbligatori", selectedDocumentIds);

		console.log('*** component.set("v.lstSelectedRowsObbligatori") :: ' + component.get("v.lstSelectedRowsObbligatori"));
	},

	handleRowSelectionCollegati: function (component, event, helper) {
		var selectedRows = event.getParam('selectedRows');
		var selectedDocumentIds = [];
		for (var i=0; i<selectedRows.length; i++) {
			selectedDocumentIds.push(selectedRows[i].Id);
		}

		component.set("v.lstSelectedRowsCollegati", selectedDocumentIds);

		console.log('*** component.set("v.lstSelectedRowsCollegati") :: ' + component.get("v.lstSelectedRowsCollegati"));
	},

	handleSalvaSelezioneObbligatori: function (component, event, helper) {
		var selectedDocumentIds = component.get("v.lstSelectedRowsObbligatori");
		helper.handleSalvaSelezione(component, event, selectedDocumentIds);
	},

	handleSalvaSelezioneCollegati: function (component, event, helper) {
		var selectedDocumentIds = component.get("v.lstSelectedRowsCollegati");
		helper.handleSalvaSelezione(component, event, selectedDocumentIds);
	},

	handleProcedi: function (component, event, helper) {
		helper.handleProcedi(component, event);
	},

	handleRisposta: function(component, event, helper) {
		var recId = event.getParam('row').Id;
		console.log("L'id della riga è :" +  recId);
        var actionName = event.getParam('action').name;
        if ( actionName == 'Si' || actionName == 'No' ) {
			var mapIdRispostaDocumentoAddizionali = component.get("v.mapIdRispostaDocumentoAddizionali");
			mapIdRispostaDocumentoAddizionali[recId] = actionName;
			component.set("v.mapIdRispostaDocumentoAddizionali", mapIdRispostaDocumentoAddizionali);
			console.log("*** mapIdRispostaDocumentoAddizionali :: " + JSON.stringify(mapIdRispostaDocumentoAddizionali));
			var lstDossierDocumentoAddizionali = component.get("v.lstDossierDocumentoAddizionali");
			for (var i = 0; i < lstDossierDocumentoAddizionali.length; i++) { 
				if (lstDossierDocumentoAddizionali[i].Id == recId) {
					lstDossierDocumentoAddizionali[i].RispostaDocumentiAddizionali__c = mapIdRispostaDocumentoAddizionali[recId];
				}
			}
			component.set("v.lstDossierDocumentoAddizionali", lstDossierDocumentoAddizionali);
		}
	},
	
	handleSalvaRisposte: function (component, event, helper) {
		helper.handleSalvaRisposte(component, event);
	},

	handleAssignToIDM: function (component, event, helper) {
		helper.callAssignToIDM(component, event);
	},

	handleProcediToListaCase: function (component, event, helper) {
		helper.goToListaCase(component, event);
	}

})