({
	doInit : function(component, numPratica) {
        console.log("INIZIO DO INIT");
        this.showSpinner(component);
        var action = component.get("c.getActivity");

        action.setParams({
            numPratica: numPratica
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
       
            if (state === "SUCCESS") {
                component.set("v.selectedActivity", response.getReturnValue());
                this.recDatiPratica(numPratica);
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

    	recDatiPratica : function(component, numPratica) {
        console.log("---------------------------------------------------");
        console.log("--recDatiPratica --");
        this.showSpinner(component);
        var action = component.get("c.getDatiPratica");

        action.setParams({
            numPratica: numPratica
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
       
            if (state === "SUCCESS") {
                component.set("v.recDatiPratica", response.getReturnValue());
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

    showSpinner: function(component) {

        var x = component.get('v.showSpinner')+1;
        component.set('v.showSpinner', x);
    }

})