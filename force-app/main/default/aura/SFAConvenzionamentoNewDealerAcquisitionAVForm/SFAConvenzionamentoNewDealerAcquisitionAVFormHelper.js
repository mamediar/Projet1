({
	callGetDealerAcquisition: function (component, event) {
		var action = component.get("c.getDealerAcquisition");
		var caseId = component.get("v.recordId");
		console.log('HELPER NDA:: '+caseId);
		action.setParams({
			caseId: caseId
		}); 

		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
                console.log('RESPONSE SUCCESS');
				var dati = response.getReturnValue();
				component.set("v.dealerAcquisitionId", dati.dealerAcquisitionId);
                component.set("v.reportCervedId", dati.reportCervedId);
                component.set("v.OCSExternalFiliale", dati.OCSExternalFiliale);
                component.set("v.disposition", dati.disposition);   
                component.set("v.visibilityOption", dati.disposition.External_Id__c);   
                component.set("v.IsAttivitaInManoAdAV", dati.IsAttivitaInManoAdAV);    
                component.set("v.message", dati.message);
                console.log('reportCervedId:: '+dati.reportCervedId);
                console.log('dealerAcquisitionId:: '+dati.dealerAcquisitionId);
                console.log('dispositionAttualeAll:: '+dati.disposition);
                console.log('IsAttivitaInManoAdAV:: '+dati.IsAttivitaInManoAdAV);
                console.log('message:: '+dati.message);
                console.log('cmp padre dispositionAttualeExternalId:: '+component.get("v.visibilityOption"));
            } else {
                console.log('RESPONSE NOT SUCCESS');
            }
		});
		
		$A.enqueueAction(action);

	},
    
    
	manageCaseWithNewDisposition: function (component, event) {
        var spinner = component.find('spinnerComponent');
        spinner.incrementCounter();
        
		var nota = event.getParam("note");
		var disposition = event.getParam("disposition");
		component.set("v.nota", nota);
		component.set("v.disposition", disposition);        
        
		var action = component.get("c.assignCaseAndSendEmail");
		var caseId = component.get("v.recordId");
		action.setParams({
			caseId: component.get("v.recordId"),   
            dealerAcquisitionId: component.get("v.dealerAcquisitionId"),
            newDisposition: component.get("v.disposition"),
            OCSExternalFiliale: component.get("v.OCSExternalFiliale"),
            nota: component.get("v.nota")
		}); 
		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
				console.log('email inviata con successo');	
                window.location.reload();
            } else {
                console.log('email non inviata con successo');	
            }
            spinner.decreaseCounter();
		});
		
		$A.enqueueAction(action);

	},    
 
	
	showToastOK: function(component, event) {
		var toastEvent = $A.get("e.force:showToast");
        console.log('Tutto OK');
		toastEvent.setParams({
			title: "Operazione completata",
			type: "success",
			message: "Dati aggiornati con successo!"
		});
		//toastEvent.fire();
	},
	
	showToastKO: function(component, event) {
		var toastEvent = $A.get("e.force:showToast");
        console.log('Errore');
		toastEvent.setParams({
			title: "Errore",
			type: "error",
			message: "Si è verificato un errore durante il salvataggio"
		});
		//toastEvent.fire();
	}
})