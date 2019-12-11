({
	updateAccount: function(cmp, event, helper) {
		var input = cmp.find("emailDatiClienteCRM");
        input.focus();
        event.getSource().focus();
        if (input.checkValidity()){
            var action = cmp.get("c.updateAccountEmail");
            action.setParams({theAccount : cmp.get("v.account"), theMail : cmp.get('v.emailTemp')})
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    cmp.set('v.account.PersonEmail',cmp.get('v.emailTemp'));
                    helper.showToast('Email aggiornata con successo','success');
                    helper.closeModal(cmp, event, helper);
                }
                else if(response.getState()=='ERROR'){
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                    errors[0].message);
                                    helper.showToast("Errore: " + 
                                    errors[0].message,'error');
                        }else {
                            helper.showToast('Errore generico','error');
                        }
                    } else {
                        helper.showToast('Errore generico','error');
                    }
                }
                
            }); 
            $A.enqueueAction(action); 
        }else{
            helper.showToast('E-mail non valida','error');
        }
	},

	openModal: function(cmp, event, helper){ 	
		cmp.find("editPopUp").openModal();
        cmp.set('v.emailTemp',cmp.get('v.account.PersonEmail'));
        cmp.find("emailDatiClienteCRM").reportValidity();
	},

	closeModal: function(cmp, event, helper){ 
        cmp.find("editPopUp").closeModal();
	},
	
	showToast : function(message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type" : type,
        });
        toastEvent.fire();
    },   
})