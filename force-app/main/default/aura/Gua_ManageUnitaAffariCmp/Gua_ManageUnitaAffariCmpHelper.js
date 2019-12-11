({
    getZoneAndRegion: function(component, event, helper) {
        var action = component.get('c.getListZoneAndRegion'); 
        var resultat;
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('### resultat ', JSON.stringify(resultat));
                if (resultat!==null) {
                    component.set('v.listZoneAndRegion',resultat);
                }else {
                    this.showToast("","error");
                }
            }else{alert('error'+response.getError());
            console.log(JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action); 
    },

    showToast: function (message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: message,
            type: type
        });
        toastEvent.fire();
    },
    getQueus: function (component, event, helper) {
        var action = component.get('c.getQueus'); 
        var resultat;
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('### resultat ', JSON.stringify(resultat));
                if (resultat.erreur===false) {
                    component.set('v.listQueus',resultat.resultat);
                }else {
                    this.showToast("","error");
                }
            }else{alert('error'+response.getError());
            console.log(JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action); 
    }
})