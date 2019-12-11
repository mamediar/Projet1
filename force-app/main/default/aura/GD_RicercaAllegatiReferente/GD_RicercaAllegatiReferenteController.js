({
    handleKeyUp: function (component, event, helper) {
        var isEnterKey = event.keyCode === 13;
        var queryTerm = component.find('enter-search').get('v.value');
        if (isEnterKey) {
            component.set('v.issearching', true);
            setTimeout(function() {
				var action = component.get("c.researchDealerCoursesAttachments");
				action.setParams({ 'codiceReferente' : queryTerm});
				action.setCallback(this, function(response) {
					var state = response.getState();
					if (state === "SUCCESS") {
						var attachmentsList = response.getReturnValue();
							console.log('myAttachmentsObject : '+JSON.stringify(attachmentsList));
							if(attachmentsList.length>0){
								component.set('v.dealerCoursesAttachList',attachmentsList);
								component.set('v.showResult',false);
							}
							else{
								var toastEvent = $A.get("e.force:showToast");
								toastEvent.setParams({
									message: "nessun risultato per questo codicereferente.",
									type : 'error'
								});
								toastEvent.fire();
								component.set('v.showResult',true);
							}
							component.set('v.issearching', false);
						
					}
					else {
				   
					}                 
				});
				$A.enqueueAction(action);
                component.set('v.issearching', false);
			}, 2000);
			

        }
    }
});