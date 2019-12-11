({
	handleManageContact : function(component, event, helper) {
         /*var resultat;
        var recordId= component.get('v.recordId');
        console.log('recordId v', JSON.stringify(recordId));
        var action = component.get('c.getDealerByCase');
        action.setParams({"idCase":recordId}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                if (!resultat.erreur) {
                    var caseDealer=resultat.resultat;
                    console.log('getDealerByCase', JSON.stringify(caseDealer));
                       component.set('v.caseDealer',resultat.resultat);
                       this.getFilialeCase(component, event, caseDealer);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action); 
        */
    },
    callCampagna: function(component, event, helper) {
        component.set("v.showScript",true);
    }
})