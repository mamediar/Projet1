({
    doInit : function(component, idCase) {
        console.log("INIZIO DO INIT");
        this.showSpinner(component);
        var idr = component.get('v.recordId');
//        alert(idr);
        var action = component.get("c.getActivity");

        action.setParams({
            idCase: idCase
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
       
            if (state === "SUCCESS") {
                component.set("v.selectedActivity", response.getReturnValue());
				console.log(component.get('v.selectedActivity'));
				var sCategoria = component.get('v.selectedActivity[0].Categoria__c');
				var b=sCategoria.includes('IRREPERIBILIT');
				if(b==true){
					component.set('v.categoria',true);
				}else{
					component.set('v.categoria',false);
				}
//                component.set('v.categoria',component.get('v.selectedActivity[0].Categoria__c'));
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

        var x = component.get('v.showSpinner')+1;
        component.set('v.showSpinner', x);
    },

    hideSpinner: function(component) {

        var x = component.get('v.showSpinner')-1;
        component.set('v.showSpinner', x);
    },
    aumentaData: function(s, h) {
        console.log('---------------------------------------------------------------');
        console.log('-- Controller JS: CRMDinieghiSDDHelper.js - Method: aumentaData'); 
        
		var mm = h*3600000;        
        var msec = Date.parse(s);
        var d = new Date(msec+mm);
        
		return d;
    }

})