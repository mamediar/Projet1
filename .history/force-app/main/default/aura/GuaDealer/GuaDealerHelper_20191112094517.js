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
                    var contact = resultat.resultat;
                    console.log('getDealerByCase', JSON.stringify(resultat));
                    component.set('v.caseDealer',resultat.resultat);
                    
                        var obj = contact.UAF_DatiAggiuntiviFile__c;
                        var regex = /&quot;/gi;
                        obj = obj.replace(regex, '"');
                        obj = obj.replace(/""""/gi,'""');
                        component.set('v.datiAggiuntivi', JSON.parse(obj));
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action); 
         
    },
})