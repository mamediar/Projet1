({

    
	doInit:	function(component, event, helper) {
        console.log('Form MD INIT');
		helper.callGetDealerAcquisition(component, event); 
	},

    
	handleDispositionReadyEvent: function(component, event, helper) {
        console.log('***handleDispositionReadyEvent');
		helper.manageCaseWithNewDisposition(component, event);
	}    
    
})