({
	doInit: function (component, event, helper) {
        console.log('SFAConvenzGestioneAccolloControllerDoInitcomponent :: ' + component);
        console.log('SFAConvenzGestioneAccolloControllerDoInitevent :: ' + event);
        var obj = component.get("v.sObjectName");     
    	
    	
     	console.log("*** sObjectName :: " + obj);   
        
  		if (obj != 'Case'){
        	helper.initVerifyContest(component, event, helper);
        }
        else{
            
            helper.initPageReference(component, event);
            helper.callTipiAccollo(component, event);
            helper.callGetDossier(component, event); 
        }
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
    handleRowSelectionAddizionali: function (component, event, helper) {
		var selectedRows = event.getParam('selectedRows');
		var selectedDocumentIds = [];
		for (var i=0; i<selectedRows.length; i++) {
			selectedDocumentIds.push(selectedRows[i].Id);
		}

		component.set("v.lstSelectedRowsAddizionali", selectedDocumentIds);

		console.log('*** component.set("v.lstSelectedRowsAddizionali") :: ' + component.get("v.lstSelectedRowsAddizionali"));
	},
    
    handleRowSelectionTipoAccollo: function (component, event, helper) {
        console.log('*** handleRowSelectionTipoAccollocomponent :: '+ component);
        console.log('*** handleRowSelectionTipoAccolloevent :: '+event);
        console.log('*** handleRowSelectionTipoAccollo :: ' + event.getParam('selectedRows'));
        var selectedRows = event.getParam('selectedRows');
        var selectedType = [];
		for (var i=0; i<selectedRows.length; i++) {
			selectedType.push(selectedRows[i].Id);
		}
		component.set("v.lstSelectedTipoAccollo", selectedType);
        helper.CheckTypeEsistenti(component,event);
        
		console.log('*** component.set("v.lstSelectedTipoAccollo") :: ' + component.get("v.lstSelectedTipoAccollo"));
    },
    
	handleSalvaSelezioneObbligatori: function (component, event, helper) {
		var selectedDocumentIdsO = component.get("v.lstSelectedRowsObbligatori");
        var selectedDocumentIdsA = component.get("v.lstSelectedRowsAddizionali");
		helper.handleSalvaSelezione(component, event, selectedDocumentIdsO,selectedDocumentIdsA);
	},


	handleProcedi: function (component, event, helper) {
        
		var selectedDocumentIdsO = component.get("v.lstSelectedRowsObbligatori");
        var selectedDocumentIdsA = component.get("v.lstSelectedRowsAddizionali");
		helper.handleSalvaSelezione(component, event, selectedDocumentIdsO,selectedDocumentIdsA);
		helper.handleProcedi(component, event);
	},
    actionButtonAnnulla : function(component,event,helper){
 		helper.AnnullaAccollo(component,event);
    }, 

	handleAssignToIDM: function (component, event, helper) {
		helper.callAssignToIDM(component, event);
	},
    
    handleSendToIDM: function (component, event, helper) {
		helper.callSendToIDM(component, event);
	},

	handleProcediToListaCase: function (component, event, helper) {
        
		helper.goToListaCase(component, event);
	},
    handleTornaAdObbligatori: function (component, event, helper) {
    	helper.goToStepIniziale(component, event);
	}

})