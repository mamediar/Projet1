({
	handleManageContact : function(component, event, helper) {
        var resultat;
        var recordId= component.get('v.recordId');
        console.log('recordId', JSON.stringify(recordId));
        var action = component.get('c.getDealerByCase');
        action.setParams({"idCase":recordId}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                if (!resultat.erreur) {
                    console.log('getDealerByCase', JSON.stringify(resultat));
                   	component.set('v.caseDealer',resultat.resultat);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action); 
         
    },
    callCampagna: function(component, event, helper) {
        var contact = component.get('v.caseDealer');
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": contact.CampaignId__c,
            "slideDevName": "detail"
        });
        navEvt.fire();
    }
})