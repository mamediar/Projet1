({
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
    },

    showToast: function (message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: message,
            type: type
        });
        toastEvent.fire();
    },
    queuSelected : function (component, event, helper) {
        var qSelected = event.getSource().get('v.value');
        //console.log('qSelected '+JSON.stringify(qSelected));
        var cmpContact = $A.get("e.c:GUA_QueueToContactEvt"); 
        cmpContact.setParams({
            "queueContact": qSelected
        });
        cmpContact.fire();
    }
})