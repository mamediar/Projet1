({
    helperMethod: function() {

    },
    updateStato: function(component) {
        var attachments = component.get('v.attachments');
        console.log('attachments >>>:', attachments);
        var action = component.get("c.updateAttachmentStatus");
        action.setParams({
            'attachments': attachments,
        });
        action.setCallback(this, function(response) {

            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('storeResponse >>>:', storeResponse);
                component.set('v.attachments', storeResponse);
                //component.set('v.courses', storeResponse.courses);
                //component.set('v.attachments', storeResponse.attachments); 
                this.showToast('Success', 'Allegati salvati con successo.', 'success');
            } else if (state === "INCOMPLETE") {
                this.showToast('Error', 'Response is Incompleted.', 'error');
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        this.showToast('Error', errors[0].message, 'error');
                    }
                } else {
                    this.showToast('Error', "Unknown error", 'error');
                }
            }
        });
        $A.enqueueAction(action);
    },
    updateIscrittos: function(component) {
        var iscritto = component.get('v.iscritto');
        var selectedStatus = component.get('v.selectedStatus');
        console.log('iscritto >>>:', iscritto);
        iscritto.Stato_Corso__c = selectedStatus;
        console.log('iscritto2 >>>:', iscritto);
        var action = component.get("c.updateIscrittoIvass");
        action.setParams({
            'iscritto': iscritto,
        });
        action.setCallback(this, function(response) {

            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('storeResponse updated >>>:', storeResponse);
                component.set('v.iscritto', storeResponse);
                //component.set('v.courses', storeResponse.courses);
                //component.set('v.attachments', storeResponse.attachments); 
                this.showToast('Success', 'Aggiornamento Effettuato con successo', 'success');
            } else if (state === "INCOMPLETE") {
                this.showToast('Error', 'Response is Incompleted.', 'error');
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " +
                            errors[0].message);
                    }
                } else {
                    this.showToast('Error', "Unknown error", 'error');
                }
            }
        });
        $A.enqueueAction(action);
    },
    showToast: function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: title,
            message: message,
            duration: '2000',
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire();
    },
})