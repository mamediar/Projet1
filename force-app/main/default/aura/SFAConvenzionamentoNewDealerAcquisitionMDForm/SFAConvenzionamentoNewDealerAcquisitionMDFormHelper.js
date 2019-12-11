({
	callGetDealerAcquisition: function (component, event) {
		var action = component.get("c.getDealerAcquisition");
		var caseId = component.get("v.recordId");

		action.setParams({
			caseId: caseId
		}); 

		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
				var dati = response.getReturnValue();
				component.set("v.dealerAcquisitionId", dati.dealerAcquisitionId);
                component.set("v.reportCervedId", dati.reportCervedId);
                component.set("v.OCSExternalFiliale", dati.OCSExternalFiliale);
                component.set("v.disposition", dati.disposition);
                component.set("v.visibilityOption", dati.disposition.External_Id__c);    
                component.set("v.IsAttivitaInManoAdMD", dati.IsAttivitaInManoAdMD);    
                component.set("v.message", dati.message); 
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
        
		var action = component.get("c.assignCase");
		var caseId = component.get("v.recordId");
		component.find('FormDealer').submit();
		action.setParams({
			caseId: component.get("v.recordId")
		}); 

		action.setCallback(this, function(response){
			if (response.getState() == 'SUCCESS'){
				console.log('case assegnato con successo');	 
                window.location.reload();
            } else {
                console.log('case non assegnato con successo');	
            }
            spinner.decreaseCounter();
		});
		
		$A.enqueueAction(action);

	},    
    


})