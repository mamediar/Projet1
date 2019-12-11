({

    
	doInit:	function(component, event, helper) {
		helper.callGetDealerAcquisition(component, event);
	},

    
	handleDispositionReadyEvent: function(component, event, helper) {
		helper.manageCaseWithNewDisposition(component, event);
	}    
    
})