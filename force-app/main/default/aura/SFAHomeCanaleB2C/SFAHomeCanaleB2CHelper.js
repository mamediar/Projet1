({
    getData: function (component) {
        this.showSpinner(component);
        var action = component.get("c.getData");

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var inadempimentiCount = response.getReturnValue()['inadempimentiCount'];
                component.set("v.inadempimentiCount", inadempimentiCount);
                this.calculateTotal(component);

            }
            else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set('v.msg', errors[0].message);
                        this.showErrorToast(component);
                    }
                } else {
                    component.set('v.msg', 'Unknown error');
                    this.showErrorToast(component);
                }
            }
            this.hideSpinner(component);
        })

        $A.enqueueAction(action);
    },

    calculateTotal: function(component) {
        component.set('v.total', 
            component.get('v.attRiassCount') +
            component.get('v.attRicCount') +
            component.get('v.campagnaCount') +
            component.get('v.carteCount') +
            component.get('v.praticheCount') +
            component.get('v.inadempimentiCount')
        );
    },

    showSuccessToast : function(component) {
        component.find('notifLib').showToast({
            "variant": "success",
            "title": "Success!",
            "message": component.get('v.msg')
        });
    },

    showErrorToast : function(component) {
        component.find('notifLib').showToast({
            "variant": "error",
            "title": "Error!",
            "message": component.get('v.msg')
        });
    },

    showInfoToast : function(component) {
        component.find('notifLib').showToast({
            "variant": "info",
            "title": "Info",
            "message": component.get('v.msg')
        });
    },

    showWarningToast : function(component) {
        component.find('notifLib').showToast({
            "variant": "warning",
            "title": "Warning!",
            "message": component.get('v.msg')
        });
    },
	
	showNotice : function(component) {
        component.find('notifLib').showNotice({
            "variant": "info",
            "header": "Info",
            "message": component.get("v.notifMsg"),
            closeCallback: function() {
                
            }
        });
    },

    showSpinner: function(component) {
        component.set('v.showSpinner', true);
    },

    hideSpinner: function(component) {
        component.set('v.showSpinner', false);
    }
})