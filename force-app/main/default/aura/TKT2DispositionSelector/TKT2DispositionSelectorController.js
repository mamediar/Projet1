({
    closeCaseFunc : function(cmp,event,helper)
    {
        console.log('Closing Case...');
		
        var action = cmp.get('c.closeCase');
        console.log('action: ' + action);

        action.setParams({
            'caseId': cmp.get('v.recordId'),
            'flagAttach': false
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            if (state == 'SUCCESS') {
                $A.get('e.force:refreshView').fire();
                toastEvent.setParams({
                    "message": 'Case chiuso',
                    "type" : 'success'
                });
			}
			else {
                var errors = response.getError();
                var errorMessage = 'Errore generico';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorMessage = errors[0].message;
                        console.log("Error message: " + errorMessage);
                    }
                }
                toastEvent.setParams({
                    "message": errorMessage,
                    "type" : 'error'
                });
            }
            toastEvent.fire();
        });
        $A.enqueueAction(action);
    }
})