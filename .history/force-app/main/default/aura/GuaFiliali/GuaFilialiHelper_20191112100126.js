({
    getCase: function(component, event, helper) {
        var recordId = component.get('v.recordId');
        console.log('recordId >>', JSON.stringify(recordId));
        var action = component.get('c.getCase');
        action.setParams({ "idCase": recordId });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('result >>', result);
                if (!result.erreur) {
                    component.set('v.case', result.case);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    getUtente: function(component, event, helper) {
        //component.set('v.showUtenzaPasscom', true);
        var action = component.get('c.getRecuperaUtenzeIntermediario');
        var resultat;
        var myCase = component.get('v.case');
        console.log('NameRoleReference__c >>', myCase.Account.NameRoleReference__c);
        action.setParams({
            "role": myCase.Account.NameRoleReference__c,
            /* "role": 'Alessandria', */
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('response >>', resultat);
                if (!resultat.erreur) {
                    component.set('v.userDealerList', resultat.utentente);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action);
    },
})